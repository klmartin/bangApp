class AppConfig {
  final String appleEmail;
  final String applePassword;

  AppConfig({required this.appleEmail, required this.applePassword});

  // Singleton instance
  static final AppConfig _instance = AppConfig(
    appleEmail: 'martinkaboja@gmail.com',
    applePassword: 'CallC1005',
  );

  factory AppConfig.instance() => _instance;
}
