import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';

class UserFormScreen extends StatefulWidget {
  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  DateTime? _selectedDate;
  List<File> _images = [];
  TextEditingController _dateController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  String? name;
  String? email;
  String? phone;
  String? _gender;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        if (userData != null) {
          setState(() {
            name = userData['name'] ?? '';
            email = userData['email'] ?? '';
            phone = userData['phone'] ?? '';
            _profileImageUrl = userData['profileImageUrl'];
          });
        }
      }
    }
  }

  Future<void> _updateUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': _nameController.text,
        'email': _emailController.text,
        'location': _locationController.text,
        'gender': _gender,
        'birthdate': _selectedDate,
        'profileImageUrl': _profileImageUrl,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User data updated successfully')),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => BottomBarScreen(
                    id: sharedpref.getString('token')!,
                    uniquId: sharedpref.getString('uniquID') ?? "1",
                    date: DateTime.now(),
                  )));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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
      if (images.isNotEmpty) {
        _uploadImage(images.first);
      }
    }
  }

  Future<void> _uploadImage(File image) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref =
            storage.ref().child('user_images').child('${user.uid}.jpg');
        UploadTask uploadTask = ref.putFile(image);

        TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
        String downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          _profileImageUrl = downloadUrl;
          _images = [image];
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
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
                backgroundImage: _profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : null,
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
                      : _profileImageUrl == null
                          ? Icon(Icons.edit, color: Colors.orange)
                          : null,
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
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 10),
                        Image.asset('assets/images/sudio_flag.png', width: 24),
                        SizedBox(width: 5),
                      ],
                    ),
                    hintText: phone,
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
                  controller: _nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    prefixIconColor: Colors.grey[400],
                    hintText: name,
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
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
                    value: _gender,
                    decoration: InputDecoration(
                      labelText: _gender,
                      border: InputBorder.none,
                    ),
                    items: <String>['ذكر', 'انثي'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _gender = newValue;
                      });
                    },
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    prefixIconColor: Colors.grey[400],
                    hintText: email,
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.emailAddress,
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
                  controller: _dateController,
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
                  keyboardType: TextInputType.text,
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
                  controller: _locationController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined),
                    prefixIconColor: Colors.grey[400],
                    hintText: 'الخالدية-جدة -المملكة',
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(height: 20),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                minWidth: .7 * mediawidth(context),
                color: primary,
                onPressed: _updateUserData,
                child: Text(
                  'حفظ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                minWidth: .7 * mediawidth(context),
                onPressed: () {
                  Navigator.pop(context);
                },
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
}
