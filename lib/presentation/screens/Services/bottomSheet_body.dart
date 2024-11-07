import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class ButtomSheetBody extends StatelessWidget {
  ButtomSheetBody({super.key, this.onTap});
  final void Function()? onTap;
  List title = ['قاعة غيم', 'مطاعم الرياض', 'مأكولات شعبية'];
  List price = ['3000', '300', '1000'];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: mediawidth(context),
      decoration: const BoxDecoration(
        color: Color(0xfff9f9f9),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("355478599", style: TextStyle(fontFamily: 'JF')),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: primary),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                Text(
                  "ملخص الطلب",
                  style: TextStyle(fontFamily: 'JF',color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      width: 90,
                      height: 20,
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: primary))),
                      child: const Center(
                        child: FittedBox(
                          child: Text(
                            "الاجمالي شامل الضريبة",
                            style: TextStyle(fontFamily: 'JF',),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Text(
                            'SR',
                            style: TextStyle(fontFamily: 'JF',fontSize: 10, color: primary),
                          ),
                        ),
                        Text(
                          "4300",
                          style: TextStyle(fontFamily: 'JF',
                              color: primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 60,
                      height: 20,
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: primary))),
                      child: const Center(
                        child: FittedBox(
                          child: Text(
                            "عدد الخدمات",
                            style: TextStyle(fontFamily: 'JF',),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "3",
                      style: TextStyle(fontFamily: 'JF',
                          fontSize: 20,
                          color: primary,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            ),
            const Divider(
              height: 0,
              endIndent: 10,
              indent: 10,
              color: Colors.black45,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch, // Added this line

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Text(
                                  'SR',
                                  style: TextStyle(fontFamily: 'JF',
                                      fontSize: 7, color: Colors.grey),
                                ),
                              ),
                              Text(
                                price[index],
                                style: const TextStyle(fontFamily: 'JF',
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            title[index],
                            style: const TextStyle(fontFamily: 'JF',fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 0,
                      endIndent: 10,
                      indent: 10,
                      color: Colors.black45,
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(
              height: 5,
            ),
            MaterialButton(
              minWidth: .7 * mediawidth(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: primary,
              onPressed: () {},
              child: const Text(
                "تاكيد",
                style: TextStyle(fontFamily: 'JF',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
