import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_skip/data/models/store_model.dart';
import '../data/repositories/store_repository.dart';

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return StoreRepository();
});

final storesProvider = FutureProvider<List<Store>>((ref) async {
  final storeRepository = ref.read(storeRepositoryProvider);
  return storeRepository.getStores();
});

final selectedStoreProvider = StateProvider<Store?>((ref) => null);

