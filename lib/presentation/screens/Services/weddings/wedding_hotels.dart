import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/sub_services_model.dart';
import 'package:sudia_events/data/services/fetch_data.dart';
import 'package:sudia_events/presentation/screens/Services/weddings/about_body.dart';
import 'package:sudia_events/presentation/screens/Services/weddings/apoinion_body.dart';
import 'package:sudia_events/presentation/screens/payment/payment_screen.dart';

class WeddingsHotels extends StatefulWidget {
  const WeddingsHotels({
    super.key,
    required this.id,
  });
  final String id;
  @override
  State<WeddingsHotels> createState() => _WeddingsHotelsState();
}

class _WeddingsHotelsState extends State<WeddingsHotels> {
  bool ontapped = false;
  bool ontappednap = false;
  bool showMore = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool next = false;
  bool prevoius = false;
  int count = 0;
  @override
  void initState() {
    super.initState();
    ontapped = true;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: FutureBuilder<List<SubServicesModel>>(
          future: fetchDetailsServicesData(widget.id),
          builder: (BuildContext context,
              AsyncSnapshot<List<SubServicesModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: primary,
              )); // Show loading indicator while fetching data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No data available');
            } else if (snapshot.hasData) {
              return SizedBox(
                width: mediawidth(context),
                height: mediaheight(context),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    try {
                      return Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: snapshot.data![index].image.length,
                                  onPageChanged: (int page) {
                                    setState(() {
                                      _currentPage = page;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      snapshot.data![index].image[count],
                                      fit: BoxFit.fitHeight,
                                    );
                                  },
                                ),
                              ),
                              Positioned.fill(
                                bottom: 0 * MediaQuery.of(context).size.height,
                                child: Container(
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ),
                              Positioned(
                                top: .05 * MediaQuery.of(context).size.height,
                                left: .03 * MediaQuery.of(context).size.width,
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  width: 150,
                                ),
                              ),
                              Positioned(
                                top: .07 * MediaQuery.of(context).size.height,
                                right: .03 * MediaQuery.of(context).size.width,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              showMore
                                  ? Positioned(
                                      top: .5 * mediaheight(context),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.arrow_back_ios,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    next = !next;
                                                    count--;
                                                  });
                                                  print("shit $count");
                                                },
                                              ),
                                              SizedBox(
                                                width: .4 * mediawidth(context),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    next = !next;
                                                    count++;
                                                  });
                                                  print("shit $count");
                                                  if (_currentPage <
                                                      snapshot.data![index]
                                                              .image.length -
                                                          1) {
                                                    _pageController.nextPage(
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.ease,
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height:
                                                  .25 * mediaheight(context)),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: .4 *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height,
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            const Text(
                                                              "السعر",
                                                              style: TextStyle(fontFamily: 'JF',
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              5.0),
                                                                  child: Text(
                                                                    'SR',
                                                                    style: TextStyle(fontFamily: 'JF',
                                                                        fontSize:
                                                                            17,
                                                                        color:
                                                                            primary),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .price[count],
                                                                  style: const TextStyle(fontFamily: 'JF',
                                                                      color:
                                                                          primary,
                                                                      fontSize:
                                                                          35,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          FittedBox(
                                                            child: Text(
                                                              snapshot
                                                                  .data![index]
                                                                  .name[count],
                                                              style: const TextStyle(fontFamily: 'JF',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 30),
                                                            ),
                                                          ),
                                                          const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "جدة - حي الشاطئ",
                                                                style: TextStyle(fontFamily: 'JF',
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .location_on_outlined,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            snapshot
                                                                .data![index]
                                                                .des[count],
                                                            style: const TextStyle(fontFamily: 'JF',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Center(
                                                    child: MaterialButton(
                                                      minWidth: .7 *
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      color: primary,
                                                      onPressed: () async {
                                                        bool bookServices =
                                                            await showDialog<
                                                                    bool>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                    title: const Text(
                                                                        'قم بحجز خدمة مع القاعة '),
                                                                    content: const Text(
                                                                        ' هل تريد حجز خدمة مع القاعة ؟'),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.of(context).pop(false),
                                                                        child: const Text(
                                                                            'لا'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.of(context).pop(true),
                                                                        child: const Text(
                                                                            'نعم'),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ) ??
                                                                false;

                                                        if (bookServices) {
                                                          _showServicesDialog(
                                                              context,
                                                              snapshot
                                                                  .data![index]
                                                                  .name[count],
                                                              snapshot
                                                                  .data![index]
                                                                  .price[count],
                                                              snapshot
                                                                  .data![index]
                                                                  .des[count]);
                                                        } else {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    const PayMentScreen()),
                                                          );
                                                        }
                                                      },
                                                      child: const Text(
                                                        "احجز الان",
                                                        style: TextStyle(fontFamily: 'JF',
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ))
                                  : Positioned(
                                      bottom: 0 *
                                          MediaQuery.of(context).size.height,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: .4 *
                                            MediaQuery.of(context).size.height,
                                        color: Colors.black.withOpacity(0.3),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              FittedBox(
                                                child: Text(
                                                  snapshot
                                                      .data![index].name[index],
                                                  style: const TextStyle(fontFamily: 'JF',
                                                    color: Colors.white,
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "جدة - حي الشاطئ",
                                                    style: TextStyle(fontFamily: 'JF',
                                                        color: Colors.white),
                                                  ),
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ],
                                              ),
                                              TabBar(
                                                indicatorPadding:
                                                    const EdgeInsets.only(
                                                        bottom: 5, left: 20),
                                                indicatorSize:
                                                    TabBarIndicatorSize.tab,
                                                indicatorWeight: 5,
                                                unselectedLabelColor:
                                                    Colors.white,
                                                labelStyle: const TextStyle(fontFamily: 'JF',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                dividerColor:
                                                    Colors.transparent,
                                                tabs: [
                                                  Container(
                                                    width: 150,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: ontapped
                                                                    ? Colors
                                                                        .transparent
                                                                    : Colors
                                                                        .white,
                                                                width: 5))),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.only(
                                                              top: 20.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text("اراء وتقيميات", style: TextStyle(fontFamily: 'JF'))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: ontappednap
                                                                    ? Colors
                                                                        .transparent
                                                                    : Colors
                                                                        .white,
                                                                width: 5))),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.only(
                                                              top: 20.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text("نبذة", style: TextStyle(fontFamily: 'JF'))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                labelColor: Colors.white,
                                                onTap: (index) {
                                                  setState(() {
                                                    ontapped = index == 0
                                                        ? true
                                                        : false;
                                                    ontappednap = index == 1
                                                        ? true
                                                        : false;
                                                  });
                                                },
                                                indicatorColor: primary,
                                              ),
                                              Expanded(
                                                child: TabBarView(
                                                  children: [
                                                    const OpinionBody(),
                                                    AboutBody(
                                                        des: snapshot
                                                                .data![index]
                                                                .des[
                                                            next
                                                                ? _currentPage +
                                                                    1
                                                                : index]),
                                                  ],
                                                ),
                                              ),
                                              Center(
                                                child: MaterialButton(
                                                  minWidth: .7 *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  color: primary,
                                                  onPressed: () {
                                                    setState(() {
                                                      showMore = !showMore;
                                                    });
                                                  },
                                                  child: const Text(
                                                    "المزيد",
                                                    style: TextStyle(fontFamily: 'JF',
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      );
                    } catch (e) {
                      return Column(
                        children: [
                          SizedBox(
                            height: .5 * mediaheight(context),
                          ),
                          const Center(
                            child: Text("لا يوجد قاعات اخري ", style: TextStyle(fontFamily: 'JF')),
                          ),
                        ],
                      );
                    }
                  },
                ),
              );
            } else {
              return const Center(
                child: Text("no more castle", style: TextStyle(fontFamily: 'JF')),
              );
            }
          },
        ),
      ),
    );
  }

  void _showServicesDialog(BuildContext parentContext, String castleName,
      String price, String des) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firebaseFirestore
        .collection('castleServices')
        .where('name', isEqualTo: castleName)
        .get();
    List<QueryDocumentSnapshot> servicesList = querySnapshot.docs;

    showDialog(
      context: parentContext,
      builder: (context) {
        // Initialize a list to track the selected services
        List<List<bool>> selectedServices = List.generate(
            servicesList.length, (_) => List<bool>.filled(3, false));

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('اختار الخدمة'),
              content: SingleChildScrollView(
                child: Column(
                  children: servicesList.map((service) {
                    int index = servicesList.indexOf(service);
                    return Column(
                      children: [
                        CheckboxListTile(
                          title: Text('${service['cooking']}'),
                          value: selectedServices[index][0],
                          onChanged: (bool? value) {
                            setState(() {
                              selectedServices[index][0] = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('${service['bofe']}'),
                          value: selectedServices[index][1],
                          onChanged: (bool? value) {
                            setState(() {
                              selectedServices[index][1] = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('${service['jucies']}'),
                          value: selectedServices[index][2],
                          onChanged: (bool? value) {
                            setState(() {
                              selectedServices[index][2] = value!;
                            });
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('الغاء'),
                ),
                TextButton(
                  onPressed: () {
                    _bookSelectedServices(parentContext, servicesList,
                        selectedServices, castleName, price, des);
                    Navigator.of(context).pop();
                    // Navigator.push(
                    //   parentContext,
                    //   MaterialPageRoute(builder: (_) => AddServices()),
                    // );
                  },
                  child: const Text('حجز'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _bookSelectedServices(
      BuildContext context,
      List<QueryDocumentSnapshot> servicesList,
      List<List<bool>> selectedServices,
      String castleName,
      String price,
      String des) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference services = firebaseFirestore.collection('BookServices');

    for (int i = 0; i < servicesList.length; i++) {
      bool cookingSelected = selectedServices[i][0];
      bool bofeSelected = selectedServices[i][1];
      bool juciesSelected = selectedServices[i][2];

      // Initialize all service data with empty strings
      String cooking = '';
      String bofe = '';
      String jucies = '';

      // Update service data if selected
      if (cookingSelected) {
        cooking = servicesList[i]['cooking'] ?? '';
      }
      if (bofeSelected) {
        bofe = servicesList[i]['bofe'] ?? '';
      }
      if (juciesSelected) {
        jucies = servicesList[i]['jucies'] ?? '';
      }

      // Add booking data to Firestore
      Map<String, dynamic> bookingData = {
        'type': 'castle',
        'name': castleName,
        'price': price,
        'des': des,
        'cooking': cooking,
        'bofe': bofe,
        'jucies': jucies,
      };

      services.add(bookingData).then((value) {
        print('Service added successfully!');
        // CustomSnackBar(context, 'تم حجز الخدمة', Colors.green);
      }).catchError((error) {
        print('Failed to add service: $error');
      });
    }
  }
}
