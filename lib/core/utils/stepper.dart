import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StepperScreen extends StatefulWidget {
  StepperScreen({
    super.key,
    required this.active,
    required this.lineColor,
    required this.stepperColor,
    required this.textColor,
    this.finishColor,
    this.onStepTapped,
  });

  final Color lineColor;
  final Color stepperColor;
  final Color textColor;
  final Color? finishColor;
  Function(int)? onStepTapped;
  int active;

  @override
  State<StepperScreen> createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      lineStyle: LineStyle(
        lineThickness: 2,
        lineType: LineType.normal,
        defaultLineColor: widget.lineColor,
        finishedLineColor: widget.finishColor,
        lineLength: 80,
      ),
      padding: const EdgeInsets.all(8),
      activeStep: widget.active,
      activeStepTextColor: Colors.black87,
      finishedStepTextColor: Colors.black87,
      showLoadingAnimation: false,
      stepRadius: 8,
      showStepBorder: false,
      maxReachedStep: 2,
      steps: List.generate(4, (index) {
        return EasyStep(
          customStep: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 7,
              backgroundColor:
                  index == widget.active ? widget.stepperColor : Colors.grey,
            ),
          ),
          customTitle: Text(
            _getTitleForIndex(index),
            style: TextStyle(
              fontSize: 10,
              color: index == widget.active ? widget.textColor : Colors.grey,
              fontFamily: 'futuraMd',
            ),
            textAlign: TextAlign.center,
          ),
        );
      }),
      onStepReached: (index) {
        setState(() {
          widget.active = index;
        });
        if (widget.onStepTapped != null) {
          widget.onStepTapped!(index);
        }
      },
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return "تم ";
      case 1:
        return "تسليم";
      case 2:
        return "توصيل";
      case 3:
        return "مراجعة";
      default:
        return "";
    }
  }
}
