import ballerina/persist as _;
import ballerina/http;

public type Employee record {|
    readonly int id;
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

public type NewEmployee record {|
    string mail;
    string name;
    string password;

|};


public type EmployeeCreated record {|
    *http:Created;
    Employee body;
|};




public table<Employee> key(id) EmployeeTable = table[];
public table<Order> key(id) OrderTable = table[];

public table<Mealtime> key(id) MealtimeTable=table[
    {
    
    id: 1,
    name:"Breakfast"
},
    {
    
    id: 2,
    name:"Lunch"
},
    {
    
    id: 3,
    name:"Dinner"
}
];

public table<Mealtype> key(id) MealtypeTable=table[
    {
    
    id: 1,
    name:"Veg"
},
    {
    
    id: 2,
    name:"Non-veg"
},
    {
    
    id: 3,
    name:"Egg"
}
];


