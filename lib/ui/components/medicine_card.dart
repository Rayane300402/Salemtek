import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../configs/theme/palette.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/entities/reminder.dart';
import '../bloc/medicine/medicine_cubit.dart';
import 'global_toast.dart';

class MedicineCard extends StatefulWidget {
  final Medicine medicine;
  final bool showCompleteAction;
  final bool enableDelete;
  final VoidCallback onSecondaryAction;

  const MedicineCard({
    super.key,
    required this.medicine,
    required this.showCompleteAction,
    required this.enableDelete,
    required this.onSecondaryAction,
  });

  @override
  State<MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {
  double _dragOffset = 0;

  static const double _maxSlide = 110;
  static const double _triggerSlide = 160;

  String _formatReminder() {
    final unit = switch (widget.medicine.reminderUnit) {
      ReminderUnit.day => widget.medicine.reminderEvery == 1 ? 'day' : 'days',
      ReminderUnit.week => widget.medicine.reminderEvery == 1 ? 'week' : 'weeks',
      ReminderUnit.month => widget.medicine.reminderEvery == 1 ? 'month' : 'months',
      ReminderUnit.year => widget.medicine.reminderEvery == 1 ? 'year' : 'years',
    };

    return 'Every ${widget.medicine.reminderEvery} $unit';
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;

      // 🚫 Block right swipe if delete disabled
      if (!widget.enableDelete && _dragOffset > 0) {
        _dragOffset = 0;
      }

      // Clamp values
      if (_dragOffset > _triggerSlide) _dragOffset = _triggerSlide;
      if (_dragOffset < -_triggerSlide) _dragOffset = -_triggerSlide;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    // DELETE (full swipe executes)
    if (_dragOffset >= _triggerSlide && widget.enableDelete) {
      context.read<MedicineCubit>().delete(widget.medicine.id);
      setState(() => _dragOffset = 0);
      return;
    }

    // COMPLETE (full swipe executes)
    if (_dragOffset <= -_triggerSlide && widget.showCompleteAction) {
      widget.onSecondaryAction();
      setState(() => _dragOffset = 0);
      return;
    }

    // 🟡 EDIT (full swipe DOES NOT execute)
    if (_dragOffset <= -_triggerSlide && !widget.showCompleteAction) {
      setState(() => _dragOffset = -_maxSlide);
      return;
    }

    setState(() {
      if (_dragOffset.abs() < 40) {
        _dragOffset = 0;
      }
      else if (_dragOffset > 0 && widget.enableDelete) {
        _dragOffset = _maxSlide;
      }
      else if (_dragOffset < 0) {
        _dragOffset = -_maxSlide;
      }
    });
  }

  void _closeCard() {
    setState(() => _dragOffset = 0);
  }

  @override
  Widget build(BuildContext context) {
    final isShowingLeft = _dragOffset > 0;
    final isShowingRight = _dragOffset < 0;

    return SizedBox(
      height: 120,
      width: double.infinity,
      child: Stack(
        children: [
          if (isShowingLeft && widget.enableDelete)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color:  Palette.navIcon,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: _maxSlide,
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          if (widget.enableDelete) {
                            context.read<MedicineCubit>().delete(widget.medicine.id);
                            GlobalToast.show(
                              'Medicine Deleted',
                              isNegative: true
                            );
                          }
                        },
                        icon:  Icon(
                          Icons.delete_outline,
                          color: Palette.secondary,
                          size: 34,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          if (isShowingRight)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Palette.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: _maxSlide,
                    child: Center(
                      child: IconButton(
                        onPressed: widget.onSecondaryAction,
                        icon: Icon(
                          widget.showCompleteAction
                              ? Icons.check
                              : Icons.edit_outlined,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            left: _dragOffset,
            right: -_dragOffset,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: _handleDragUpdate,
              onHorizontalDragEnd: _handleDragEnd,
              onTap: _closeCard,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Row(
                  children: [
                    SizedBox(
                      width: 82,
                      child: Center(
                        child: Image.asset(
                          widget.medicine.imagePath,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.medicine.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Palette.text,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.medicine.dosage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Palette.text.withValues(alpha: 0.65),
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_filled,
                                size: 18,
                                color: Palette.text,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _formatReminder(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Palette.text,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        size: 28,
                        color: Palette.text,
                      ),
                      color: Palette.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            widget.onSecondaryAction();
                            break;

                          case 'complete':
                            widget.onSecondaryAction();
                            break;

                          case 'delete':
                            if (widget.enableDelete) {
                              context.read<MedicineCubit>().delete(widget.medicine.id);
                            }
                            break;
                        }
                      },
                      itemBuilder: (context) {
                        final items = <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                        ];

                        if (widget.showCompleteAction) {
                          items.add(
                            const PopupMenuItem<String>(
                              value: 'complete',
                              child: Text('Complete'),
                            ),
                          );
                        }

                        if (widget.enableDelete) {
                          items.add(
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          );
                        }

                        return items;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}