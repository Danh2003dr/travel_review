// lib/widgets/floating_action_menu.dart
// ------------------------------------------------------
// 🎯 FLOATING ACTION MENU - MENU FAB VỚI ANIMATIONS
// - Expandable floating action button
// - Multiple action items
// - Smooth animations
// - Customizable colors and icons
// ------------------------------------------------------

import 'package:flutter/material.dart';

class FloatingActionMenu extends StatefulWidget {
  final List<FloatingActionItem> items;
  final IconData mainIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onMainPressed;
  final Duration animationDuration;
  final double itemSpacing;
  final bool isOpen;

  const FloatingActionMenu({
    super.key,
    required this.items,
    this.mainIcon = Icons.add,
    this.backgroundColor,
    this.foregroundColor,
    this.onMainPressed,
    this.animationDuration = const Duration(milliseconds: 300),
    this.itemSpacing = 70.0,
    this.isOpen = false,
  });

  @override
  State<FloatingActionMenu> createState() => _FloatingActionMenuState();
}

class _FloatingActionMenuState extends State<FloatingActionMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _fadeAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _expandAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _rotateAnimation =
        Tween<double>(
          begin: 0.0,
          end: 0.125, // 45 degrees (1/8 of a full rotation)
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    if (widget.isOpen) {
      _isExpanded = true;
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FloatingActionMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _expand();
      } else {
        _collapse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isExpanded) {
      _collapse();
    } else {
      _expand();
    }
  }

  void _expand() {
    setState(() => _isExpanded = true);
    _animationController.forward();
  }

  void _collapse() {
    setState(() => _isExpanded = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: widget.items.length * widget.itemSpacing + 60,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Action items
          ...widget.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _buildActionItem(item, index);
          }).toList(),

          // Main FAB
          _buildMainFAB(),
        ],
      ),
    );
  }

  Widget _buildActionItem(FloatingActionItem item, int index) {
    final position = (widget.items.length - 1 - index) * widget.itemSpacing;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final expandedValue = _expandAnimation.value;
        final fadeValue = _fadeAnimation.value;

        return Positioned(
          bottom: position * expandedValue + 60,
          child: Opacity(
            opacity: fadeValue,
            child: Transform.scale(
              scale: expandedValue,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: item.backgroundColor ?? Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(28),
                    onTap: () {
                      item.onPressed();
                      _collapse();
                    },
                    child: Icon(
                      item.icon,
                      color: item.foregroundColor ?? Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainFAB() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotateAnimation.value * 2 * 3.14159,
          child: FloatingActionButton(
            onPressed: () {
              if (widget.onMainPressed != null) {
                widget.onMainPressed!();
              } else {
                _toggle();
              }
            },
            backgroundColor:
                widget.backgroundColor ?? Theme.of(context).primaryColor,
            foregroundColor: widget.foregroundColor ?? Colors.white,
            child: Icon(_isExpanded ? Icons.close : widget.mainIcon, size: 28),
          ),
        );
      },
    );
  }
}

class FloatingActionItem {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;

  const FloatingActionItem({
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
  });
}

// Speed dial variant
class SpeedDial extends StatefulWidget {
  final List<SpeedDialItem> children;
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;
  final bool closeOnSelected;

  const SpeedDial({
    super.key,
    required this.children,
    this.icon = Icons.add,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.closeOnSelected = true,
  });

  @override
  State<SpeedDial> createState() => _SpeedDialState();
}

class _SpeedDialState extends State<SpeedDial>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    setState(() => _isOpen = true);
    _animationController.forward();
  }

  void _close() {
    setState(() => _isOpen = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Items
        ...widget.children.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _buildSpeedDialItem(item, index);
        }).toList(),

        // Main button
        FloatingActionButton(
          onPressed: _toggle,
          backgroundColor:
              widget.backgroundColor ?? Theme.of(context).primaryColor,
          foregroundColor: widget.foregroundColor ?? Colors.white,
          tooltip: widget.tooltip,
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Icon(widget.icon),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedDialItem(SpeedDialItem item, int index) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Transform.scale(
            scale: _animation.value,
            child: Opacity(
              opacity: _animation.value,
              child: FloatingActionButton.small(
                onPressed: () {
                  item.onPressed();
                  if (widget.closeOnSelected) {
                    _close();
                  }
                },
                backgroundColor: item.backgroundColor ?? Colors.white,
                foregroundColor:
                    item.foregroundColor ?? Theme.of(context).primaryColor,
                tooltip: item.tooltip,
                child: Icon(item.icon),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SpeedDialItem {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;

  const SpeedDialItem({
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
  });
}
