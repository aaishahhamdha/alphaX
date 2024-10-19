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




//public table<Employee> key(id) EmployeeTable = table[];
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


public table<Employee> key(id) EmployeeTable = table [
    {
        id: 1,
        mail: "john.doe@example.com",
        name: "John Doe",
        password: "password123"
        
    },
    {
        id: 2,
        mail: "jane.smith@example.com",
        name: "Jane Smith",
        password: "securepassword"
        
    },
    {
        id: 3,
        mail: "mike.jones@example.com",
        name: "Mike Jones",
        password: "mypassword"
        
    },
    {
        id: 4,
        mail: "linda.brown@example.com",
        name: "Linda Brown",
        password: "adminpass" 
    },
    {
        id: 5,
        mail: "sam.wilson@example.com",
        name: "Sam Wilson",
        password: "testpass"
    }
];
