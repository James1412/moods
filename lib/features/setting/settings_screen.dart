import 'package:final_project/features/authentication/repos/authentication_repository.dart';
import 'package:final_project/features/dark_mode/view_models/dark_mode_config_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  static const routeUrl = '/settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text("Licenses"),
            onTap: () => showAboutDialog(
              context: context,
            ),
          ),
          SwitchListTile.adaptive(
            title: const Text(
              "Dark mode",
              style: TextStyle(),
            ),
            value: ref.watch(darkmodeConfigProvider).darkMode,
            onChanged: (value) {
              ref.read(darkmodeConfigProvider.notifier).setDarkMode(value);
            },
          ),
          ListTile(
            title: const Text(
              "Log out",
              style: TextStyle(),
            ),
            trailing: const Icon(
              FontAwesomeIcons.rightFromBracket,
            ),
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text("Leave the app?"),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.of(context).pop(context);
                        },
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: const Text("Yes"),
                        onPressed: () {
                          ref.read(authRepo).signOut();
                          context.go('/');
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text(
              "Delete Account",
              style: TextStyle(),
            ),
            trailing: const Icon(
              FontAwesomeIcons.userXmark,
              color: Colors.red,
            ),
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text("Delete the account?"),
                    content: const Text("Are you sure?"),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.of(context).pop(context);
                        },
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: const Text("Yes"),
                        onPressed: () {
                          ref.read(authRepo).deleteAccount();
                          context.go('/');
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
