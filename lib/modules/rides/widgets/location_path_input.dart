import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideshare/shared/providers/rides_provider.dart';
import 'package:rideshare/shared/theme.dart';

class LocationPathInput extends ConsumerStatefulWidget {
  final TextEditingController startController;
  final TextEditingController endController;
  final String? startError;
  final String? endError;

  const LocationPathInput({
    super.key,
    required this.startController,
    required this.endController,
    this.startError,
    this.endError,
  });

  @override
  ConsumerState<LocationPathInput> createState() => _LocationPathInputState();
}

class _LocationPathInputState extends ConsumerState<LocationPathInput> {
  Timer? _startDebounceTimer;
  Timer? _endDebounceTimer;
  List<String> _startSuggestions = [];
  List<String> _endSuggestions = [];
  final LayerLink _startLayerLink = LayerLink();
  final LayerLink _endLayerLink = LayerLink();
  OverlayEntry? _startOverlayEntry;
  OverlayEntry? _endOverlayEntry;
  final FocusNode _startFocusNode = FocusNode();
  final FocusNode _endFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.startController.addListener(_onStartTextChanged);
    widget.endController.addListener(_onEndTextChanged);
    _startFocusNode.addListener(_onStartFocusChanged);
    _endFocusNode.addListener(_onEndFocusChanged);
  }

  @override
  void dispose() {
    _startDebounceTimer?.cancel();
    _endDebounceTimer?.cancel();
    widget.startController.removeListener(_onStartTextChanged);
    widget.endController.removeListener(_onEndTextChanged);
    _startFocusNode.removeListener(_onStartFocusChanged);
    _endFocusNode.removeListener(_onEndFocusChanged);
    _startFocusNode.dispose();
    _endFocusNode.dispose();
    _removeStartOverlay();
    _removeEndOverlay();
    super.dispose();
  }

  void _onStartTextChanged() {
    _startDebounceTimer?.cancel();
    _startDebounceTimer = Timer(const Duration(milliseconds: 250), () {
      _fetchStartSuggestions();
    });
  }

  void _onEndTextChanged() {
    _endDebounceTimer?.cancel();
    _endDebounceTimer = Timer(const Duration(milliseconds: 250), () {
      _fetchEndSuggestions();
    });
  }

  void _onStartFocusChanged() {
    if (!_startFocusNode.hasFocus) {
      _removeStartOverlay();
    } else if (widget.startController.text.isNotEmpty && _startSuggestions.isNotEmpty) {
      _showStartOverlay();
    }
  }

  void _onEndFocusChanged() {
    if (!_endFocusNode.hasFocus) {
      _removeEndOverlay();
    } else if (widget.endController.text.isNotEmpty && _endSuggestions.isNotEmpty) {
      _showEndOverlay();
    }
  }

  Future<void> _fetchStartSuggestions() async {
    final query = widget.startController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _startSuggestions = [];
      });
      _removeStartOverlay();
      return;
    }

    try {
      final suggestions = await ref.read(ridesNotifierProvider.notifier).getRecommendations(query);
      if (mounted) {
        setState(() {
          _startSuggestions = suggestions?.take(5).toList() ?? [];
        });
        if (_startFocusNode.hasFocus && _startSuggestions.isNotEmpty) {
          _showStartOverlay();
        } else {
          _removeStartOverlay();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _startSuggestions = [];
        });
        _removeStartOverlay();
      }
    }
  }

  Future<void> _fetchEndSuggestions() async {
    final query = widget.endController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _endSuggestions = [];
      });
      _removeEndOverlay();
      return;
    }

    try {
      final suggestions = await ref.read(ridesNotifierProvider.notifier).getRecommendations(query);
      if (mounted) {
        setState(() {
          _endSuggestions = suggestions?.take(5).toList() ?? [];
        });
        if (_endFocusNode.hasFocus && _endSuggestions.isNotEmpty) {
          _showEndOverlay();
        } else {
          _removeEndOverlay();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _endSuggestions = [];
        });
        _removeEndOverlay();
      }
    }
  }

  void _showStartOverlay() {
    _removeStartOverlay();
    _startOverlayEntry = _createOverlayEntry(
      _startSuggestions,
      widget.startController,
      _startLayerLink,
      () => _removeStartOverlay(),
      _startFocusNode,
    );
    Overlay.of(context).insert(_startOverlayEntry!);
  }

  void _showEndOverlay() {
    _removeEndOverlay();
    _endOverlayEntry = _createOverlayEntry(
      _endSuggestions,
      widget.endController,
      _endLayerLink,
      () => _removeEndOverlay(),
      _endFocusNode,
    );
    Overlay.of(context).insert(_endOverlayEntry!);
  }

  void _removeStartOverlay() {
    _startOverlayEntry?.remove();
    _startOverlayEntry = null;
  }

  void _removeEndOverlay() {
    _endOverlayEntry?.remove();
    _endOverlayEntry = null;
  }

  OverlayEntry _createOverlayEntry(
    List<String> suggestions,
    TextEditingController controller,
    LayerLink layerLink,
    VoidCallback onRemove,
    FocusNode focusNode,
  ) {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 48,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 56),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            color: AppColors.card,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: suggestions.map((suggestion) {
                return InkWell(
                  onTap: () {
                    controller.text = suggestion;
                    onRemove();
                    focusNode.unfocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      suggestion,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CompositedTransformTarget(
          link: _startLayerLink,
          child: _LocationInputRow(
            icon: Icons.circle_outlined,
            hint: 'Start Location',
            controller: widget.startController,
            errorText: widget.startError,
            focusNode: _startFocusNode,
          ),
        ),
        const SizedBox(height: 16),
        CompositedTransformTarget(
          link: _endLayerLink,
          child: _LocationInputRow(
            icon: Icons.location_on,
            hint: 'Destination',
            controller: widget.endController,
            errorText: widget.endError,
            focusNode: _endFocusNode,
          ),
        ),
      ],
    );
  }
}

class _LocationInputRow extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final String? errorText;
  final FocusNode? focusNode;

  const _LocationInputRow({
    required this.icon,
    required this.hint,
    required this.controller,
    this.errorText,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primary.withAlpha((0.1 * 255).round()),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withAlpha((0.7 * 255).round()),
              ),
              errorText: errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: errorText != null
                      ? Theme.of(context).colorScheme.error
                      : Colors.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              filled: true,
              fillColor: AppColors.card,
            ),
          ),
        ),
      ],
    );
  }
}
