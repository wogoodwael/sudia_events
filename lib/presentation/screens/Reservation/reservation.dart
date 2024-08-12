import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/Reservation/complete.dart';
import 'package:sudia_events/presentation/screens/Reservation/delete_order.dart';
import 'package:sudia_events/presentation/screens/Reservation/sechdual.dart';
import 'package:sudia_events/presentation/screens/Services/subServices/check_out.dart';
import 'package:sudia_events/presentation/screens/home/location.dart';
import 'package:sudia_events/presentation/widgets/search.dart'; // Firestore package

class ReservationScreen extends StatefulWidget {

  const ReservationScreen({super.key, this.id});
  final String? id;

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final TextEditingController controller = TextEditingController();
  final List<String> services = [
    'All',
    'active',
    'complete',
    'cancel',
    'pending'
  ];
  
  final List<String> arabicservices = [
    'الكل',
    'نشط',
    'مكتمل',
    'ملغي',
    'في انتظار الدفع'
  ];
  final List<bool> onTapped = [false, false, false, false];
  String selectedService = 'All';
  List<dynamic> reservations = [];
  List<dynamic> filteredReservations = [];

  @override
  void initState() {
    super.initState();
    selectedService == 'All';
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot =
        await firestore.collection('booked_services').get();

    setState(() {
      reservations = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data;
      }).toList();
      _filterReservations();
    });
  }

  void _filterReservations() {
    setState(() {
      if (selectedService == 'All') {
        filteredReservations = reservations;
      } else {
        filteredReservations = reservations
            .where((reservation) => reservation['status'] == selectedService)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('yyyy/MM/dd', 'ar').format(DateTime.now()),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              DateFormat('EEEE', 'ar').format(DateTime.now()),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => LocationScreen(
                            lat: sharedpref.getDouble('lat')!,
                            long: sharedpref.getDouble('long')!,
                            fromHome: true,
                          )));
            },
            child: Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(color: Colors.yellow[100]),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'location'.tr(),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.location_on_rounded),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          )
        ],
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
                    Icons.shopping_cart_outlined,
                    color: primary,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutScreen(
                            name: sharedpref.getString('name')!,
                            number: sharedpref.getString('number')!,
                            date: DateTime.parse(sharedpref.getString(
                                'date')!), // Convert String to DateTime
                            uniquID: sharedpref.getString('uniquID')!,
                            img: sharedpref.getString('img')!,
                          ),
                        ));
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
      ),
      body: reservations.isEmpty
          ? const Center(
              child: Text(
                '☺ لايوجد طلبات لديك',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SearchContainernew(
                              hintText: 'search'.tr(),
                              controller: controller,
                              onTap: () {}),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: mediawidth(context),
                            height: 45,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: services.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: ChoiceChip(
                                    label: Text(
                                      arabicservices[index],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            selectedService == services[index]
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    selected:
                                        selectedService == services[index],
                                    selectedColor: primary,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        selectedService = services[index];
                                        _filterReservations();
                                      });
                                      print("seeeeeeeee$selectedService");
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 10),
                Expanded(
                  flex: 5,
                  child: ListView.builder(
                    itemCount: filteredReservations.length,
                    itemBuilder: (context, index) {

                     
                   
                     List<Color>containerColor=[];

                     for(int i=0;i<filteredReservations.length;i++){
                       containerColor.add(secondary);
                     }

                      final reservation = filteredReservations[index];
                         if(reservation['status'] ==
                                                      'complete'){
                                                        containerColor[index]==Colors.green[100];
                                                        //setState(() {
                                                          //  secondary = Colors.green[100]!; 
                                                       // });
                                                     
                                                      }else{
                                                        containerColor[index]==secondary;
                                                    //   setState(() {
                                                       //   secondary=secondary;
                                                      // });
                                                      }
                      final timestamp = reservation['timestamp'] as Timestamp;
                      final date = DateFormat('dd/MM/yyyy HH:mm')
                          .format(timestamp.toDate());
                      final prevoiusDate =
                          DateFormat('dd/MM/yyyy').format(timestamp.toDate());
                      final prevoiusTime =
                          DateFormat('jm').format(timestamp.toDate());



                          // return Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     decoration:BoxDecoration(
                          //       borderRadius:BorderRadius.circular(13),
                          //       color: Colors.orange.withOpacity(0.2),
                                
                          //     ),
                          //     child:Column(
                          //       children: [
                          //                 Row(
                          //                   mainAxisAlignment:MainAxisAlignment.center,
                          //                   children: [
                          //                      const CircleAvatar(
                          //                       backgroundColor: Colors.green,
                          //                       child: Icon(Icons.shopping_bag,
                          //                           color: Colors.white),
                          //                     ),
                          //                   const Text('رقم الحجز ',style:  TextStyle(
                          //                     color:Colors.grey,fontSize: 15.0
                          //                   )),
                          //                 const SizedBox(width: 6,),
                          //                     Text(
                          //                           ' ${reservation['uniquID'].split('-').last}',
                          //                           style: const TextStyle(
                          //                             fontSize: 15.0,
                          //                           ),
                          //                         ),
                          //                   ],
                          //                 ),
                          //                const SizedBox(height: 16,),
                          //                Row(
                          //                 //mainAxisAlignment:MainAxisAlignment.spaceAround,
                          //                 children: [
                          //                 const  SizedBox(width: 11,),
                            
                          
                            
                          //                 Image.network(reservation['img'],height: 50,width: 50,fit:BoxFit.cover),
                            
                          //                 Column(children: [
                            
                          //                   Text(reservation['item_name'],style: const TextStyle(
                          //                     color:Colors.black,fontSize: 18.0
                          //                   )),
                          //                   const SizedBox(height: 6,),
                          //                   Row(
                          //                     children: [
                          //                       const SizedBox(width: 6,),
                          //                       const Text('رقم الحجز ',style:  TextStyle(
                          //                         color:Colors.grey,fontSize: 15.0
                          //                       )),
                          //                       const SizedBox(width: 6,),
                          //                     Text(
                          //                           ' ${reservation['uniquID'].split('-').last}',
                          //                           style: const TextStyle(
                          //                             fontSize: 15.0,color:Colors.grey
                          //                           ),
                          //                         ),
                          //                     ],
                          //                   ),

                          //                    Row(children: [

                          //                  const   Text("حالة الحجز ",style: TextStyle(
                          //                       color:Colors.black,fontSize: 15.0,fontWeight: FontWeight.bold
                          //                     )),

                          //                   const  SizedBox(width: 11,),

                          //                   (reservation['status'] =='pending')?

                          //                     const Text('قيد الانتظار',
                          //                     style:TextStyle(color: primary,fontSize: 15.0),
                          //                     ):const SizedBox(),

                          //                      (reservation['status'] =='complete')?

                          //                     const Text('مكتمل',
                          //                     style:TextStyle(color: primary,fontSize: 15.0),
                          //                     ):const SizedBox(),

                          //                      (reservation['status'] =='complete')?

                          //                     const Text('مكتمل',
                          //                     style:TextStyle(color: primary,fontSize: 15.0),
                          //                     ):const SizedBox(),

                          //                     (reservation['status'] !='complete' || reservation['status'] !='pending')?
                          //                       Text(reservation['status'],
                          //                     style:const TextStyle(color: primary,fontSize: 15.0),
                          //                     ):const SizedBox()
                                              


                          //                   ],),
                          //                    Text(reservation['name'],style: const TextStyle(
                          //                     color:Colors.black,fontSize: 18.0
                          //                   )),



                                          
                            
                            
                            
                            
                          //                 ],),
                            
                            
                          //                ],)
                            
                            
                            
                            
                            
                          //       ],
                          //     ),
                          //   ),
                          // );

                          Color color=Colors.orange.withOpacity(0.2);

                          if(reservation['status'] == 'complete'){

                            color=Colors.green.withOpacity(0.2);
                            
                          }
                           if(reservation['status'] == 'pending'){

                            color=Colors.orange.withOpacity(0.2);

                           }
                      

                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                         
                          decoration:BoxDecoration(
                             color:Colors.white,
                             border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              surfaceTintColor:color,
                              //Colors.orange.withOpacity(0.2),
                              elevation: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                 // color:Colors.white,
                               //   border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: mediawidth(context),
                                      //  color:containerColor[index],
                                     //    secondary,
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10, left: 10, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  // Text(
                                                  //   date,
                                                  //   style: const TextStyle(
                                                  //     fontSize: 14.0,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const CircleAvatar(
                                                    backgroundColor: Colors.green,
                                                    child: Icon(Icons.shopping_bag,
                                                        color: Colors.white),
                                                  ),
                                                  const SizedBox(width: 11,),
                                                  const Text(" حجز رقم ",style:TextStyle(
                                                    color:Colors.grey,fontSize: 14.0,
                                                    fontWeight:FontWeight.bold
                                                  ),),
                                                  const SizedBox(width: 20.0),
                                                  Text(
                                                    '${reservation['uniquID'].split('-').last}',
                                                    style: const TextStyle(
                                                      fontSize: 15.0,
                                                       fontWeight:FontWeight.bold,
                                                       color:Colors.black
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16.0),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [

                                                const Text(

                                                  'عدد الخدمات',
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Text(
                                                  (reservation['options']
                                                      .length+1)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.red),
                                                ),
                                                reservation['status'] == "pending"
                                                    ? Row(
                                                        children: [

                                                        
                                                          MaterialButton(
                                                            elevation: 0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                20)),
                                                            color: Colors.yellow[100],
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          SechdualScreen(
                                                                            date:
                                                                                prevoiusTime,
                                                                            day:
                                                                                prevoiusDate,
                                                                            itemName:
                                                                                reservation[
                                                                                    'item_name'],
                                                                          )));
                                                            },
                                                            child: const Text(
                                                                "اعادة جدولة الحجز"),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          MaterialButton(
                                                              elevation: 0,
                                                              minWidth: 40,
                                                              height: 30,
                                                              color: Colors.red,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (_) =>
                                                                            CancelOrderScreen(
                                                                                uniquID:
                                                                                    reservation['uniquID'])));
                                                              },
                                                              child: const Text(
                                                                "حذف",
                                                                style: TextStyle(
                                                                    color:
                                                                        Colors.white),
                                                              )),
                                                        ],
                                                      )
                                                    : reservation['status'] ==
                                                            'complete'
                                                        ? MaterialButton(
                                                            minWidth: 40,
                                                            height: 30,
                                                            elevation: 0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                20)),
                                                            color: Colors.green[100],
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          BookingSummaryScreen(
                                                                            img: reservation[
                                                                                'img'],
                                                                            name: reservation[
                                                                                'item_name'],
                                                                            price: reservation[
                                                                                'price'],
                                                                            discount:
                                                                                reservation[
                                                                                    'discount'],
                                                                            options:
                                                                                reservation[
                                                                                    'options'],
                                                                            subtotal:
                                                                                '${reservation['subtotal']}',
                                                                            total:
                                                                                '${reservation['total']}',
                                                                            discountf:
                                                                                '${reservation['discount_amount'].toStringAsFixed(2)}',
                                                                            number:
                                                                                '${reservation['uniquID'].split('-').last}',
                                                                            type:
                                                                                'مكتمل',
                                                                          )));
                                                            },
                                                            child: Text(
                                                              "مكتمل",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green[700]),
                                                            ),
                                                          )
                                                        : reservation['status'] ==
                                                                'active'
                                                            ? MaterialButton(
                                                                elevation: 0,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                20)),
                                                                color: Colors
                                                                    .yellow[100],
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (_) =>
                                                                              SechdualScreen(
                                                                                date:
                                                                                    prevoiusTime,
                                                                                day:
                                                                                    prevoiusDate,
                                                                                itemName:
                                                                                    reservation['item_name'],
                                                                              )));
                                                                },
                                                                child: const Text(
                                                                    "اعادة جدولة الحجز"),
                                                              )
                                                            : MaterialButton(
                                                                elevation: 0,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                20)),
                                                                color:
                                                                    Colors.grey[300],
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (_) =>
                                                                              BookingSummaryScreen(
                                                                                img: reservation[
                                                                                    'img'],
                                                                                name:
                                                                                    reservation['item_name'],
                                                                                price:
                                                                                    reservation['price'],
                                                                                discount:
                                                                                    reservation['discount'],
                                                                                options:
                                                                                    reservation['options'],
                                                                                subtotal:
                                                                                    '${reservation['subtotal']}',
                                                                                total:
                                                                                    '${reservation['total']}',
                                                                                discountf:
                                                                                    '${reservation['discount_amount'].toStringAsFixed(2)}',
                                                                                number:
                                                                                    '${reservation['uniquID'].split('-').last}',
                                                                                type:
                                                                                    'ملغي',
                                                                              )));
                                                                },
                                                                child: const Text(
                                                                    "ملغي"),
                                                              )
                                              ],
                                            ),
                                          ],
                                        )),
                                    const SizedBox(height: 10),
                                    // OrderItem(
                                    //   title: '${index + 1}   ${reservation['name']}',
                                    //   price: 'SAR${reservation['price']}',
                                    //   options:
                                    //       reservation['options'] as List<dynamic>,
                                    //   number: reservation['uniquID'].split('-').last,
                                    // ),
                                    // const SizedBox(height: 16.0),
                                    // const Row(
                                    //   children: [
                                    //     Icon(
                                    //       Icons.location_on_outlined,
                                    //       color: Colors.grey,
                                    //       size: 17,
                                    //     ),
                                    //     SizedBox(
                                    //       width: 10,
                                    //     ),
                                    //     Text(
                                    //       'التوصيل إلى ->  المنزل',
                                    //       style: TextStyle(
                                    //         fontSize: 15.0,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // const Text(
                                    //   'حي السلامة - جدة - المملكة العربية السعودية',
                                    //   style: TextStyle(fontSize: 14.0),
                                    // ),
                                    // const SizedBox(
                                    //   height: 10,
                                    // ),
                                    const Divider(),


                                                  Row(
                                                    children: [

                                                      CircleAvatar(
                                                        radius: 30,
                                                        backgroundImage: NetworkImage(reservation['img']??"",
                                                        
                                                        ),

                                                      ),
                                                     
                                                    ],
                                                  ),

                                    OrderItem(
                                      title: '${index + 2}   ${reservation['name']}'
                                      
                                      ,
                                      price: "${reservation['price']}   SAR",
                                      //'SAR${reservation['price']}',
                                      options:
                                          reservation['options'] as List<dynamic>,
                                      number: reservation['uniquID'].split('-').last,
                                    ),
                                    const Row(
                                      children: [
                                       
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'الاستلام من ->  مطعم الباشا',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                          ),
                                        ),
                                         SizedBox(
                                          width: 10,
                                        ),
                                         Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.grey,
                                          size: 17,
                                        ),
                                      ],
                                    ),
                                    const Text(
                                      '512 -حي السلامة - جدة - المملكة العربية السعودية',
                                      style: TextStyle(fontSize: 14.0,
                                      color: Colors.grey
                                      ),
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 33),
                                        const Text(
                                          'الاجمالي',
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color:Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Container(
                                          width: 170,
                                          height: 55,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                '  SAR ${reservation['total'].toString()} ''',
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 15.0,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
