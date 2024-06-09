import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/res_content_model.dart';
import 'package:sudia_events/data/services/fetch_data.dart';
import 'package:sudia_events/presentation/screens/Services/offers_screen.dart';

class BookResturant extends StatefulWidget {
  const BookResturant({super.key, required this.name});
  final String name;
  @override
  State<BookResturant> createState() => _BookResturantState();
}

class _BookResturantState extends State<BookResturant> {
  List<bool> ontapped = [false, false, false, false, false];

  bool delivery = false;
  bool fromShop = false;
  bool shouldCloseBottomSheet =
      false; // Flag to indicate whether to close the bottom sheet

// Inside your build method or wherever appropriate
  SolidController _controller = SolidController(); // Define your controller

  List<String> number = ["1", "0", "0", "1"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<ResturantDetailsModel>>(
        future: fetchDetailsResturantData(widget.name),
        builder: (BuildContext context,
            AsyncSnapshot<List<ResturantDetailsModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: primary,
            )); // Show loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }
          return Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        width: 150,
                        color: primary,
                      ),
                      Transform.scale(
                          scale: 1.5,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_forward,
                                color: primary,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      // return OffersBody(
                      //   ontapped: ontapped,
                      //   resName: widget.name,
                      //   price: snapshot.data![index].price,
                      //   discount: snapshot.data![index].discount,
                      //   img: snapshot.data![index].image,
                      //   dishes: snapshot.data![index].dishes,
                      //   lenght: snapshot.data![index].dishes.length,
                      // );
                    },
                  )),
              Expanded(
                flex: 6,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: mediawidth(context),
                      height: mediaheight(context),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data![index].discount.length,
                        itemBuilder: (BuildContext context, int index2) {
                          return SingleChildScrollView(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        FittedBox(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: Icon(
                                                  Icons.add_circle,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              Text(number[index]),
                                              IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 15,
                                              color: primary,
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 15,
                                              color: primary,
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 15,
                                              color: primary,
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 15,
                                              color: primary,
                                            ),
                                            Icon(
                                              Icons.star,
                                              size: 15,
                                              color: primary,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: .2 * mediawidth(context)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 65,
                                            height: 20,
                                            child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: Text(
                                                snapshot.data![index]
                                                    .dishes[index2],
                                                style: TextStyle(
                                                    color: primary,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            snapshot
                                                .data![index].dishes[index2],
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Container(
                                              width: 70,
                                              height: 20,
                                              child: Text(
                                                snapshot.data![index]
                                                    .overview[index2],
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 7,
                                                    color: Colors.black),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          width: 70,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                    0.5), // Shadow color
                                                spreadRadius:
                                                    1, // Spread radius
                                                blurRadius: 5, // Blur radius
                                                offset: const Offset(1,
                                                    5), // Offset in x and y axes from the box
                                              ),
                                            ],
                                            // border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                            child: Image.network(
                                              snapshot
                                                  .data![index].image[index2],
                                              width: 20,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            bottom: -1,
                                            left: 10,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
                                              child: Container(
                                                width: 70,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: primary,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 5.0),
                                                          child: Text(
                                                            'SR',
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        Text(
                                                          snapshot.data![index]
                                                              .price[index2],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                endIndent: 15,
                                indent: 15,
                              ),
                            ],
                          ));
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
      bottomSheet: Container(
        height: 140,
        width: mediawidth(context),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: primary)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Color(0xfff9f9f9),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _controller.isOpened
                        ? _controller.hide()
                        : _controller.show();
                  },
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: primary),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        delivery = true;
                        fromShop = false;
                        _controller.show();
                      });
                    },
                    child: Container(
                      width: 70,
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: delivery ? primary : Colors.grey,
                                  width: 5))),
                      child: Center(
                          child: Text(
                        'توصيل',
                        style:
                            TextStyle(color: delivery ? primary : Colors.grey),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        fromShop = true;
                        delivery = false;
                        _controller.show();
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: fromShop ? primary : Colors.grey,
                                  width: 5))),
                      child: Center(
                          child: FittedBox(
                              child: Text(
                        'الاستلام من المحل',
                        style:
                            TextStyle(color: fromShop ? primary : Colors.grey),
                      ))),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                minWidth: .8 * mediawidth(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: primary,
                onPressed: () {},
                child: Text(
                  "احجز الان ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
