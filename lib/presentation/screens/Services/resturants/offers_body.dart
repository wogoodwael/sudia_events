import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class OffersBody extends StatefulWidget {
  const OffersBody(
      {super.key,
      required this.ontapped,
      required this.resName,
      required this.price,
      required this.discount,
      required this.img,
      required this.dishes, required this.lenght});
  final List<bool> ontapped;
  final String resName;
  final List price;
  final List discount;
  final List img;
  final List dishes;
  final int lenght;
  @override
  State<OffersBody> createState() => _OffersBodyState();
}

class _OffersBodyState extends State<OffersBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: .1 * mediawidth(context)),
            child: Text(
              widget.resName,
              style: TextStyle(
                  color: primary, fontWeight: FontWeight.w500, fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: .1 * mediawidth(context),
              left: .05 * mediawidth(context),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "عرض الكل ",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey),
                ),
                Text(
                  "العروض",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 5.0),
                Expanded(
                  child: Container(
                    width: 260,
                    height: 150,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.lenght,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          widget.ontapped[index] =
                                              !widget.ontapped[index];
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(10),
                                        width: 110,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                  0.5), // Shadow color
                                              spreadRadius: 1, // Spread radius
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
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                          child: Image.network(
                                            widget.img[index],
                                            width: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: -1,
                                        left: 10,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: Container(
                                            width: 110,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: widget.ontapped[index]
                                                    ? primary
                                                    : Color(0xff848484),
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 2.0),
                                                  child: Text(
                                                    "${widget.discount[index]}%",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 5.0, left: 2),
                                                  child: Text(
                                                    "خصم",
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      widget.price[index],
                                                      style: TextStyle(
                                                          color: widget
                                                                      .ontapped[
                                                                  index]
                                                              ? Colors.amber
                                                              : Colors
                                                                  .grey[900],
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5.0),
                                                      child: Text(
                                                        'SR',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: widget
                                                                      .ontapped[
                                                                  index]
                                                              ? Colors.amber
                                                              : Colors
                                                                  .grey[900],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ))
                                  ],
                                )
                              ],
                            ),
                            Container(
                              width: 100,
                              height: 20,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: widget.ontapped[index]
                                              ? primary
                                              : Colors.white,
                                          width: 5))),
                              child: Center(
                                child: FittedBox(
                                    child: Text(
                                  widget.dishes[index],
                                  style: TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
