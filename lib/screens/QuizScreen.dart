import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/screens/Options.dart';
import 'package:quiz_app/screens/ResultScreen.dart';
import 'package:quiz_app/services/ApiService.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<bool> list = [false, false, false, false];
  List<dynamic> quiz = [];
  int currentQuestionIndex = 0;
  bool isLoading = false;
  bool isAnswered=false;
  List<int?> selectedOptions = [];
  final int timerDuration = 15;
  late Timer _timer;
  int _timeLeft = 900;

  @override
  void initState() {
    fetchQuiz();
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer.cancel();
        _navigateToResultScreen();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _navigateToResultScreen(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(selectedOptions: selectedOptions,quiz:quiz)),
    );
  }

  Future<void> fetchQuiz() async {
    setState(() {
      isLoading = true;
    });
    quiz = await ApiService().fetchQuizData();
    setState(() {
      isLoading = false;
      selectedOptions = List.filled(quiz.length, null);
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
        title: Text("Quiz", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: quiz.isEmpty
            ? Center(child: Text("Loading..."))
            : Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                  child: Text(
                                    "Time left:\n${(_timeLeft ~/ 60).toString().padLeft(2, '0')}:${(_timeLeft % 60).toString().padLeft(2, '0')}",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Question:${currentQuestionIndex + 1}",
                                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "${quiz[currentQuestionIndex]['description']}",
                                style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        bool isSelected = selectedOptions[currentQuestionIndex] == index;
                        return Options(
                          isChecked: isSelected,
                          index: index,
                          option: quiz[currentQuestionIndex]['options'][index]['description'],
                          onChanged: (bool newValue) {
                            setState(() {
                              if(isAnswered && selectedOptions[currentQuestionIndex]==index) return;
                              selectedOptions[currentQuestionIndex] = newValue ? index : null;
                              for (int i = 0; i < list.length; i++) {
                                if (i != index) {
                                  list[i] = false;
                                }
                              }
                              if (quiz[currentQuestionIndex]['options'][index]['is_correct'] == true) {
                                print("Correct Answer Selected!");
                              } else {
                                print("Wrong Answer Selected!");
                              }
                              isAnswered = true;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentQuestionIndex > 0)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentQuestionIndex--;
                          list = [false, false, false, false];
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          backgroundColor: Color.fromRGBO(34, 34, 34, 1.0)),
                      child: Text(
                        "Previous",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  ElevatedButton(
                    onPressed: () {
                      if (currentQuestionIndex < quiz.length - 1) {
                        setState(() {
                          currentQuestionIndex++;
                          list = [false, false, false, false];
                        });
                      } else {
                        print(selectedOptions);
                        _navigateToResultScreen();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.green),
                    child: Text(currentQuestionIndex == 9 ? " Finish  " : "   Next   ",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

