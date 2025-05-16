import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/widgets/custom_app_bar.dart';

class PromosScreen extends ConsumerWidget {
  const PromosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final String userId = ref.read(currentUserProvider)!.id;

    return Scaffold(
      appBar: CustomAppBar(title: 'Promos'),
      body: const Center(child: Text('No promos found.')),
    );
  }
}
