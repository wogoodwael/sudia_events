import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class UserFormScreen extends StatefulWidget {
  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  DateTime? _selectedDate;
  List<File> _images = [];

  TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            "${picked.toLocal()}".split(' ')[0]; // Formatting date to string
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الملف الشخصي '),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[200],
                child: GestureDetector(
                  onTap: () async {
                    await _getImages();
                  },
                  child: _images.isNotEmpty
                      ? ClipOval(
                          child: Image.file(
                            _images.first,
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          ),
                        )
                      : Icon(Icons.edit, color: Colors.orange),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: .9 * mediawidth(context),
                height: .07 * mediaheight(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 10),
                        Image.asset('assets/images/sudio_flag.png', width: 24),
                        SizedBox(width: 5),
                      ],
                    ),
                    hintText: '(+966) 98458548',
                    hintTextDirection: TextDirection.ltr,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: .9 * mediawidth(context),
                height: .07 * mediaheight(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    prefixIconColor: Colors.grey[400],
                    hintText: 'جمعان سعيد علي زهران',
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: .9 * mediawidth(context),
                height: .07 * mediaheight(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'ذكر',
                      border: InputBorder.none,
                    ),
                    items: <String>['ذكر', 'انثي'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: .9 * mediawidth(context),
                height: .07 * mediaheight(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    prefixIconColor: Colors.grey[400],
                    hintText: 'gan@gmail.com',
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: .9 * mediawidth(context),
                height: .07 * mediaheight(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                    prefixIconColor: Colors.grey[400],
                    hintText: '18/5/2001',
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: .9 * mediawidth(context),
                height: .07 * mediaheight(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined),
                    prefixIconColor: Colors.grey[400],
                    hintText: 'الخالدية-جدة -المملكة',
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              SizedBox(height: 20),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                minWidth: .7 * mediawidth(context),
                color: primary,
                onPressed: () {},
                child: Text(
                  'حفظ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                minWidth: .7 * mediawidth(context),
                onPressed: () {},
                child: Text(
                  'إلغاء',
                  style: TextStyle(color: Colors.grey, fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getImages() async {
    List<Asset> pickedImages = [];
    try {
      pickedImages = await MultiImagePicker.pickImages();
    } catch (e) {
      print('Error picking images: $e');
    }

    if (pickedImages.isNotEmpty) {
      List<File> images = [];
      for (var pickedImage in pickedImages) {
        try {
          final ByteData byteData = await pickedImage.getByteData();
          final List<int> imageData = byteData.buffer.asUint8List();
          final tempDir = await getTemporaryDirectory();
          final tempFile = File('${tempDir.path}/${pickedImage.name}');
          await tempFile.writeAsBytes(imageData);
          images.add(tempFile);
        } catch (e) {
          print('Error converting asset to file: $e');
        }
      }
      setState(() {
        _images = images;
      });
    }
  }
}
