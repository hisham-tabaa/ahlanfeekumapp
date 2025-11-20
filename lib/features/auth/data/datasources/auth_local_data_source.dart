import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUserData(UserModel user);
  Future<void> saveTokens(String accessToken, String? refreshToken);
  Future<UserModel?> getUserData();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> setLoggedIn(bool isLoggedIn);
  Future<bool> isLoggedIn();
  Future<void> setGuest(bool isGuest);
  Future<bool> isGuest();
  Future<void> clearUserData();
  Future<bool> hasValidToken();
  Future<void> clearInvalidTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl(this.sharedPreferences, this.secureStorage);

  @override
  Future<void> saveUserData(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await sharedPreferences.setString(AppConstants.userDataKey, userJson);
    } catch (e) {
      throw CacheException('Failed to save user data: $e');
    }
  }

  @override
  Future<void> saveTokens(String accessToken, String? refreshToken) async {
    try {
      // Store tokens in SharedPreferences (used by DioFactory interceptor)
      await sharedPreferences.setString(
        AppConstants.accessTokenKey,
        accessToken,
      );

      if (refreshToken != null) {
        await sharedPreferences.setString(
          AppConstants.refreshTokenKey,
          refreshToken,
        );
      }
    } catch (e) {
      throw CacheException('Failed to save tokens: $e');
    }
  }

  @override
  Future<UserModel?> getUserData() async {
    try {
      final userJson = sharedPreferences.getString(AppConstants.userDataKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get user data: $e');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return sharedPreferences.getString(AppConstants.accessTokenKey);
    } catch (e) {
      throw CacheException('Failed to get access token: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return sharedPreferences.getString(AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException('Failed to get refresh token: $e');
    }
  }

  @override
  Future<void> setLoggedIn(bool isLoggedIn) async {
    try {
      await sharedPreferences.setBool(AppConstants.isLoggedInKey, isLoggedIn);
    } catch (e) {
      throw CacheException('Failed to set login status: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return sharedPreferences.getBool(AppConstants.isLoggedInKey) ?? false;
    } catch (e) {
      throw CacheException('Failed to get login status: $e');
    }
  }

  @override
  Future<void> setGuest(bool isGuest) async {
    try {
      await sharedPreferences.setBool(AppConstants.isGuestKey, isGuest);
    } catch (e) {
      throw CacheException('Failed to set guest status: $e');
    }
  }

  @override
  Future<bool> isGuest() async {
    try {
      return sharedPreferences.getBool(AppConstants.isGuestKey) ?? false;
    } catch (e) {
      throw CacheException('Failed to get guest status: $e');
    }
  }

  @override
  Future<void> clearUserData() async {
    try {
      await sharedPreferences.remove(AppConstants.userDataKey);
      await sharedPreferences.remove(AppConstants.isLoggedInKey);
      await sharedPreferences.remove(AppConstants.isGuestKey);
      await sharedPreferences.remove(AppConstants.accessTokenKey);
      await sharedPreferences.remove(AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException('Failed to clear user data: $e');
    }
  }

  // Helper method to check if current token is valid (not a placeholder)
  @override
  Future<bool> hasValidToken() async {
    try {
      final token = sharedPreferences.getString(AppConstants.accessTokenKey);
      if (token == null || token.isEmpty) {
        return false;
      }

      // Check if it's a placeholder token
      const placeholderTokens = ['otp_verified_token', 'password_reset_token'];

      return !placeholderTokens.contains(token);
    } catch (e) {
      return false;
    }
  }

  // Helper method to clear invalid tokens
  @override
  Future<void> clearInvalidTokens() async {
    try {
      final hasValid = await hasValidToken();
      if (!hasValid) {
        await clearUserData();
      }
    } catch (e) {
    }
  }
}
