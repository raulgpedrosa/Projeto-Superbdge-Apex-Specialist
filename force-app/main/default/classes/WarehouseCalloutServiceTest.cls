@isTest
public class WarehouseCalloutServiceTest {

    @isTest
    static void testGetEquipment() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        // Execute o método getEquipment da classe WarehouseCalloutService
        HttpResponse response = WarehouseCalloutService.getEquipment();

        // Verifique se a resposta é bem-sucedida (status 200)
        System.assertEquals(200, response.getStatusCode());

        // Verifique se o registro de equipamento foi criado corretamente
        List<Product2> equipamentos = [SELECT Warehouse_SKU__c, Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c, Maintenance_Cycle__c, Name, ProductCode FROM Product2 WHERE Warehouse_SKU__c = '12345'];
        System.assertEquals(1, equipamentos.size());

        Product2 equipamento = equipamentos[0];
        System.assertEquals(true, equipamento.Replacement_Part__c);
        System.assertEquals(100.0, equipamento.Cost__c);
        System.assertEquals(50, equipamento.Current_Inventory__c);
        System.assertEquals(36, equipamento.Lifespan_Months__c);
        System.assertEquals(6, equipamento.Maintenance_Cycle__c);
        System.assertEquals('Equipment 1', equipamento.Name);
        System.assertEquals('EQUIP001', equipamento.ProductCode);
    }

    
    static testmethod void testQueueable() {
    // Crie um caso de teste para inserir os registros de teste necessários, como Product2
    Product2 equipmentRecord = new Product2(Name = 'Test Equipment', Warehouse_SKU__c = '12345');
    insert equipmentRecord;

    // Crie uma instância de WarehouseCalloutService e execute a fila
    WarehouseCalloutService service = new WarehouseCalloutService();
    
    // Defina um mock para simular a chamada do serviço da web
    Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
    
    // Execute a fila
    Test.startTest();
    System.enqueueJob(service);
    Test.stopTest();

    // Verifique se a chamada ao serviço externo e a atualização foram bem-sucedidas
    List<Product2> updatedEquipment = [SELECT Warehouse_SKU__c, Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c, Maintenance_Cycle__c, Name, ProductCode FROM Product2 WHERE Warehouse_SKU__c = '12345'];
    System.assertEquals(1, updatedEquipment.size());
    System.assertEquals(true, updatedEquipment[0].Replacement_Part__c);
    // Adicione outras verificações conforme necessário
}
}