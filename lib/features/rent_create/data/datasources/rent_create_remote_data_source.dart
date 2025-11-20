import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/file_upload_helper.dart';
import '../models/create_property_request.dart';
import '../models/create_property_response.dart';

abstract class RentCreateRemoteDataSource {
  Future<CreatePropertyResponse> createPropertyStepOne(
    CreatePropertyStepOneRequest request,
  );
  Future<CreatePropertyResponse> createPropertyStepTwo(
    CreatePropertyStepTwoRequest request,
  );
  Future<ApiResponse<bool>> addAvailability(
    List<PropertyAvailability> availability,
  );
  Future<String> uploadSingleMedia(String propertyId, File image, int order);
  Future<ApiResponse<List<String>>> uploadMultipleMedia(
    List<PropertyMediaUpload> media,
  );
  Future<ApiResponse<bool>> setPrice(SetPriceRequest request);
}

class RentCreateRemoteDataSourceImpl implements RentCreateRemoteDataSource {
  final Dio _dio;

  RentCreateRemoteDataSourceImpl(this._dio);

  @override
  Future<CreatePropertyResponse> createPropertyStepOne(
    CreatePropertyStepOneRequest request,
  ) async {
    try {
      final requestData = request.toJson();

      // Convert to JSON string to ensure proper formatting
      final jsonString = jsonEncode(requestData);

      final response = await _dio.post(
        AppConstants.createPropertyStepOne,
        data: jsonString,
      );

      return CreatePropertyResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create property step one: $e');
    }
  }

  @override
  Future<CreatePropertyResponse> createPropertyStepTwo(
    CreatePropertyStepTwoRequest request,
  ) async {
    try {
      final response = await _dio.post(
        AppConstants.createPropertyStepTwo,
        data: request.toJson(),
      );

      return CreatePropertyResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create property step two: $e');
    }
  }

  @override
  Future<ApiResponse<bool>> addAvailability(
    List<PropertyAvailability> availability,
  ) async {
    try {
      final requestData = availability.map((e) => e.toJson()).toList();

      final response = await _dio.post(
        AppConstants.addAvailability,
        data: requestData,
      );


      return ApiResponse.fromJson(response.data, (json) => json as bool);
    } catch (e) {
      if (e is DioException) {
      }
      throw Exception('Failed to add availability: $e');
    }
  }

  @override
  Future<String> uploadSingleMedia(
    String propertyId,
    File image,
    int order,
  ) async {
    try {
      // Use FileUploadHelper for cross-platform compatibility
      final multipartFile = await FileUploadHelper.createMultipartFileFromPath(
        image.path,
        filename: image.path.split('/').last,
      );

      final formData = FormData.fromMap({
        'PropertyId': propertyId,
        'Image': multipartFile,
        'Order': order,
        'isActive': true,
      });

      final response = await _dio.post(
        AppConstants.uploadSingleMedia,
        data: formData,
      );

      return response.data['data'] ?? '';
    } catch (e) {
      throw Exception('Failed to upload single media: $e');
    }
  }

  @override
  Future<ApiResponse<List<String>>> uploadMultipleMedia(
    List<PropertyMediaUpload> media,
  ) async {
    try {
      // Create form data with multiple media files
      final formDataMap = <String, dynamic>{};

      for (int i = 0; i < media.length; i++) {
        final mediaItem = media[i];
        formDataMap['input[$i].PropertyId'] = mediaItem.propertyId;
        formDataMap['input[$i].Order'] = mediaItem.order.toString();
        formDataMap['input[$i].isActive'] = mediaItem.isActive.toString();

        // Use XFile if available (web compatible), otherwise use path
        if (mediaItem.imageFile != null) {
          formDataMap['input[$i].Image'] =
              await FileUploadHelper.createMultipartFile(
                mediaItem.imageFile!,
                filename: mediaItem.imageFile!.name,
              );
        } else {
          formDataMap['input[$i].Image'] =
              await FileUploadHelper.createMultipartFileFromPath(
                mediaItem.image,
                filename: mediaItem.image.split('/').last,
              );
        }
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        AppConstants.uploadMultipleMedia,
        data: formData,
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => (json as List).cast<String>(),
      );
    } catch (e) {
      throw Exception('Failed to upload multiple media: $e');
    }
  }

  @override
  Future<ApiResponse<bool>> setPrice(SetPriceRequest request) async {
    try {
      final requestData = request.toJson();

      final response = await _dio.post(
        AppConstants.setPrice,
        data: requestData,
      );


      return ApiResponse.fromJson(response.data, (json) => json as bool);
    } catch (e) {
      if (e is DioException) {
      }
      throw Exception('Failed to set price: $e');
    }
  }
}
