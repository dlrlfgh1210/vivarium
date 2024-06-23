import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivarium/search/models/nature_model.dart';
import 'package:vivarium/search/repos/searh_repo.dart';

class SearchViewModel extends AsyncNotifier<List<NatureModel>> {
  late final SearchRepository _searchRepository;
  List<NatureModel> _list = [];

  @override
  FutureOr<List<NatureModel>> build() async {
    _searchRepository = ref.read(searchRepo);
    return [];
  }

  Future<void> fetchNatures(String category) async {
    state = const AsyncValue.loading();
    final result = await _searchRepository.getAllNatures(category);
    _list = result;
    state = AsyncValue.data(_list);
  }

  Future<void> searchPosts(String category, String query) async {
    state = const AsyncValue.loading();
    final result = await _searchRepository.searchNatures(category, query);
    _list = result;
    state = AsyncValue.data(_list);
  }
}

final searchViewModelProvider =
    AsyncNotifierProvider<SearchViewModel, List<NatureModel>>(
  SearchViewModel.new,
);
