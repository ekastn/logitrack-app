import 'package:flutter/material.dart';
import 'package:logitrack_app/auth_service.dart';
import 'package:logitrack_app/delivery_detail_page.dart';
import 'package:logitrack_app/models/delivery_task_model.dart';
import 'package:logitrack_app/qr_scanner_page.dart';
import 'package:logitrack_app/services/api_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  late Future<List<DeliveryTask>> _tasksFuture;

  List<DeliveryTask>? _tasksCache;

  void _navigateToScanner() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerPage()),
    );

    if (!mounted || result == null) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Kode terdeteksi: $result')));

    final scannedId = int.tryParse(result.trim());
    if (scannedId == null) {
      messenger
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('QR tidak valid (bukan angka): $result')),
        );
      return;
    }

    final tasks = _tasksCache;
    if (tasks == null) {
      messenger
        ..removeCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Data tugas belum siap, coba lagi.')),
        );
      return;
    }

    DeliveryTask? matchedTask;
    for (final task in tasks) {
      if (task.id == scannedId) {
        matchedTask = task;
        break;
      }
    }

    if (matchedTask == null) {
      messenger
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Tugas dengan ID $scannedId tidak ditemukan.'),
          ),
        );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryDetailPage(task: matchedTask!),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tasksFuture = _apiService.fetchDeliveryTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Pengiriman'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              _navigateToScanner();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authService.signOut();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DeliveryTask>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final tasks = snapshot.data!;
            _tasksCache = tasks;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: ListTile(
                    leading: Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task.isCompleted ? Colors.green : Colors.grey,
                    ),
                    title: Text(task.title),
                    subtitle: Text('ID Tugas: ${task.id}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeliveryDetailPage(task: task),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Tidak ada data pengiriman.'));
          }
        },
      ),
    );
  }
}
