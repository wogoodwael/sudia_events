import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/service.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/Services/subServices/sub_services.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';
import 'package:sudia_events/presentation/widgets/search.dart';

class ServicesScreen extends StatefulWidget {
  final DateTime date;
  final bool inside;

  const ServicesScreen({super.key, required this.date, required this.inside});
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  TextEditingController controller = TextEditingController();
  String searchQuery = "";
  List<bool> onTapped = [true, false, false, false];
  String selectedService = 'الكل';
  List<String> services = ['الكل', 'قاعات افراح', 'استراحات', 'ورود'];

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        searchQuery = controller.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Service> _filterServices(List<Service> items, String query) {
    if (query.isEmpty) {
      return items;
    } else {
      return items.where((item) {
        var name = item.name.toLowerCase();
        return name.contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        BottomBarScreen(id: sharedpref.getString('token')!)));
          },
          child: Icon(
            Icons.home,
            color: primary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_forward,
              color: primary,
            ),
          ),
        ],
        title: Text('قائمة الخدمات'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: .03 * mediaheight(context),
                  ),
                  SearchContainernew(
                    hintText: 'البحث',
                    controller: controller,
                    onTap: () {},
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: mediawidth(context),
                    height: 45,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: services.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              for (int i = 0; i < onTapped.length; i++) {
                                onTapped[i] = i == index;
                              }
                              selectedService = services[index];
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                              color:
                                  onTapped[index] ? primary : Colors.grey[200],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Center(
                                  child: Text(
                                    services[index],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: onTapped[index]
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.check,
                                  size: 15,
                                  color: onTapped[index]
                                      ? Colors.white
                                      : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: StreamBuilder<QuerySnapshot>(
              stream: (selectedService == 'الكل')
                  ? FirebaseFirestore.instance
                      .collection('services')
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('services')
                      .where(
                        'uniqu',
                        isEqualTo: selectedService == 'استراحات'
                            ? 'break'
                            : selectedService == 'ورود'
                                ? 'flowers'
                                : 'castle',
                      )
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var services = snapshot.data!.docs
                    .map((doc) => Service.fromFirestore(
                        doc.data() as Map<String, dynamic>))
                    .toList();

                var filteredServices = _filterServices(services, searchQuery);

                return ListView.builder(
                  itemCount: filteredServices.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubServicesScreen(
                              itemName: filteredServices[index].name,
                              date: widget.date,
                              inside: widget.inside,
                            ),
                          ),
                        );
                      },
                      child: ServiceTile(service: filteredServices[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final Service service;

  ServiceTile({required this.service});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115, // Adjust the height as needed
      child: Card(
        surfaceTintColor: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  service.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      service.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      service.description,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                    ),
                    if (service.hasDelivery)
                      Container(
                        width: 80,
                        height: 20,
                        color: Colors.yellow[100],
                        child: Center(
                          child: Text(
                            'يوجد توصيل',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: service.status == 'مفتوح'
                          ? Colors.green[100]
                          : Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        service.status,
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '${service.distance} كلم',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        service.rating.toString(),
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Icon(Icons.star, color: Colors.amber, size: 15),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
