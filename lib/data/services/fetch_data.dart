import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sudia_events/data/model/booked_services.dart';
import 'package:sudia_events/data/model/res_content_model.dart';
import 'package:sudia_events/data/model/services_model.dart';
import 'package:sudia_events/data/model/sub_services_model.dart';
import 'package:sudia_events/data/model/user_model.dart';

Future<List<ServicesModel>> fetchServicesData() async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('services').get();

    final List<ServicesModel> servicesData = querySnapshot.docs
        .map((DocumentSnapshot<Map<String, dynamic>> doc) => ServicesModel(
              name: doc['name'],
              // des: doc['des'],
              image: doc['image'],
              price: doc['price'],
              services_provider_email: doc['service_provider_email'],
              services_provider_name: doc['service_provider_name'],
              id: doc['id'], type: doc['type'],
            ))
        .toList();

    return servicesData;
  } catch (e) {
    print("Error fetching services data: $e");
    return [];
  }
}

Future<List<SubServicesModel>> fetchDetailsServicesData(String id) async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('SubServices')
            .where('id', isEqualTo: id)
            .get();
    print("Query executed. Total documents: ${querySnapshot.docs.length}");
    querySnapshot.docs.forEach((doc) {
      print("Document: $doc");
    });
    final List<SubServicesModel> servicesDataDetails =
        querySnapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
      print("Document: $doc");
      print("Name: ${doc['name']}");
      print("Des: ${doc['des']}");
      print("Image: ${doc['image']}");
      print("Price: ${doc['price']}");
      return SubServicesModel(
        name: List<dynamic>.from(doc['name']),
        des: List<dynamic>.from(doc['des']),
        image: List<dynamic>.from(doc['image']),
        price: List<dynamic>.from(doc['price']),
      );
    }).toList();
    print("Services data details: $servicesDataDetails");
    return servicesDataDetails;
  } catch (e) {
    print("Error fetching services data: $e");
    return [];
  }
}

//*resturant details
Future<List<ResturantDetailsModel>> fetchDetailsResturantData(
    String name) async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('ResturantsContent')
            .where('name', isEqualTo: name)
            .get();
    print("Query executed. Total documents: ${querySnapshot.docs.length}");
    querySnapshot.docs.forEach((doc) {
      print("Document: $doc");
    });
    final List<ResturantDetailsModel> resturantDataDetails =
        querySnapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
      print("Document: $doc");

      print("Image: ${doc['image']}");
      print("Price: ${doc['price']}");
      return ResturantDetailsModel(
        image: List<dynamic>.from(doc['image']),
        price: List<dynamic>.from(doc['price']),
        dishes: List<dynamic>.from(doc['dishes']),
        discount: List<dynamic>.from(doc['discount']),
        overview: List<dynamic>.from(doc['overview']),
      );
    }).toList();
    print("Resturant data details: $resturantDataDetails");
    return resturantDataDetails;
  } catch (e) {
    print("Error fetching resturant data: $e");
    return [];
  }
}

//*booked services
Future<List<BookedServicesModel>> fetchBookedData() async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('BookServices').get();
    print("Query executed. Total documents: ${querySnapshot.docs.length}");
    querySnapshot.docs.forEach((doc) {
      print("Document: $doc");
    });
    final List<BookedServicesModel> booked =
        querySnapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
      print("Document: $doc");

      print("Price: ${doc['price']}");
      return BookedServicesModel(
        name: doc['name'],
        des: doc['des'],
        price: doc['price'],
        type: doc['type'],
        bofe: doc['bofe'],
        cooking: doc['cooking'],
        jucies: doc['jucies'],
      );
    }).toList();
    print("booked data details: $booked");
    return booked;
  } catch (e) {
    print("Error fetching resturant data: $e");
    return [];
  }
}

Stream<List<UserModel>> fetchUserData({required String id}) async* {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: id)
            .get();

    final List<UserModel> userData =
        querySnapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
      print(doc.data());
      return UserModel(
        name: doc['name'] ?? "",
        phone: doc['phone'] ?? "",
        email: doc['email'] ?? "",
        img: doc['profileImageUrl'] ?? "",
      );
    }).toList();

    yield userData;
  } catch (e) {
    print("Error fetching userData : $e");
    yield [];
  }
}
