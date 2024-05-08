import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class UnTappedContainer extends StatefulWidget {
  const UnTappedContainer(
      {super.key,
      required this.tapped,
      this.onTap,
      required this.indexData,
      required this.indexPrice});
  final bool tapped;
  final void Function()? onTap;
  final String indexData;
  final String indexPrice;

  @override
  State<UnTappedContainer> createState() => _UnTappedContainerState();
}

class _UnTappedContainerState extends State<UnTappedContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, right: 10, left: 10),
      width:
          widget.tapped ? .92 * mediawidth(context) : .97 * mediawidth(context),
      height: 110,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.tapped ? primary : Colors.white,
          border: Border(
              top: BorderSide(color: primary),
              left: BorderSide(color: primary),
              right: BorderSide(color: primary),
              bottom: BorderSide(color: primary))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 10,
                          color: Colors.yellow,
                        ),
                        Icon(
                          Icons.star,
                          size: 10,
                          color: Colors.yellow,
                        ),
                        Icon(
                          Icons.star,
                          size: 10,
                          color: Colors.yellow,
                        ),
                        Icon(
                          Icons.star,
                          size: 10,
                          color: Colors.yellow,
                        ),
                        Icon(
                          Icons.star,
                          size: 10,
                          color: Colors.yellow,
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, top: 5),
                      width: 70,
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: widget.tapped ? Colors.white : primary),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "SR",
                              style: TextStyle(
                                  fontSize: 10,
                                  color:
                                      widget.tapped ? primary : Colors.white),
                            ),
                          ),
                          Text(
                            widget.indexPrice,
                            style: TextStyle(
                                color: widget.tapped ? primary : Colors.white),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.indexData,
                        style: TextStyle(
                            color: widget.tapped ? Colors.white : Colors.black),
                      ),
                      Row(
                        children: [
                          Text(
                            "جدة- حي الشاطئ",
                            style: TextStyle(
                                color: widget.tapped ? Colors.white : primary,
                                fontSize: 9),
                          ),
                          Icon(
                            Icons.location_on,
                            size: 10,
                            color: widget.tapped ? Colors.white : primary,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: widget.tapped ? Colors.white : primary,
                  radius: 20,
                  child: Center(
                    child: Image.asset(
                      "assets/images/just_logo.png",
                      color: widget.tapped ? primary : Colors.white,
                      width: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 20, left: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onTap,
                  child: Icon(
                    Icons.keyboard_arrow_up_outlined,
                    color: widget.tapped ? Colors.white : Colors.grey,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 100,
                ),
                Expanded(
                  child: Text(
                    textAlign: TextAlign.end,
                    " نبذه عن القصر ومواصفاته ونبذه ع نبذه عن القصر ومواصفاته ونبذه عن نبذه عن القصر  نبذه عن القصر ومواصفاته ونبذه  ومواصفاته ونبذه عن",
                    softWrap: true,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.tapped ? Colors.white : primary,
                        fontSize: 8),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
