import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/widgets/custom_app_bar.dart';

class BestPlacesScreen extends ConsumerWidget {
  const BestPlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final String userId = ref.read(currentUserProvider)!.id;

    return Scaffold(
      appBar: CustomAppBar(title: 'Best Places'),
      body: const Center(child: Text('No places found.')),
    );
  }
}
