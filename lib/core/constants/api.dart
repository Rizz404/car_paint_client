class ApiConstant {
  // ! GENERAL
  static const String applicationJson = 'application/json';
  static const String multipartFormData = 'multipart/form-data';
  static const String search = '/search';
  // ! URL
  static const String baseUrl =
      'https://familiar-tomasina-happiness-overload-148b3187.koyeb.app/api/v1';
  // ! PATH
  static const String brandsPath = "/car-brands";
  static const String multipleBrandsPath = "/brands/multiple";
  static const String workshopsPath = "/workshops";
  static const String authPath = "/auth";
  static const String registerPath = "$authPath/register";
  static const String loginPath = "$authPath/login";
  static const String profilePath = "/profile";
  static const String comparePath = "$profilePath/compare";
  static const String carsPath = "/cars";

  static const String noInternetConnection = 'No internet connection';
  static const String unknownError = 'Unknown error';
  static const String logoKey = 'logo';
}
