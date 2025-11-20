import '../../../../core/network/api_result.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/home_entities.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl({required HomeRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResult<HomeData>> getHomeData() async {
    try {
      final response = await _remoteDataSource.getHomeData();

      // Convert DTOs to entities
      final specialAdvertisements = response.specialAdvertismentMobileDtos
          .map(
            (dto) => SpecialAdvertisement(
              id: dto.id,
              imageUrl: _buildFullImageUrl(dto.image),
              propertyId: dto.sitePropertyId,
              propertyTitle: dto.sitePropertyTitle,
            ),
          )
          .toList();

      final siteProperties = response.siteProperties
          .map(
            (dto) => Property(
              id: dto.id,
              title: dto.propertyTitle,
              hotelName: dto.hotelName,
              address: dto.address,
              streetAndBuildingNumber: dto.streetAndBuildingNumber,
              landmark: dto.landMark,
              pricePerNight: dto.pricePerNight,
              isActive: dto.isActive,
              isFavorite: dto.isFavorite,
              averageRating: dto.averageRating,
              area: dto.area,
              mainImageUrl: dto.mainImage != null
                  ? _buildFullImageUrl(dto.mainImage!)
                  : null,
            ),
          )
          .toList();

      final highlyRatedProperties = response.highlyRatedProperty
          .map(
            (dto) => Property(
              id: dto.id,
              title: dto.propertyTitle,
              hotelName: dto.hotelName,
              address: dto.address,
              streetAndBuildingNumber: dto.streetAndBuildingNumber,
              landmark: dto.landMark,
              pricePerNight: dto.pricePerNight,
              isActive: dto.isActive,
              isFavorite: dto.isFavorite,
              averageRating: dto.averageRating,
              area: dto.area,
              mainImageUrl: dto.mainImage != null
                  ? _buildFullImageUrl(dto.mainImage!)
                  : null,
            ),
          )
          .toList();

      final governorates = response.governorateMobileDto
          .map(
            (dto) => Governorate(
              id: dto.id,
              title: dto.title,
              iconUrl: dto.icon != null ? _buildFullImageUrl(dto.icon!) : null,
            ),
          )
          .toList();

      final onlyForYouSection = OnlyForYouSection(
        id: response.onlyForYouSectionMobileDto.id,
        firstPhotoUrl: _buildFullImageUrl(
          response.onlyForYouSectionMobileDto.firstPhoto,
        ),
        secondPhotoUrl: _buildFullImageUrl(
          response.onlyForYouSectionMobileDto.secondPhoto,
        ),
        thirdPhotoUrl: _buildFullImageUrl(
          response.onlyForYouSectionMobileDto.thirdPhoto,
        ),
      );

      // User profile
      final userProfile = response.userProfile != null
          ? UserProfile(
              id: response.userProfile!.id,
              name: response.userProfile!.name,
              email: response.userProfile!.email,
              profilePhotoUrl: response.userProfile!.profilePhoto != null
                  ? _buildFullImageUrl(response.userProfile!.profilePhoto!)
                  : null,
              averageRating: response.userProfile!.averageRating,
              isSuperHost: response.userProfile!.isSuperHost,
            )
          : null;


      // Hotels of the week
      final hotelsOfTheWeek = response.hotelsOfTheWeek
          ?.map(
            (dto) => HotelOfTheWeek(
              id: dto.id,
              name: dto.name,
              email: dto.email,
              profilePhotoUrl: dto.profilePhoto != null
                  ? _buildFullImageUrl(dto.profilePhoto!)
                  : null,
              averageRating: dto.averageRating,
              isSuperHost: dto.isSuperHost,
            ),
          )
          .toList();

      final homeData = HomeData(
        specialAdvertisements: specialAdvertisements,
        siteProperties: siteProperties,
        highlyRatedProperties: highlyRatedProperties,
        governorates: governorates,
        onlyForYouSection: onlyForYouSection,
        userProfile: userProfile,
        hotelsOfTheWeek: hotelsOfTheWeek,
      );

      return ApiResult.success(homeData);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.getErrorMessage(error));
    }
  }

  String _buildFullImageUrl(String imagePath) {
    // If the path is already a complete URL, return it as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Otherwise, build the full URL
    const baseUrl = 'http://srv954186.hstgr.cloud:5000';
    if (imagePath.startsWith('/')) {
      return '$baseUrl$imagePath';
    }
    return '$baseUrl/$imagePath';
  }
}
