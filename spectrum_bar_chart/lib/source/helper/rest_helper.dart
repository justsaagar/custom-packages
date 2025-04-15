import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spectrum_bar_chart/source/ui/app_toast.dart';

class RestHelper {
  RestHelper._privateConstructor();

  static final RestHelper instance = RestHelper._privateConstructor();

  Map<String, String> headers = {'accept': 'application/json','Content-Type' : 'application/json'};

  void showRequestLogs(path, Map<String, Object> requestData, String method) {
    debugLogs('•••••••••• Network debugLogs ••••••••••');
    debugLogs('Request $method --> $path');
    debugLogs('Request headers --> $requestData');
    debugLogs('••••••••••••••••••••••••••••••••••');
  }
  void showRequestAndResponseDebugLogs(http.Response? response, Map<String, Object> requestData) {
    debugLogs('•••••••••• Network debugLogs ••••••••••');
    debugLogs('Request code --> ${response!.statusCode} : ${response.request!.url}');
    debugLogs('Request headers --> $requestData');
    debugLogs('Response headers --> ${response.headers}');
    debugLogs('Response body --> ${response.body}');
    debugLogs('••••••••••••••••••••••••••••••••••');
  }


  Future<http.Response?> getRestCallWithResponse({
    required String url,
    Map<String, String>? customHeaders,
    required BuildContext context,
  }) async {
    http.Response? responseData;
    try {
      Uri? requestedUri = Uri.tryParse(url);
      if (requestedUri == null) {
        debugLogs('Invalid URL: $url');
        return null;
      }

      final requestHeaders = customHeaders != null ? {...headers, ...customHeaders} : headers;

      showRequestLogs(url, requestHeaders, 'GET');
      http.Response response = await http.get(
        requestedUri,
        headers: requestHeaders,
      );

      showRequestAndResponseDebugLogs(response, requestHeaders);

      switch (response.statusCode) {
        case 200:
        case 201:
        case 400:
        case 422:
          responseData = response;
          break;
        case 401:
          debugLogs('Unauthorized request (401): ${response.body}');
          if (context.mounted) 'Unauthorized request'.showError(context);
          break;
        case 404:
        case 500:
        case 502:
          debugLogs('Error status code: ${response.statusCode}');
          break;
        case 409:
          debugLogs('Conflict error (409): ${response.body}');
          if (context.mounted) jsonDecode(response.body)['error'].toString().showError(context);
          break;
        default:
          debugLogs('Unexpected status code: ${response.statusCode} : ${response.body}');
          break;
      }
    } catch (e) {
      debugLogs('Exception in getRestCallWithResponse: $e');
      if (context.mounted) 'Error in getRestCallWithResponse'.showError(context);
    }
    return responseData;
  }

