import 'dart:io';
import 'package:dio/dio.dart';
import '../constants/phrases_constants.dart';

class ApiError {
  final String text;

  const ApiError(this.text);

  factory ApiError.fromDioError(DioError e) {
    String errorText;
    final DioErrorType errorType = e.type;
    final dynamic error = e.error;

    if (errorType == DioErrorType.DEFAULT) {
      if (error is SocketException) {
        errorText = PhrasesConstants.CONNECTION_DOWN;
      } else {
        errorText = PhrasesConstants.UNKNOWN_ERROR;
      }
    } else if (errorType == DioErrorType.CONNECT_TIMEOUT ||
        errorType == DioErrorType.RECEIVE_TIMEOUT ||
        errorType == DioErrorType.SEND_TIMEOUT)
      errorText = PhrasesConstants.CONNECTION_TIMEOUT;
    else
      errorText = PhrasesConstants.SERVER_ERROR;

    return ApiError(errorText);
  }
}
