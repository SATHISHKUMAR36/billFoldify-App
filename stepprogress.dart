import 'package:billfold/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StepProgress extends StatefulWidget {
  final double currentStep;
  final double steps;

  StepProgress({super.key, required this.currentStep, required this.steps});

  @override
  State<StepProgress> createState() => _StepProgressState();
}

class _StepProgressState extends State<StepProgress> {
  double widthProgress = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void onSizeWidget() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (context.size is Size) {
        Size size = context.size!;
        widthProgress = size.width / (widget.steps - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                height: 4,
                width: MediaQuery.of(context).size.width / 3.1,
                margin: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    color: currentTheme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(8)))),
            // SizedBox(
            //   width: 20,
            // ),
            Container(
                height: 4,
                width: MediaQuery.of(context).size.width / 3.1,
                margin: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    color: widget.currentStep >= 1
                        ? currentTheme.primaryColor
                        : Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(8)))),
            Container(
                height: 4,
                width: MediaQuery.of(context).size.width / 3.1,
                margin: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    color: widget.currentStep >= 2
                        ? currentTheme.primaryColor
                        : Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(8))))
          ],
        )
      ],
    );
  }
}
