public with sharing class BrandingQueueable implements Queueable, Database.AllowsCallouts {

    private Id recordId;

    public BrandingQueueable(Id recordId) {
        this.recordId = recordId;
    }

    public void execute(QueueableContext context) {
        BrandingService.updateBrandingRecord(recordId);
    }
}