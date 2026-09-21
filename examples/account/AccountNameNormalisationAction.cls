public inherited sharing class AccountNameNormalisationAction
    implements ApexRailAction {

    public void execute(ApexRailContext context) {
        for (SObject record : context.newRecords) {
            Account accountRecord = (Account) record;
            if (!String.isBlank(accountRecord.Name)) {
                accountRecord.Name = accountRecord.Name.trim();
            }
        }
    }
}
