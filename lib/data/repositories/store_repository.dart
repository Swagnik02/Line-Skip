import 'package:flutter/material.dart';

// Store Model
class Store {
  final String name;
  final String description;
  final bool hasTrolleyPairing;

  Store({
    required this.name,
    required this.description,
    required this.hasTrolleyPairing,
  });
}

class StoreRepository {
  final List<Store> stores = [
    Store(
      name: 'Store A',
      description: 'Latest gadgets and more.',
      hasTrolleyPairing: true,
    ),
    Store(
      name: 'Store B',
      description: 'Fashion and accessories.',
      hasTrolleyPairing: false,
    ),
    Store(
      name: 'Store C',
      description: 'Groceries and essentials.',
      hasTrolleyPairing: true,
    ),
    Store(
      name: 'Store D',
      description: 'Books and stationery.',
      hasTrolleyPairing: false,
    ),
    Store(
      name: 'Store E',
      description: 'Health and wellness products.',
      hasTrolleyPairing: true,
    ),
  ];

  List<Store> getStores() {
    return stores;
  }

  List<Store> getStoresWithTrolleyPairing() {
    return stores.where((store) => store.hasTrolleyPairing).toList();
  }
}


