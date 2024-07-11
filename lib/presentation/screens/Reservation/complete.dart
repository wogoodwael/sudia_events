import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BookingSummaryScreen extends StatelessWidget {
  final String img;
  const BookingSummaryScreen({super.key, required this.img});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملخص الحجز'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Add back button functionality here
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BookingHeader(),
              const SizedBox(height: 16),
              BookingDetails(
                img: img,
              ),
              const SizedBox(height: 16),
              const BookingTotal(),
              const SizedBox(height: 16),
              const DownloadInvoiceButton(),
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
  const BookingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              "مكتمل",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("حجز رقم "),
            Text(
              'SP 0023901',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

class BookingDetails extends StatelessWidget {
  final String img;
  const BookingDetails({super.key, required this.img});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ورود الطايف',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'SAR 200.00  SAR 150.00',
                        style: TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        'SAR 150.00',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'SAR 0.50\nSAR 2.00',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow, size: 20),
                          Text('4.9', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'التوصيل إلى: المنزل\n212 حي الخالدية - جدة - المملكة العربية السعودية',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingTotal extends StatelessWidget {
  const BookingTotal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('المجموع'),
                Text('SAR 150.00'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('مقدار الخصم'),
                Text('20%'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('مبلغ الخصم'),
                Text('SAR 115.00'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('إضافة حجزك في مناسبة 😊😇'),
                Text('SAR 10.00'),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('SAR 125.00',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DownloadInvoiceButton extends StatelessWidget {
  const DownloadInvoiceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Add download invoice functionality here
      },
      icon: const Icon(Icons.download),
      label: const Text('تحميل فاتورة الحجز'),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
    );
  }
}

class RebookButton extends StatelessWidget {
  const RebookButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Add rebook functionality here
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: const Text('إعادة الحجز'),
    );
  }
}
