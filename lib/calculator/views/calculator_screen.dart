import 'package:flutter/material.dart';
import 'package:vivarium/calculator/views/widgets/button.dart';
import 'package:vivarium/calculator/views/widgets/custom_text_field.dart';

class CalculatorScreen extends StatefulWidget {
  static const String routeName = "Calculator";
  static const String routeURL = "/Calculator";
  const CalculatorScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController widthController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController substrateController = TextEditingController();

  double waterVolume = 0.0;
  double substrateVolume = 0.0;

  void calculate() {
    double width = double.tryParse(widthController.text) ?? 0.0;
    double length = double.tryParse(lengthController.text) ?? 0.0;
    double height = double.tryParse(heightController.text) ?? 0.0;
    double substrate = double.tryParse(substrateController.text) ?? 0.0;

    double adjustedHeight = height - substrate;

    setState(() {
      waterVolume = (width * length * adjustedHeight) / 1000;
      substrateVolume = (width * length * substrate) / 1000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("수조 물양 계산기"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomTextField(
                          controller: widthController,
                          labelText: "수조 가로(cm)",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomTextField(
                          controller: lengthController,
                          labelText: "수조 세로(cm)",
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomTextField(
                          controller: heightController,
                          labelText: "물높이(cm)",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomTextField(
                          controller: substrateController,
                          labelText: "바닥재(cm)",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Button(
                  onTap: calculate,
                  text: "계산하기",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "💧수조의 물 용량: 약 $waterVolume L",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "🌱바닥재 필요량: 약 $substrateVolume KG",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