  Future<http.Response?> postRestCallWithResponse({
    required String url, // Direct URL instead of endpoint + AppConfig
    required Map<String, dynamic>? body,
    required BuildContext context,
    Map<String, String>? customHeaders,
  }) async {
    http.Response? responseData;

    try {
      Uri? requestedUri = Uri.tryParse(url);
      if (requestedUri == null) {
        debugLogs('Invalid URL: $url');
        return null;
      }

      final requestHeaders = customHeaders != null ? {...headers, ...customHeaders} : headers;
      requestHeaders['Content-Type'] = 'application/json';

      debugLogs('Body map --> $body');
      showRequestLogs(url, requestHeaders, 'POST');
      http.Response response = await http.post(
        requestedUri,
        body: jsonEncode(body),
        headers: requestHeaders,
      );
      showRequestAndResponseDebugLogs(response, requestHeaders);

      switch (response.statusCode) {
        case 200:
        case 201:
        case 400:
        case 500:
        case 502:
          responseData = response;
          break;
        case 401:
          debugLogs('Unauthorized request (401): ${response.body}');
          if (context.mounted) 'Unauthorized request'.showError(context);
          break;
        case 403:
          debugLogs('Forbidden request (403): ${response.body}');
          break;
        case 404:
          debugLogs('Not found (404): ${response.body}');
          break;
        case 409:
          debugLogs('Conflict error (409): ${response.body}');
          if (context.mounted) 'Conflict error'.showError(context);
          break;
        default:
          debugLogs('Unexpected status code: ${response.statusCode} : ${response.body}');
          break;
      }
    } catch (e) {
      debugLogs('Exception in postRestCallWithResponse: $e');
      if (context.mounted) 'Error in postRestCallWithResponse'.showError(context);
    }
    return responseData;
  }
}

  // apiHealthCheck(context, var responseData) async {
  //   debugLogs("apiHealthCheck ->");
  //   debugLogs(AppConfig.shared.apiHealthCheckStream.value);
  //   if(responseData==null){
  //     DashboardController dashboardController = Get.put(DashboardController());
  //     await dashboardController.checkHealth(context);
  //     debugLogs("apiHealthCheck after checkHealth->");
  //     debugLogs(AppConfig.shared.apiHealthCheckStream.value);
  //   }else{
  //     AppConfig.shared.apiHealthCheckStream.sink.add(true);
  //   }
  // }
  //
  // Future<void> addAuthorizationToken() async {
  //   if(!AppConfig.shared.isQLCentral){
  //     String? accessToken = await getPrefStringValue(AppSharedPreference.accessToken) ?? '';
  //     if (accessToken.isNotEmpty) headers['Authorization'] =  'Bearer $accessToken';
  //   }
  // }
  //
  // Future<dynamic> handleTokenExpired({
  //   required bool isRetry,
  //   required Future<dynamic>? Function() apiCallFunction,
  //   required String responseData,
  // }) async {
  //   Map<String, dynamic> jsonData = jsonDecode(responseData);
  //
  //   if (jsonData["error"] == "TokenExpired" && !isRetry) {
  //     if (!isRetry) {
  //       bool tokenRefreshed = await refreshToken();
  //       if (tokenRefreshed) {
  //         return await apiCallFunction(); // Retry API call
  //       }
  //     }
  //   } else {
  //     // If token refresh fails, remove token and redirect to sign-in
  //     debugLogs("handleTokenExpired-->${jsonData["error"]}");
  //     await removeAT();
  //     goToSignInPage();
  //   }
  //   return null;
  // }
  //
  // Future<bool> refreshToken() async {
  //   try {
  //     String requestUrl = '${AppConfig.shared.baseUrl}/${RestConstants.instance.authKey}/${RestConstants.instance.refreshKey}';
  //     Uri? requestedUri = Uri.tryParse(requestUrl);
  //     String? refreshTokenId = await getPrefStringValue(AppSharedPreference.refreshTokenId) ?? '';
  //     if (refreshTokenId.isEmpty) {
  //       debugLogs('No refresh token available');
  //       await removeAT();
  //       goToSignInPage(); // Redirect if no refresh token is found
  //       return false;
  //     }
  //     showRequestLogs(requestUrl, headers, 'POST');
  //     http.Response response = await http.post(
  //       requestedUri!,
  //       body: jsonEncode({"refresh_token": refreshTokenId}),
  //       headers: headers,
  //     );
  //     Map<String, dynamic> jsonResponse = json.decode(response.body);
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       AuthResponse authResponse = AuthResponse.fromJson(jsonResponse);
  //       await removeAT();
  //       await setPrefStringValue(AppSharedPreference.accessToken, authResponse.accessToken ?? "");
  //       await setPrefStringValue(AppSharedPreference.refreshTokenId, authResponse.refreshToken ?? "");
  //       debugLogs('Token refreshed successfully');
  //       return true;
  //     } else {
  //       String errorMessage = jsonResponse['detail'] ?? 'Token refresh failed';
  //       debugLogs('Token refresh error: $errorMessage');
  //       await removeAT();
  //       goToSignInPage();
  //       return false;
  //     }
  //   }  catch (e) {
  //     debugLogs('Exception in refreshToken: ${e.toString()}');
  //     await removeAT();
  //     goToSignInPage();
  //     return false;
  //   }
  // }
  //
  //
  // Future<void> removeAT() async {
  //   await removePrefValue(AppSharedPreference.accessToken);
  //   await removePrefValue(AppSharedPreference.refreshTokenId);
  // }


debugLogs(r){
  debugPrint("$r");
}