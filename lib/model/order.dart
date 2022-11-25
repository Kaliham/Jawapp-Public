import 'package:app/services/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderModel {
  List<ItemModel> items;
  LatLng position;
  String status;
  OrderStoreModel store;
  DateTime time;
  String userId;
  String userNationalId;
  String familyId;
  double totalPrice;
  String id;
  OrderModel({
    this.items,
    this.position,
    this.status,
    this.store,
    this.time,
    this.userId,
    this.userNationalId,
    this.familyId,
    this.totalPrice,
    this.id,
  });
  String itemDetails() {
    String details = "";
    items.forEach((element) {
      details += "${element.ar} x ${element.amount}";
    });
    return details;
  }

  String getPrice() {
    return "$totalPrice د.أ";
  }

  factory OrderModel.fromResponse(Map<String, dynamic> response) {
    Map<String, dynamic> model = response["data"];
    print(model);
    return OrderModel(
      items: ItemModel.listOfMap(model["items"]),
      store: OrderStoreModel.fromMap(model["store"]),
      id: response["orderId"],
      status: model["status"],
      userId: model["user"],
      userNationalId: model["user_national_id"],
      position: Util.getLocFromMap(model["position"]),
      familyId: model["family_id"],
      totalPrice: model["total_price"],
      time: Util.parseTime(model['time']),
    );
  }
  factory OrderModel.fromDoc(QueryDocumentSnapshot doc) {
    Map<String, dynamic> model = doc.data();

    var position = model["position"] as GeoPoint;
    print(doc.id);
    model["position"] = {
      "latitude": position.latitude.toString(),
      "longitude": position.longitude.toString()
    };
    print(model['time']);
    return OrderModel(
      items: ItemModel.listOfMap(model["items"]),
      store: OrderStoreModel.fromMap(model["store"]),
      id: doc.id,
      status: model["status"],
      userId: model["user"],
      userNationalId: model["user_national_id"],
      position: Util.getLocFromMap(model["position"]),
      familyId: model["family_id"],
      totalPrice: model["total_price"],
      time: model['time'].toDate(),
    );
  }
}

class ItemModel {
  int amount;
  String ar, en;
  String id;
  String status;
  double price;
  String get title => ar;
  ItemModel({
    this.amount,
    this.ar,
    this.id,
    this.en,
    this.status,
    this.price,
  });
  factory ItemModel.fromMap(map) {
    print(map);
    return ItemModel(
      amount: map["amount"],
      ar: map["ar"],
      en: map["ar"],
      status: map["status"],
      id: map["id"],
      price: map["price"],
    );
  }
  static List<ItemModel> listOfMap(List<dynamic> model) {
    List<ItemModel> list = [];
    model.forEach((element) {
      list.add(new ItemModel.fromMap(element));
    });
    return list;
  }
}

class OrderStoreModel {
  String id;
  String ar;
  String en;
  String get title => ar;
  OrderStoreModel({
    this.id,
    this.ar,
    this.en,
  });
  factory OrderStoreModel.fromMap(map) {
    return OrderStoreModel(
      id: map["id"],
      ar: map["title"]["ar"] ?? "",
      en: map["title"]["ar"] ?? "",
    );
  }
}
