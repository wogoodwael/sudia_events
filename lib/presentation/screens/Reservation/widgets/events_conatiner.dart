import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class EventsContainer extends StatefulWidget {
  EventsContainer(
      {super.key,
      required this.name,
      required this.phone,
      required this.onPressed,
      required this.widgetRow});
  final TextEditingController name;
  final Widget widgetRow;
  final TextEditingController phone;
  final void Function()? onPressed;

  @override
  State<EventsContainer> createState() => _EventsContainerState();
}

class _EventsContainerState extends State<EventsContainer> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: mediawidth(context),
      height: .6 * mediaheight(context),
      decoration: BoxDecoration(
          color: Colors.grey[270],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          border: Border.all(color: primary)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "ادخل بياناتك ",
              style: TextStyle(
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
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'اسم المناسبه ',
                        hintTextDirection: TextDirection.rtl),
                  ),
                )),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "رقم الجوال ",
              style: TextStyle(
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
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '021548585',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      hintTextDirection: TextDirection.rtl),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "نوع المناسبة",
                style: TextStyle(color: Colors.grey[700]),
              ),
              Text(
                "الجنس",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          widget.widgetRow,
          SizedBox(
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
                Text("اظهار المناسبة في المواعيد"),
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
              child: Text(
                "استمرار",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
