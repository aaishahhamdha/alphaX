import ballerina/http;
import ballerinax/mysql;
import ballerina/sql;
import ballerina/io;
import ballerinax/mysql.driver as _;

final mysql:Client dbClient = check new(
    host = "localhost",
    user = "root",
    password = "Aaishah1234",
    port = 3306,
    database = "meal_management"
);

service /api on new http:Listener(9090) {

     // Sign in (Login)
    resource function post signin(http:Caller caller, LoginRequest loginRequest) returns error? {
       
        sql:ParameterizedQuery selectQuery = `SELECT id, mail, name, password FROM Employee WHERE mail = ${loginRequest.mail}`;
        
        stream<Employee, sql:Error?> resultStream = dbClient->query(selectQuery);

       
        Employee? employee;
        check from Employee emp in resultStream
            do {
                employee = emp;
            };
        
        if employee is () {
          
            http:Response res = new;
            res.statusCode = 404;
            res.setPayload({message: "User not found"});
            check caller->respond(res);
            return;
        }

      
        if employee.password == loginRequest.password {
            // Successful login
            UserData userData = {
                name: employee.name,
                mail: employee.mail
            };

            http:Response res = new;
            res.setPayload(userData);
            check caller->respond(res);
        } else {
            // Incorrect password
            http:Response res = new;
            res.statusCode = 401;
            res.setPayload({message: "Invalid credentials"});
            check caller->respond(res);
        }
    }

    // Sign up (Register)
    resource function post signup(http:Caller caller, NewEmployee newEmployee) returns error? {
      
        sql:ParameterizedQuery selectQuery = `SELECT id FROM Employee WHERE mail = ${newEmployee.mail}`;
        
        stream<Employee, sql:Error?> resultStream = dbClient->query(selectQuery);
        Employee? existingEmployee;
        check from Employee emp in resultStream
            do {
                existingEmployee = emp;
            };

        if existingEmployee is Employee {
          
            http:Response res = new;
            res.statusCode = 409;
            res.setPayload({message: "Email already exists"});
            check caller->respond(res);
            return;
        }

        sql:ParameterizedQuery insertQuery = `INSERT INTO Employee (mail, name, password)
            VALUES (${newEmployee.mail}, ${newEmployee.name}, ${newEmployee.password})`;
        var result = dbClient->execute(insertQuery);

        if result is sql:ExecutionResult {
         
            http:Response res = new;
            res.statusCode = 201;
            res.setPayload({message: "Employee registered successfully"});
            check caller->respond(res);
        } else {
           
            http:Response res = new;
            res.statusCode = 500;
            res.setPayload({message: "Failed to register employee"});
            check caller->respond(res);
        }
    }

    // Get all orders
    resource function get orders() returns Order1[] | error {
        Order1[] orders = [];
        stream<Order1, sql:Error?> orderStream = dbClient->query(
            `SELECT id, employeeId, mealtypeId, mealtimeId, date FROM Order1`
        );
        check from Order1 order1 in orderStream
            do {
                orders.push(order1);
            };
        return orders;
    }

    // Post a new order
    resource function post orders(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        NewOrder1 newOrder1 = check payload.cloneWithType(NewOrder1);

       
        sql:ParameterizedQuery insertQuery = `INSERT INTO Order1 (employeeId, mealtypeId, mealtimeId, date)
            VALUES (${newOrder1.employeeId}, ${newOrder1.mealtypeId}, ${newOrder1.mealtimeId}, ${newOrder1.date})`;
        var result = dbClient->execute(insertQuery);
        if result is sql:ExecutionResult {
            check caller->respond({message: "Order added successfully"});
        } else {
            check caller->respond({message: "Failed to add order"});
        }
    }

    // Post a new employee
    resource function post employees(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        NewEmployee newEmployee = check payload.cloneWithType(NewEmployee);

        
        sql:ParameterizedQuery insertQuery = `INSERT INTO Employee (mail, name, password)
            VALUES (${newEmployee.mail}, ${newEmployee.name}, ${newEmployee.password})`;
        var result = dbClient->execute(insertQuery);
        if result is sql:ExecutionResult {
            check caller->respond({message: "Employee added successfully"});
        } else {
            check caller->respond({message: "Failed to add employee"});
        }
    }

    // Get all employees
    resource function get employees() returns Employee[] | error {
        Employee[] employees = [];
        stream<Employee, sql:Error?> employeeStream = dbClient->query(
            `SELECT id, mail, name, password FROM Employee`
        );
        check from Employee employee in employeeStream
            do {
                employees.push(employee);
            };
        return employees;
    }



// Get order count for a specific date
resource function get orderCountsForDate(http:Caller caller, http:Request req, string inputDate) returns error? {
    // Map for mealtime names
    map<string> mealtimeNames = {
        "1": "Breakfast",
        "2": "Lunch",
        "3": "Dinner"
    };

    // Initialize response map
    map<map<string>> mealTimeCounts = {
        "Breakfast": { "veg_count": "0", "nonveg_count": "0", "egg_count": "0" },
        "Lunch": { "veg_count": "0", "nonveg_count": "0", "egg_count": "0" },
        "Dinner": { "veg_count": "0", "nonveg_count": "0", "egg_count": "0" }
    };

    // Stream SQL results
    stream<OrderCountRecord, sql:Error?> countStream = dbClient->query(
        `SELECT 
    c.id AS mealtimeId, 
    IFNULL(t.id, 0) AS mealtypeId,  -- Replace null values with 0
    CAST(SUM(CASE WHEN o.id IS NOT NULL THEN 1 ELSE 0 END) AS UNSIGNED) AS count
FROM 
    Mealtime c
LEFT JOIN 
    Order1 o ON o.mealtimeId = c.id AND o.date = ${inputDate}
LEFT JOIN 
    Mealtype t ON o.mealtypeId = t.id
GROUP BY 
    c.id, t.id
ORDER BY 
    c.id;


        `
    );

    check from OrderCountRecord record1 in countStream
        do {
            string? mealtimeName = mealtimeNames[record1.mealtimeId.toString()]; 

            
            if mealtimeName is string { 
                
                string countStr = record1.count.toString(); 
                if record1.mealtypeId == 1 { // Veg
                    mealTimeCounts[mealtimeName]["veg_count"] = countStr;
                } else if record1.mealtypeId == 2 { // Non-Veg
                    mealTimeCounts[mealtimeName]["nonveg_count"] = countStr;
                } else if record1.mealtypeId == 3 { // Egg
                    mealTimeCounts[mealtimeName]["egg_count"] = countStr;
                }
            } else {
                
            }
        };

   
    check caller->respond(mealTimeCounts);
}



}

// Function to add CORS headers
function addCorsHeaders(http:Response response) {
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");
    io:println("CORS headers added");
}

@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:5173"],
        allowHeaders: ["REQUEST_ID", "Content-Type"],
        exposeHeaders: ["RESPONSE_ID"],
        allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        maxAge: 84900
    }
}


// Types

public type LoginRequest record {|
    string mail;
    string password;
|};

public type UserData record {|
    string name;
    string mail;
|};

public type Employee record {|
    readonly int id;
    string mail;
    string name;
    string password;
|};

public type NewEmployee record {|
    string mail;
    string name;
    string password;
|};
public type Mealtime record {|
    readonly int id;
    string name;
|};

public type Mealtype record {|
    readonly int id;
    string name;
|};

public type Order1 record {|
    readonly int id;
    int employeeId;
    int mealtypeId;
    int mealtimeId;
    string date;
|};

public type NewOrder1 record {|
    int employeeId;
    int mealtypeId;
    int mealtimeId;
    string date;
|};

type OrderCreated1 record {|
    *http:Created;
    Order1 body;
|};



type MealCountRecord record {|
    int mealtypeId;
    int count;
|};

type OrderCountRecord record {
    int mealtimeId;
    int mealtypeId;
    int count;
};

