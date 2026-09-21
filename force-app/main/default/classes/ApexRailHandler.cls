public abstract inherited sharing class ApexRailHandler {
    protected ApexRailContext context;

    protected ApexRailHandler() {
        this.context = ApexRailContext.fromTrigger();
    }

    public void run() {
        String handlerName = getHandlerName();
        if (ApexRailControl.isBypassed(handlerName)) {
            return;
        }

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
