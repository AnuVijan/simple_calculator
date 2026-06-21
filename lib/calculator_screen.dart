import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String output = "0";
  String firstNumber = "";
  String secondNumber = "";
  String operator = "";
  String expression = "";
  bool isResultShown = false;

  void buttonPressed(String value) {
    setState(() {
      // CLEAR
      if (value == "C") {
        output = "0";
        firstNumber = "";
        secondNumber = "";
        operator = "";
        expression = "";
        isResultShown = false;
      }

      // BACKSPACE
      else if (value == "<") {
        if (output == "Error") {
          output = "0";
        } else if (output.length > 1) {
          output = output.substring(0, output.length - 1);
        } else {
          output = "0";
        }
      }

      // OPERATORS
      else if (value == "+" ||
          value == "-" ||
          value == "*" ||
          value == "/") {
        firstNumber = output;
        operator = value;
        expression = "$firstNumber $operator";
        output = "0";
        isResultShown = false;
      }

      // PERCENTAGE
      else if (value == "%") {
        if (firstNumber.isEmpty || operator.isEmpty) {
          return;
        }

        double num1 = double.parse(firstNumber);
        double num2 = double.parse(output);

        double percentageValue;

        if (operator == "+" || operator == "-") {
          percentageValue = (num1 * num2) / 100;
        } else {
          percentageValue = num2 / 100;
        }

        if (percentageValue == percentageValue.toInt()) {
          output = percentageValue.toInt().toString();
        } else {
          output = percentageValue.toString();
        }
      }

      // DECIMAL
      else if (value == ".") {
        if (!output.contains(".")) {
          if (output == "0") {
            output = "0.";
          } else {
            output += ".";
          }
        }
      }

      // EQUAL
      else if (value == "=") {
        if (firstNumber.isEmpty || operator.isEmpty) {
          return;
        }

        secondNumber = output;

        double num1 = double.parse(firstNumber);
        double num2 = double.parse(secondNumber);

        double result = 0;

        if (operator == "+") {
          result = num1 + num2;
        } else if (operator == "-") {
          result = num1 - num2;
        } else if (operator == "*") {
          result = num1 * num2;
        } else if (operator == "/") {
          if (num2 == 0) {
            output = "Error";
            return;
          }

          result = num1 / num2;
        }

        expression = "$firstNumber $operator $secondNumber";

        if (result == result.toInt()) {
          output = result.toInt().toString();
        } else {
          output = result.toString();
        }

        firstNumber = "";
        secondNumber = "";
        operator = "";
        isResultShown = true;
      }

      // NUMBERS
      else {
        if (isResultShown) {
          output = value;
          expression = "";
          isResultShown = false;
        } else if (output == "0") {
          output = value;
        } else {
          output += value;
        }
      }
    });
  }

  Widget myButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 70),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor:
                ["+", "-", "*", "/", "=", "%"].contains(text)
                    ? Colors.orange
                    : Colors.white,
            foregroundColor:
                ["+", "-", "*", "/", "=", "%"].contains(text)
                    ? Colors.white
                    : Colors.black,
          ),
          onPressed: () => buttonPressed(text),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    expression,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    output,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                myButton("C"),
                myButton("%"),
                myButton("<"),
                myButton("/"),
              ],
            ),

            Row(
              children: [
                myButton("7"),
                myButton("8"),
                myButton("9"),
                myButton("+"),
              ],
            ),

            Row(
              children: [
                myButton("4"),
                myButton("5"),
                myButton("6"),
                myButton("-"),
              ],
            ),

            Row(
              children: [
                myButton("1"),
                myButton("2"),
                myButton("3"),
                myButton("*"),
              ],
            ),

            Row(
              children: [
                myButton("00"),
                myButton("0"),
                myButton("."),
                myButton("="),
              ],
            ),
          ],
        ),
      ),
    );
  }
}