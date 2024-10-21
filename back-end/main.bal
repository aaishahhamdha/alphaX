import ballerina/http;
import ballerinax/mysql;
import ballerina/sql;
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

    // Get order count for each mealtime and meal type
    resource function get orderCounts(http:Caller caller) returns error? {
        map<json> result = {};
        
        stream<OrderCountRecord, sql:Error?> countStream = dbClient->query(
            `SELECT o.mealtimeId, o.mealtypeId, COUNT(*) as count 
            FROM Order1 o 
            GROUP BY o.mealtimeId, o.mealtypeId`
        );

        map<json> mealCounts = {};
        check from OrderCountRecord countRec in countStream
            do {
                mealCounts[countRec.mealtypeId.toString()] = countRec.count;
                result[countRec.mealtimeId.toString()] = mealCounts;
            };

        http:Response res = new;
        res.setPayload(result);
        addCorsHeaders(res);
        check caller->respond(res);
    }

    // Get order count for a specific date
    resource function get orderCountsForDate(http:Caller caller, http:Request req, string inputDate) returns error? {
        map<json> result = {};
        
        stream<OrderCountRecord, sql:Error?> countStream = dbClient->query(
            `SELECT o.mealtimeId, o.mealtypeId, COUNT(*) as count 
            FROM Order1 o 
            WHERE o.date = ${inputDate} 
            GROUP BY o.mealtimeId, o.mealtypeId`
        );

        map<json> mealCounts = {};
        check from OrderCountRecord countRec in countStream
            do {
                mealCounts[countRec.mealtypeId.toString()] = countRec.count;
                result[countRec.mealtimeId.toString()] = mealCounts;
            };

        http:Response res = new;
        res.setPayload(result);
        addCorsHeaders(res);
        check caller->respond(res);
    }

}

// Function to add CORS headers
function addCorsHeaders(http:Response response) {
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");
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

type OrderCountRecord record {|
    int mealtimeId;
    int mealtypeId;
    int count;
|};
