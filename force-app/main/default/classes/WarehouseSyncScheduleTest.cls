@isTest
public class WarehouseSyncScheduleTest {

    static testMethod void testJobExecution() {
        // Defina seu mock para o serviço de chamada de API aqui
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        // Crie uma instância da classe WarehouseSyncSchedule
        WarehouseSyncSchedule scheduleJob = new WarehouseSyncSchedule();

        // Chame diretamente o método execute para testar sua lógica
        Test.startTest();
        scheduleJob.execute(null); // O argumento SchedulableContext é nulo no contexto de teste
        Test.stopTest();

        // Adicione asserções para verificar o comportamento esperado após a execução do método execute

        // Verifique se os registros de equipamento foram criados ou atualizados
        List<Product2> updatedEquipment = [SELECT Warehouse_SKU__c, Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c, Maintenance_Cycle__c, Name, ProductCode FROM Product2 WHERE Warehouse_SKU__c = '12345'];
        System.assertEquals(1, updatedEquipment.size());
        System.assertEquals(true, updatedEquipment[0].Replacement_Part__c);
     
    }
}