import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advanced Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String expression = '';
  String result = '0';
  String history = '';
  bool isDarkMode = true;

  bool insideLog = false;  // Flag to track if we are inside a log function

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "CLEAR") {
        expression = '';
        result = '0';
      } else if (buttonText == "DEL") {
        expression = expression.length > 0
            ? expression.substring(0, expression.length - 1)
            : '';
      } else if (buttonText == "=") {
        try {
          // Replace 'x' with '*' for multiplication
          expression = expression.replaceAll('x', '*');

          // Automatically close any unclosed parentheses
          expression = autoCloseParentheses(expression);

          // Custom handling for log10
          String finalExpression = expression.replaceAll('log(', 'log10(');

          result = evaluateExpression(finalExpression);
          history = expression;
          expression = result;
        } catch (e) {
          result = 'Error';
        }
      } else if (buttonText == '√') {
        expression += 'sqrt(';
      } else if (buttonText == 'log') {
        expression += 'log(';
      } else if (buttonText == 'ln') {
        expression += 'ln(';
      } else if (buttonText == ')') {
        expression += ')';
      } else {
        expression += buttonText;
      }
    });
  }

  String autoCloseParentheses(String exp) {
    int openCount = '('.allMatches(exp).length;
    int closeCount = ')'.allMatches(exp).length;

    while (openCount > closeCount) {
      if (exp.endsWith('sqrt(')) {
        exp = exp.substring(0, exp.length - 5) + 'sqrt(' + ')';
      } else if (exp.endsWith('log(')) {
        exp = exp.substring(0, exp.length - 4) + 'log(' + ')';
      } else if (exp.endsWith('ln(')) {
        exp = exp.substring(0, exp.length - 3) + 'ln(' + ')';
      } else {
        exp += ')';
      }
      closeCount++;
    }
    return exp;
  }

  String evaluateExpression(String expression) {
    Parser p = Parser();
    Expression exp = p.parse(expression);
    ContextModel cm = ContextModel();
    return '${exp.evaluate(EvaluationType.REAL, cm)}';
  }

  Widget buildButton(String buttonText, Color color) {
    return GestureDetector(
      onTap: () => buttonPressed(buttonText),
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF22252D) : Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDarkMode ? Color(0xFF292D36) : Color(0xFF03A9F4),
        title: Text("Advanced Calculator"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            alignment: Alignment.centerRight,
            child: Text(

            expression,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            alignment: Alignment.centerRight,
            child: Text(
              result,
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.green : Colors.blue,
              ),
            ),
          ),
          Expanded(child: Divider()),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: GridView.builder(
              padding: EdgeInsets.all(12.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.2,
              ),
              itemCount: 24,
              itemBuilder: (BuildContext context, int index) {
                List<String> buttons = [
                  '7', '8', '9', '/',
                  '4', '5', '6', 'x',
                  '1', '2', '3', '-',
                  '.', '0', '=', '+',
                  'CLEAR', 'DEL', '(', ')',
                  '^', '√', 'log', 'ln'
                ];

                List<Color> buttonColors = [
                  isDarkMode ? Colors.grey[850]! : Colors.blue[200]!,
                  isDarkMode ? Colors.grey[850]! : Colors.blue[200]!,
                  isDarkMode ? Colors.grey[850]! : Colors.blue[200]!,
                  isDarkMode ? Color(0xFFF57C00) : Color(0xFF0288D1),
                  isDarkMode ? Colors.grey[850]! : Colors.blue[200]!,
                  isDarkMode ? Colors.grey[850]! : Colors.blue[200]!,
                  isDarkMode ? Colors.grey[850]! : Colors.blue[200]!,
                  isDarkMode ? Color(0xFFF57C00) : Color(0xFF0288D1),
                  isDarkMode ? Colors.grey[850]! : Colors.blue[200]!,
                  isDarkMode ? Colors.grey[850]! : Colors.blue[200]!,
                  isDarkMode ? Colors.grey[850]! : Colors.blue[200]!,
                  isDarkMode ? Color(0xFFF57C00) : Color(0xFF0288D1),
                  isDarkMode ? Colors.grey[850]! : Colors.blue[200]!,
                  isDarkMode ? Colors.grey[850]! : Colors.blue[200]!,
                  isDarkMode ? Color(0xFF43A047) : Color(0xFF4CAF50),
                  isDarkMode ? Color(0xFFF57C00) : Color(0xFF0288D1),
                  isDarkMode ? Colors.red[400]! : Colors.red[300]!,
                  isDarkMode ? Colors.orange[600]! : Colors.orange[400]!,
                  isDarkMode ? Colors.purple[600]! : Colors.purple[400]!,
                  isDarkMode ? Colors.purple[600]! : Colors.purple[400]!,
                  isDarkMode ? Colors.purple[600]! : Colors.purple[400]!,
                  isDarkMode ? Colors.purple[300]! : Colors.purple[200]!,
                  isDarkMode ? Colors.purple[300]! : Colors.purple[200]!,
                  isDarkMode ? Colors.purple[300]! : Colors.purple[200]!,
                ];

                return buildButton(buttons[index], buttonColors[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}


