import 'package:flutter/material.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/l10n/app_localizations.dart';

const Color _kGreen  = AppColors.primaryGreen;
const Color _kOrange = Color(0xFFFF6B00);

class PostPhotoPicker extends StatefulWidget {
  const PostPhotoPicker({
    super.key,
    this.onChanged,
    this.showError = false,
    this.accentColor = _kGreen,
  });

  final ValueChanged<int>? onChanged;
  final bool showError;
  final Color accentColor;

  @override
  State<PostPhotoPicker> createState() => PostPhotoPickerState();
}

class PostPhotoPickerState extends State<PostPhotoPicker> {
  final List<int> _photos = [];

  int get photoCount => _photos.length;
  bool get hasPhotos => _photos.isNotEmpty;

  void _notifyChange() => widget.onChanged?.call(_photos.length);

  void _addPhoto() {
    if (_photos.length >= 5) return;
    setState(() => _photos.add(_photos.length + 1));
    _notifyChange();
  }

  void _removePhoto(int id) {
    setState(() => _photos.remove(id));
    _notifyChange();
  }

  void _clearAll() {
    setState(() => _photos.clear());
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    final l10n  = AppLocalizations.of(context)!;
    final accent = widget.accentColor;
    final borderColor = widget.showError && _photos.isEmpty
        ? Colors.red.shade400
        : Colors.grey.shade200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color:        Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: widget.showError && _photos.isEmpty ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color:      Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset:     const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.photo_camera_rounded, size: 16, color: accent),
                  const SizedBox(width: 6),
                  Text(
                    l10n.postPhotosAdded(_photos.length),
                    style: TextStyle(
                      fontSize:   12,
                      fontWeight: FontWeight.w700,
                      color:      Colors.grey.shade700,
                    ),
                  ),
                  const Spacer(),
                  if (_photos.isNotEmpty)
                    GestureDetector(
                      onTap: _clearAll,
                      child: Text(
                        l10n.postClearAllPhotos,
                        style: TextStyle(
                          fontSize:   11,
                          color:      Colors.red.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (_photos.length < 5)
                      GestureDetector(
                        onTap: _addPhoto,
                        child: Container(
                          width:  90,
                          height: 90,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color:        accent.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: accent.withOpacity(0.35),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_rounded,
                                color: accent,
                                size: 28,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.postAddPhoto,
                                style: TextStyle(
                                  fontSize:   10,
                                  color:      accent,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    for (var i = 0; i < _photos.length; i++)
                      _PhotoThumb(
                        index:       i,
                        accentColor: accent,
                        onRemove:    () => _removePhoto(_photos[i]),
                      ),
                  ],
                ),
              ),
              if (_photos.isEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      widget.showError
                          ? Icons.error_outline_rounded
                          : Icons.info_outline_rounded,
                      size: 13,
                      color: widget.showError ? Colors.red.shade400 : _kOrange,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        widget.showError
                            ? l10n.postPhotoRequiredError
                            : l10n.postPhotoPromo,
                        style: TextStyle(
                          fontSize:   11,
                          color:      widget.showError
                              ? Colors.red.shade400
                              : _kOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({
    required this.index,
    required this.onRemove,
    required this.accentColor,
  });

  final int index;
  final VoidCallback onRemove;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = [
      const Color(0xFFE8F5E9),
      const Color(0xFFFFF3E0),
      const Color(0xFFE3F2FD),
      const Color(0xFFFCE4EC),
      const Color(0xFFEDE7F6),
    ];
    final iconColors = [
      accentColor,
      _kOrange,
      const Color(0xFF1976D2),
      const Color(0xFFE91E63),
      const Color(0xFF7B1FA2),
    ];

    return Stack(
      children: [
        Container(
          width:  90,
          height: 90,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color:        colors[index % colors.length],
            borderRadius: BorderRadius.circular(12),
            border:       Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_rounded,
                color: iconColors[index % iconColors.length],
                size:  32,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.postPhotoNumber(index + 1),
                style: TextStyle(
                  fontSize:   9,
                  color:      Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 2,
          right: 12,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width:  20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded,
                  size: 13, color: Colors.white),
            ),
          ),
        ),
        if (index == 0)
          Positioned(
            bottom: 4,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topRight:   Radius.circular(6),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Text(
                l10n.postPhotoCover,
                style: const TextStyle(
                  color:      Colors.white,
                  fontSize:   9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
