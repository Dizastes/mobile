import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() 
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget 
{
  const MyApp({super.key}); 
  @override
  Widget build(BuildContext context) 
  {
    return const MaterialApp
    (
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget 
{
  const Calculator({super.key});
  @override
  State<Calculator> createState() => _CalculatorState();
}


class _CalculatorState extends State<Calculator> 
{
  void equal() //вычисление
  {
    if (exp == '') 
    {
      return;
    }
    String tmp = exp;
    tmp = tmp.replaceAll(r'×', '*');
    tmp = tmp.replaceAll(r'÷', '/');
    tmp = tmp.replaceAll(r'−', '-');
  
    if (symbols.contains(tmp[tmp.length - 1])) 
    {
      tmp = tmp.substring(0, tmp.length - 1);
    }
    Parser p = Parser();
    Expression expression = p.parse(tmp);
    ContextModel cm = ContextModel();
    double eval = expression.evaluate(EvaluationType.REAL, cm);
    String temp = eval.toString();
    tmp = temp;
    if (temp[temp.length - 1] == '0' && temp[temp.length - 2] == '.') 
    {
      temp = temp.substring(0, temp.length - 2);
    }
    if (answer == temp) 
    {
      exp = answer;
    } 
    else 
    {
      answer = temp;
    }
  }

  void changes(String text) 
  {
    setState(() //проверка на кнопки
    {
      if (text == '=') 
      {
        equal();
      } 
      else if (text == 'C') 
      {
        exp = '';
        answer = '';
      } 
      else if (text == '⌫') 
      {
        if (exp.length > 1) 
        {
          exp = exp.substring(0, exp.length - 1);
        } 
        else if (exp.length == 1) 
        {
          exp = '';
        }
      } 
      else if (exp == '') 
      {
        if (numbers.contains(text))
        {
           exp = text;
        }
         
      } 
      else 
      {
        String last = exp.length > 0 ? exp[exp.length-1] : 'null';
        String last2 = exp.length > 2 ? exp[exp.length - 2] : 'null';
        if (text == '.') {
          //Точка
          if (numbers.contains(last)) 
          {
            for (int i = exp.length-1; i >= 0; i--) 
            {
          
              if (symbols.contains(exp[i]) || i == 0) 
              {
                exp += text;
                break;
              } 
              else if (exp[i] == '.') 
              {
                break;
              }
            }
          } 
          else if (symbols.contains(last)) 
          {
            for (int i = exp.length - 1; i >= 0; i--) 
            {
              if (symbols.contains(exp[i]) || i == 0) 
              {
                exp = exp.substring(0, exp.length) + text;
                break;
              } 
              else if (exp[i] == '.') 
              {
                break;
              }
            }
          }
        } 
        else if (numbers.contains(text)) 
        {
          //число
          if (symbols.contains(last)) 
          {
            exp += text;
          } 
          else if (last == '' && symbols.contains(last2)) 
          {
            exp = exp.substring(0, exp.length - 1) + text;
          } 
          else if (numbers.contains(last) || last == '.') 
          {
            exp += text;
          }
        } 
        else 
        {
          //символ
          if (text == 'xʸ')
          {
              text = '^';
          }
          if (symbols.contains(last) || last == '.') 
          {
            exp = exp.substring(0, exp.length - 1) + text;
          } 
          else
          {
            exp += text;
          }
        }
      }
    });
  }

  String exp = '';
  String answer = '';
  List numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  List symbols = ['+', '−', '×', '÷', '^'];
  

  Widget getButton(String text, Color color) 
  {
    bool t;
    if (text == '0') 
    {
      t = true;
    } 
    else 
    {
      t = false;
    }
    return Expanded

    (
        flex: t == true ? 2 : 1,
        child: Padding
        (
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: ElevatedButton
            (
              style: ElevatedButton.styleFrom
              (
                  backgroundColor: color,
                  foregroundColor: const Color.fromARGB(250, 210, 250, 210),
                  shape: RoundedRectangleBorder
                  (
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20)),
              onPressed: () 
              {
                changes(text);
              },
              child: Text(text, style: const TextStyle(fontSize: 25)),
            )));
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      backgroundColor:const Color.fromARGB(250, 210, 250, 210),
      appBar: AppBar
      (
        backgroundColor: const Color.fromARGB(250, 26, 64, 25),
        title: const Text('Calculator', style: TextStyle(color: Color.fromARGB(250, 210, 250, 210))),
      ),
      body: Padding
      (
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical:20),
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.end,
          children: 
          [
            //Display
            Align
            (
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text
                  (
                    exp,
                    style: const TextStyle(color: Color.fromARGB(250, 26, 64, 25), fontSize: 40),
                    textAlign: TextAlign.right,
                  ),
                )),
            const SizedBox(height: 40,),

            Align
            (
                alignment: Alignment.centerRight,
                child: SingleChildScrollView
                (
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text
                  (
                    '=$answer',
                    style: const TextStyle(color: Color.fromARGB(250, 26, 64, 25), fontSize: 70),
                    textAlign: TextAlign.right,
                  ),
                )),

            //Buttons
            Row
            (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: 
              [
                getButton('C', const Color.fromARGB(250, 45, 25, 71)),
                getButton('⌫', const Color.fromARGB(250, 45, 25, 71)),
                getButton('xʸ', const Color.fromARGB(250, 45, 25, 71)),
                getButton('÷', const Color.fromARGB(250, 45, 25, 71)),
              ],
            ),
            const SizedBox
            (
              height: 5,
            ),

            Row
            (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: 
              [
                getButton('7', const Color.fromARGB(250, 26, 64, 25)),
                getButton('8', const Color.fromARGB(250, 26, 64, 25)),
                getButton('9', const Color.fromARGB(250, 26, 64, 25)),
                getButton('×', const Color.fromARGB(250, 45, 25, 71)),
              ],
            ),
            const SizedBox
            (
              height: 5,
            ),

            Row
            (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: 
              [
                getButton('4', const Color.fromARGB(250, 26, 64, 25)),
                getButton('5', const Color.fromARGB(250, 26, 64, 25)),
                getButton('6', const Color.fromARGB(250, 26, 64, 25)),
                getButton('−', const Color.fromARGB(250, 45, 25, 71)),
              ],
            ),
            const SizedBox
            (
              height: 5,
            ),

            Row
            (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: 
              [
                getButton('1', const Color.fromARGB(250, 26, 64, 25)),
                getButton('2', const Color.fromARGB(250, 26, 64, 25)),
                getButton('3', const Color.fromARGB(250, 26, 64, 25)),
                getButton('+', const Color.fromARGB(250, 45, 25, 71)),
              ],
            ),
            const SizedBox
            (
              height: 5,
            ),
            
            Row
            (
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: 
              [
                getButton('0', const Color.fromARGB(250, 26, 64, 25)),
                getButton('.', const Color.fromARGB(250, 26, 64, 25)),
                getButton('=', const Color.fromARGB(250, 45, 25, 71)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}