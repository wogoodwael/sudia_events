import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class BookingSummaryScreen extends StatelessWidget {
  final String img;
  final String name;
  final String price;
  final String discount;
  final List options;
  final String subtotal;
  final String discountf;
  final String total;
  final String number;
  final String type;
  const BookingSummaryScreen({
    super.key,
    required this.img,
    required this.name,
    required this.price,
    required this.discount,
    required this.options,
    required this.subtotal,
    required this.total,
    required this.discountf,
    required this.number,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملخص الحجز'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingHeader(
                number: number,
                type: type,
              ),
              const SizedBox(height: 16),
              BookingDetails(
                img: img,
                name: name,
                price: price,
                discount: discount,
                options: options,
              ),
              const SizedBox(height: 16),
              BookingTotal(
                subtotal: subtotal,
                discount: discountf,
                total: total,
              ),
              const SizedBox(height: 5),
              type == 'مكتمل'
                  ? DownloadInvoiceButton(
                      number: number,
                    )
                  : Container(),
              const SizedBox(height: 16),
              const RebookButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingHeader extends StatelessWidget {
  final String number;
  final String type;
  const BookingHeader({super.key, required this.number, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70,
          height: 30,
          decoration: BoxDecoration(
            color: type == 'مكتمل'
                ? Colors.green.withOpacity(0.1)
                : Colors.grey.withOpacity(.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              type,
              style: TextStyle(fontFamily: 'JF',
                  color: type == 'مكتمل' ? Colors.green : Colors.grey),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "حجز رقم ",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            Text(
              number,
              style: const TextStyle(fontFamily: 'JF',fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

class BookingDetails extends StatelessWidget {
  final String img;
  final String name;
  final String price;
  final String discount;
  final List options;

  const BookingDetails(
      {super.key,
      required this.img,
      required this.name,
      required this.price,
      required this.discount,
      required this.options});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Image.network(
                      img, // Replace with the actual image URL
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'SAR $price',
                              style: const TextStyle(fontFamily: 'JF',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'SAR $discount',
                              style: const TextStyle(fontFamily: 'JF',
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4.0),
                    const Divider(),
                    ...options.map((option) {
                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${option['option']}',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  ' SAR${option['price']}',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Repeat _OrderItem as needed based on your data structure
                        ],
                      );
                    }),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 20),
                        Text('4.9', style: TextStyle(fontFamily: 'JF',fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                Text(
                  'التوصيل إلى: المنزل',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              '212 حي الخالدية - جدة - المملكة العربية السعودية',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  5,
                  (index) => Icon(
                        Icons.star,
                        color: Colors.yellow[800],
                      )),
            ),
            Container(
              width: mediawidth(context),
              height: 90,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'اكتب رايك',
                        hintStyle: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        border: InputBorder.none),
                  ),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.grey,
                          ),
                          Icon(
                            Icons.photo,
                            size: 20,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BookingTotal extends StatelessWidget {
  final String subtotal;
  final String discount;
  final String total;
  const BookingTotal(
      {super.key,
      required this.subtotal,
      required this.discount,
      required this.total});

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المجموع',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtotal,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'مقدار الخصم',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '20%',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'مبلغ الخصم',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                Text(
                  discount,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 3,
              thickness: 1,
              color: Colors.black,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment
                  .start, // Change this to MainAxisAlignment.start
              children: [
                Transform.scale(
                  scale: .7,
                  child: Checkbox(
                      activeColor: Colors.grey,
                      value: true,
                      onChanged: (va) {}),
                ),
                Text(
                  'إضافة حجزك في مناسبة😊😇',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'SAR 10.00',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 3,
              thickness: 1,
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الإجمالي',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400, fontSize: 18)),
                Text(total,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.green)),
              ],
            ),
            const Divider(
              height: 5,
              thickness: 1,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}

class DownloadInvoiceButton extends StatelessWidget {
  final String number;
  const DownloadInvoiceButton({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "تحميل فاتورة الحجز",
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        Text(
          number,
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 16),
        )
      ],
    );
  }
}

class RebookButton extends StatelessWidget {
  const RebookButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mediawidth(context),
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 5)
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Center(
        child: MaterialButton(
          height: 40,
          color: primary,
          minWidth: .8 * mediawidth(context),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "اعادة الحجز ",
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
              const Icon(
                Icons.shopping_bag,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
