import '../../../../core/network/api_result.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/search_entities.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';
import '../models/search_filter.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepositoryImpl({required SearchRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResult<List<LookupItemEntity>>> getPropertyTypes() async {
    try {
      final response = await _remoteDataSource.getPropertyTypes();
      final entities = response.items
          .map(
            (item) =>
                LookupItemEntity(id: item.id, displayName: item.displayName),
          )
          .toList();
      return ApiResult.success(entities);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.getErrorMessage(error));
    }
  }

  @override
  Future<ApiResult<List<LookupItemEntity>>> getPropertyFeatures() async {
    try {
      final response = await _remoteDataSource.getPropertyFeatures();
      final entities = response.items
          .map(
            (item) =>
                LookupItemEntity(id: item.id, displayName: item.displayName),
          )
          .toList();
      return ApiResult.success(entities);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.getErrorMessage(error));
    }
  }

  @override
  Future<ApiResult<List<LookupItemEntity>>> getGovernates() async {
    try {
      final response = await _remoteDataSource.getGovernates();
      final entities = response.items
          .map(
            (item) =>
                LookupItemEntity(id: item.id, displayName: item.displayName),
          )
          .toList();
      return ApiResult.success(entities);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.getErrorMessage(error));
    }
  }

  @override
  Future<ApiResult<SearchResultEntity>> searchProperties(
    SearchFilter filter,
  ) async {
    try {
      final queryMap = SearchRemoteDataSourceHelper.filterToQueryMap(filter);

      final response = await _remoteDataSource.searchProperties(queryMap);

      final entities = response.items
          .map(
            (property) => PropertyEntity(
              id: property.id,
              title: property.title,
              description: property.description,
              pricePerNight: property.pricePerNight,
              address: property.address,
              cityName: property.cityName,
              governateName: property.governateName,
              bedrooms: property.bedrooms,
              bathrooms: property.bathrooms,
              livingrooms: property.livingrooms,
              rating: property.rating,
              mainImage: property.mainImage,
              features: property.features,
              propertyTypeId: property.propertyTypeId,
              propertyTypeName: property.propertyTypeName,
              hotelName: property.hotelName,
              isActive: property.isActive,
            ),
          )
          .toList();

      final searchResult = SearchResultEntity(
        properties: entities,
        totalCount: response.totalCount,
      );

      return ApiResult.success(searchResult);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.getErrorMessage(error));
    }
  }
}
