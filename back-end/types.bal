import ballerina/persist as _;


public type Employee record {|
    readonly int id;
    string mail;
    string name;
    string password;
    Order[] orders; 
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


