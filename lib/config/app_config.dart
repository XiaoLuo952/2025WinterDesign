class AppConfig {
  // 只保留开发环境和生产环境
  static const String devBaseUrl =
      'http://10.0.2.2:11897'; // Android 模拟器访问本机的特殊 IP
  static const String prodBaseUrl = 'https://your-prod-server.com';

  // 使用开发环境
  static const String baseUrl = devBaseUrl; // 使用 10.0.2.2
}
