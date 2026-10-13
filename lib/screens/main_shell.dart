import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/widgets.dart';
import 'bible_books_screen.dart';
import 'home_screen.dart';
import 'plans_list_screen.dart';
import 'you_screen.dart';

/// Hosts the four tabs. Detail screens are pushed above it.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final tab = context.select<AppState, int>((s) => s.tab);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom > 0;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: tab,
              children: const [
                HomeScreen(),
                BibleBooksScreen(),
                PlansListScreen(),
                YouScreen(),
              ],
            ),
          ),
          if (!keyboard)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppTabBar(
                current: tab,
                onTap: (i) => context.read<AppState>().setTab(i),
              ),
            ),
        ],
      ),
    );
  }
}
