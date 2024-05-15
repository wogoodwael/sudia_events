import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/presentation/screens/client/settings/widgets/header_services.dart';

class PillDetails extends StatefulWidget {
  PillDetails({Key? key}) : super(key: key);

  @override
  _PillDetailsState createState() => _PillDetailsState();
}

class _PillDetailsState extends State<PillDetails> {
  bool showContainer = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> firstRow = [
      const Text(''),
      const Text(' المبلغ'),
      const SizedBox(width: 2),
      const Text('مقدم الخدمة '),
    ];
    List<Widget> data = [
      Icon(
        showContainer ? Icons.arrow_drop_down_outlined : Icons.arrow_back_ios,
        size: showContainer ? 20 : 10,
      ),
      const Text(
        ' 300',
        style: TextStyle(color: Colors.grey),
      ),
      const SizedBox(width: 20),
      const Text(' قاعة غيم  '),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              const Header(
                text: '002555675751',
                paddingButtom: 50,
                paddingTop: 70,
              ),
              Positioned(
                right: 10,
                top: 50,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Transform.scale(
                    scale: 1.5,
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.all(8),
              width: 400,
              height: showContainer ? 150 : 70,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: firstRow,
                  ),
                  const Divider(indent: 10, endIndent: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showContainer = !showContainer;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: data,
                    ),
                  ),
                  if (showContainer)
                    _buildServicesDetails(), // Extracted method for services details
                  const Divider(endIndent: 10, indent: 10),
                  _buildTotalRow(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesDetails() {
    return SizedBox(
      width: 400,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          _buildServiceRow('1000', 'بوفية'),
          _buildServiceRow('1000', 'طبخ'),
          _buildServiceRow('1000', 'عصاير'),
        ],
      ),
    );
  }

  Widget _buildServiceRow(String amount, String serviceName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 4),
        Text(amount, style: TextStyle(color: Colors.grey)),
        SizedBox(width: 2),
        FittedBox(
            child: Text(serviceName, style: TextStyle(color: Colors.grey))),
      ],
    );
  }

  Widget _buildTotalRow() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  showContainer = !showContainer;
                });
              },
              child: const Icon(
                Icons.arrow_back_ios,
                size: 10,
              ),
            ),
            const Text(
              ' 1300',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(width: 20),
            const Text('مطاعم الرياض '),
          ],
        ),
        const Divider(endIndent: 10, indent: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(' 645', style: TextStyle(color: Colors.grey)),
            SizedBox(width: 20),
            Text('الضريبة'),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(' 4300', style: TextStyle(color: Colors.grey)),
            SizedBox(width: 20),
            Text('المجموع'),
          ],
        ),
      ],
    );
  }
}
