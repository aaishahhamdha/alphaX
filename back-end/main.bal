import ballerina/http;

public table<Order> key(id) OrderTable=table[{
    
    id: 1,
    employeeId: 1,
    mealtypeId: 1,
    mealtimeId: 1,
    date: "2024-10-23"
}
];

service /api on new http:Listener(9090){
   resource function get Order() returns Order[]{
    return OrderTable.toArray();

   }
}