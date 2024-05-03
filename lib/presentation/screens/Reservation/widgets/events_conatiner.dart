import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class EventsContainer extends StatefulWidget {
  const EventsContainer(
      {super.key,
      required this.name,
      required this.gender,
      required this.type,
      required this.phone,required this.onPressed});
  final TextEditingController name;
  final TextEditingController gender;
  final TextEditingController type;
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
      height: .5 * mediaheight(context),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "نوع المناسبة",
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "الجنس",
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                "رقم الجوال ",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: primary)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 5),
                  child: TextField(
                    controller: widget.type,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'نوع المناسبة',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        hintTextDirection: TextDirection.rtl),
                  ),
                ),
              ),
              Container(
                width: 70,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: primary)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 5),
                  child: TextField(
                    controller: widget.gender,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'ذكر/انثي',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        hintTextDirection: TextDirection.rtl),
                  ),
                ),
              ),
              Container(
                width: 150,
                height: 30,
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
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Image.asset(
              "assets/images/image.png",
              width: 350,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  "موقع المناسبة ",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
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
