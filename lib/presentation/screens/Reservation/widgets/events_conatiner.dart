import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class EventsContainer extends StatefulWidget {
  const EventsContainer(
      {super.key,
      required this.name,
      required this.phone,
      required this.onPressed,
      required this.widgetRow,
      required this.family,
      required this.tribe});
  final TextEditingController name;
  final Widget widgetRow;
  final TextEditingController phone;
  final void Function()? onPressed;
  final TextEditingController family;
  final TextEditingController tribe;
  @override
  State<EventsContainer> createState() => _EventsContainerState();
}

class _EventsContainerState extends State<EventsContainer> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mediawidth(context),
      height: .9 * mediaheight(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 10, bottom: 10),
              child: Text(
                "ادخل بياناتك ",
                style: TextStyle(fontFamily: 'JF',
                    fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
            ),
            Center(
              child: Container(
                  width: .8 * mediawidth(context),
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white, border: Border.all(color: primary)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, right: 5),
                    child: TextField(
                      controller: widget.name,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'الاسم  ',
                          hintTextDirection: TextDirection.rtl),
                    ),
                  )),
            ),
            Center(
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: .8 * mediawidth(context),
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white, border: Border.all(color: primary)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, right: 5),
                    child: TextField(
                      controller: widget.family,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'اسم العائلة ',
                          hintTextDirection: TextDirection.rtl),
                    ),
                  )),
            ),
            Center(
              child: Container(
                  width: .8 * mediawidth(context),
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white, border: Border.all(color: primary)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, right: 5),
                    child: TextField(
                      controller: widget.tribe,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'اسم القبيله',
                          hintTextDirection: TextDirection.rtl),
                    ),
                  )),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 10, bottom: 10),
              child: Text(
                "رقم الجوال ",
                style: TextStyle(fontFamily: 'JF',
                    fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
            ),
            Center(
              child: Container(
                width: .8 * mediawidth(context),
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: primary)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 5),
                  child: TextField(
                    controller: widget.phone,
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '021548585',
                        hintStyle: TextStyle(fontFamily: 'JF',color: Colors.grey, fontSize: 12),
                        hintTextDirection: TextDirection.rtl),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 5,
            ),
            widget.widgetRow,
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Image.asset(
                "assets/images/image.png",
                width: 350,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("اظهار المناسبة في المواعيد", style: TextStyle(fontFamily: 'JF')),
                  Transform.scale(
                    scale: .6,
                    child: Checkbox(
                      activeColor: primary,
                      visualDensity: VisualDensity.compact,
                      value: value, // Set the initial value of the checkbox
                      onChanged: (bool? value) {
                        setState(() {
                          this.value = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: MaterialButton(
                color: primary,
                height: 30,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minWidth: .8 * mediawidth(context),
                onPressed: widget.onPressed,
                child: const Text(
                  "استمرار",
                  style: TextStyle(fontFamily: 'JF',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
