public with sharing class WarehouseCalloutService implements queueable, Database.AllowsCallouts {
	
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
	
    public static HttpResponse getEquipment() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            List<Object> listaDeEquipamentos = (List<Object>) JSON.deserializeUntyped(response.getBody());

            List<Product2> registrosDeEquipamentosParaUpsert = new List<Product2>();

            for (Object equipamentoData : listaDeEquipamentos) {
                Map<String, Object> dadosDeEquipamento = (Map<String, Object>) equipamentoData;
                Product2 equipamento = new Product2();
                equipamento.Warehouse_SKU__c = (String) dadosDeEquipamento.get('_id');
                equipamento.Replacement_Part__c = true;
                equipamento.Cost__c = (Decimal) dadosDeEquipamento.get('cost');
                equipamento.Current_Inventory__c = (Integer) dadosDeEquipamento.get('quantity');
                equipamento.Lifespan_Months__c = (Integer) dadosDeEquipamento.get('lifespan');
                equipamento.Maintenance_Cycle__c = (Integer) dadosDeEquipamento.get('maintenanceperiod');
                equipamento.Name = (String) dadosDeEquipamento.get('name');
                equipamento.ProductCode = (String) dadosDeEquipamento.get('sku');

                registrosDeEquipamentosParaUpsert.add(equipamento);
            }

            upsert registrosDeEquipamentosParaUpsert Product2.Warehouse_SKU__c;
        }
        return response;
    }

    //public class WarehouseCalloutQueueable implements queueable, Database.AllowsCallouts {
        public void execute(QueueableContext context) {
            // Chame a sua lógica de atualização de dados aqui
            HttpResponse response = WarehouseCalloutService.getEquipment();
            System.debug('Response da classe WarehouseCalloutQueueable: ' + response);

            // Verifique se a chamada ao serviço externo e a atualização foram bem-sucedidas
            if (response.getStatusCode() == 200) {
                System.debug('Dados atualizados com sucesso.');
            } else {
                System.debug('Erro ao atualizar os dados.');
            }
        }
    //}
}