// lib/widgets/modern_search_bar.dart
// ------------------------------------------------------
// 🔍 MODERN SEARCH BAR - THANH TÌM KIẾM HIỆN ĐẠI
// - Glassmorphism effect
// - Smooth animations
// - Auto-complete suggestions
// - Voice search support
// - Recent searches
// ------------------------------------------------------

import 'package:flutter/material.dart';
import 'dart:ui';

class ModernSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool enabled;
  final bool autofocus;
  final List<String> suggestions;
  final ValueChanged<String>? onSuggestionTap;
  final VoidCallback? onVoiceSearch;
  final bool showVoiceButton;
  final bool showFilterButton;
  final VoidCallback? onFilterTap;
  final EdgeInsetsGeometry? padding;

  final TextEditingController? controller;

  const ModernSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Tìm kiếm địa điểm...',
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.autofocus = false,
    this.suggestions = const [],
    this.onSuggestionTap,
    this.onVoiceSearch,
    this.showVoiceButton = true,
    this.showFilterButton = true,
    this.onFilterTap,
    this.padding,
  });

  @override
  State<ModernSearchBar> createState() => _ModernSearchBarState();
}

class _ModernSearchBarState extends State<ModernSearchBar>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool _isFocused = false;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      _showSuggestions = _isFocused && widget.suggestions.isNotEmpty;
    });

    if (_isFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main search bar
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: widget.padding ?? const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: _isFocused ? 20 : 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isFocused
                            ? Colors.white.withValues(alpha: 0.95)
                            : Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: _isFocused
                              ? Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.2),
                          width: _isFocused ? 2 : 1,
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        enabled: widget.enabled,
                        autofocus: widget.autofocus,
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: _isFocused
                                ? Theme.of(context).primaryColor
                                : Colors.grey[500],
                          ),
                          suffixIcon: _buildSuffixIcons(),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        onChanged: widget.onChanged,
                        onSubmitted: widget.onSubmitted,
                        onTap: widget.onTap,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Suggestions
        if (_showSuggestions) _buildSuggestions(),
      ],
    );
  }

  Widget _buildSuffixIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_controller.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              widget.onChanged?.call('');
            },
          ),
        if (widget.showVoiceButton)
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: widget.onVoiceSearch ?? _showVoiceSearchDialog,
          ),
        if (widget.showFilterButton)
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: widget.onFilterTap,
          ),
      ],
    );
  }

  Widget _buildSuggestions() {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Recent searches
                if (widget.suggestions.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.history, color: Colors.grey[600], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Tìm kiếm gần đây',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...widget.suggestions.take(5).map((suggestion) {
                    return ListTile(
                      leading: Icon(Icons.search, color: Colors.grey[500]),
                      title: Text(suggestion),
                      onTap: () {
                        _controller.text = suggestion;
                        widget.onSuggestionTap?.call(suggestion);
                        _focusNode.unfocus();
                      },
                    );
                  }).toList(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showVoiceSearchDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Icon(Icons.mic, size: 64, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(
              'Tìm kiếm bằng giọng nói',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Nhấn và giữ để nói',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mic,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tính năng này sẽ sớm ra mắt!',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

// Quick search chips
class QuickSearchChips extends StatelessWidget {
  final List<String> chips;
  final ValueChanged<String>? onChipTap;
  final String? selectedChip;

  const QuickSearchChips({
    super.key,
    required this.chips,
    this.onChipTap,
    this.selectedChip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        itemBuilder: (context, index) {
          final chip = chips[index];
          final isSelected = selectedChip == chip;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(chip),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onChipTap?.call(chip);
                }
              },
              backgroundColor: Colors.grey[100],
              selectedColor: Theme.of(
                context,
              ).primaryColor.withValues(alpha: 0.2),
              checkmarkColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
