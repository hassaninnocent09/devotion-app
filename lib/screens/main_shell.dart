import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/widgets.dart';
import 'bible_books_screen.dart';
import 'home_screen.dart';
import 'plans_list_screen.dart';
import 'you_screen.dart';

/// Hosts the four tabs (kept alive, cross-faded). Detail screens push above it.
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _pages = [HomeScreen(), BibleBooksScreen(), PlansListScreen(), YouScreen()];

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
              children: [
                for (var i = 0; i < _pages.length; i++)
                  AnimatedOpacity(
                    opacity: i == tab ? 1 : 0,
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOut,
                    child: _pages[i],
                  ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSlide(
              offset: keyboard ? const Offset(0, 1) : Offset.zero,
              duration: const Duration(milliseconds: 200),
              child: AppTabBar(current: tab, onTap: (i) => context.read<AppState>().setTab(i)),
            ),
          ),
        ],
      ),
    );
  }
}
