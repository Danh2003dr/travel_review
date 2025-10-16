// lib/features/review/write_review_screen.dart
// ------------------------------------------------------
// ✍️ WRITE REVIEW SCREEN
// - Viết đánh giá địa điểm
// - Upload ảnh và rating
// ------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/review.dart';
import '../../providers/auth_provider.dart';
import '../../providers/reviews_provider.dart';
import '../../widgets/rating_stars.dart';
import '../../services/storage_service.dart';

class WriteReviewScreen extends StatefulWidget {
  final String placeId;

  const WriteReviewScreen({super.key, required this.placeId});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  double _rating = 5.0;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viết đánh giá'),
        actions: [
          Consumer<ReviewsProvider>(
            builder: (context, reviewsProvider, child) {
              return TextButton(
                onPressed: reviewsProvider.isLoading
                    ? null
                    : () => _submitReview(reviewsProvider),
                child: const Text(
                  'Gửi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRatingSection(),
              const SizedBox(height: 24),
              _buildContentSection(),
              const SizedBox(height: 24),
              _buildImageSection(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đánh giá của bạn',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: () => _showRatingDialog(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RatingStars(rating: _rating, size: 32),
                const SizedBox(width: 8),
                Text(
                  _rating.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nội dung đánh giá',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _contentController,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: 'Chia sẻ trải nghiệm của bạn về địa điểm này...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Vui lòng nhập nội dung đánh giá';
            }
            if (value.trim().length < 10) {
              return 'Nội dung đánh giá phải ít nhất 10 ký tự';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hình ảnh (tùy chọn)',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!,
                style: BorderStyle.solid,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Thêm hình ảnh',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
          ),
        ),
        if (_selectedImage != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đã chọn 1 hình ảnh',
                  style: TextStyle(
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _selectedImage = null),
                child: const Text('Xóa'),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Consumer<ReviewsProvider>(
      builder: (context, reviewsProvider, child) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: reviewsProvider.isLoading
                ? null
                : () => _submitReview(reviewsProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: reviewsProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Gửi đánh giá',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn đánh giá'),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RatingStars(
                  rating: _rating,
                  size: 40,
                  onRatingChanged: (rating) {
                    setDialogState(() {
                      _rating = rating;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  _getRatingText(_rating),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _getRatingText(double rating) {
    if (rating >= 5) return 'Tuyệt vời';
    if (rating >= 4) return 'Tốt';
    if (rating >= 3) return 'Bình thường';
    if (rating >= 2) return 'Không tốt';
    return 'Rất tệ';
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _submitReview(ReviewsProvider reviewsProvider) async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) return;

    try {
      String? imageUrl;

      // Upload image nếu có
      if (_selectedImage != null) {
        final storageService = StorageService();
        imageUrl = await storageService.uploadReviewImage(_selectedImage!);
      }

      // Tạo review object
      final review = Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        placeId: widget.placeId,
        userId: authProvider.user!.id,
        userName: authProvider.user!.name,
        userAvatar: authProvider.user!.avatarUrl,
        userAvatarUrl: authProvider.user!.avatarUrl,
        rating: _rating,
        content: _contentController.text.trim(),
        imageUrl: imageUrl ?? '',
        createdAt: DateTime.now(),
      );

      // Submit review
      final success = await reviewsProvider.addReview(widget.placeId, review);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đánh giá đã được gửi thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(reviewsProvider.errorMessage ?? 'Có lỗi xảy ra'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
