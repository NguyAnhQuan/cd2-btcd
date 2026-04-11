import 'package:flutter/material.dart';

/// Kiểm tra chuỗi có phải URL ảnh http(s) hợp lệ để dùng [Image.network].
bool isDiaryImageNetworkUrl(String? imagePath) {
  if (imagePath == null) return false;
  final t = imagePath.trim();
  if (t.isEmpty) return false;
  final u = Uri.tryParse(t);
  return u != null &&
      u.hasScheme &&
      (u.scheme == 'http' || u.scheme == 'https');
}

/// Thumbnail vuông bên cạnh tiêu đề trên danh sách nhật ký.
class DiaryListThumbnail extends StatelessWidget {
  const DiaryListThumbnail({super.key, required this.imageUrl});

  final String imageUrl;

  static const double size = 56;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl.trim();
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            width: size,
            height: size,
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          width: size,
          height: size,
          color: Colors.grey.shade200,
          child: Icon(
            Icons.broken_image_outlined,
            color: Colors.grey.shade600,
            size: 28,
          ),
        ),
      ),
    );
  }
}
