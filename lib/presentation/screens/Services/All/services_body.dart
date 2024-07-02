import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudia_events/core/helper/custom_snack_bar.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/Services/All/all_services.dart';
import 'package:sudia_events/presentation/screens/Services/All/invitation.dart';
import 'package:sudia_events/presentation/screens/Services/offers_screen.dart';
import 'package:sudia_events/presentation/screens/Services/subServices/details.dart';
import 'package:sudia_events/presentation/screens/favorite/fav.dart';

// ignore: must_be_immutable
class ServicesBodey extends StatelessWidget {
  final DateTime date;
  final bool inside;
  final String id;
  final String uniquId;
  TextEditingController controller = TextEditingController();

  ServicesBodey(
      {super.key,
      required this.date,
      required this.inside,
      required this.id,
      required this.uniquId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: .07 * mediawidth(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "invitation card".tr(),
                    style: TextStyle(color: primary),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => InvitationCardScreen(
                                    id: id,
                                    date: date,
                                  )));
                    },
                    child: Icon(
                      Icons.add_circle,
                      size: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: .9 * mediawidth(context),
                height: 45,
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'البحث ',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[400],
                      ),
                      suffixIcon: Icon(
                        Icons.tune,
                        color: Colors.grey[400],
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "what".tr(),
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
              SizedBox(height: 10),
              CategorySection(
                date: date,
                inside: inside,
                uniquID: uniquId,
              ),
              SizedBox(height: 16),
              WeeklyOffersSection(
                inside: inside,
                uniquId: uniquId,
              ),
              SizedBox(height: 16),
              PreviousReservationsSection(),
              SizedBox(height: 16),
              FavoritesSection(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final DateTime date;
  final bool inside;
  final String uniquID;
  const CategorySection(
      {super.key,
      required this.date,
      required this.inside,
      required this.uniquID});
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        CategoryItem(
          title: 'kitchens'.tr(),
          icon: Icons.kitchen,
          date: date,
          inside: inside,
          uniquID: uniquID,
        ),
        CategoryItem(
          title: 'resturants'.tr(),
          icon: Icons.restaurant,
          date: date,
          inside: inside,
          uniquID: uniquID,
        ),
        CategoryItem(
          title: 'Places'.tr(),
          icon: Icons.location_on,
          date: date,
          inside: inside,
          uniquID: uniquID,
        ),
        CategoryItem(
          title: 'supplies'.tr(),
          icon: Icons.shopping_bag,
          date: date,
          inside: inside,
          uniquID: uniquID,
        ),
        CategoryItem(
          title: 'gifts'.tr(),
          icon: Icons.card_giftcard,
          date: date,
          inside: inside,
          uniquID: uniquID,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => ServicesScreen(
                          date: date,
                          inside: inside,
                          uniquID: '',
                        )));
          },
          child: Icon(
            Icons.more_horiz_outlined,
            color: primary,
            size: 35,
          ),
        )
      ],
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String uniquID;
  final IconData icon;
  final DateTime date;
  final bool inside;
  CategoryItem(
      {required this.title,
      required this.icon,
      required this.date,
      required this.inside,
      required this.uniquID});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => ServicesScreen(
                      date: date,
                      inside: inside,
                      uniquID: uniquID,
                    )));
      },
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: 2,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: primary),
            SizedBox(height: 8),
            Text(title, style: GoogleFonts.cairo(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class WeeklyOffersSection extends StatelessWidget {
  final bool inside;
  final String uniquId;

  const WeeklyOffersSection(
      {super.key, required this.inside, required this.uniquId});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("weekly offers".tr(),
                style: GoogleFonts.cairo(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => OffersScreen(
                              inside: inside,
                              uniquId: uniquId,
                            )));
              },
              child: Text('see all'.tr(),
                  style: GoogleFonts.cairo(fontSize: 15, color: primary)),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
            height: 220,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('offers').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No offers found');
                }

                // Your data handling code here, for example:
                var offers = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    var offer = offers[index];
                    return GestureDetector(
                      child: WeeklyOfferItem(
                          offer['img'] ?? "",
                          offer['name'] ?? "",
                          offer['discount'] ?? "",
                          offer['price'] ?? "",
                          inside,
                          uniquId),
                    );
                  },
                );
              },
            )),
      ],
    );
  }
}

