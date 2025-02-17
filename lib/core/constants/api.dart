// ignore_for_file: unnecessary_string_interpolations

class ApiConstant {
  // ! GENERAL
  static const String applicationJson = 'application/json';
  static const String multipartFormData = 'multipart/form-data';
  static const String search = '/search';
  // ! URL
  static const String baseUrl =
      'https://familiar-tomasina-happiness-overload-148b3187.koyeb.app/api/v1';
  // ! PATH

  // ! USER
  static const String userCarsPath = "/user-cars";

  // ! SUPER ADMIN
  // ! CAR
  // * brands
  static const String brandsPath = "/car-brands";
  static const String multipleBrandsPath = "$brandsPath/multiple";
  // * models
  static const String modelsPath = "/car-models";
  static const String multipleModelsPath = "$modelsPath/multiple";
  // * services
  static const String servicesPath = "/car-services";
  static const String multipleServicesPath = "$servicesPath/multiple";
  // * workshops
  static const String workshopsPath = "/workshops";
  // * colors
  static const String colorsPath = "/colors";
  // * model years
  static const String carModelYearsPath = "/car-model-years";
  // * model year colors
  static const String carModelYearColorsPath = "/car-model-year-colors";
  // * AUTH
  static const String authPath = "/auth";
  static const String registerPath = "$authPath/register";
  static const String loginPath = "$authPath/login";
  // * PROFILE
  static const String profilePath = "/profile";
  static const String comparePath = "$profilePath/compare";
  // * CARS
  static const String carsPath = "/cars";
  // ! financial
  // * payment methods
  static const String paymentMethodPath = "/payment-methods";
  // * orders
  static const String ordersPath = "/orders";
  static const String ordersCancel = "$ordersPath/cancel";
  static const String ordersUpdate = "$ordersPath";
  static const String ordersUserPath = "$ordersPath/user";
  static const String ordersUserCancelPath = "$ordersPath/user/cancel";
  // * transactions
  static const String transactionsPath = "/transactions";
  static const String transactionsUserPath = "$transactionsPath/user";
  // * eTicket
  static const String eTicketPath = "/e-tickets";
  // * history
  static const String historyPath = "/histories";

  // ! key
  static const String logoKey = 'logo';

  // ! error
  static const String noInternetConnection = 'No internet connection';
  static const String invalidFormatRes = 'Invalid format response';
  static const String requestTimeout = 'Request timeout';
  static const String socketException =
      "Cannot connect to the server. Please check your internet connection.";
  static const String clientException =
      "There was a problem connecting to the server. Please try again later.";
  static const String httpException =
      "There was a problem with the HTTP connection. Please try again later.";
  static const String formatException =
      "The data received is invalid. Please try again.";
  static const String handshakeException =
      "There was a security (SSL) issue connecting to the server. Please try again later.";
  static const String cancelTokenException = "Request has been cancelled.";
  static const String unknownError = "An error occurred. Please try again.";

  // ! query params
  static const int limit = 10;
}
