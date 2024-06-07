import 'package:flutter/material.dart';

class MenuItemDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Item Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    'https://example.com/your-image-url.jpg',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(Icons.shopping_basket),
                      onPressed: () {
                        // Navigate to the cart
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'ورد صناعي',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    'SAR 10.00',
                    style: TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'SAR 6.00',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '4.9 (1,205)',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'A delicious chicken burger served on a toasted bun with fresh lettuce, tomato slices, and mayonnaise. Juicy grilled chicken patty seasoned...',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Show more description
                },
                child: Text('See more'),
              ),
              SizedBox(height: 16),
              Text(
                'Additional Options:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              OptionItem(
                label: 'أضف',
                price: 0.50,
              ),
              OptionItem(
                label: 'Add Bacon',
                price: 1.00,
              ),
              OptionItem(
                label: 'Add Meat',
                price: 1.00,
              ),
              OptionItem(
                label: 'Add Meat',
                price: 1.00,
              ),
              OptionItem(
                label: 'Extra Patty',
                price: 2.00,
              ),
              OptionItem(
                label: 'Extra Patty',
                price: 2.00,
              ),
              OptionItem(
                label: 'Double Patty',
                price: 3.50,
              ),
              OptionItem(
                label: 'Double Patty',
                price: 3.50,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          // Decrease quantity
                        },
                      ),
                      Text(
                        '1',
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          // Increase quantity
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add to cart
                    },
                    child: Text('إضافة'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final String label;
  final double price;

  OptionItem({required this.label, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '+ SAR $price',
          style: TextStyle(fontSize: 16),
        ),
        Checkbox(
          value: false,
          onChanged: (bool? value) {
            // Handle checkbox change
          },
        ),
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
