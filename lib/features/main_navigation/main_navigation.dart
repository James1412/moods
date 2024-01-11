import 'package:final_project/constants/sizes.dart';
import 'package:final_project/features/moods/my_moods_screen.dart';
import 'package:final_project/features/moods/public_mood_screen.dart';
import 'package:final_project/features/main_navigation/widgets/nav_tab.dart';
import 'package:final_project/features/write_mood/mood_writing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({required this.tab, super.key});
  final String tab;

  static const routeUrl = '/public';
  static const routeName = 'mainNavigation';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  final List<String> _tabs = [
    "public",
    "write",
    "private",
  ];
  late int _selectedIndex = _tabs.indexOf(widget.tab);
  final ScrollController _publicScrollController = ScrollController();
  final ScrollController _privateScrollController = ScrollController();

  Future<void> onTap(int index) async {
    // Tap on page 1 when user is on page 1
    if (index == 0 && _selectedIndex == 0) {
      //scroll up
      if (_publicScrollController.hasClients) {
        await _publicScrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.elasticInOut,
        );
      }
    }
    // Tap on page 3 when user is on page 3
    else if (index == 2 && _selectedIndex == 2) {
      if (_privateScrollController.hasClients) {
        await _privateScrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.elasticInOut,
        );
      }
    } else {
      context.go("/${_tabs[index]}");
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: PublicMoodScreen(
              scrollController: _publicScrollController,
            ),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: const MoodWritingScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 2,
            child: PrivateMoodScreen(
              scrollController: _privateScrollController,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: Sizes.size44,
        padding: const EdgeInsets.only(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: NavTab(
                isWrite: false,
                icon: FontAwesomeIcons.house,
                onTap: () => onTap(0),
                isSelected: _selectedIndex == 0,
              ),
            ),
            Expanded(
              child: NavTab(
                isWrite: true,
                icon: FontAwesomeIcons.pencil,
                onTap: () => onTap(1),
                isSelected: _selectedIndex == 1,
              ),
            ),
            Expanded(
              child: NavTab(
                isWrite: false,
                icon: FontAwesomeIcons.solidUser,
                onTap: () => onTap(2),
                isSelected: _selectedIndex == 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
