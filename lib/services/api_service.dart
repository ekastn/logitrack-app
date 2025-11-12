import 'package:http/http.dart' as http;
import 'package:logitrack_app/models/delivery_task_model.dart';
import 'dart:convert';

class ApiService {
  final String apiUrl = "https://jsonplaceholder.typicode.com/todos";

  Future<List<DeliveryTask>> fetchDeliveryTasks() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);

        List<DeliveryTask> tasks = body
            .map((dynamic item) => DeliveryTask.fromJson(item))
            .toList();

        return tasks;
      } else {
        throw Exception('Gagal memuat data dari API');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
