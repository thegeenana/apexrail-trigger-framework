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
            dispatchAfter();
            return;
        }

        dispatchBefore();
    }

    private Boolean isAfterOperation() {
        return context.operation == System.TriggerOperation.AFTER_INSERT ||
            context.operation == System.TriggerOperation.AFTER_UPDATE ||
            context.operation == System.TriggerOperation.AFTER_DELETE ||
            context.operation == System.TriggerOperation.AFTER_UNDELETE;
    }

    private void dispatchBefore() {
        switch on context.operation {
            when BEFORE_INSERT { beforeInsert(); }
            when BEFORE_UPDATE { beforeUpdate(); }
            when BEFORE_DELETE { beforeDelete(); }
        }
    }

    private void dispatchAfter() {
        switch on context.operation {
            when AFTER_INSERT { afterInsert(); }
            when AFTER_UPDATE { afterUpdate(); }
            when AFTER_DELETE { afterDelete(); }
            when AFTER_UNDELETE { afterUndelete(); }
        }

        runAfter();
    }

    protected virtual void beforeInsert() {}
    protected virtual void beforeUpdate() {}
    protected virtual void beforeDelete() {}
    protected virtual void afterInsert() {}
    protected virtual void afterUpdate() {}
    protected virtual void afterDelete() {}
    protected virtual void afterUndelete() {}
    protected abstract void runAfter();

    protected virtual String getHandlerName() {
        return String.valueOf(this).substringBefore(':');
    }
}
