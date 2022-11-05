# salesforce-interview
This repo contains most commonly asked interview problems.Edited using SourceTree.

# Note
The code snippets are no way near production ready.
The purpose here is to understand and grasp the logic used for given problem statement.

# Problem Statements:

1. Total amount sum should be updated for each account from all the child cases every time a case is created. Hierarchy would be as: Case (Child) ==> Contact(Parent) ==> Account(Grandparent)
Solution: CaseTrigger --> TwoLevelRollupSum

