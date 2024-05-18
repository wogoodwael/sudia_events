import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/sub_services_model.dart';
import 'package:sudia_events/data/services/fetch_data.dart';
import 'package:sudia_events/presentation/screens/Services/resturants/book_resturant.dart';
import 'package:sudia_events/presentation/screens/Services/weddings/about_body.dart';
import 'package:sudia_events/presentation/screens/Services/weddings/apoinion_body.dart';

class Resturants extends StatefulWidget {
  const Resturants({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<Resturants> createState() => _ResturantsState();
}

class _ResturantsState extends State<Resturants> {
  bool ontapped = false;
  bool ontappednap = false;
  bool showMore = false;
  PageController _pageController = PageController();
  int _currentPage = 0;
  int count = 0;
  bool next = false;
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
                      try {
                        return Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: PageView.builder(
                                    controller: _pageController,
                                    itemCount:
                                        snapshot.data![index].image.length,
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
                                  bottom:
                                      0 * MediaQuery.of(context).size.height,
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
                                  right:
                                      .03 * MediaQuery.of(context).size.width,
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
                                Positioned(
                                  bottom:
                                      0 * MediaQuery.of(context).size.height,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: .45 *
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
                                              snapshot.data![index].name[count],
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
                                            unselectedLabelColor: Colors.white,
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
                                                                : Colors.white,
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
                                                                : Colors.white,
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
                                                      .data![index].des[count],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: Icon(
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
                                                width: .1 * mediawidth(context),
                                              ),
                                              IconButton(
                                                icon: Icon(
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
                                                      duration: Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.ease,
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
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
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            BookResturant(
                                                              name: snapshot
                                                                  .data![index]
                                                                  .name[count],
                                                            )));
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
                      } catch (e) {
                        return Column(
                          children: [
                            SizedBox(
                              height: .5 * mediaheight(context),
                            ),
                            Center(
                              child: Text("لا يوجد مطاعم اخري "),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                );
              }
            }),
      ),
    );
  }
}
