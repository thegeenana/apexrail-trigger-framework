public inherited sharing class ApexRailAfterBuffer {
    private static Map<String, Map<String, SObject>> recordsByWorkType =
        new Map<String, Map<String, SObject>>();

    private ApexRailAfterBuffer() {}

    public static void register(
        String workType,
        String deduplicationKey,
        SObject record
    ) {
        requireValue(workType, 'work type');
        requireValue(deduplicationKey, 'deduplication key');
        if (record == null) {
            throw new ApexRailException(
                'ApexRail after buffer requires a record.'
            );
        }

        if (!recordsByWorkType.containsKey(workType)) {
            recordsByWorkType.put(workType, new Map<String, SObject>());
        }

        recordsByWorkType.get(workType).put(deduplicationKey, record);
    }

    public static List<SObject> drain(String workType) {
        requireValue(workType, 'work type');
        if (!recordsByWorkType.containsKey(workType)) {
            return new List<SObject>();
        }

        List<SObject> records = recordsByWorkType.get(workType).values();
        recordsByWorkType.remove(workType);
        return records;
    }

    public static Boolean hasWork(String workType) {
        return !String.isBlank(workType) &&
            recordsByWorkType.containsKey(workType) &&
            !recordsByWorkType.get(workType).isEmpty();
    }

    private static void requireValue(String value, String label) {
        if (String.isBlank(value)) {
            throw new ApexRailException(
                'ApexRail after buffer requires a ' + label + '.'
            );
        }
    }

    @TestVisible
    private static void reset() {
        recordsByWorkType.clear();
    }
}
