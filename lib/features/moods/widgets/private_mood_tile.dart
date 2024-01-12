import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/constants/gaps.dart';
import 'package:final_project/constants/sizes.dart';
import 'package:final_project/features/dark_mode/view_models/dark_mode_config_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class PrivateMoodTile extends ConsumerStatefulWidget {
  final String mood;
  final String text;
  final Timestamp time;
  final List likes;
  final double scale;
  final String moodId;
  final bool isPublic;
  const PrivateMoodTile({
    required this.isPublic,
    required this.moodId,
    required this.scale,
    required this.mood,
    required this.text,
    required this.time,
    required this.likes,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MoodTileState();
}

class _MoodTileState extends ConsumerState<PrivateMoodTile> {
  late bool isLiked;
  bool _expandText = false;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      isLiked = widget.likes.contains(FirebaseAuth.instance.currentUser!.uid);
    } else {
      isLiked = false;
    }
    setState(() {});
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference moodRef =
        FirebaseFirestore.instance.collection('moods').doc(widget.moodId);

    if (isLiked) {
      moodRef.update({
        'likes': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      });
    } else {
      moodRef.update({
        'likes':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      });
    }
  }

  void deletePost(BuildContext context) {
    FirebaseFirestore.instance
        .collection('moods')
        .doc(widget.moodId)
        .delete()
        .then((value) async {
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully deleted the post!"),
          ),
        );
      } catch (e) {
        print(e);
      }
    }).catchError((error) async {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sorry, failed to delete the post. $error has raised"),
        ),
      );
    });
    if (!mounted) {
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Sizes.size10,
        horizontal: Sizes.size10,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.2,
            color: ref.watch(darkmodeConfigProvider).darkMode
                ? Colors.white30
                : Colors.black38,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.v10,
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Row(
                  children: [
                    const Text(
                      "Mood: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Sizes.size20,
                      ),
                    ),
                    Text(
                      widget.mood,
                      style: const TextStyle(
                        fontSize: Sizes.size24,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Slider(
                    allowedInteraction: SliderInteraction.tapOnly,
                    value: widget.scale,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ),
          Gaps.v5,
          GestureDetector(
            onTap: () {
              setState(() {
                _expandText = !_expandText;
              });
            },
            child: Text(
              widget.text,
              maxLines: _expandText ? null : 4,
              overflow: _expandText ? null : TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: Sizes.size18,
              ),
            ),
          ),
          Gaps.v20,
          Opacity(
            opacity: 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.time.toDate().toString().split(' ')[0],
                  style: const TextStyle(
                    fontSize: Sizes.size14,
                  ),
                ),
                GestureDetector(
                  onTap: toggleLike,
                  child: Row(
                    children: [
                      Text(
                        widget.likes.length.toString(),
                        style: const TextStyle(
                          fontSize: Sizes.size16,
                        ),
                      ),
                      Gaps.h7,
                      Icon(
                        isLiked
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        size: Sizes.size18,
                        color: isLiked ? Colors.pink : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gaps.v10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.isPublic ? "Public post" : "Private post"),
              GestureDetector(
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text("Delete the post"),
                      content: const Text("Are you sure?"),
                      actions: [
                        CupertinoDialogAction(
                          textStyle: const TextStyle(color: Colors.blue),
                          child: const Text("No"),
                          onPressed: () {
                            context.pop();
                          },
                        ),
                        CupertinoDialogAction(
                          onPressed: () => deletePost(context),
                          isDestructiveAction: true,
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          Gaps.v10,
          GestureDetector(
            onTap: () async {
              FirebaseFirestore db = FirebaseFirestore.instance;
              await db
                  .collection('moods')
                  .doc(widget.moodId)
                  .update({"isPublic": !widget.isPublic});
              setState(() {});
            },
            child: Text(
                widget.isPublic ? "Change to Private" : "Change to Public"),
          ),
        ],
      ),
    );
  }
}
