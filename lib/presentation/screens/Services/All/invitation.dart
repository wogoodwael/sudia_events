// ignore_for_file: unused_field

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/Services/All/continue.dart';
import 'package:sudia_events/presentation/screens/home/booking.dart';
import 'package:sudia_events/presentation/screens/home/check.dart';

class InvitationCardScreen extends StatefulWidget {
  final String id;
  final DateTime date;
  final List<String> price = ['0.0', '15.00', '35.00'];
  final List<String> name = ['M458w', 'M8ws', 'Mqqk'];

  InvitationCardScreen({super.key, required this.id, required this.date});

  @override
  _InvitationCardScreenState createState() => _InvitationCardScreenState();
}

class _InvitationCardScreenState extends State<InvitationCardScreen> {
  TextEditingController husband = TextEditingController();
  TextEditingController wife = TextEditingController();
  TextEditingController visitors = TextEditingController();
  final String _selectedRadio = '';
  final String _selectedCheckbox = '';
  String _selectedCheckboxCard = '';
  final String _selectedImage = '';
  List<bool> isAddedToFavList = [];
  final GlobalKey _screenshotKey = GlobalKey();
  void _showDialog(BuildContext context, File img) {
    showDialog(
      context: context,
      builder: (context) {
        return RepaintBoundary(
          key: _screenshotKey,
          child: AlertDialog(
            surfaceTintColor: Colors.white,
            contentPadding: const EdgeInsets.all(10),
            content: Stack(children: [
              Container(
                width: .7 * mediawidth(context),
                height: .3 * mediaheight(context),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(img), fit: BoxFit.contain)),
              ),
              Positioned(
                  top: 70,
                  right: 10,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: primary,
                    child: IconButton(
                        onPressed: _shareScreenshot,
                        icon: const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 15,
                        )),
                  ))
            ]),
            actions: [
              MaterialButton(
                minWidth: .7 * mediawidth(context),
                color: primary,
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const BookingScreen()));
                },
                child: const Text(
                  'حفظ',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<String?> shareWidgets({required GlobalKey globalKey}) async {
    try {
      if (globalKey.currentContext == null) {
        throw Exception("GlobalKey's currentContext is null");
      }

      RenderRepaintBoundary? boundary = globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception("RenderRepaintBoundary is null");
      }

      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData == null) {
        throw Exception("ByteData is null");
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/screenshot.png').create();
      await imagePath.writeAsBytes(pngBytes);

      return imagePath.path;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void _shareScreenshot() async {
    final imagePath = await shareWidgets(globalKey: _screenshotKey);
    if (imagePath != null) {
      Share.shareXFiles(
        [XFile(imagePath, mimeType: "image/png")],
        text: 'Screenshot from Sudia Events app',
        subject: 'Screenshot',
      );
    }
  }

  String _selectedPrice = '';
  List<File?> _uploadedImages = [];

  @override
  void initState() {
    super.initState();
    isAddedToFavList = List<bool>.filled(widget.name.length, false);
    _uploadedImages = List<File?>.filled(widget.name.length, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('SubServices')
              .doc(widget.id)
              .collection('checkout')
              .snapshots(),
          builder: (context, snapshot) {
            int favoriteCount = 0;
            if (snapshot.hasData) {
              favoriteCount = snapshot.data!.docs.length;
            }
            return Stack(
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.shopify_rounded,
                    color: primary,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CheckoutScreenOverView(
                                  id: widget.id,
                                )));
                  },
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$favoriteCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        title: const Text('بطاقة الدعوة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InvitationForm(
                husband: husband,
                wife: wife,
                visitors: visitors,
              ),
              const SizedBox(height: 16),
              Container(
                color: Colors.white,
                width: .9 * mediawidth(context),
                height: .27 * mediaheight(context),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.price.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPrice = widget.price[index];
                        });
                        print("selected price ${widget.price[index]}");
                      },
                      child: _buildCardItem(context, widget.price[index],
                          widget.name[index], widget.name[index], index),
                    );
                  },
                ),
              ),
              Center(
                child: MaterialButton(
                  minWidth: .9 * mediawidth(context),
                  color: primary,
                  onPressed: () {
                    _uploadedImages[0] != null
                        ? _showDialog(context, _uploadedImages[0]!)
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ContinueInvitation(
                                      id: widget.id,
                                      husband: husband.text,
                                      wife: wife.text,
                                      visitors: visitors.text,
                                      date: widget.date,
                                      price: _selectedPrice,
                                    )));
                  },
                  child: const Text(
                    "التالي ",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _uploadedImages[index] = File(pickedImage.path);
      });
    }
  }

  Widget _buildCardItem(BuildContext context, String price, String title,
      String cardName, int index) {
    Future<void> addToFavorites(BuildContext context) async {
      try {
        // Get current user
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          // User is not logged in
          // You can handle this case according to your app's logic
          return;
        }

        // Add item to favorites collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .add({
          'img':
              'https://firebasestorage.googleapis.com/v0/b/saudievents-99e16.appspot.com/o/invitation_images%2Finvitation.png?alt=media&token=5763a96c-55eb-4995-8625-257d1258f562',
          'name': cardName,
          'discount': "",
          'price': price,
          // You can add more fields if needed
        });
        setState(() {
          isAddedToFavList[index] = !isAddedToFavList[index];
        });
        // Show a snackbar or toast to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to favorites'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        // Handle errors
        print('Error adding to favorites: $e');
      }
    }

    return Card(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
      child: SizedBox(
        width: 150,
        height: .25 * MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                GestureDetector(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(8.0)),
                    child: _uploadedImages[index] != null
                        ? Image.file(
                            _uploadedImages[index]!,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/invitation.png',
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 8.0,
                  right: 8.0,
                  child: GestureDetector(
                    onTap: () async {
                      await addToFavorites(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                          isAddedToFavList[index]
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Checkbox(
                        side: const BorderSide(color: Colors.grey),
                        value: _selectedCheckboxCard == title,
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedCheckboxCard = value! ? title : '';
                          });
                          sharedpref.setDouble('invitation_price',
                              double.parse(widget.price[index]));
                        },
                      ),
                      Text(
                        cardName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
          price[index]=='0.0'?      Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        price,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("تحميل"),
                    GestureDetector(
                        onTap: () => _pickImage(index),
                        child: const Icon(Icons.keyboard_arrow_down_rounded))
                  ],
                ):Container(),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('4.9'),
                    Icon(Icons.star, size: 20, color: Colors.yellow[600]),
                    const SizedBox(width: 4.0),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _additionContainer(String label, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            labelText: 'اسم العريس',
            icon: const Icon(
              Icons.person,
              color: Colors.grey,
            ),
            context: context,
            controller: husband,
          ),
          SizedBox(
            height: .02 * mediaheight(context),
          ),
          _buildTextField(
            labelText: 'الإسم الإضافي ..',
            icon: const Icon(
              Icons.check_circle,
            ),
            iconColor: Colors.orange,
            context: context,
          ),
          SizedBox(height: .02 * mediaheight(context)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              width: .9 * mediawidth(context),
              height: 45,
              color: Colors.white,
              child: const Text(
                'مثال : اسم العروس\nإبنة - كريمة : محمد بن عبدالعزيز ..',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String labelText,
    required Widget icon,
    Color iconColor = Colors.grey,
    TextEditingController? controller,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                prefixIcon: icon,
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InvitationForm extends StatefulWidget {
  final TextEditingController husband, wife, visitors;

  const InvitationForm(
      {super.key,
      required this.husband,
      required this.wife,
      required this.visitors});
  @override
  _InvitationFormState createState() => _InvitationFormState();
}

class _InvitationFormState extends State<InvitationForm> {
  int _selectedBridegroom = 1;
  int _selectedRole = 1;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('اسم العريس', style: TextStyle(fontSize: 15)),
            ),
            Center(
              child: Container(
                  width: .8 * mediawidth(context),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: widget.husband,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'محمد احمد ',
                        contentPadding: EdgeInsets.only(top: 10),
                        hintTextDirection: TextDirection.rtl,
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.grey,
                        )),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('اختر', style: TextStyle(fontSize: 14)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the right
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: _selectedRole,
                  onChanged: (val) {
                    setState(() {
                      _selectedRole = val!;
                    });
                  },
                ),
                const Text("علي ابنة"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the right
              children: [
                Radio<int>(
                  value: 3,
                  groupValue: _selectedRole,
                  onChanged: (val) {
                    setState(() {
                      _selectedRole = val!;
                    });
                  },
                ),
                const Text("علي عروسة"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the right
              children: [
                Radio<int>(
                  value: 2,
                  groupValue: _selectedRole,
                  onChanged: (val) {
                    setState(() {
                      _selectedRole = val!;
                    });
                  },
                ),
                const Text("علي كريمة"),
              ],
            ),
            Center(
              child: Container(
                  width: .8 * mediawidth(context),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: widget.wife,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'علي احمد الزهراني',
                        contentPadding: EdgeInsets.only(top: 10),
                        hintTextDirection: TextDirection.rtl,
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.grey,
                        )),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the right
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: _selectedBridegroom,
                  onChanged: (val) {
                    setState(() {
                      _selectedBridegroom = val!;
                    });
                  },
                ),
                const Text("الداعي"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the right
              children: [
                Radio<int>(
                  value: 2,
                  groupValue: _selectedBridegroom,
                  onChanged: (val) {
                    setState(() {
                      _selectedBridegroom = val!;
                    });
                  },
                ),
                const Text("الداعون"),
              ],
            ),
            Center(
              child: Container(
                  width: .8 * mediawidth(context),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: widget.visitors,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: _selectedBridegroom == 2
                            ? 'الاسم الاول - الاسم الثاني '
                            : 'الاسم الاول ',
                        contentPadding: const EdgeInsets.only(top: 10),
                        hintTextDirection: TextDirection.rtl,
                        suffixIcon: const Icon(
                          Icons.person,
                          color: Colors.grey,
                        )),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('العنوان', style: TextStyle(fontSize: 18)),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                  width: .8 * mediawidth(context),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'قاعة السلام للاحتفالات الكبري ',
                        contentPadding: EdgeInsets.only(top: 10),
                        hintTextDirection: TextDirection.rtl,
                        suffixIcon: Icon(
                          Icons.location_city,
                          color: Colors.grey,
                        )),
                  )),
            ),
            const SizedBox(height: 16),
            const Text('التلفون', style: TextStyle(fontSize: 18)),
            Center(
              child: Container(
                width: .8 * mediawidth(context),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: .01 * mediaheight(context)),
                  child: IntlPhoneField(
                    controller: _phoneController,
                    dropdownIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 5, left: 10),
                      border: InputBorder.none,
                      counterText: "",
                      errorStyle: TextStyle(
                          fontSize: 0, height: 0), // This hides the error text
                    ),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      print(phone.completeNumber);
                      sharedpref.setString('phone', phone.completeNumber);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