class WeeklyOfferItem extends StatefulWidget {
  final String img;
  final String name;
  final String discount;
  final String price;
  final bool inside;
  final String uniquID;
  WeeklyOfferItem(this.img, this.name, this.discount, this.price, this.inside,
      this.uniquID);

  @override
  State<WeeklyOfferItem> createState() => _WeeklyOfferItemState();
}

class _WeeklyOfferItemState extends State<WeeklyOfferItem> {
  bool isAddedToFav = false;

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
        'img': widget.img,
        'name': widget.name,
        'discount': widget.discount,
        'price': widget.price,
        // You can add more fields if needed
      });
      setState(() {
        isAddedToFav = !isAddedToFav;
      });
      // Show a snackbar or toast to indicate success
      CustomSnackBar(
        context,
        'add to fav'.tr(),
        Colors.green,
        .75 * mediaheight(context),
      );
    } catch (e) {
      // Handle errors
      print('Error adding to favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MenuItemDetail(
                      img: widget.img,
                      name: widget.name,
                      price: widget.price,
                      options: [],
                      optionsprice: [],
                      dis: widget.discount,
                      rating: '4.5',
                      about: 'من افضل واشهي الاطباق',
                      date: DateTime.now(),
                      type: 'offers',
                      inside: widget.inside,
                      uniquID: widget.uniquID,
                    )));
      },
      child: Container(
        width: 170,
        margin: EdgeInsets.only(right: 10),
        child: Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(widget.img,
                          fit: BoxFit.cover,
                          height: 100,
                          width: double.infinity),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () async {
                          await addToFavorites(context);
                        },
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(
                            isAddedToFav
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name, style: GoogleFonts.cairo(fontSize: 16)),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text('4.9', style: TextStyle(color: Colors.orange)),
                          Icon(Icons.star, color: Colors.orange, size: 16),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text('SAR ${widget.price}',
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough)),
                      Text('SAR ${widget.discount}',
                          style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PreviousReservationsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "prevoius booked".tr(),
          style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          height: 215,
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(20))),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ReservationItem(
                status: 'مكتمل',
                color: Colors.green,
                iconColor: Colors.purple,
                isComplete: true,
              ),
              ReservationItem(
                status: 'مكتمل',
                color: Colors.green,
                iconColor: Colors.purple,
                isComplete: true,
              ),
              ReservationItem(
                status: 'ملغي',
                color: Colors.red,
                iconColor: Colors.orange,
                isComplete: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReservationItem extends StatelessWidget {
  final String status;
  final Color color;
  final Color iconColor;
  final bool isComplete;

  ReservationItem({
    required this.status,
    required this.color,
    required this.iconColor,
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: 150,
        height: 250, // You can adjust this height as needed
        margin: EdgeInsets.only(right: 10),
        child: Card(
          surfaceTintColor: status == 'مكتمل' ? Colors.green : Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(color: color, fontSize: 12),
                    ),
                  ),
                ),
                Icon(Icons.sports_basketball, color: iconColor, size: 35),
                SizedBox(height: 8),
                Text('مطعم النكهة',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                  ' رقم الحجز : SP 0023 ',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
                Text(
                  'منذ أسبوعين',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                // This will push the button to the bottom
              ],
            ),
          ),
        ),
      ),
      Positioned(
        bottom: -5,
        right: 15,
        child: MaterialButton(
          height: 30,
          minWidth: 140,
          color: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
          ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إعادة الطلب',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 2,
              ),
              Icon(
                Icons.restore_rounded,
                color: Colors.white,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

class FavoritesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Favorite'.tr(),
            style:
                GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('favorites')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No favorites found'));
            }

            var favorites = snapshot.data!.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();

            return Container(
              width: mediawidth(context),
              height: .2 * mediaheight(context),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  var favorite = favorites[index];
                  return FavoriteItem(
                    img: favorite['img'],
                    name: favorite['name'] ?? favorite['des'],
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class FavoriteItem extends StatelessWidget {
  final String img;
  final String name;

  FavoriteItem({required this.img, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => FavouriteScreen()));
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.only(right: 10),
        child: Card(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  img,
                  fit: BoxFit.cover,
                  height: 100,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(name, style: GoogleFonts.cairo(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
