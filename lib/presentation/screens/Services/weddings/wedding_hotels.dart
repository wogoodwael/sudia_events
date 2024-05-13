import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/helper/custom_snack_bar.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/services_model.dart';
import 'package:sudia_events/data/model/sub_services_model.dart';
import 'package:sudia_events/data/services/fetch_data.dart';
import 'package:sudia_events/presentation/screens/Services/weddings/about_body.dart';
import 'package:sudia_events/presentation/screens/Services/weddings/apoinion_body.dart';
import 'package:sudia_events/presentation/screens/Services/weddings/show_more_wedding_body.dart';

class WeddingsHotels extends StatefulWidget {
  const WeddingsHotels({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  State<WeddingsHotels> createState() => _WeddingsHotelsState();
}

class _WeddingsHotelsState extends State<WeddingsHotels> {
  bool ontapped = false;
  bool ontappednap = false;
  bool showMore = false;
  PageController _pageController = PageController();
  int _currentPage = 0;
  bool next = false;
  bool prevoius = false;
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
              return Center(
                  child: CircularProgressIndicator(
                color: primary,
              )); // Show loading indicator while fetching data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No data available');
            } else {
              return Container(
                width: mediawidth(context),
                height: mediaheight(context),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Stack(
                          children: [
                            Container(
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
                                    snapshot.data![index]
                                        .image[next ? _currentPage + 1 : index],
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
                                              icon: Icon(
                                                Icons.arrow_back_ios,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  next = !next;
                                                });
                                              },
                                            ),
                                            SizedBox(
                                              width: .4 * mediawidth(context),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  next = !next;
                                                });
                                                if (_currentPage <
                                                    snapshot.data![index].image
                                                            .length -
                                                        1) {
                                                  _pageController.nextPage(
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.ease,
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: .25 * mediaheight(context)),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: .4 *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                          color: Colors.black.withOpacity(0.4),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            "السعر",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            5.0),
                                                                child: Text(
                                                                  'SR',
                                                                  style: TextStyle(
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
                                                                        .price[
                                                                    next
                                                                        ? _currentPage +
                                                                            1
                                                                        : index],
                                                                style: TextStyle(
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
                                                                    .name[
                                                                next
                                                                    ? _currentPage +
                                                                        1
                                                                    : index],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 30),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "جدة - حي الشاطئ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .location_on_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 15,
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          snapshot.data![index]
                                                              .des[index],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                                    onPressed: () {
                                                      FirebaseFirestore
                                                          firebaseFirestore =
                                                          FirebaseFirestore
                                                              .instance;
                                                      CollectionReference
                                                          services =
                                                          firebaseFirestore
                                                              .collection(
                                                                  'BookServices');

                                                      // Create a map representing the event data
                                                      Map<String, dynamic>
                                                          bookingData = {
                                                        'name': snapshot
                                                                .data![index]
                                                                .name[
                                                            next
                                                                ? _currentPage +
                                                                    1
                                                                : index],
                                                        'des': snapshot
                                                                .data![index]
                                                                .des[
                                                            next
                                                                ? _currentPage +
                                                                    1
                                                                : index],
                                                        'price': snapshot
                                                                .data![index]
                                                                .price[
                                                            next
                                                                ? _currentPage +
                                                                    1
                                                                : index],
                                                      };

                                                      // Add the event data to Firestore
                                                      services
                                                          .add(bookingData)
                                                          .then((value) {
                                                        print(
                                                            'services added successfully!');
                                                        CustomSnackBar(
                                                            context,
                                                            'تم حجز الخدمة',
                                                            Colors.green);
                                                      }).catchError((error) {
                                                        print(
                                                            'Failed to add services: $error');
                                                      });
                                                    },
                                                    child: Text(
                                                      "احجز الان",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ))
                                : Positioned(
                                    bottom:
                                        0 * MediaQuery.of(context).size.height,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: .4 *
                                          MediaQuery.of(context).size.height,
                                      color: Colors.black.withOpacity(0.3),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            FittedBox(
                                              child: Text(
                                                snapshot
                                                    .data![index].name[index],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "جدة - حي الشاطئ",
                                                  style: TextStyle(
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
                                              indicatorPadding: EdgeInsets.only(
                                                  bottom: 5, left: 20),
                                              indicatorSize:
                                                  TabBarIndicatorSize.tab,
                                              indicatorWeight: 5,
                                              unselectedLabelColor:
                                                  Colors.white,
                                              labelStyle: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              dividerColor: Colors.transparent,
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
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text("اراء وتقيميات")
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
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [Text("نبذة")],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              labelColor: Colors.white,
                                              onTap: (index) {
                                                setState(() {
                                                  ontapped =
                                                      index == 0 ? true : false;
                                                  ontappednap =
                                                      index == 1 ? true : false;
                                                });
                                              },
                                              indicatorColor: primary,
                                            ),
                                            Expanded(
                                              child: TabBarView(
                                                children: [
                                                  OpinionBody(),
                                                  AboutBody(
                                                      des: snapshot
                                                              .data![index].des[
                                                          next
                                                              ? _currentPage + 1
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
                                                child: Text(
                                                  "المزيد",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
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
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
