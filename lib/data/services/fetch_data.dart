import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sudia_events/data/model/services_model.dart';
import 'package:sudia_events/data/model/sub_services_model.dart';

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
