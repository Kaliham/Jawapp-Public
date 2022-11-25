import 'dart:async';

import 'package:app/constants.dart';
import 'package:app/model/area_control.dart';
import 'package:app/model/limited_resouce.dart';
import 'package:app/model/order.dart';
import 'package:app/model/tags.dart';
import 'package:app/services/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/model/article.dart';
import 'package:app/model/rule.dart';
import 'package:app/model/user.dart';
import 'package:app/model/volunteer.dart';
import 'package:app/services/setup_locator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DatabaseService {
  // ignore: unused_field
  FirebaseFirestore get _instance => FirebaseFirestore.instance;
  CollectionReference rulesCollection,
      volunteerCollection,
      articleCollection,
      userDataCollection,
      limitedResourceCollection,
      areaControlCollection,
      areaControlPolyCollection,
      areaControlTagsCollection,
      resourcesCollection,
      ordersCollection,
      familyCollection;

  DatabaseService() {
    rulesCollection = _instance.collection("rules");
    volunteerCollection = _instance.collection("volunteer");
    articleCollection = _instance.collection("article");
    userDataCollection = _instance.collection("userdata");
    limitedResourceCollection = _instance.collection("limited_resource");
    areaControlCollection = _instance.collection("area_control");
    areaControlPolyCollection = _instance.collection("area_control_poly");
    areaControlTagsCollection = _instance.collection("area_control_tags");
    resourcesCollection = _instance.collection("resources");
    ordersCollection = _instance.collection("orders");
    familyCollection = _instance.collection("family");
  }

  Stream<UserModel> get userDataStream {
    String id = FirebaseAuth.instance.currentUser.uid;
    createUserData(id);
    return userDataCollection
        .doc(id)
        .snapshots()
        .map((doc) => UserModel.fromDoc(doc));
  }

  void createUserData(id) async {
    final doc = await userDataCollection.doc(id).get();
    if (!doc.exists) {
      Map<String, dynamic> data = new Map<String, dynamic>();
      data['nationalID'] = "";
      data['lang'] = 'ar';
      data['homepoint'] = new GeoPoint(
        Const.amman.latitude,
        Const.amman.longitude,
      );
      userDataCollection.doc(id).set(data);
    }
    if (doc['nationalID'] == null) {
      userDataCollection.doc(id).update({'nationalID': ""});
    }
    if (doc['lang'] == null) {
      userDataCollection.doc(id).update({'lang': 'ar'});
    }
    if (doc['homepoint'] == null) {
      userDataCollection.doc(id).update(
        {
          'homepoint': new GeoPoint(Const.amman.latitude, Const.amman.longitude)
        },
      );
    }
  }

  void updateVolunteering(String id, List<dynamic> base) {
    volunteerCollection.doc(id).update({"volunteers": base});
  }

  void addVolunteering(String id, List<String> base) {
    String value = locators.userService.id;
    base.add(value);
    updateVolunteering(id, base);
  }

  void removeVolunteering(String id, List<String> base) {
    String value = locators.userService.id;
    base.remove(value);
    updateVolunteering(id, base);
  }

  Stream<List<Resource>> get resourcesStream {
    return resourcesCollection.snapshots().map(_mapResources);
  }

  Stream<List<Resource>> resourcesStreamById(String id) {
    return limitedResourceCollection
        .doc(id)
        .collection("resources")
        .snapshots()
        .map(_mapResources);
  }

  Stream<String> familyIdStream(nationalId) {
    return familyCollection
        .where("national_ids", arrayContains: nationalId)
        .snapshots()
        .map((event) {
      String id = "-no record-";
      event.docs.forEach((element) {
        id = element.id;
      });
      return id;
    });
  }

  Stream<List<OrderModel>> get orders {
    print(locators.userService.familyId);
    return ordersCollection
        .where("family_id", isEqualTo: locators.userService.familyId)
        .snapshots()
        .map(_ordersFromSnapshot);
  }

  List<OrderModel> _ordersFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
      return OrderModel.fromDoc(documentSnapshot);
    }).toList();
  }

  Future<List<String>> get aboutPages async {
    var ref = await _instance.collection("about").doc("pages").get();
    print(ref.data());
    List<String> list = [];
    (ref.data()["urls"] as List<dynamic>).forEach((element) {
      list.add(element.toString());
    });
    return list;
  }

  Future<int> limitAmount(String resource) async {
    print(locators.userService.familyId);
    var ref = await familyCollection.doc(locators.userService.familyId).get();
    print(ref.data());
    print(resource);
    return ref.data()["amount"][resource] as int;
  }

  Stream<LatLng> get homepoint {
    String id = FirebaseAuth.instance.currentUser.uid;

    return userDataCollection.doc(id).snapshots().map((doc) => new LatLng(
        doc.data()['homepoint'].latitude, doc.data()['homepoint'].longitude));
  }

  Stream<List<LimitedResourceModel>> get limitedResourcesModels {
    if (locators.mapService.limitedResourceFilter != null &&
        locators.mapService.limitedResourceFilter.isNotEmpty) {
      return limitedResourceCollection
          .where('resources',
              arrayContainsAny: locators.mapService.limitedResourceFilter)
          .snapshots()
          .map((e) {
        return _mapLimitedResources(e);
      });
    }
    return limitedResourceCollection.snapshots().map(_mapLimitedResources) ??
        [];
  }

  Stream<List<TagInfo>> get areaControlTags {
    return areaControlTagsCollection.snapshots().map(_mapTagInfo);
  }

  Stream<List<AreaControlModel>> get areaControlModels {
    if (locators.mapService.areacontrolfilter.isEmpty)
      return areaControlCollection.snapshots().map(_mapAreaControl) ?? [];
    return areaControlCollection
            .where("color", whereIn: locators.mapService.areacontrolfilter)
            .snapshots()
            .map(_mapAreaControl) ??
        [];
  }

  Stream<List<AreaControlPolyModel>> get areaControlPolyModels {
    if (locators.mapService.areacontrolfilter.isEmpty)
      return areaControlPolyCollection.snapshots().map(_mapAreaControlPoly) ??
          [];
    return areaControlPolyCollection
            .where("color", whereIn: locators.mapService.areacontrolfilter)
            .snapshots()
            .map(_mapAreaControlPoly) ??
        [];
  }

  Stream<List<Rule>> get rulesStream {
    return rulesCollection
            .where("active", isEqualTo: true)
            .snapshots()
            .map(_ruleFromSnapshot) ??
        [];
  }

  Stream<List<ArchiveRule>> get rulesArchiveStream {
    return rulesCollection
            .where("active", isEqualTo: false)
            .snapshots()
            .map(_ruleArchiveFromSnapshot) ??
        [];
  }

  Stream<List<Volunteer>> get volunteersStream {
    return volunteerCollection.snapshots().map(_volunteerFromSnapshot) ?? [];
  }

  Stream<List<Volunteer>> get myVolunteering {
    return volunteerCollection
            .where("volunteers", arrayContains: locators.userService.id)
            .snapshots()
            .map(_myvolunteerFromSnapshot) ??
        [];
  }

  Stream<List<ProceduralArticle>> get proceduralArticlesStream {
    return articleCollection
            .where("category", isEqualTo: "procedural")
            .where("active", isEqualTo: true)
            .snapshots()
            .map(_proceduralArticleFromSnapshot) ??
        [];
  }

  Stream<List<RecommendationArticle>> get recommendationArticlesStream {
    return articleCollection
            .where("category", isEqualTo: "recommendation")
            .where("active", isEqualTo: true)
            .snapshots()
            .map(_recommendationArticleFromSnapshot) ??
        [];
  }

  Stream<List<ArchivedArticle>> get archiveArticlesStream {
    return articleCollection
            .where("active", isEqualTo: false)
            .snapshots()
            .map(_archivedArticleFromSnapshot) ??
        [];
  }

  Stream<List<SearchArticle>> searchArticlesStream(
      String category, String search,
      {bool isArchive = false}) {
    if (isArchive) {
      return articleCollection
              .where("active", isEqualTo: !isArchive)
              .snapshots()
              .map((s) => _searchArticleFromSnapshot(s, search)) ??
          [];
    }
    if (category.isEmpty) {
      return articleCollection
              .snapshots()
              .map((s) => _searchArticleFromSnapshot(s, search)) ??
          [];
    }

    return articleCollection
            .where("category", isEqualTo: category)
            .snapshots()
            .map((s) => _searchArticleFromSnapshot(s, search)) ??
        [];
  }

  Stream<List<SearchVolunteer>> searchVolunteerStream(
    String search,
  ) {
    return volunteerCollection
            .snapshots()
            .map((s) => _searchVolunteerFromSnapshot(s, search)) ??
        [];
  }

  void updateLang(String newValue) {
    userDataCollection
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({"lang": newValue});
  }

  void updateNationalId(String newValue) {
    userDataCollection
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({"nationalID": newValue});
  }

  Future<void> updateHomePoint(LatLng position) {
    GeoPoint homepoint = new GeoPoint(position.latitude, position.longitude);
    return userDataCollection
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({"homepoint": homepoint});
  }

  List<Rule> _ruleFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data()["active"] ?? true) {
        if (documentSnapshot.data().isNotEmpty) {
          return Rule.fromDoc(documentSnapshot);
        }
      }
      return null;
    }).toList();
  }

  List<ArchiveRule> _ruleArchiveFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data().isNotEmpty) {
        return ArchiveRule.fromDoc(documentSnapshot);
      }
      return null;
    }).toList();
  }

  List<Volunteer> _volunteerFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data()['active'] ?? true) {
        if (documentSnapshot.data().isNotEmpty) {
          if (!((documentSnapshot.data()['volunteers'] ?? []) as List<dynamic>)
              .contains(locators.userService.id))
            return Volunteer.fromDoc(documentSnapshot);
        }
      }
      return null;
    }).toList();
  }

  List<Volunteer> _myvolunteerFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data()['active'] ?? true) {
        if (documentSnapshot.data().isNotEmpty) {
          return Volunteer.fromDoc(documentSnapshot);
        }
      }
      return null;
    }).toList();
  }

  List<ProceduralArticle> _proceduralArticleFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data()['active'] ?? true) {
        if (documentSnapshot.data().isNotEmpty) {
          ProceduralArticle article =
              ProceduralArticle.fromDoc(documentSnapshot, 'ar');
          return article;
        }
      }
      return null;
    }).toList();
  }

  List<RecommendationArticle> _recommendationArticleFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data()['active'] ?? true) {
        if (documentSnapshot.data().isNotEmpty) {
          return RecommendationArticle.fromDoc(documentSnapshot, 'ar');
        }
      }
      return null;
    }).toList();
  }

  List<ArchivedArticle> _archivedArticleFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data().isNotEmpty) {
        return ArchivedArticle.fromDoc(documentSnapshot, 'ar');
      }
      return null;
    }).toList();
  }

  List<SearchArticle> _searchArticleFromSnapshot(
      QuerySnapshot snapshot, String searchWord) {
    return snapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data().isNotEmpty) {
        if (documentSnapshot
                .data()['title']
                .toString()
                .toLowerCase()
                .contains(searchWord.toLowerCase()) ||
            documentSnapshot
                .data()['article']
                .toString()
                .toLowerCase()
                .contains(searchWord.toLowerCase()))
          return SearchArticle.fromDoc(documentSnapshot, 'ar');
      }
      return null;
    }).toList();
  }

  List<SearchVolunteer> _searchVolunteerFromSnapshot(
      QuerySnapshot snapshot, String searchWord) {
    return snapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data().isNotEmpty) {
        if (documentSnapshot
                .data()['title']
                .toString()
                .toLowerCase()
                .contains(searchWord.toLowerCase()) ||
            documentSnapshot
                .data()['article']
                .toString()
                .toLowerCase()
                .contains(searchWord.toLowerCase()))
          return SearchVolunteer.fromDoc(documentSnapshot);
      }
      return null;
    }).toList();
  }

  List<LimitedResourceModel> _mapLimitedResources(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Stream<List<Resource>> resources = limitedResourceCollection
          .doc(doc.id)
          .collection("resources")
          .snapshots()
          .map(_mapResources);
      return LimitedResourceModel.fromDoc(doc, resources);
    }).toList();
  }

  List<Resource> _mapResources(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      if (doc != null && doc.data().isNotEmpty) return Resource.fromDoc(doc);
      return null;
    }).toList();
  }

  List<AreaControlModel> _mapAreaControl(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      if (doc != null && doc.data().isNotEmpty)
        return AreaControlModel.fromDoc(doc);
      return null;
    }).toList();
  }

  List<AreaControlPolyModel> _mapAreaControlPoly(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      if (doc != null && doc.data().isNotEmpty)
        return AreaControlPolyModel.fromDoc(doc);
      return null;
    }).toList();
  }

  List<TagInfo> _mapTagInfo(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TagInfo.fromDoc(doc, 'ar');
    }).toList();
  }
}
