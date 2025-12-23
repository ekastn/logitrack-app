import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logitrack_app/models/delivery_task_model.dart';

class DeliveryDetailPage extends StatefulWidget {
  final DeliveryTask task;

  const DeliveryDetailPage({super.key, required this.task});

  @override
  State<DeliveryDetailPage> createState() => _DeliveryDetailPageState();
}

class _DeliveryDetailPageState extends State<DeliveryDetailPage> {
  XFile? _imageFile;

  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal mengakses kamera.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail: ${widget.task.id}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${widget.task.isCompleted ? "Selesai" : "Dalam Proses"}',
            ),
            const SizedBox(height: 24),
            const Text(
              'Bukti Pengiriman:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _imageFile == null
                  ? const Center(child: Text('Belum ada gambar'))
                  : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Ambil Foto Bukti'),
                onPressed: _pickImageFromCamera,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
