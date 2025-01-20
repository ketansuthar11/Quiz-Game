import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  Future<Map<String, dynamic>> fetchQuizDetails() async {
    const String apiurl = "https://api.jsonserve.com/Uw5CrX";
    try {
      final response = await http.get(Uri.parse(apiurl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print("Failed to load quiz details. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("No internet connecton$e");
    }
    return {};
  }

  Future<List<dynamic>> fetchQuizData() async {
    final data = await fetchQuizDetails();

    if (data.isNotEmpty) {
      return data['questions'] ?? [];
    }

    return [];
  }
}
