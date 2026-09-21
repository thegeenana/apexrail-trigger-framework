public inherited sharing class ApexRailGuard {
    private static Map<String, Set<Id>> processedIdsByAction =
        new Map<String, Set<Id>>();
    private static Set<String> completedExecutionKeys = new Set<String>();

    private ApexRailGuard() {}

    public static Boolean enterOnce(String executionKey) {
        if (String.isBlank(executionKey)) {
            throw new ApexRailException(
                'ApexRail run-once guard requires an execution key.'
            );
        }
        if (completedExecutionKeys.contains(executionKey)) {
            return false;
        }

        completedExecutionKeys.add(executionKey);
        return true;
    }

    public static Set<Id> retainUnprocessed(
        String actionName,
        Set<Id> candidateIds
    ) {
        if (String.isBlank(actionName)) {
            throw new ApexRailException('ApexRail guard requires an action name.');
        }
        if (candidateIds == null || candidateIds.isEmpty()) {
            return new Set<Id>();
        }
        if (!processedIdsByAction.containsKey(actionName)) {
            processedIdsByAction.put(actionName, new Set<Id>());
        }

        Set<Id> unprocessedIds = candidateIds.clone();
        unprocessedIds.removeAll(processedIdsByAction.get(actionName));
        processedIdsByAction.get(actionName).addAll(unprocessedIds);
        return unprocessedIds;
    }

    @TestVisible
    private static void reset() {
        processedIdsByAction.clear();
        completedExecutionKeys.clear();
    }
}
