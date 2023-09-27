public with sharing class WarehouseSyncSchedule implements Schedulable {
    public void execute(SchedulableContext context) {
        // Enfileira a classe WarehouseCalloutQueueable para execução em segundo plano
        WarehouseCalloutService queueableJob = new WarehouseCalloutService();
        System.enqueueJob(queueableJob);
    }
}