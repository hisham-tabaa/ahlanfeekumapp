import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/models/search_filter.dart';
import '../../domain/entities/search_entities.dart';
import '../../domain/repositories/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;
  final SharedPreferences _sharedPreferences;
  static const String _recentSearchesKey = 'recent_searches';

  SearchBloc({
    required SearchRepository searchRepository,
    required SharedPreferences sharedPreferences,
  }) : _searchRepository = searchRepository,
       _sharedPreferences = sharedPreferences,
       super(const SearchInitial()) {
    on<LoadLookupsEvent>(_onLoadLookups);
    on<SearchPropertiesEvent>(_onSearchProperties);
    on<UpdateFilterEvent>(_onUpdateFilter);
    on<ResetFilterEvent>(_onResetFilter);
    on<LoadMorePropertiesEvent>(_onLoadMoreProperties);
    on<SaveRecentSearchEvent>(_onSaveRecentSearch);
  }

  Future<void> _onLoadLookups(
    LoadLookupsEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(const LookupsLoading());

    try {
      final results = await Future.wait([
        _searchRepository.getPropertyTypes(),
        _searchRepository.getPropertyFeatures(),
        _searchRepository.getGovernates(),
      ]);

      final propertyTypesResult = results[0];
      final propertyFeaturesResult = results[1];
      final governatesResult = results[2];

      // Load recent searches
      final recentSearches = await _loadRecentSearches();

      final propertyTypes = propertyTypesResult.maybeWhen(
        success: (data) => data,
        orElse: () => null,
      );
      final propertyFeatures = propertyFeaturesResult.maybeWhen(
        success: (data) => data,
        orElse: () => null,
      );
      final governates = governatesResult.maybeWhen(
        success: (data) => data,
        orElse: () => null,
      );

      if (propertyTypes != null &&
          propertyFeatures != null &&
          governates != null) {
        emit(
          LookupsLoaded(
            propertyTypes: propertyTypes,
            propertyFeatures: propertyFeatures,
            governates: governates,
            currentFilter: const SearchFilter(),
            recentSearches: recentSearches,
          ),
        );
      } else {
        // Find the failure message
        final failureMessage = propertyTypesResult.maybeWhen(
          failure: (message) => message,
          orElse: () => propertyFeaturesResult.maybeWhen(
            failure: (message) => message,
            orElse: () => governatesResult.maybeWhen(
              failure: (message) => message,
              orElse: () => 'Unknown error',
            ),
          ),
        );
        emit(SearchError(message: failureMessage));
      }
    } catch (error) {
      emit(SearchError(message: 'An unexpected error occurred: $error'));
    }
  }

  Future<void> _onSearchProperties(
    SearchPropertiesEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchLoading());

    final result = await _searchRepository.searchProperties(event.filter);

    result.when(
      success: (searchResult) {
        final currentState = state;
        List<RecentSearch> recentSearches = [];
        List<LookupItemEntity> propertyTypes = [];
        List<LookupItemEntity> propertyFeatures = [];
        List<LookupItemEntity> governates = [];

        if (currentState is LookupsLoaded) {
          recentSearches = currentState.recentSearches;
          propertyTypes = currentState.propertyTypes;
          propertyFeatures = currentState.propertyFeatures;
          governates = currentState.governates;
        } else if (currentState is SearchLoaded) {
          recentSearches = currentState.recentSearches;
          propertyTypes = currentState.propertyTypes;
          propertyFeatures = currentState.propertyFeatures;
          governates = currentState.governates;
        }

        emit(
          SearchLoaded(
            properties: searchResult.properties,
            totalCount: searchResult.totalCount,
            currentFilter: event.filter,
            propertyTypes: propertyTypes,
            propertyFeatures: propertyFeatures,
            governates: governates,
            recentSearches: recentSearches,
            hasReachedMax:
                searchResult.properties.length < event.filter.maxResultCount,
          ),
        );
      },
      failure: (message) => emit(SearchError(message: message)),
    );
  }

  Future<void> _onUpdateFilter(
    UpdateFilterEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (state is LookupsLoaded) {
      final currentState = state as LookupsLoaded;
      emit(
        LookupsLoaded(
          propertyTypes: currentState.propertyTypes,
          propertyFeatures: currentState.propertyFeatures,
          governates: currentState.governates,
          currentFilter: event.filter,
          recentSearches: currentState.recentSearches,
        ),
      );
    } else if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      emit(
        SearchLoaded(
          properties: currentState.properties,
          totalCount: currentState.totalCount,
          currentFilter: event.filter,
          propertyTypes: currentState.propertyTypes,
          propertyFeatures: currentState.propertyFeatures,
          governates: currentState.governates,
          recentSearches: currentState.recentSearches,
          hasReachedMax: currentState.hasReachedMax,
        ),
      );
    }
  }

  Future<void> _onResetFilter(
    ResetFilterEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (state is LookupsLoaded) {
      final currentState = state as LookupsLoaded;
      emit(
        LookupsLoaded(
          propertyTypes: currentState.propertyTypes,
          propertyFeatures: currentState.propertyFeatures,
          governates: currentState.governates,
          currentFilter: const SearchFilter(),
          recentSearches: currentState.recentSearches,
        ),
      );
    } else if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      emit(
        SearchLoaded(
          properties: currentState.properties,
          totalCount: currentState.totalCount,
          currentFilter: const SearchFilter(),
          propertyTypes: currentState.propertyTypes,
          propertyFeatures: currentState.propertyFeatures,
          governates: currentState.governates,
          recentSearches: currentState.recentSearches,
          hasReachedMax: currentState.hasReachedMax,
        ),
      );
    }
  }

  Future<void> _onLoadMoreProperties(
    LoadMorePropertiesEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (state is! SearchLoaded) return;

    final currentState = state as SearchLoaded;
    if (currentState.hasReachedMax) return;


    final result = await _searchRepository.searchProperties(event.filter);

    result.when(
      success: (searchResult) {
        final newProperties = [
          ...currentState.properties,
          ...searchResult.properties,
        ];

        emit(
          SearchLoaded(
            properties: newProperties,
            totalCount: searchResult.totalCount,
            currentFilter: currentState.currentFilter,
            propertyTypes: currentState.propertyTypes,
            propertyFeatures: currentState.propertyFeatures,
            governates: currentState.governates,
            recentSearches: currentState.recentSearches,
            hasReachedMax:
                searchResult.properties.length < event.filter.maxResultCount,
          ),
        );
      },
      failure: (message) {
        // Handle error for load more if needed
      },
    );
  }

  Future<void> _onSaveRecentSearch(
    SaveRecentSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    final recentSearches = await _loadRecentSearches();

    final newSearch = RecentSearch(
      location: event.location,
      checkIn: event.checkIn,
      checkOut: event.checkOut,
      guests: event.guests,
      timestamp: DateTime.now(),
    );

    // Remove duplicate if exists and add to beginning
    final updatedSearches = [
      newSearch,
      ...recentSearches.where(
        (search) =>
            search.location != newSearch.location ||
            search.checkIn != newSearch.checkIn ||
            search.checkOut != newSearch.checkOut ||
            search.guests != newSearch.guests,
      ),
    ].take(5).toList(); // Keep only 5 recent searches

    await _saveRecentSearches(updatedSearches);

    // Update current state with new recent searches
    if (state is LookupsLoaded) {
      final currentState = state as LookupsLoaded;
      emit(
        LookupsLoaded(
          propertyTypes: currentState.propertyTypes,
          propertyFeatures: currentState.propertyFeatures,
          governates: currentState.governates,
          currentFilter: currentState.currentFilter,
          recentSearches: updatedSearches,
        ),
      );
    } else if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      emit(
        SearchLoaded(
          properties: currentState.properties,
          totalCount: currentState.totalCount,
          currentFilter: currentState.currentFilter,
          propertyTypes: currentState.propertyTypes,
          propertyFeatures: currentState.propertyFeatures,
          governates: currentState.governates,
          recentSearches: updatedSearches,
          hasReachedMax: currentState.hasReachedMax,
        ),
      );
    }
  }

  Future<List<RecentSearch>> _loadRecentSearches() async {
    final jsonString = _sharedPreferences.getString(_recentSearchesKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map(
            (json) => RecentSearch(
              location: json['location'] as String?,
              checkIn: json['checkIn'] != null
                  ? DateTime.tryParse(json['checkIn'] as String)
                  : null,
              checkOut: json['checkOut'] != null
                  ? DateTime.tryParse(json['checkOut'] as String)
                  : null,
              guests: json['guests'] as int?,
              timestamp: DateTime.parse(json['timestamp'] as String),
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveRecentSearches(List<RecentSearch> searches) async {
    final jsonList = searches
        .map(
          (search) => {
            'location': search.location,
            'checkIn': search.checkIn?.toIso8601String(),
            'checkOut': search.checkOut?.toIso8601String(),
            'guests': search.guests,
            'timestamp': search.timestamp.toIso8601String(),
          },
        )
        .toList();

    await _sharedPreferences.setString(
      _recentSearchesKey,
      json.encode(jsonList),
    );
  }
}
