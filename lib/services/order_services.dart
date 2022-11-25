import 'dart:convert';

import 'package:app/constants.dart';
import 'package:app/model/order.dart';
import 'package:app/services/setup_locator.dart';
import "package:http/http.dart" as http;

class OrderService {
  String api_url = "18.157.231.59:8080";
  Uri get order_url => Uri.http(api_url, "/order");
  Uri get change_url => Uri.http(api_url, "/change");
  var headers = {
    "Content-Type": "application/json; charset=UTF-8",
    'Accept': '*/*'
  };
  Future<OrderModel> order(
      {String merchantId, List<Map<String, dynamic>> items}) {
    Map<String, dynamic> body = {
      "order": items,
      "userId": locators.userService.id,
      "merchantId": merchantId
    };
    print(json.encode(body));
    return http
        .post(order_url, body: json.encode(body), headers: headers)
        .then((data) {
      print(data.statusCode);
      if (data.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(data.bodyBytes));
        // if (jsonData["status"] != "success") {
        //   return OrderModel(status: "failed");
        // }

        print("jay son");
        print(jsonData);
        return OrderModel.fromResponse(jsonData);
      }
      return OrderModel(status: "failed");
    });
  }

  Future<String> cancel(String orderId) {
    var body = {"orderId": orderId, "status": "canceled"};
    return http
        .post(change_url, body: json.encode(body), headers: headers)
        .then((data) {
      try {
        final jsonData = json.decode(data.body);
        if (jsonData["status"] == "success") {
          return "success";
        }
      } catch (e) {
        return "failed";
      }
      return "failed";
    });
  }
}
// {
//     "order": [
//         {
//             "id":"hcKRQFPpJI5UNGjZ6z5I",
//             "amount":4
//         },
//         {
//             "id":"lZOPZRm7ds3pO4nY0s71",
//             "amount":4
//         }
//     ],
//     "userId": "3LxnjThggnPZcRMtRH5WSn7s2Gu2",
//     "merchantId": "RPFi9Ewd8oApANrif5Tr"

// }
