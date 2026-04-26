import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salemtek/ui/pages/main/create_edit/create_edit_medicine.dart';

import '../../../../configs/theme/palette.dart';
import '../../../../domain/entities/medicine.dart';
import '../../../bloc/medicine/medicine_cubit.dart';
import '../../../bloc/medicine/medicine_state.dart';
import '../../../components/custom_header.dart';
import '../../../components/medicine_card.dart';

class Cabinet extends StatefulWidget {
  const Cabinet({super.key});

  @override
  State<Cabinet> createState() => _CabinetState();
}

class _CabinetState extends State<Cabinet> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;

      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  List<Medicine> _filterMedicines(List<Medicine> medicines) {
    final query = _searchController.text.trim().toLowerCase();

    final sorted = List<Medicine>.of(medicines)
      ..sort((a, b) => b.dateCreated.compareTo(a.dateCreated));

    if (query.isEmpty) return sorted;

    return sorted.where((medicine) {
      final title = medicine.title.toLowerCase();
      final dosage = medicine.dosage.toLowerCase();

      return title.contains(query) || dosage.contains(query);
    }).toList();
  }

  void _openCreateEditMedicine(
      BuildContext context, {
        Medicine? medicine,
      }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.86,
          child: CreateEditMedicine(medicine: medicine),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();

        if (_isSearching) {
          setState(() {
            _isSearching = false;
            _searchController.clear();
          });
        }
      },
      child: Column(
        children: [
          CustomHeader(
            title: 'Your\nDrug Cabinet',
            icon: Icons.add,
            onPressed: () => _openCreateEditMedicine(context),
            onSearchPressed: _toggleSearch,
          ),

          if (_isSearching)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search medicine or type...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                    icon: const Icon(Icons.close),
                  )
                      : null,
                  filled: true,
                  fillColor: Palette.secondary,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Palette.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
                  child: BlocBuilder<MedicineCubit, MedicineState>(
                    builder: (context, state) {
                      if (state.status == MedicineStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final medicines = _filterMedicines(state.medicines);

                      if (medicines.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Center(
                            child: Text(
                              _searchController.text.trim().isEmpty
                                  ? 'No medicines yet'
                                  : 'No medicines found',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: medicines.map((medicine) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: MedicineCard(
                              medicine: medicine,
                              showCompleteAction: false,
                              enableDelete: true,
                              onSecondaryAction: () {
                                _openCreateEditMedicine(
                                  context,
                                  medicine: medicine,
                                );
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}