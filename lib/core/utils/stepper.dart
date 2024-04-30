import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

class StepperScreen extends StatefulWidget {
  StepperScreen({
    Key? key,
    required this.active,
    required this.lineColor,
    required this.stepperColor,
    required this.textColor,
    this.finishColor,
  }) : super(key: key);

  final Color lineColor;
  final Color stepperColor;
  final Color textColor;
  final Color? finishColor;
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
      padding: EdgeInsets.all(8),
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
      onStepReached: (index) => setState(() => widget.active = index),
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return "تم التنفيذ";
      case 1:
        return "قيد التنفيذ";
      case 2:
        return "الاستلام من مقدم الخدمة";
      case 3:
        return "قيد المراجعة";
      default:
        return "";
    }
  }
}
