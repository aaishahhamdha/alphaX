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
   

}
