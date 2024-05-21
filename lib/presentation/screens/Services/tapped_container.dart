import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/helper/custom_checkBox.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class TappedContainer extends StatefulWidget {
  const TappedContainer({super.key, required this.textData});
  final List<String> textData;
  @override
  State<TappedContainer> createState() => _TappedContainerState();
}

class _TappedContainerState extends State<TappedContainer> {
  List<String> measuring = ['متر', 'كيلو', 'حبة'];
  List<int> number = [5, 1, 20];
  List<double> pricePerItem = [15.0, 15.0, 15.0];
  List<double> totalPrices = [];

  @override
  void initState() {
    super.initState();
    totalPrices = List.generate(
        pricePerItem.length, (index) => number[index] * pricePerItem[index]);
  }

  void _incrementQuantity(int index) {
    setState(() {
      number[index]++;
      totalPrices[index] = number[index] * pricePerItem[index];
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (number[index] > 0) {
        number[index]--;
        totalPrices[index] = number[index] * pricePerItem[index];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        width: .92 * mediawidth(context),
        height: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: primary),
            left: BorderSide(color: primary),
            right: BorderSide(color: primary),
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            topLeft: Radius.circular(5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 10),
              child: Text("الخدمات المحجوزة"),
            ),
            SizedBox(
              width: mediawidth(context),
              height: 150,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: widget.textData.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, bottom: 5),
                                  child: Text(
                                    measuring[index],
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add_circle,
                                      color: Colors.green[300],
                                    ),
                                    onPressed: () => _incrementQuantity(index),
                                  ),
                                ),
                                Text(number[index].toString()),
                                IconButton(
                                  onPressed: () => _decrementQuantity(index),
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Text(
                                  totalPrices[index].toStringAsFixed(2),
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  " SR",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 7,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 5),
                            CustomCheckBox(
                              text: widget.textData[index],
                              value: false,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(.3),
                        indent: 10,
                        endIndent: 10,
                        height: 0,
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Text(
                    textAlign: TextAlign.right,
                    softWrap: true,
                    " هذه هي اول ملاحظه تم كتابتها في هذا التطبيق وقد تبين ان هذه هي اول ملاحظه يقوم بهاالمستخدم العادي ",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5.0, left: 15),
                  child: Text(
                    "اضف ملاحظة",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
