import 'package:flutter/material.dart';

/// Cùng độ rộng cột nhãn để căn dropdown nhắc nhở với các ô nhập.
const double kDiaryFormLabelWidth = 132;

/// Viền ô nhập dùng chung cho form tạo nhật ký.
const InputDecoration kDiaryOutlineFieldDecoration = InputDecoration(
  isDense: true,
  border: OutlineInputBorder(),
  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
);

const InputDecoration kDiaryOutlineDropdownDecoration = InputDecoration(
  isDense: true,
  border: OutlineInputBorder(),
  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
);

/// Hàng form: nhãn trái + nội dung phải (tái sử dụng cho toàn bộ form).
class FormRow extends StatelessWidget {
  const FormRow({
    super.key,
    required this.label,
    required this.child,
    this.labelWidth = kDiaryFormLabelWidth,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final String label;
  final Widget child;
  final double labelWidth;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(label, style: textStyle),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
