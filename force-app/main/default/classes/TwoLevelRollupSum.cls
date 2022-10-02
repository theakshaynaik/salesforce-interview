/*
		       Account1							      Account2
	Contact1		     Contact2				   Contact3		Contact4
 Case1    Case2	       Case3   Case4		    Case5	Case7
 					             *			      *

 Loop and get BID's. --- get immediate B's
 Query A from BId   ---- get All the A's
 Query All BIds from A --- Get All B's
*/

// Problem Statement:
// Total amount sum should be updated for each account from all the child cases every time a case is created.
// Hierarchy would be as: Case (Child) ==> Contact(Parent) ==> Account(Grandparent)

public with sharing class TwoLevelRollupSum {

    public static void execute(List<Case> newCaseList) {
        Set<Id> contactIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        Map<Id,Integer> accountIdTotalAmountMap = new Map<Id,Integer>();
        List<Account> accountToBeUpdatedList = new List<Account>();
        for(Case caseObj : newCaseList) {
            // accountIds.add(caseObj.Contact.AccountId); --> not possible as we are in trigger context
            contactIds.add(caseObj.ContactId);
        }
        for(Contact contactObj : [SELECT Id, AccountId FROM Contact WHERE Id IN :contactIds]) {
            accountIds.add(contactObj.AccountId);
        }
        for(Contact contactObj : [SELECT Id, AccountId,
                                    (SELECT Id, Contact.AccountId, Amount__c FROM Cases)
                                    FROM Contact WHERE AccountId IN :accountIds]) {

            for(Case caseObj : contactObj.Cases) {
                if(!accountIdTotalAmountMap.containsKey(caseObj.Contact.AccountId)) {	
                    accountIdTotalAmountMap.put(caseObj.contact.AccountId,caseObj.Amount);
                    continue;
                }
                Integer tempAmount = accountIdTotalAmountMap.get(caseObj.Contact.AccountId);
                accountIdTotalAmountMap.put(caseObj.Contact.AccountId, tempAmount + caseObj.amount);
            }
        }
        for(Id accountId : accountIdTotalAmountMap.keySet()) {
            accountToBeUpdatedList.add(new Account(Id = accountId, accountIdTotalAmountMap.get(accountId)));
        }
        update accountToBeUpdatedList;
    }
}