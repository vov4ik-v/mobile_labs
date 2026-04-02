class ApiConfig {
  const ApiConfig._();

  static const String baseUrl = 'http://10.0.2.2:5050/api';

  static const String loginPath = '/auth/login';
  static const String registerPath = '/auth/register';
  static const String userPath = '/auth/user';
  static const String roomsPath = '/rooms';
}
