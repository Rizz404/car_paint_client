class ApiConstant {
  // ! GENERAL
  static const String applicationJson = 'application/json';
  static const String multipartFormData = 'multipart/form-data';
  static const String search = '/search';
  // ! URL
  static const String baseUrl =
      'https://familiar-tomasina-happiness-overload-148b3187.koyeb.app/api/v1';
  // ! PATH
  // * brands
  static const String brandsPath = "/car-brands";
  static const String multipleBrandsPath = "$brandsPath/multiple";
  // * models
  static const String modelsPath = "/car-models";
  static const String multipleModelsPath = "$modelsPath/multiple";
  // * workshops
  static const String workshopsPath = "/workshops";
  // * AUTH
  static const String authPath = "/auth";
  static const String registerPath = "$authPath/register";
  static const String loginPath = "$authPath/login";
  // * PROFILE
  static const String profilePath = "/profile";
  static const String comparePath = "$profilePath/compare";
  // * CARS
  static const String carsPath = "/cars";

  // ! key
  static const String logoKey = 'logo';

  // ! error
  static const String noInternetConnection = 'No internet connection';
  static const String unknownError = 'Unknown error';
  static const String invalidFormatRes = 'Invalid format response';
  static const String requestTimeout = 'Request timeout';
}
