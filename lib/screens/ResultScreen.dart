import 'package:flutter/material.dart';
import 'package:quiz_app/screens/ViewSummary.dart';
import 'package:quiz_app/services/Score.dart';
class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.quiz,
    required this.selectedOptions,
  });
  final List<dynamic> quiz;
  final List<int?> selectedOptions;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int score=0;
  int ans=0;
  @override
  void initState() {
    ans = Score().correctAnswers(widget.selectedOptions,widget.quiz);
    score = Score().options(widget.selectedOptions,widget.quiz);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
        title: Text("Result", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your score: $score"),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewSummary(
                      correctAns:ans,
                      selectedOption: widget.selectedOptions,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.green),
              child: Text("View Summary",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
