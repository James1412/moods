import 'package:final_project/features/setting/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PrivateMoodScreen extends ConsumerStatefulWidget {
  const PrivateMoodScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrivateMoodState();
}

class _PrivateMoodState extends ConsumerState<PrivateMoodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Private moods"),
        ),
        body: Center(
          child: TextButton(
            onPressed: () {
              context.go(SettingsScreen.routeUrl);
            },
            child: const Text("hi"),
          ),
        ));
  }
}