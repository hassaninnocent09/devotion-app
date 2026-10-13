import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

/// Screen 15 – Daily reminders.
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: Insets.top(context)),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(28, 30, 40, 10),
                        child: AppIcon('left', size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const AppIcon('bell', size: 28, color: AppColors.inkDim),
                  const SizedBox(height: 29),
                  Text('Daily Reminders', style: AppText.t(26, lh: 30)),
                  const SizedBox(height: 8),
                  Text('Get a gentle nudge to spend time\nwith God each day.',
                      textAlign: TextAlign.center,
                      style: AppText.t(13, color: AppColors.muted, lh: 26)),
                  const SizedBox(height: 32),
                  _row(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Enable reminders', style: AppText.t(13, color: AppColors.inkDim)),
                        GestureDetector(
                          onTap: () => setState(() => _draft = _draft.copyWith(enabled: !on)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 50,
                            height: 28,
                            padding: const EdgeInsets.all(3),
                            alignment: on ? Alignment.centerRight : Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: on ? AppColors.green : AppColors.switchOff,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: on ? _pickTime : null,
                    child: _row(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Reminder time', style: AppText.t(13, color: AppColors.inkDim)),
                          Row(
                            children: [
                              Text(timeLabel(_draft.hour, _draft.minute),
                                  style: AppText.t(13, color: AppColors.inkDim)),
                              const SizedBox(width: 12),
                              const AppIcon('right', size: 14, color: AppColors.muted),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(34, 25, 34, 0),
                      child: Text('Days', style: AppText.t(13, color: AppColors.muted, lh: 18)),
                    ),
                  ),
                  Opacity(
                    opacity: on ? 1 : 0.45,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 21, 25, 24),
                      child: WeekDots(
                        items: [
                          for (var i = 0; i < 7; i++)
                            WeekItem(
                              weekdayShort[i],
                              !_draft.days[i]
                                  ? DotState.off
                                  : (i >= 5 ? DotState.part : DotState.done),
                              onTap: on ? () => _toggleDay(i) : null,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(26, 8, 26, 32 + Insets.bottom(context)),
            child: PrimaryButton('Save', height: 48, onTap: () {
              context.read<AppState>().saveReminders(_draft);
              showToast(context, 'Reminders saved');
              Navigator.of(context).maybePop();
            }),
          ),
        ],
      ),
    );
  }

  Widget _row({required Widget child}) => Container(
        height: 66,
        padding: const EdgeInsets.fromLTRB(34, 0, 28, 0),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderSoft)),
        ),
        child: child,
      );
}
