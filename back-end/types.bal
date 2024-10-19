import ballerina/persist as _;
import ballerina/http;

public type Employee record {|
    readonly int id;
    string mail;
    string name;
    string password;
    Order[] orders?;
|};

public type Mealtime record {|
    readonly int id;
    string name;
|};

public type Mealtype record {|
    readonly int id;
    string name;
|};

public type Order record {|
    readonly int id;
    int employeeId;
    int mealtypeId;
    int mealtimeId;
    string date;
|};

public type NewOrder record {|
    int employeeId;
    int mealtypeId;
    int mealtimeId;
    string date;
|};

type OrderCreated record{|
*http:Created;
Order body;
|};


public table<Employee> key(id) EmployeeTable = table[];
public table<Order> key(id) OrderTable = table[];
