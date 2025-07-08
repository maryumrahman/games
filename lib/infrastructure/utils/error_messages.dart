class ErrorMessages {
  final String _internalServerException =
      "An error occurred while communicating with the server. Please try again later or contact support if the issue persists.";
  final String _notFoundException =
      "The requested resource could not be found on the server. Please check the URL or contact support for assistance.";
  final String _noInternetException =
      "It appears that you are not connected to the internet. Please check your network settings and try again.";
  final String _timeOutException =
      "Your internet connection is unstable, resulting in a timeout. Please check your connection and try again.";
  final String _badRequestException =
      "The server could not understand the request due to invalid syntax. Please verify your input and try again.";
  final String _unauthorizedException =
      "You are not authorized to access this resource. Please check your credentials and try again.";
  final String _forbiddenException =
      "You do not have permission to access this resource. Please contact support if you believe this is an error.";
  final String _requestTimeoutException =
      "The server timed out waiting for the request. Please check your internet connection and try again.";
  final String _badGatewayException =
      "The server received an invalid response from the upstream server. Please try again later.";
  final String _serviceUnavailableException =
      "The server is currently unavailable. Please try again later.";
  final String _gatewayTimeoutException =
      "The server did not receive a timely response from the upstream server. Please check your internet connection and try again.";
  final String _httpException =
      "A general HTTP error occurred. Please try again.";
  final String _formatException =
      "The response format is invalid. Please contact support if the issue persists.";
  final String _generalException =
      "Something went wrong. Please try again later.";

  String get generalException => _generalException;

  String get internalServerException => _internalServerException;

  String get notFoundException => _notFoundException;

  String get noInternetException => _noInternetException;

  String get timeOutException => _timeOutException;

  String get gatewayTimeoutException => _gatewayTimeoutException;

  String get serviceUnavailableException => _serviceUnavailableException;

  String get badGatewayException => _badGatewayException;

  String get requestTimeoutException => _requestTimeoutException;

  String get forbiddenException => _forbiddenException;

  String get unauthorizedException => _unauthorizedException;

  String get badRequestException => _badRequestException;

  String get formatException => _formatException;

  String get httpException => _httpException;

  bool isErrorMessage(String e) {
    return [
      _internalServerException,
      _notFoundException,
      _noInternetException,
      _timeOutException,
      _badRequestException,
      _unauthorizedException,
      _forbiddenException,
      _requestTimeoutException,
      _badGatewayException,
      _serviceUnavailableException,
      _gatewayTimeoutException,
      _httpException,
      _formatException,
      _generalException,
    ].contains(e);
  }
}
