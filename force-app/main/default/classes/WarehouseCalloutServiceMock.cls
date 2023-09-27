@isTest
global class WarehouseCalloutServiceMock implements HttpCalloutMock {
    
    global HttpResponse respond(HttpRequest request){
        HttpResponse resp = new HttpResponse();
        resp.setHeader('Content-Type', 'application-json');
        resp.setStatusCode(200);
        resp.setBody('[{"_id": "12345", "cost": 100.0, "quantity": 50, "lifespan": 36, "maintenanceperiod": 6, "name": "Equipment 1", "sku": "EQUIP001"}]');        
        return resp;
    } 	
}