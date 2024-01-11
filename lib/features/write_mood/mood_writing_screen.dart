import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:final_project/constants/gaps.dart';
import 'package:final_project/constants/sizes.dart';
import 'package:final_project/features/authentication/repos/authentication_repository.dart';
import 'package:final_project/features/write_mood/models/mood_tile_model.dart';
import 'package:final_project/features/write_mood/repos/mood_tile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoodWritingScreen extends ConsumerStatefulWidget {
  const MoodWritingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MoodWritingScreenState();
}

class _MoodWritingScreenState extends ConsumerState<MoodWritingScreen> {
  final TextEditingController _controller = TextEditingController();
  double moodLevel = 0;
  bool isIconTap = false;
  List<List<dynamic>> emojis = [
    ["😁", false],
    ["😍", false],
    ["😊", false],
    ["🥳", false],
    ["😭", false],
    ["🤬", false],
  ];
  String selectedEmoji = "";
  final MoodTileRepository _moodTileRepo = MoodTileRepository();
  bool emojiSelected = false;

  void onIconTap(int index) {
    for (var element in emojis) {
      element[1] = false;
    }
    emojis[index][1] = !emojis[index][1];
    isIconTap = true;
    selectedEmoji = emojis[index][0];
    setState(() {});
  }

  void onAddIconTap() {
    // Save icons in sharedperferences and bring it back from the users phone
    showDialog(
      context: context,
      builder: (context) => Dialog(
        elevation: 0,
        backgroundColor: const Color(0xffEBEFF1),
        child: SizedBox(
          height: 250,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              setState(() {
                for (var element in emojis) {
                  element[1] = false;
                }
                emojis.add([emoji.emoji, true]);
                isIconTap = true;
                selectedEmoji = emoji.emoji;
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  Future<void> _postTap(bool isPublic) async {
    // check if an emoji is selected
    for (var emoji in emojis) {
      if (emoji[1] == true) {
        emojiSelected = true;
        setState(() {});
      }
    }
    // show snackbar if not
    if (emojiSelected == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an emoji"),
        ),
      );
      return;
    }

    // add to firebase
    await _moodTileRepo.addMood(
      MoodTileModel(
        isPublic: isPublic,
        creatorUid: ref.watch(authRepo).user!.uid,
        text: _controller.text,
        emoji: selectedEmoji,
        scale: moodLevel,
        time: Timestamp.now(),
        likes: [],
      ),
    );

    // reset the emoji after upload
    for (var emoji in emojis) {
      emoji[1] = false;
    }
    // reset the texteditingcontroller
    _controller.clear();
    moodLevel = 0;
    isIconTap = false;
    setState(() {});
  }

  Future<void> _onPostPublicTap() async {
    await _postTap(true);
  }

  Future<void> _onPostPrivateTap() async {
    await _postTap(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Your mood today"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gaps.v10,
                TextField(
                  minLines: 8,
                  maxLines: 8,
                  controller: _controller,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Write it down here!",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Sizes.size5,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Sizes.size5,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                Gaps.v20,
                SizedBox(
                  height: Sizes.size52,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: emojis.length,
                        separatorBuilder: (context, index) => Gaps.h14,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: emojis[index][1] ? 1 : 0.4,
                          child: GestureDetector(
                            onTap: () => onIconTap(index),
                            child: Text(
                              emojis[index][0],
                              style: const TextStyle(
                                fontSize: Sizes.size36,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Gaps.h16,
                      Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            Gaps.v8,
                            GestureDetector(
                              onTap: onAddIconTap,
                              child: const Icon(
                                Icons.add_circle_outline_rounded,
                                size: Sizes.size32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.v20,
                const Text(
                  "How much?",
                  style: TextStyle(
                    fontSize: Sizes.size18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: moodLevel,
                  onChanged: (value) {
                    setState(() {
                      moodLevel = value;
                    });
                  },
                  divisions: 10,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Public post
              GestureDetector(
                onTap: _onPostPublicTap,
                child: AnimatedOpacity(
                  opacity: isIconTap ? 1 : 0.5,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(Sizes.size10),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: const Center(
                      child: Text(
                        "Public post",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Sizes.size16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _onPostPrivateTap,
                child: AnimatedOpacity(
                  opacity: isIconTap ? 1 : 0.5,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.06,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(Sizes.size10),
                    ),
                    child: const Center(
                      child: Text(
                        "Private post",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Sizes.size16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
