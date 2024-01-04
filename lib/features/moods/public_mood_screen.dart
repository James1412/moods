import 'package:final_project/features/moods/widgets/public_mood_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicMoodScreen extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const PublicMoodScreen({required this.scrollController, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PublicMoodScreenState();
}

class _PublicMoodScreenState extends ConsumerState<PublicMoodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Public moods"),
      ),
      body: RefreshIndicator.adaptive(
        displacement: 10,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
        },
        child: Scrollbar(
          controller: widget.scrollController,
          child: ListView(
            controller: widget.scrollController,
            children: const [
              PublicMoodTile(
                mood: "😁",
                text:
                    "Hi this is very long test mood sentences. It's to describe my emotion today and what I did today and it is going to be really loooooooooong, Hi this is very long test mood sentences. It's to describe my emotion today and what I did today and it is going to be really loooooooooong",
                time: "Jan 3",
                likes: '13',
              ),
              PublicMoodTile(
                mood: "😁",
                text:
                    "Hi this is very long test mood sentences. It's to describe my emotion today and what I did today and it is going to be really loooooooooong, Hi this is very long test mood sentences. It's to describe my emotion today and what I did today and it is going to be really loooooooooong",
                time: "Jan 3",
                likes: '13',
              ),
              PublicMoodTile(
                mood: "😁",
                text:
                    "Hi this is very long test mood sentences. It's to describe my emotion today and what I did today and it is going to be really loooooooooong, Hi this is very long test mood sentences. It's to describe my emotion today and what I did today and it is going to be really loooooooooong",
                time: "Jan 3",
                likes: '13',
              ),
              PublicMoodTile(
                mood: "😁",
                text:
                    "Hi this is very long test mood sentences. It's to describe my emotion today and what I did today and it is going to be really loooooooooong",
                time: "Jan 3",
                likes: '13',
              ),
              PublicMoodTile(
                mood: "😁",
                text:
                    "Hi this is very long test mood sentences. It's to describe my emotion today and what I did today and it is going to be really loooooooooong",
                time: "Jan 3",
                likes: '13',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
