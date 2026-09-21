public abstract inherited sharing class ApexRailHandler {
    protected ApexRailContext context;

    protected ApexRailHandler() {
        this.context = ApexRailContext.fromTrigger();
    }

    @TestVisible
    protected ApexRailHandler(ApexRailContext context) {
        if (context == null) {
            throw new ApexRailException('ApexRail handler requires a context.');
        }
        this.context = context;
    }

    public void run() {
        String handlerName = getHandlerName();
        if (ApexRailControl.isBypassed(handlerName)) {
            return;
        }

        if (isAfterOperation()) {
            runAfterOnce(handlerName);
            return;
        }

        dispatch();
    }

    private void runAfterOnce(String handlerName) {
        String executionKey = handlerName + ':' + String.valueOf(context.operation);
        if (ApexRailGuard.enterOnce(executionKey)) {
            dispatch();
        }
    }

    private Boolean isAfterOperation() {
        return context.operation == System.TriggerOperation.AFTER_INSERT ||
            context.operation == System.TriggerOperation.AFTER_UPDATE ||
            context.operation == System.TriggerOperation.AFTER_DELETE ||
            context.operation == System.TriggerOperation.AFTER_UNDELETE;
    }

    private void dispatch() {
        switch on context.operation {
            when BEFORE_INSERT { beforeInsert(); }
            when BEFORE_UPDATE { beforeUpdate(); }
            when BEFORE_DELETE { beforeDelete(); }
            when AFTER_INSERT { afterInsert(); }
            when AFTER_UPDATE { afterUpdate(); }
            when AFTER_DELETE { afterDelete(); }
            when AFTER_UNDELETE { afterUndelete(); }
        }
    }

    protected virtual void beforeInsert() {}
    protected virtual void beforeUpdate() {}
    protected virtual void beforeDelete() {}
    protected virtual void afterInsert() {}
    protected virtual void afterUpdate() {}
    protected virtual void afterDelete() {}
    protected virtual void afterUndelete() {}

    protected virtual String getHandlerName() {
        return String.valueOf(this).substringBefore(':');
    }
}
