import 'package:flutter/material.dart';

import '../../../../../domain/entities/medicine.dart';

class MedicineLegend extends StatefulWidget {
  final List<Medicine> medicines;

  const MedicineLegend({
    super.key,
    required this.medicines,
  });

  @override
  State<MedicineLegend> createState() => _MedicineLegendState();
}

class _MedicineLegendState extends State<MedicineLegend> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.medicines.isEmpty) {
      return const Center(
        child: Text(
          'No medicines',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount: widget.medicines.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final medicine = widget.medicines[index];

          return Row(
            children: [
              Image.asset(
                medicine.imagePath,
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  medicine.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}