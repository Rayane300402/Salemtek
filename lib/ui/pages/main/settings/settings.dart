import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salemtek/configs/theme/palette.dart';
import 'package:salemtek/ui/components/global_toast.dart';
import 'package:salemtek/ui/pages/main/settings/components/settings_button.dart';
import 'package:salemtek/ui/pages/main/settings/components/settings_section_header.dart';

import '../../../components/custom_header.dart';
import '../../../bloc/settings/settings_cubit.dart';
import '../../../bloc/settings/settings_state.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  Future<void> _showHardResetDialog(BuildContext context) async {
    final cubit = context.read<SettingsCubit>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hard Reset'),
          content: const Text(
            'This will permanently delete all medicines and reset settings. This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await cubit.hardReset();
      GlobalToast.show('All data cleared', isNegative: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeader(title: 'Your\nMedical Settings'),
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
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
              child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: const Offset(0.18, 0),
                        end: Offset.zero,
                      ).animate(animation);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: switch (state.section) {
                      SettingsViewSection.root => _RootSettingsView(
                        key: const ValueKey('root'),
                      ),
                      SettingsViewSection.data => _DataSettingsView(
                        key: const ValueKey('data'),
                        onHardReset: () => _showHardResetDialog(context),
                      ),
                      SettingsViewSection.notification => _NotificationSettingsView(
                        key: const ValueKey('notification'),
                      ),
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RootSettingsView extends StatelessWidget {
  const _RootSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsButton(
          title: 'Data',
          subtitle: 'manage your data',
          icon: Icons.data_usage,
          onTap: () => context.read<SettingsCubit>().goToData(),
        ),
        const SizedBox(height: 15),
        SettingsButton(
          title: 'Notification',
          subtitle: 'manage your notifications',
          icon: Icons.notifications_active,
          onTap: () => context.read<SettingsCubit>().goToNotification(),
        ),
      ],
    );
  }
}

class _DataSettingsView extends StatelessWidget {
  final VoidCallback onHardReset;

  const _DataSettingsView({
    super.key,
    required this.onHardReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(
          title: 'Data',
          onBack: () => context.read<SettingsCubit>().goToRoot(),
        ),
        const SizedBox(height: 24),
        SettingsButton(
          title: 'Restore Data',
          subtitle: 'restore all soft-deleted medicines',
          icon: Icons.restore,
          onTap: () async {
            await context.read<SettingsCubit>().restoreData();
            GlobalToast.show('Data restored');
          },
        ),
        const SizedBox(height: 15),
        SettingsButton(
          title: 'Hard Reset',
          subtitle: 'permanently clear all medicines and reset settings',
          icon: Icons.delete_forever,
          onTap: onHardReset,
        ),
      ],
    );
  }
}

class _NotificationSettingsView extends StatelessWidget {
  const _NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsCubit>().state.settings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(
          title: 'Notification',
          onBack: () => context.read<SettingsCubit>().goToRoot(),
        ),
        const SizedBox(height: 24),

        SwitchListTile(
          value: settings.notificationsEnabled,
          onChanged: (value) {
            context.read<SettingsCubit>().toggleNotifications(value);
          },
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Notifications',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('turn reminders on or off'),
        ),

        const SizedBox(height: 10),

        SwitchListTile(
          value: settings.excessiveRemindersEnabled,
          onChanged: (value) {
            context.read<SettingsCubit>().toggleExcessiveReminders(value);
          },
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Excessive Reminder',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('repeat reminder every X minutes'),
        ),

        const SizedBox(height: 10),

        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Repeat Interval',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text('${settings.excessiveReminderMinutes} minutes'),
          trailing: DropdownButton<int>(
            value: settings.excessiveReminderMinutes,
            underline: const SizedBox.shrink(),
            items: const [5, 10, 15, 20, 30, 45, 60]
                .map(
                  (value) => DropdownMenuItem<int>(
                value: value,
                child: Text('$value'),
              ),
            )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                context
                    .read<SettingsCubit>()
                    .updateExcessiveReminderMinutes(value);
              }
            },
          ),
        ),
      ],
    );
  }
}