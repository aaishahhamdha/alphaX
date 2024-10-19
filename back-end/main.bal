import ballerina/http;

service /api on new http:Listener(9090) {

   
    resource function get orders() returns Order[] {
        return OrderTable.toArray();
    }


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

   

}
