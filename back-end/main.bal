import ballerina/http;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;



final mysql:Client dbClient = check new(
    host = "localhost",
    user = "root",
    password = "0000",
    port = 3306,
    database = "flexmeals"
);

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
    resource function get employees() returns Employee[] | error {
        return EmployeeTable.toArray();
    }

//post employees
resource function post employees(NewEmployee newEmployee) returns EmployeeCreated {
        int id = EmployeeTable.nextKey();
        Employee employee1 = {
            id: id,
            ...newEmployee
        };

        EmployeeTable.add(employee1);
        EmployeeCreated response = {body: employee1};
        return response;
    }
   


// order count for each meal time - counts for 3 types
resource function get orderCounts(http:Caller caller) returns error? {
    // Create a new response
    http:Response res = new;
    
    // Function to add CORS headers
    addCorsHeaders(res);
    
    OrderCountRecord[] counts = [];
    
    foreach var orderItem in OrderTable {
        int mealtimeId = orderItem.mealtimeId;
        int mealtypeId = orderItem.mealtypeId;

        // Filter records by mealtimeId
        OrderCountRecord[] mealtimeRecords = counts.filter(rec => rec.mealtimeId == mealtimeId);
        
        if mealtimeRecords.length() > 0 {
            OrderCountRecord mealtimeRecord = mealtimeRecords[0];
            
            // Filter meal records by mealtypeId
            MealCountRecord[] mealRecords = mealtimeRecord.mealCounts.filter(meal => meal.mealtypeId == mealtypeId);
            
            if mealRecords.length() > 0 {
                MealCountRecord mealRecord = mealRecords[0];
                mealRecord.count += 1; // Increment count if found
            } else {
                mealtimeRecord.mealCounts.push({ mealtypeId: mealtypeId, count: 1 }); // Add new meal record
            }
        } else {
            // Add new mealtime record with the meal record
            counts.push({
                mealtimeId: mealtimeId,
                mealCounts: [{ mealtypeId: mealtypeId, count: 1 }]
            });
        }
    }

    // Create the final result map
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

    // Set the result payload and return the response
    res.setPayload(result);
    
    // Send the response with CORS headers
    check caller->respond(res);
}


}
// Function to add CORS headers
function addCorsHeaders(http:Response response) {
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");
}