import ballerina/http;

service /api on new http:Listener(9090) {

   
   //get orders
    resource function get orders() returns Order[] {
        return OrderTable.toArray();
    }

//post orders
resource function post orders(NewOrder newOrder) returns OrderCreated {
    int id = OrderTable.nextKey();
    Order order1 = {
        id: id,
        ...newOrder
    };

    OrderTable.add(order1);
    OrderCreated response = {body: order1};
    return response;
}
   //get employees
    resource function get employees() returns Employee[] {
        return EmployeeTable.toArray();
    }

//post employees
resource function post employees(NewEmployee newEmployee) returns string {
    int id = EmployeeTable.nextKey(); 
    Employee employee1 = {
        id: id,    
        ...newEmployee 
    };

    EmployeeTable.add(employee1);
    return "User created successfully with ID: " + id.toString();
}



   


// order count for each meal time - counts for 3 types
resource function get orderCounts() returns json {
    OrderCountRecord[] counts = [];

    
    foreach var orderItem in OrderTable {
        int mealtimeId = orderItem.mealtimeId;
        int mealtypeId = orderItem.mealtypeId;

        
        OrderCountRecord[] mealtimeRecords = counts.filter(rec => rec.mealtimeId == mealtimeId);
        
        if mealtimeRecords.length() > 0 {
            OrderCountRecord mealtimeRecord = mealtimeRecords[0];
            
           
            MealCountRecord[] mealRecords = mealtimeRecord.mealCounts.filter(meal => meal.mealtypeId == mealtypeId);
            
            if mealRecords.length() > 0 {
                MealCountRecord mealRecord = mealRecords[0];
              
                mealRecord.count += 1;
            } else {
                
                mealtimeRecord.mealCounts.push({ mealtypeId: mealtypeId, count: 1 });
            }
        } else {
        
            counts.push({
                mealtimeId: mealtimeId,
                mealCounts: [{ mealtypeId: mealtypeId, count: 1 }]
            });
        }
    }

   
    map<json> result = {};  
    foreach var mealtime in MealtimeTable {
        map<json> mealtypeCounts = {};  
        foreach var mealtype in MealtypeTable {
            
            int count = 0;
            OrderCountRecord[] mealtimeRecords = counts.filter(rec => rec.mealtimeId == mealtime.id);
            if mealtimeRecords.length() > 0 {
                OrderCountRecord mealtimeRecord = mealtimeRecords[0];
                MealCountRecord[] mealRecords = mealtimeRecord.mealCounts.filter(meal => meal.mealtypeId == mealtype.id);
                if mealRecords.length() > 0 {
                    count = mealRecords[0].count;
                }
            }
            mealtypeCounts[mealtype.name.toString()] = count;
        }
        result[mealtime.name.toString()] = mealtypeCounts;
    }

    return result;
}


// order count for each meal time - counts for 3 types BY DATE
 resource function get orderCountsForDate(http:Caller caller, http:Request req, string inputDate) returns error? {
        OrderCountRecord[] counts = [];

      
        foreach var orderItem in OrderTable {
            
            if orderItem.date == inputDate {

                int mealtimeId = orderItem.mealtimeId;
                int mealtypeId = orderItem.mealtypeId;

                OrderCountRecord[] mealtimeRecords = counts.filter(rec => rec.mealtimeId == mealtimeId);

                if mealtimeRecords.length() > 0 {
                    OrderCountRecord mealtimeRecord = mealtimeRecords[0];

                   
                    MealCountRecord[] mealRecords = mealtimeRecord.mealCounts.filter(meal => meal.mealtypeId == mealtypeId);

                    if (mealRecords.length() > 0) {
                        MealCountRecord mealRecord = mealRecords[0];
                       
                        mealRecord.count += 1;
                    } else {
                      
                        mealtimeRecord.mealCounts.push({ mealtypeId: mealtypeId, count: 1 });
                    }
                } else {
                    
                    counts.push({
                        mealtimeId: mealtimeId,
                        mealCounts: [{ mealtypeId: mealtypeId, count: 1 }]
                    });
                }
            }
        }

     
        map<json> result = {};  
        foreach var mealtime in MealtimeTable {
            map<json> mealtypeCounts = {};  
            foreach var mealtype in MealtypeTable {
                
                int count = 0;
                OrderCountRecord[] mealtimeRecords = counts.filter(rec => rec.mealtimeId == mealtime.id);
                if mealtimeRecords.length() > 0 {
                    OrderCountRecord mealtimeRecord = mealtimeRecords[0];
                    MealCountRecord[] mealRecords = mealtimeRecord.mealCounts.filter(meal => meal.mealtypeId == mealtype.id);
                    if mealRecords.length() > 0 {
                        count = mealRecords[0].count;
                    }
                }
                mealtypeCounts[mealtype.name.toString()] = count;
            }
            result[mealtime.name.toString()] = mealtypeCounts;
        }

      
        check caller->respond(result);
    }

}
