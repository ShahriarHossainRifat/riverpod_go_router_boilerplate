/// Environment configuration for the app.
///
/// Configure different settings for `dev`, `staging`, and `prod`. Values can
/// be provided at compile-time through `--dart-define` or at runtime via
/// `EnvConfig.initialize` for development/testing.
///
/// Example (compile-time):
/// ```bash
/// flutter build apk \
///   --dart-define=ENV=prod \
///   --dart-define=BASE_URL=https://api.myapp.com \
///   --dart-define=API_KEY=your_secret_key
/// ```
enum Environment {
  /// Development environment. Uses development backend and mocks by default.
  dev,

  /// Staging environment. Useful for pre-release testing against staging APIs.
  staging,

  /// Production environment. Use when building release artifacts.
  prod,
}

/// Runtime environment configuration.
///
/// Supports compile-time variables via `--dart-define` for secure production builds,
/// with fallback to runtime configuration for development flexibility.
///
/// **Priority:** Compile-time values (`--dart-define`) take precedence over runtime values.
class EnvConfig {
  /// Private constructor to prevent instantiation.
  new _();

  // Compile-time constants sourced from `--dart-define`.
  static const String _dartDefineEnv = String.fromEnvironment('ENV');
  static const String _dartDefineBaseUrl = String.fromEnvironment('BASE_URL');
  static const String _dartDefineApiKey = String.fromEnvironment('API_KEY');
  static const String _dartDefineMocksStr = String.fromEnvironment('USE_MOCKS');
  static const bool _dartDefineEnableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );
  static const bool _dartDefineUseMocks = bool.fromEnvironment(
    'USE_MOCKS',
    defaultValue: true,
  );

  static late final Environment _environment;
  static late final String _baseUrl;
  static late final String _apiKey;
  static late final bool _enableLogging;
  static late final bool _useMockRepositories;

  /// Whether the config has been initialized.
  static bool _isInitialized = false;

  /// Initialize the environment configuration.
  ///
  /// Call this in `main()` before `runApp()` for runtime configuration in
  /// development. When compile-time values are provided via `--dart-define`,
  /// they take precedence and will be used instead of the runtime parameters.
  ///
  /// Parameters:
  /// - `environment`: Runtime environment (dev/staging/prod)
  /// - `useMocks`: Runtime override to enable/disable mocks (null = use default logic)
  ///
  /// Example:
  /// ```dart
  /// void main() {
  ///   EnvConfig.initialize(
  ///     environment: Environment.dev,
  ///     useMocks: false,  // Use real API
  ///   );
  ///   runApp(MyApp());
  /// }
  /// ```
  static void initialize({required Environment environment, bool? useMocks}) {
    if (_isInitialized) return;

    // Use compile-time environment if provided, otherwise use runtime parameter
    _environment = _dartDefineEnv.isNotEmpty
        ? _parseEnvironment(_dartDefineEnv)
        : environment;

    // Use compile-time base URL if provided, otherwise derive from environment
    _baseUrl = _dartDefineBaseUrl.isNotEmpty
        ? _dartDefineBaseUrl
        : _getBaseUrl(_environment);

    // API key from compile-time (empty string if not provided)
    _apiKey = _dartDefineApiKey;

    // Logging: compile-time value, or enabled for non-prod
    _enableLogging = _dartDefineEnv.isNotEmpty
        ? _dartDefineEnableLogging
        : _environment != Environment.prod;

    // Mock repositories: priority order
    // 1. Runtime parameter passed to initialize()
    // 2. Compile-time --dart-define values
    // 3. Default: use mocks for non-prod, real API for prod
    if (useMocks != null) {
      // Explicit runtime override takes precedence
      _useMockRepositories = useMocks;
    } else {
      // Check if USE_MOCKS was explicitly set via --dart-define
      final hasExplicitMocks = _dartDefineMocksStr.isNotEmpty;
      _useMockRepositories = (_dartDefineEnv.isNotEmpty || hasExplicitMocks)
          ? _dartDefineUseMocks
          : _environment != Environment.prod;
    }

    _isInitialized = true;
  }

  /// Parse a string into an [Environment]. Accepts common aliases.
  static Environment _parseEnvironment(String env) {
    return switch (env.toLowerCase()) {
      'prod' || 'production' => Environment.prod,
      'staging' || 'stage' => Environment.staging,
      _ => Environment.dev,
    };
  }

  /// Resolve the default base URL for a given [Environment].
  static String _getBaseUrl(Environment env) {
    return switch (env) {
      Environment.dev => 'https://dev-api.example.com',
      Environment.staging => 'https://staging-api.example.com',
      Environment.prod => 'https://api.example.com',
    };
  }

  /// Current environment. This value is set after calling [initialize].
  static Environment get environment => _environment;

  /// Whether the app is running in development mode.
  static bool get isDev => _environment == Environment.dev;

  /// Whether the app is running in staging mode.
  static bool get isStaging => _environment == Environment.staging;

  /// Whether the app is running in production mode.
  static bool get isProd => _environment == Environment.prod;

  /// Base URL for API calls. Derived from environment or `--dart-define`.
  static String get baseUrl => _baseUrl;

  /// API key for authenticated requests.
  ///
  /// This will be an empty string when not provided via `--dart-define`.
  static String get apiKey => _apiKey;

  /// Whether logging is enabled. Determined by `--dart-define` or enabled
  /// by default for non-production environments.
  static bool get enableLogging => _enableLogging;

  /// Whether to use mock repositories instead of remote ones.
  ///
  /// Defaults to `true` for dev/staging when not overridden by
  /// `--dart-define=USE_MOCKS`.
  static bool get useMockRepositories => _useMockRepositories;
}
