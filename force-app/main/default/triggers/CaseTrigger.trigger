trigger CaseTrigger on Case (after insert) {
    TwoLevelRollupSum.execute(Trigger.New);
}