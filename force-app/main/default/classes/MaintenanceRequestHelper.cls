public with sharing class MaintenanceRequestHelper {
	public static void updateWorkOrders(List<Case> novoCaso) { 
		List<Case> nCasos = new List<Case>();
        List<Case> nData = new List<Case>();
        List<Equipment_Maintenance_Item__c> equipamentos = [SELECT Equipment__c, Quantity__c, Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Item__c  WHERE Maintenance_Request__c =: novoCaso[0].Id WITH SECURITY_ENFORCED];
        System.debug('Lista para add os dados que serão inseridos: ' + nCasos);
        Date menorDataVencimento = null;
        for (Case c : novoCaso) {
            if (c.Status == 'Closed' && (c.Type == 'Repair' || c.Type == 'Routine Maintenance')) {
                System.debug('Variável de iteração c: ' + c);
                
                Case novoCasoAdd = new Case();
                novoCasoAdd.Type = 'Routine Maintenance';
                novoCasoAdd.Origin = 'Phone';
                novoCasoAdd.Status = 'New';
                novoCasoAdd.Subject = novoCaso.get(0).Subject;
                novoCasoAdd.Vehicle__c = novoCaso[0].Vehicle__c;
            
                nCasos.add(novoCasoAdd);    
            } 
		}
		
            insert nCasos;
            System.debug('Novo caso criado: ' + nCasos);
        
        List<Equipment_Maintenance_Item__c> addNovosEquipamentos = new List<Equipment_Maintenance_Item__c>();
        for(Equipment_Maintenance_Item__c c : equipamentos){
                Equipment_Maintenance_Item__c equip = new Equipment_Maintenance_Item__c();
            	equip.Maintenance_Request__c = nCasos.get(0).Id;
            	equip.Equipment__c = c.Equipment__c;
            	equip.Quantity__c = c.Quantity__c;
            	System.debug('Criação do Equipment_Maintenance_Item__c: ' + equip);
            
            if(c.Equipment__r.Maintenance_Cycle__c != null){
                Date dataVencimentoEquipamento = Date.today().addDays(Integer.valueOf(c.Equipment__r.Maintenance_Cycle__c));
                
                if(menorDataVencimento == null || dataVencimentoEquipamento < menorDataVencimento){
                  menorDataVencimento = dataVencimentoEquipamento; 
                    
                }
            }
            	AddNovosEquipamentos.add(equip);   	
        }
        if (menorDataVencimento != null && !nCasos.isEmpty()) {
        nCasos[0].Date_Due__c = menorDataVencimento;
        update nCasos[0];
    }
        
        System.debug('Menor data: ' + menorDataVencimento);
        insert addNovosEquipamentos;
        System.debug('Inserção dos Equipment_Maintenance_Item__c: ' + AddNovosEquipamentos);
        
   } 
}