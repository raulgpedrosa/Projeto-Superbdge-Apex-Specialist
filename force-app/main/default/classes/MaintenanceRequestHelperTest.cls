@isTest
public with sharing class MaintenanceRequestHelperTest {
    
    
	//Teste de Caso Positivo
	@isTest
    static void updateWorkOrdersCasoTestePositivo(){
        
        Vehicle__c testVeiculo = new Vehicle__c();
        testVeiculo.Name = 'Veículo';
        
        //Criar um Caso (Case = Maintenance Request)
        Case testCasoPositivo = new Case();
        testCasoPositivo.Status = 'Closed';
        testCasoPositivo.Type = 'Routine Maintenance';
        testCasoPositivo.Subject = 'Teste Subject';
        testCasoPositivo.Vehicle__c = testVeiculo.Id;
        testCasoPositivo.Origin = 'Phone';
        insert testCasoPositivo;
        
        //Criar um Equipamento (Objeto API name = Product2)
        Product2 testNovoProdutoCasoPositivo = new Product2();
        testNovoProdutoCasoPositivo.Name = 'Generator 1000 kW';
        testNovoProdutoCasoPositivo.Maintenance_Cycle__c = 30;
        testNovoProdutoCasoPositivo.Replacement_Part__c = true;
        insert testNovoProdutoCasoPositivo;
        
        //Criar Item de manutenção de caso (Objeto API Name = Equipment_Maintenance_item__c)
        Equipment_Maintenance_item__c testNovoItemEquipamentoCasoPositivo = new Equipment_Maintenance_Item__c();
        testNovoItemEquipamentoCasoPositivo.Maintenance_Request__c = testCasoPositivo.Id;
        testNovoItemEquipamentoCasoPositivo.Equipment__c = testNovoProdutoCasoPositivo.Id;
        testNovoItemEquipamentoCasoPositivo.Quantity__c = 1;
        insert testNovoItemEquipamentoCasoPositivo;
        
        Test.startTest();
        MaintenanceRequestHelper.updateWorkOrders(new List<Case>{testCasoPositivo});
        Test.stopTest();
        
        System.assertEquals(1, [SELECT COUNT() FROM Case WHERE Type = 'Routine Maintenance' AND Status = 'New']);   
        
    }
    @isTest
    static void updateWorkOrdersCasoNegativo(){
         Vehicle__c testVeiculoNegativo = new Vehicle__c();
        testVeiculoNegativo.Name = 'Veic';
        
        //Criar um Caso (Case = Maintenance Request)
        Case testCasoNegativo = new Case();
        testCasoNegativo.Status = 'Open';
        testCasoNegativo.Type = 'Routine Maintenance';
        testCasoNegativo.Subject = 'Teste Subject';
        testCasoNegativo.Vehicle__c = testVeiculoNegativo.Id;
        testCasoNegativo.Origin = 'Phone';
        insert testCasoNegativo;
        
        
        
        Test.startTest();
        MaintenanceRequestHelper.updateWorkOrders(new List<Case>{testCasoNegativo});
        Test.stopTest();
        // Verifique se o comportamento esperado ocorreu (neste caso, nada deve ser criado)
        System.assertEquals(0, [SELECT COUNT() FROM Case WHERE Type = 'Routine Maintenance' AND Status = 'New']);
    }
    
     // Teste de Caso em Massa
    @isTest
    static void updateWorkOrdersMassa(){
        Vehicle__c veic = new Vehicle__c(Name = 'Palio');
        insert veic;
        
        List<Case> casos = new List<Case>();
        for(Integer i = 0; i < 5; i++){
            Case testCasoMassa = new Case();
            testCasoMassa.Status = 'Closed';
            testCasoMassa.Type = 'Routine Maintenance';
            testCasoMassa.Subject = 'Teste Subject' + 1;
            testCasoMassa.Vehicle__c = veic.Id;
            testCasoMassa.Origin = 'Phone';
            casos.add(testCasoMassa);
        }    
        insert casos;
        Test.startTest();
        MaintenanceRequestHelper.updateWorkOrders(casos);
        Test.stopTest();
        
        System.AssertEquals(5, [SELECT COUNT() FROM Case WHERE Type = 'Routine Maintenance' AND Status = 'New']);  
    }
    
    // Teste de Exceções
    @isTest
    static void updateWorkOrdersExceptionTest(){
        Vehicle__c testVehicle = new Vehicle__c(Name = 'Test Vehicle ');
        insert testVehicle;
        // Crie um cenário onde o método deve lançar uma exceção (por exemplo, fornecer um ID inválido)
        Case testCaso = new Case();
        testCaso.Type = 'Routine Maintenance';
        testCaso.Status = 'Closed';
        testCaso.Subject = 'Test Subject';
        testCaso.Vehicle__c = testVehicle.Id; // ID inválido
        testCaso.Origin = 'Phone';

        Test.startTest();
        // Capture a exceção
        try {
            MaintenanceRequestHelper.updateWorkOrders(new List<Case>{testCaso});
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Invalid ID'));
        }
        Test.stopTest();
    }
    
    
}