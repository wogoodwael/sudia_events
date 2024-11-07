import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<bool> onTapped = [false, false, false, false, false];

  List reviews = ['الكل', 'positive', ' negative', '1 ', '2'];
  String selectedService = 'الكل';
  void _onServiceSelected(int index) {
    setState(() {
      for (int i = 0; i < onTapped.length; i++) {
        onTapped[i] = i == index;
      }
      selectedService = reviews[index];
      // Reset favorites when a specific service is selected
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("التعليقات", style: TextStyle(fontFamily: 'JF')),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "التعليقات",
              style: TextStyle(fontFamily: 'JF',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "ورد صناعي",
              style: TextStyle(fontFamily: 'JF',
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    height: 170,
                    child: Column(
                      children: List.generate(5, (index) {
                        int rating = 5 - index;
                        double ratingValue = getRatingValue(
                            rating); // Replace with your actual values
                        return RatingBar(rating: rating, value: ratingValue);
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "4.9",
                        style: TextStyle(fontFamily: 'JF',
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 24,
                          ),
                        ),
                      ),
                      const Text("(1,205)", style: TextStyle(fontFamily: 'JF')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(reviews.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChoiceChip(
                      checkmarkColor: Colors.white,
                      selectedColor: primary,
                      label: Text(
                        reviews[index],
                        style: TextStyle(fontFamily: 'JF',
                            color:
                                onTapped[index] ? Colors.white : Colors.black),
                      ),
                      selected: onTapped[index],
                      onSelected: (_) => _onServiceSelected(index),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: List.generate(4, (index) {
                  return const ReviewTile();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundImage: ExactAssetImage("assets/images/p.png"),
            radius: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      "John Doe",
                      style: TextStyle(fontFamily: 'JF',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "29/03/2024",
                      style: TextStyle(fontFamily: 'JF',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Delicious chicken برقر! Loved the crispy chicken and the bun was perfectly toasted. Definitely a new favorite!",
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

double getRatingValue(int rating) {
  // Replace this with actual logic to get the rating values
  // For demonstration, returning dummy values
  switch (rating) {
    case 5:
      return 0.9;
    case 4:
      return 0.2;
    case 3:
      return 0.1;
    case 2:
      return 0.0;
    case 1:
      return 0.0;
    default:
      return 0.0;
  }
}

class RatingBar extends StatelessWidget {
  final int rating;
  final double value;

  const RatingBar({super.key, required this.rating, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$rating',
            style: const TextStyle(fontFamily: 'JF',fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
