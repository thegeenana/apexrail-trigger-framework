public inherited sharing class ApexRail {
    private ApexRail() {}

    public static void dispatch(ApexRailHandler handler) {
        if (handler == null) {
            throw new ApexRailException('ApexRail requires a handler.');
        }
        handler.run();
    }
}
