import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

/// Daily reminders.
class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  late ReminderSettings _draft = context.read<AppState>().reminders;

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _draft.hour, minute: _draft.minute),
    );
    if (t != null) setState(() => _draft = _draft.copyWith(hour: t.hour, minute: t.minute));
  }

  void _toggleDay(int i) {
    final days = [..._draft.days];
    days[i] = !days[i];
    setState(() => _draft = _draft.copyWith(days: days));
  }

  @override
  Widget build(BuildContext context) {
    final on = _draft.enabled;
    return Scaffold(
      body: GlassPage(
        title: 'Daily Reminders',
        largeTitle: false,
        showBack: true,
        bottomPadding: 120 + Insets.bottom(context),
        bottomBar: SizedBox(
          height: 96 + Insets.bottom(context),
          child: Stack(
            children: [
              const Positioned.fill(child: GlassBackdrop(borderTop: true)),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + Insets.bottom(context)),
                child: PrimaryButton('Save', onTap: () {
                  context.read<AppState>().saveReminders(_draft);
                  showToast(context, 'Reminders saved');
                  Navigator.of(context).maybePop();
                }),
              ),
            ],
          ),
        ),
        children: [
          FadeSlideIn(
            child: Column(
              children: [
                const SizedBox(height: 8),
                const IconTile('bell', size: 72, filled: true),
                const SizedBox(height: 20),
                Text('Daily Reminders', style: AppText.serif(28, w: FontWeight.w500)),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text('Get a gentle nudge to spend time with God each day.',
                      textAlign: TextAlign.center,
                      style: AppText.t(14, color: AppColors.muted, lh: 22)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          FadeSlideIn(
            index: 1,
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Container(
                    height: 66,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.borderSoft)),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text('Enable reminders', style: AppText.t(15, w: FontWeight.w500))),
                        Pressable(
                          scale: 0.94,
                          onTap: () => setState(() => _draft = _draft.copyWith(enabled: !on)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            width: 52,
                            height: 30,
                            padding: const EdgeInsets.all(3),
                            alignment: on ? Alignment.centerRight : Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: on ? AppColors.green : AppColors.switchOff,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: on ? 1 : 0.45,
                    duration: const Duration(milliseconds: 200),
                    child: Pressable(
                      scale: 0.99,
                      onTap: on ? _pickTime : null,
                      child: Container(
                        height: 66,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(child: Text('Reminder time', style: AppText.t(15, w: FontWeight.w500))),
                            Text(timeLabel(_draft.hour, _draft.minute),
                                style: AppText.t(15, w: FontWeight.w500, color: AppColors.green)),
                            const SizedBox(width: 4),
                            const AppIcon('right', size: 22, color: AppColors.faint),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SectionLabel('Repeat on', padding: EdgeInsets.fromLTRB(24, 28, 24, 14)),
          FadeSlideIn(
            index: 2,
            child: AnimatedOpacity(
              opacity: on ? 1 : 0.45,
              duration: const Duration(milliseconds: 200),
              child: AppCard(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 16),
                child: WeekDots(
                  items: [
                    for (var i = 0; i < 7; i++)
                      WeekItem(
                        weekdayShort[i],
                        !_draft.days[i] ? DotState.off : (i >= 5 ? DotState.part : DotState.done),
                        onTap: on ? () => _toggleDay(i) : null,
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
