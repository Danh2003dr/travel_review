// lib/widgets/type_chip.dart
// ------------------------------------------------------
// 💬 TYPE CHIP
// - Chip chọn loại hình địa điểm (biển, núi, văn hóa,...)
// - Dùng trong HomeScreen và SearchScreen
// ------------------------------------------------------

import 'package:flutter/material.dart';

class TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const TypeChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
