import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/image_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  Future<void> _pickImages(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked != null && picked.isNotEmpty) {
      final bytesList = await Future.wait(picked.map((x) => x.readAsBytes()));
      Provider.of<ImageState>(context, listen: false).addImages(bytesList);
    }
  }

  Color _statusColor(UploadStatus status) {
    switch (status) {
      case UploadStatus.success:
        return Colors.green;
      case UploadStatus.failed:
        return Colors.red;
      case UploadStatus.uploading:
        return Colors.blue;
      case UploadStatus.pending:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _statusText(UploadStatus status) {
    switch (status) {
      case UploadStatus.idle:
        return "Idle";
      case UploadStatus.pending:
        return "Pending";
      case UploadStatus.uploading:
        return "Uploading";
      case UploadStatus.success:
        return "Success";
      case UploadStatus.failed:
        return "Failed";
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animatedCorner({required Alignment alignment, required Color color}) {
    return Align(
      alignment: alignment,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(
                color: color.withOpacity(_animation.value),
                width: 3 + 2 * _animation.value,
              ),
              borderRadius: BorderRadius.only(
                topLeft: alignment == Alignment.topLeft ? const Radius.circular(24) : Radius.zero,
                topRight: alignment == Alignment.topRight ? const Radius.circular(24) : Radius.zero,
                bottomLeft: alignment == Alignment.bottomLeft ? const Radius.circular(24) : Radius.zero,
                bottomRight: alignment == Alignment.bottomRight ? const Radius.circular(24) : Radius.zero,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF131921), Color(0xFF232F3E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Amazon-like red header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFB12704), // Amazon red
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  'Offline Image Upload',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer<ImageState>(
                  builder: (context, state, _) {
                    if (state.queue.isEmpty) {
                      return Center(
                        child: Text(
                          "No images selected.",
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 18),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.queue.length,
                      itemBuilder: (context, i) {
                        final img = state.queue[i];
                        return Stack(
                          children: [
                            Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              color: Colors.white.withOpacity(0.97),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.memory(
                                        img.bytes,
                                        width: 72,
                                        height: 72,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Chip(
                                            label: Text(
                                              _statusText(img.status),
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            backgroundColor: _statusColor(img.status),
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          ),
                                          if (img.status == UploadStatus.uploading)
                                            const Padding(
                                              padding: EdgeInsets.only(top: 8.0),
                                              child: LinearProgressIndicator(),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (img.status == UploadStatus.failed)
                                      IconButton(
                                        icon: const Icon(Icons.refresh, color: Colors.red),
                                        onPressed: () => state.retryUpload(i),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            // Animated glowing corners only if NOT uploading
                            if (img.status != UploadStatus.uploading) ...[
                              Positioned(
                                top: 0,
                                left: 0,
                                child: _animatedCorner(
                                  alignment: Alignment.topLeft,
                                  color: const Color(0xFFB12704),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: _animatedCorner(
                                  alignment: Alignment.topRight,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: _animatedCorner(
                                  alignment: Alignment.bottomLeft,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: _animatedCorner(
                                  alignment: Alignment.bottomRight,
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: Text('Pick Images', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: GoogleFonts.poppins(),
                  ),
                  onPressed: () => _pickImages(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}