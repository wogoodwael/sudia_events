import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class SearchContainer extends StatefulWidget {
  const SearchContainer({super.key});

  @override
  State<SearchContainer> createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  TextEditingController controller = TextEditingController();
  bool tappedFamily = false;
  @override
  void initState() {
    super.initState();
    tappedFamily = false;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: .9 * mediawidth(context),
        height: 100,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white,
            border: Border.all(color: Colors.grey)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: .8 * mediawidth(context),
                decoration: BoxDecoration(
                    border: Border.all(color: primary),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                height: 30,
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.search,
                        color: primary,
                      )),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 70,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: primary)),
                    child: const Center(
                      child: FittedBox(
                          child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text("نوع المناسبه ", style: TextStyle(fontFamily: 'JF')),
                      )),
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: primary)),
                    child: const Center(
                      child: FittedBox(
                          child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text("المدينة", style: TextStyle(fontFamily: 'JF')),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        tappedFamily = !tappedFamily;
                      });
                      // List data = await Api()
                      //     .filterByFamily(controller.text, controller.text);
                      // print('-----------------$data');
                    },
                    child: Container(
                      width: 70,
                      height: 25,
                      decoration: BoxDecoration(
                          color: tappedFamily ? primary : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: primary)),
                      child: Center(
                        child: FittedBox(
                            child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            "العائلة",
                            style: TextStyle(fontFamily: 'JF',
                                color:
                                    tappedFamily ? Colors.white : Colors.black),
                          ),
                        )),
                      ),
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 25,
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: primary)),
                    child: const Center(
                      child: FittedBox(
                          child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          "القبيلة",
                          style: TextStyle(fontFamily: 'JF',color: Colors.white),
                        ),
                      )),
                    ),
                  ),
                  GestureDetector(child: const Icon(Icons.filter_list))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
