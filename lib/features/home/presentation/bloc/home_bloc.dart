import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({
    required HomeRepository homeRepository,
  })  : _homeRepository = homeRepository,
        super(const HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<RefreshHomeDataEvent>(_onRefreshHomeData);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    
    final result = await _homeRepository.getHomeData();
    
    result.when(
      success: (homeData) => emit(HomeLoaded(homeData: homeData)),
      failure: (message) => emit(HomeError(message: message)),
    );
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Keep current data while refreshing
    final result = await _homeRepository.getHomeData();
    
    result.when(
      success: (homeData) => emit(HomeLoaded(homeData: homeData)),
      failure: (message) => emit(HomeError(message: message)),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<HomeState> emit,
  ) async {

    // For now, just refresh the data
    if (state is HomeLoaded) {
      add(const RefreshHomeDataEvent());
    }
  }
}
