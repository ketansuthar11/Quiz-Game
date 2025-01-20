import 'package:flutter/material.dart';
import 'package:quiz_app/screens/QuizScreen.dart';
import 'package:quiz_app/services/Score.dart';
import '../services/ApiService.dart';

class ViewSummary extends StatefulWidget {
  final List<int?> selectedOption;
  final int correctAns;
  const ViewSummary({
    super.key,
    required this.correctAns,
    required this.selectedOption,
  });

  @override
  State<ViewSummary> createState() => _ViewSummaryState();
}


class _ViewSummaryState extends State<ViewSummary> {
  Map<String,dynamic> details = {};
  bool isLoading=false;
  int answered = 0;

  @override
  void initState() {
    isLoading=true;
    super.initState();
    fetchQuizDetails();
  }

  Future<void> fetchQuizDetails() async {
    Map<String,dynamic> fetchedDetails = await ApiService().fetchQuizDetails();
    setState(() {
      answered=Score().answered(widget.selectedOption);
      details = fetchedDetails;
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int score = (widget.correctAns*4)-answered-widget.correctAns*(-1);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detailed Summary",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
      ),
      body:isLoading?Center(child: Text("Loading..."),):ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            "Summary",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Dynamically displaying summary details
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              "Quiz Title: ${details['title'] ?? 'N/A'}",
              style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              "Total Questions: ${details['questions_count'] ?? 'N/A'}",
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              "Questions Attempted: ${answered?? 'N/A'}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              "Correct Answers: ${widget.correctAns ?? 'N/A'}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              "Incorrect Answers: ${answered-widget.correctAns ?? 'N/A'}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              "Unanswered Questions: ${details['questions_count']-answered ?? 'N/A'}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const Text(
            "Performance Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              "Total Points Scored: ${score?? 'N/A'}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
