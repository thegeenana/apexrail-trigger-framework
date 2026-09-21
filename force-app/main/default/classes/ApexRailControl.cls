public inherited sharing class ApexRailControl {
    private static Set<String> bypassedHandlers = new Set<String>();

    private ApexRailControl() {}

    public static void bypass(String handlerName) {
        requireName(handlerName);
        bypassedHandlers.add(handlerName);
    }

    public static void resume(String handlerName) {
        requireName(handlerName);
        bypassedHandlers.remove(handlerName);
    }

    public static Boolean isBypassed(String handlerName) {
        return !String.isBlank(handlerName) &&
            bypassedHandlers.contains(handlerName);
    }

    private static void requireName(String handlerName) {
        if (String.isBlank(handlerName)) {
            throw new ApexRailException(
                'ApexRail control requires a handler name.'
            );
        }
    }

    @TestVisible
    private static void reset() {
        bypassedHandlers.clear();
    }
}
