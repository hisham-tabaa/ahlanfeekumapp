import 'package:dio/dio.dart';
import '../error/exceptions.dart';

/// WhatsApp API service for sending OTP messages
class WhatsAppService {
  final Dio dio;

  // WhatsApp API configuration
  static const String _whatsappApiUrl =
      'YOUR_WHATSAPP_API_URL'; // Replace with actual URL
  static const String _whatsappToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJpeGIwZzVHa1dGTTNvd3JjR05LZG15MHYwV0tsWkVSVyIsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNzYwMjc1NjAyfQ.DF7jmrjpYxbTiZyUvZ8E2d8mqyLzPmeyS-YrQje0psQ';
  static const String _fromNumber = '963942385589';

  WhatsAppService({required this.dio});

  /// Sends OTP code to the specified phone number via WhatsApp
  ///
  /// [phoneNumber] - The recipient's phone number (including country code)
  /// [otpCode] - The OTP code to send
  ///
  /// Returns true if message sent successfully
  Future<bool> sendOtpMessage({
    required String phoneNumber,
    required String otpCode,
  }) async {
    try {

      final requestData = {
        'messageType': 'text',
        'requestType': 'POST',
        'token': _whatsappToken,
        'from': _fromNumber,
        'to': phoneNumber,
        'text': 'Your Ahlan Feekum verification code is: $otpCode',
      };


      final response = await dio.post(
        _whatsappApiUrl,
        data: requestData,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );


      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException('WhatsApp API connection error');
      } else if (e.response != null) {
        final errorMessage =
            e.response?.data?['message'] ?? 'Failed to send WhatsApp message';
        throw ServerException(errorMessage, e.response?.statusCode);
      } else {
        throw const ServerException('Unknown WhatsApp API error');
      }
    } catch (e) {
      throw ServerException('Unexpected WhatsApp error: $e');
    }
  }
}
