import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:quiz_app/screens/QuizScreen.dart';
import '../services/ApiService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> details = {};
  bool isLoading = false;
  bool isOnline = true;
  String errorMessage = "";

  late InternetConnection _connectionChecker;

  @override
  void initState() {
    super.initState();
    _connectionChecker = InternetConnection();
    _checkInternetConnection();
    fetchQuizDetails();
  }

  Future<void> _checkInternetConnection() async {
    bool result = await _connectionChecker.hasInternetAccess;
    setState(() {
      isOnline = result;
      errorMessage = isOnline
          ? ""
          : "You are offline. Please check your internet connection.";
    });
  }

  Future<void> fetchQuizDetails() async {
    if (isOnline) {
      setState(() {
        isLoading = true;
      });
      try {
        Map<String, dynamic> fetchedDetails =
        await ApiService().fetchQuizDetails();
        setState(() {
          details = fetchedDetails;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          errorMessage = "Failed to load quiz details.";
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          "Quiz Game",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isOnline
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                const Text(
                  "Topic",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  isLoading ? "Loading..." : details['topic'] ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Spacer(),
            const SizedBox(height: 30),
            Text(isLoading
                ? "":
              "Total Questions: ${details['questions_count'] ?? 'N/A'}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500
              ),
            ),
            Text(
              isLoading
                  ? ""
                  : "Points for correct Answer : ${details['correct_answer_marks'] ?? ""}",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isLoading
                  ? ""
                  : "Negative points : -${details['negative_marks'] ?? ""}",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                  fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 30,),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "Start Quiz",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Spacer(flex: 3,)
          ],
        ),
      )
          :
      Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _checkInternetConnection();
                if (isOnline) {
                  fetchQuizDetails();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No Internet Connection. Please check your network.'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "Retry",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      )
    );
  }
}
