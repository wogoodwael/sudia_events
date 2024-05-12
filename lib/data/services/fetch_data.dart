import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sudia_events/data/model/services_model.dart';

Future<List<ServicesModel>> fetchServicesData() async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('services').get();

    final List<ServicesModel> servicesData = querySnapshot.docs
        .map((DocumentSnapshot<Map<String, dynamic>> doc) => ServicesModel(
              name: doc['name'],
              des: doc['des'],
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

Future<List<ServicesModel>> fetchDetailsServicesData(String id) async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('services')
            .where('id', isEqualTo: id)
            .get();

    final List<ServicesModel> servicesDataDetails = querySnapshot.docs
        .map((DocumentSnapshot<Map<String, dynamic>> doc) => ServicesModel(
              name: doc['name'],
              des: doc['des'],
              image: doc['image'],
              price: doc['price'],
              services_provider_email: doc['service_provider_email'],
              services_provider_name: doc['service_provider_name'],
              id: doc['id'], type: doc['type'],
            ))
        .toList();

    return servicesDataDetails;
  } catch (e) {
    print("Error fetching services data: $e");
    return [];
  }
}
