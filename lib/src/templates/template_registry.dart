/// Embedded template repository providing production-ready Dart code templates.
class TemplateRegistry {
  TemplateRegistry._();

  // =========================================================================
  // CORE ERROR HANDLING
  // =========================================================================

  static const String coreFailures = '''
abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, [this.statusCode]);

  @override
  String toString() => '\$runtimeType: \$message (code: \$statusCode)';
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred. Please try again later.', super.statusCode]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection. Please verify your network.', super.statusCode]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache retrieval failed.', super.statusCode]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Invalid data submitted.', super.statusCode]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.', super.statusCode]);
}
''';

  static const String coreExceptions = '''
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException([this.message = 'Server exception occurred.', this.statusCode]);

  @override
  String toString() => 'ServerException: \$message (code: \$statusCode)';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'Network connectivity error.']);

  @override
  String toString() => 'NetworkException: \$message';
}

class CacheException implements Exception {
  final String message;

  const CacheException([this.message = 'Cache storage error.']);

  @override
  String toString() => 'CacheException: \$message';
}

class ValidationException implements Exception {
  final String message;

  const ValidationException([this.message = 'Validation constraint violated.']);

  @override
  String toString() => 'ValidationException: \$message';
}
''';

  static const String coreResult = '''
import '../error/failures.dart';

sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(Failure failure) = FailureResult<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  T? get dataOrNull => isSuccess ? (this as Success<T>).data : null;
  Failure? get failureOrNull => isFailure ? (this as FailureResult<T>).failure : null;

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else {
      return failure((this as FailureResult<T>).failure);
    }
  }
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class FailureResult<T> extends Result<T> {
  final Failure failure;
  const FailureResult(this.failure);
}
''';

  // =========================================================================
  // CORE CONSTANTS & UTILS
  // =========================================================================

  static const String coreConstants = '''
class AppConstants {
  AppConstants._();

  static const String appName = '{{app_title}}';
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String themeModeKey = 'app_theme_mode';
  static const String localeKey = 'app_locale';
}
''';

  static const String coreContextExtensions = '''
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.sizeOf(this);
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
''';

  // =========================================================================
  // CORE NETWORK (DIO)
  // =========================================================================

  static const String networkApiEndpoints = '''
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.example.com/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/profile';
}
''';

  static const String networkInfo = '''
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // In production, integrate with connectivity_plus or internet_connection_checker
    return true;
  }
}
''';

  static const String networkErrorInterceptor = '''
import 'package:dio/dio.dart';
import '../../error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        throw const NetworkException('Connection timed out. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final message = err.response?.data is Map && (err.response?.data as Map).containsKey('message')
            ? err.response?.data['message'].toString()
            : 'Server responded with status code \$statusCode';
        throw ServerException(message ?? 'Server error', statusCode);
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.badCertificate:
        throw const ServerException('Invalid SSL certificate.');
      case DioExceptionType.unknown:
      default:
        throw NetworkException(err.message ?? 'Unknown network error.');
    }
    super.onError(err, handler);
  }
}
''';

  static const String networkLoggingInterceptor = '''
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('--> \${options.method.toUpperCase()} \${options.uri}');
      if (options.headers.isNotEmpty) {
        debugPrint('Headers: \${options.headers}');
      }
      if (options.data != null) {
        debugPrint('Body: \${options.data}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('<-- \${response.statusCode} \${response.requestOptions.uri}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('<-- ERROR [\${err.response?.statusCode}] \${err.requestOptions.uri}: \${err.message}');
    }
    super.onError(err, handler);
  }
}
''';

  static const String networkDioClient = '''
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import 'api_endpoints.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class DioClient {
  final Dio _dio;

  DioClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiEndpoints.baseUrl,
                connectTimeout: AppConstants.connectTimeout,
                receiveTimeout: AppConstants.receiveTimeout,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    _dio.interceptors.addAll([
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer \$token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get<T>(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.patch<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete<T>(path, data: data, queryParameters: queryParameters, options: options);
  }
}
''';

  // =========================================================================
  // CORE THEME (MATERIAL 3)
  // =========================================================================

  static const String themeAppColors = '''
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary = Color(0xFF0F62FE);
  static const Color primaryDark = Color(0xFF0043CE);
  static const Color primaryLight = Color(0xFF4589FF);

  // Secondary palette
  static const Color secondary = Color(0xFF007D79);
  static const Color secondaryLight = Color(0xFF009D9A);

  // Neutral tones
  static const Color backgroundLight = Color(0xFFF4F7FB);
  static const Color backgroundDark = Color(0xFF12161A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E232A);

  // Status colors
  static const Color success = Color(0xFF24A148);
  static const Color warning = Color(0xFFF1C21B);
  static const Color error = Color(0xFFDA1E28);
  static const Color info = Color(0xFF0043CE);
}
''';

  static const String themeAppTextStyles = '''
import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}
''';

  static const String themeAppThemeMode = '''
enum AppThemeMode {
  light,
  dark,
  system,
}
''';

  static const String themeAppTheme = '''
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: Color(0xFF161616),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.surfaceLight,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        titleLarge: AppTextStyles.titleLarge,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.surfaceDark,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        titleLarge: AppTextStyles.titleLarge,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
      ),
    );
  }
}
''';

  // =========================================================================
  // CORE ROUTING & WIDGETS
  // =========================================================================

  static const String coreRouter = '''
import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();

  static const String initialRoute = '/';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Welcome to Flutter Architect')),
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for \${settings.name}')),
          ),
          settings: settings,
        );
    }
  }
}
''';

  static const String coreErrorView = '''
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
''';

  static const String coreLoadingIndicator = '''
import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatelessWidget {
  final String? message;

  const AppLoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
''';

  // =========================================================================
  // DEPENDENCY INJECTION (GET_IT)
  // =========================================================================

  static const String injectionContainer = '''
import 'package:get_it/get_it.dart';
import 'package:{{package_name}}/core/network/dio_client.dart';
import 'package:{{package_name}}/core/network/network_info.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Features registration will be appended here
}
''';

  // =========================================================================
  // MAIN.DART
  // =========================================================================

  static const String mainDart = '''
import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'injection/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '{{app_title}}',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.initialRoute,
    );
  }
}
''';

  static const String coreWidgetTest = '''
import 'package:flutter_test/flutter_test.dart';
import 'package:{{package_name}}/main.dart';

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Welcome to Flutter Architect'), findsOneWidget);
  });
}
''';

  // =========================================================================
  // FEATURE CLEAN ARCHITECTURE TEMPLATES
  // =========================================================================

  static const String featureModel = '''
class {{feature_pascal}}Model {
  final String id;
  final String title;
  final DateTime createdAt;

  const {{feature_pascal}}Model({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  factory {{feature_pascal}}Model.fromJson(Map<String, dynamic> json) {
    return {{feature_pascal}}Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
    };
  }

  {{feature_pascal}}Model copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
  }) {
    return {{feature_pascal}}Model(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is {{feature_pascal}}Model &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}
''';

  static const String featureRemoteDatasource = '''
import 'package:{{package_name}}/core/error/exceptions.dart';
import 'package:{{package_name}}/core/network/dio_client.dart';
import '../models/{{feature_name}}_model.dart';

abstract class {{feature_pascal}}RemoteDataSource {
  Future<{{feature_pascal}}Model> get{{feature_pascal}}(String id);
}

class {{feature_pascal}}RemoteDataSourceImpl implements {{feature_pascal}}RemoteDataSource {
  final DioClient client;

  {{feature_pascal}}RemoteDataSourceImpl({required this.client});

  @override
  Future<{{feature_pascal}}Model> get{{feature_pascal}}(String id) async {
    try {
      final response = await client.get('/{{feature_name}}/\$id');
      if (response.statusCode == 200 && response.data != null) {
        return {{feature_pascal}}Model.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException('Failed to load {{feature_name}}', response.statusCode);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
''';

  static const String featureLocalDatasource = '''
import 'package:{{package_name}}/core/error/exceptions.dart';
import '../models/{{feature_name}}_model.dart';

abstract class {{feature_pascal}}LocalDataSource {
  Future<{{feature_pascal}}Model?> getLast{{feature_pascal}}();
  Future<void> cache{{feature_pascal}}({{feature_pascal}}Model item);
}

class {{feature_pascal}}LocalDataSourceImpl implements {{feature_pascal}}LocalDataSource {
  {{feature_pascal}}Model? _cached;

  @override
  Future<{{feature_pascal}}Model?> getLast{{feature_pascal}}() async {
    try {
      return _cached;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> cache{{feature_pascal}}({{feature_pascal}}Model item) async {
    try {
      _cached = item;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
''';

  static const String featureRepository = '''
import 'package:{{package_name}}/core/utils/result.dart';
import '../../data/models/{{feature_name}}_model.dart';

abstract class {{feature_pascal}}Repository {
  Future<Result<{{feature_pascal}}Model>> get{{feature_pascal}}(String id);
}
''';

  static const String featureRepositoryImpl = '''
import 'package:{{package_name}}/core/error/exceptions.dart';
import 'package:{{package_name}}/core/error/failures.dart';
import 'package:{{package_name}}/core/network/network_info.dart';
import 'package:{{package_name}}/core/utils/result.dart';
import '../../domain/repositories/{{feature_name}}_repository.dart';
import '../datasources/{{feature_name}}_local_datasource.dart';
import '../datasources/{{feature_name}}_remote_datasource.dart';
import '../models/{{feature_name}}_model.dart';

class {{feature_pascal}}RepositoryImpl implements {{feature_pascal}}Repository {
  final {{feature_pascal}}RemoteDataSource remoteDataSource;
  final {{feature_pascal}}LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  {{feature_pascal}}RepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<{{feature_pascal}}Model>> get{{feature_pascal}}(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.get{{feature_pascal}}(id);
        await localDataSource.cache{{feature_pascal}}(remoteData);
        return Result.success(remoteData);
      } on ServerException catch (e) {
        return Result.failure(ServerFailure(e.message, e.statusCode));
      } on NetworkException catch (e) {
        return Result.failure(NetworkFailure(e.message));
      } catch (e) {
        return Result.failure(UnknownFailure(e.toString()));
      }
    } else {
      try {
        final localData = await localDataSource.getLast{{feature_pascal}}();
        if (localData != null) {
          return Result.success(localData);
        }
        return Result.failure(const CacheFailure('No cached data available'));
      } on CacheException catch (e) {
        return Result.failure(CacheFailure(e.message));
      }
    }
  }
}
''';

  static const String featureUseCase = '''
import 'package:{{package_name}}/core/utils/result.dart';
import '../../data/models/{{feature_name}}_model.dart';
import '../repositories/{{feature_name}}_repository.dart';

class Get{{feature_pascal}}UseCase {
  final {{feature_pascal}}Repository repository;

  Get{{feature_pascal}}UseCase({required this.repository});

  Future<Result<{{feature_pascal}}Model>> call(String id) async {
    return repository.get{{feature_pascal}}(id);
  }
}
''';

  static const String featureBlocEvent = '''
abstract class {{feature_pascal}}Event {
  const {{feature_pascal}}Event();
}

class Load{{feature_pascal}}Event extends {{feature_pascal}}Event {
  final String id;
  const Load{{feature_pascal}}Event(this.id);
}

class Refresh{{feature_pascal}}Event extends {{feature_pascal}}Event {
  final String id;
  const Refresh{{feature_pascal}}Event(this.id);
}
''';

  static const String featureBlocState = '''
import '../../data/models/{{feature_name}}_model.dart';

sealed class {{feature_pascal}}State {
  const {{feature_pascal}}State();
}

class {{feature_pascal}}Initial extends {{feature_pascal}}State {
  const {{feature_pascal}}Initial();
}

class {{feature_pascal}}Loading extends {{feature_pascal}}State {
  const {{feature_pascal}}Loading();
}

class {{feature_pascal}}Loaded extends {{feature_pascal}}State {
  final {{feature_pascal}}Model data;
  const {{feature_pascal}}Loaded(this.data);
}

class {{feature_pascal}}Error extends {{feature_pascal}}State {
  final String message;
  const {{feature_pascal}}Error(this.message);
}
''';

  static const String featureBloc = '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_{{feature_name}}_usecase.dart';
import '{{feature_name}}_event.dart';
import '{{feature_name}}_state.dart';

class {{feature_pascal}}Bloc extends Bloc<{{feature_pascal}}Event, {{feature_pascal}}State> {
  final Get{{feature_pascal}}UseCase get{{feature_pascal}}UseCase;

  {{feature_pascal}}Bloc({
    required this.get{{feature_pascal}}UseCase,
  }) : super(const {{feature_pascal}}Initial()) {
    on<Load{{feature_pascal}}Event>(_onLoad{{feature_pascal}});
    on<Refresh{{feature_pascal}}Event>(_onRefresh{{feature_pascal}});
  }

  Future<void> _onLoad{{feature_pascal}}(
    Load{{feature_pascal}}Event event,
    Emitter<{{feature_pascal}}State> emit,
  ) async {
    emit(const {{feature_pascal}}Loading());
    final result = await get{{feature_pascal}}UseCase(event.id);
    result.when(
      success: (data) => emit({{feature_pascal}}Loaded(data)),
      failure: (failure) => emit({{feature_pascal}}Error(failure.message)),
    );
  }

  Future<void> _onRefresh{{feature_pascal}}(
    Refresh{{feature_pascal}}Event event,
    Emitter<{{feature_pascal}}State> emit,
  ) async {
    final result = await get{{feature_pascal}}UseCase(event.id);
    result.when(
      success: (data) => emit({{feature_pascal}}Loaded(data)),
      failure: (failure) => emit({{feature_pascal}}Error(failure.message)),
    );
  }
}
''';

  static const String featureCubit = '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_{{feature_name}}_usecase.dart';
import '{{feature_name}}_state.dart';

class {{feature_pascal}}Cubit extends Cubit<{{feature_pascal}}State> {
  final Get{{feature_pascal}}UseCase get{{feature_pascal}}UseCase;

  {{feature_pascal}}Cubit({
    required this.get{{feature_pascal}}UseCase,
  }) : super(const {{feature_pascal}}Initial());

  Future<void> load{{feature_pascal}}(String id) async {
    emit(const {{feature_pascal}}Loading());
    final result = await get{{feature_pascal}}UseCase(id);
    result.when(
      success: (data) => emit({{feature_pascal}}Loaded(data)),
      failure: (failure) => emit({{feature_pascal}}Error(failure.message)),
    );
  }
}
''';

  static const String featurePage = '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{package_name}}/core/extensions/context_extensions.dart';
import 'package:{{package_name}}/core/widgets/error_view.dart';
import 'package:{{package_name}}/core/widgets/loading_indicator.dart';
import '../bloc/{{feature_name}}_bloc.dart';
import '../bloc/{{feature_name}}_state.dart';
import '../widgets/{{feature_name}}_item_view.dart';

class {{feature_pascal}}Page extends StatelessWidget {
  const {{feature_pascal}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{feature_title}}'),
      ),
      body: BlocConsumer<{{feature_pascal}}Bloc, {{feature_pascal}}State>(
        listener: (context, state) {
          if (state is {{feature_pascal}}Error) {
            context.showSnackBar(state.message, isError: true);
          }
        },
        builder: (context, state) {
          if (state is {{feature_pascal}}Loading) {
            return const AppLoadingIndicator(message: 'Loading {{feature_title}}...');
          }
          if (state is {{feature_pascal}}Loaded) {
            return {{feature_pascal}}ItemView(data: state.data);
          }
          if (state is {{feature_pascal}}Error) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                // context.read<{{feature_pascal}}Bloc>().add(const Load{{feature_pascal}}Event('1'));
              },
            );
          }
          return Center(
            child: Text(
              'No {{feature_title}} data loaded',
              style: context.textTheme.bodyMedium,
            ),
          );
        },
      ),
    );
  }
}
''';

  static const String featureWidget = '''
import 'package:flutter/material.dart';
import 'package:{{package_name}}/core/extensions/context_extensions.dart';
import '../../data/models/{{feature_name}}_model.dart';

class {{feature_pascal}}ItemView extends StatelessWidget {
  final {{feature_pascal}}Model data;

  const {{feature_pascal}}ItemView({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data.title,
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'ID: \${data.id}',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
''';

  // =========================================================================
  // STANDALONE ARCHITECTURE TEMPLATES (WHEN NOT IN A SPECIFIC FEATURE)
  // =========================================================================

  static const String standaloneBlocEvent = '''
abstract class {{name_pascal}}Event {
  const {{name_pascal}}Event();
}

class Load{{name_pascal}}Event extends {{name_pascal}}Event {
  const Load{{name_pascal}}Event();
}
''';

  static const String standaloneBlocState = '''
sealed class {{name_pascal}}State {
  const {{name_pascal}}State();
}

class {{name_pascal}}Initial extends {{name_pascal}}State {
  const {{name_pascal}}Initial();
}

class {{name_pascal}}Loading extends {{name_pascal}}State {
  const {{name_pascal}}Loading();
}

class {{name_pascal}}Loaded extends {{name_pascal}}State {
  const {{name_pascal}}Loaded();
}

class {{name_pascal}}Error extends {{name_pascal}}State {
  final String message;
  const {{name_pascal}}Error(this.message);
}
''';

  static const String standaloneBloc = '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '{{name}}_event.dart';
import '{{name}}_state.dart';

class {{name_pascal}}Bloc extends Bloc<{{name_pascal}}Event, {{name_pascal}}State> {
  {{name_pascal}}Bloc() : super(const {{name_pascal}}Initial()) {
    on<Load{{name_pascal}}Event>(_onLoad{{name_pascal}});
  }

  Future<void> _onLoad{{name_pascal}}(
    Load{{name_pascal}}Event event,
    Emitter<{{name_pascal}}State> emit,
  ) async {
    emit(const {{name_pascal}}Loading());
    // Generated implementation
    emit(const {{name_pascal}}Loaded());
  }
}
''';

  static const String standaloneCubit = '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '{{name}}_state.dart';

class {{name_pascal}}Cubit extends Cubit<{{name_pascal}}State> {
  {{name_pascal}}Cubit() : super(const {{name_pascal}}Initial());

  Future<void> load() async {
    emit(const {{name_pascal}}Loading());
    // Generated implementation
    emit(const {{name_pascal}}Loaded());
  }
}
''';

  static const String standaloneUseCase = '''
import 'package:{{package_name}}/core/utils/result.dart';

class Get{{name_pascal}}UseCase {
  Get{{name_pascal}}UseCase();

  Future<Result<String>> call(String id) async {
    return Result.success('{{name_title}} success');
  }
}
''';

  static const String standaloneRepository = '''
import 'package:{{package_name}}/core/utils/result.dart';
import '../../data/models/{{name}}_model.dart';

abstract class {{name_pascal}}Repository {
  Future<Result<{{name_pascal}}Model>> get{{name_pascal}}(String id);
}
''';

  static const String standaloneRepositoryImpl = '''
import 'package:{{package_name}}/core/error/exceptions.dart';
import 'package:{{package_name}}/core/error/failures.dart';
import 'package:{{package_name}}/core/network/network_info.dart';
import 'package:{{package_name}}/core/utils/result.dart';
import '../../domain/repositories/{{name}}_repository.dart';
import '../datasources/{{name}}_local_datasource.dart';
import '../datasources/{{name}}_remote_datasource.dart';
import '../models/{{name}}_model.dart';

class {{name_pascal}}RepositoryImpl implements {{name_pascal}}Repository {
  final {{name_pascal}}RemoteDataSource remoteDataSource;
  final {{name_pascal}}LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  {{name_pascal}}RepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<{{name_pascal}}Model>> get{{name_pascal}}(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.get{{name_pascal}}(id);
        await localDataSource.cache{{name_pascal}}(remoteData);
        return Result.success(remoteData);
      } on ServerException catch (e) {
        return Result.failure(ServerFailure(e.message, e.statusCode));
      } on NetworkException catch (e) {
        return Result.failure(NetworkFailure(e.message));
      } catch (e) {
        return Result.failure(UnknownFailure(e.toString()));
      }
    } else {
      try {
        final localData = await localDataSource.getLast{{name_pascal}}();
        if (localData != null) {
          return Result.success(localData);
        }
        return Result.failure(const CacheFailure('No cached data available'));
      } on CacheException catch (e) {
        return Result.failure(CacheFailure(e.message));
      }
    }
  }
}
''';

  static const String standaloneDatasourceRemote = '''
import 'package:{{package_name}}/core/error/exceptions.dart';
import 'package:{{package_name}}/core/network/dio_client.dart';
import '../models/{{name}}_model.dart';

abstract class {{name_pascal}}RemoteDataSource {
  Future<{{name_pascal}}Model> get{{name_pascal}}(String id);
}

class {{name_pascal}}RemoteDataSourceImpl implements {{name_pascal}}RemoteDataSource {
  final DioClient client;

  {{name_pascal}}RemoteDataSourceImpl({required this.client});

  @override
  Future<{{name_pascal}}Model> get{{name_pascal}}(String id) async {
    try {
      final response = await client.get('/{{name}}/\$id');
      if (response.statusCode == 200 && response.data != null) {
        return {{name_pascal}}Model.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException('Failed to load {{name}}', response.statusCode);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
''';

  static const String standaloneDatasourceLocal = '''
import 'package:{{package_name}}/core/error/exceptions.dart';
import '../models/{{name}}_model.dart';

abstract class {{name_pascal}}LocalDataSource {
  Future<{{name_pascal}}Model?> getLast{{name_pascal}}();
  Future<void> cache{{name_pascal}}({{name_pascal}}Model item);
}

class {{name_pascal}}LocalDataSourceImpl implements {{name_pascal}}LocalDataSource {
  {{name_pascal}}Model? _cached;

  @override
  Future<{{name_pascal}}Model?> getLast{{name_pascal}}() async {
    try {
      return _cached;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> cache{{name_pascal}}({{name_pascal}}Model item) async {
    try {
      _cached = item;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
''';

  // =========================================================================
  // STANDALONE UI COMPONENTS (PAGE, WIDGET, DIALOG, BOTTOMSHEET)
  // =========================================================================

  static const String standalonePage = '''
import 'package:flutter/material.dart';
import 'package:{{package_name}}/core/extensions/context_extensions.dart';

class {{name_pascal}}Page extends StatelessWidget {
  const {{name_pascal}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{name_title}}'),
      ),
      body: Center(
        child: Text(
          '{{name_title}} Page',
          style: context.textTheme.titleLarge,
        ),
      ),
    );
  }
}
''';

  static const String standaloneWidget = '''
import 'package:flutter/material.dart';
import 'package:{{package_name}}/core/extensions/context_extensions.dart';

class {{name_pascal}}Widget extends StatelessWidget {
  const {{name_pascal}}Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Text(
        '{{name_title}} Widget',
        style: context.textTheme.bodyMedium,
      ),
    );
  }
}
''';

  static const String standaloneDialog = '''
import 'package:flutter/material.dart';
import 'package:{{package_name}}/core/extensions/context_extensions.dart';

class {{name_pascal}}Dialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirm;

  const {{name_pascal}}Dialog({
    super.key,
    this.title = '{{name_title}}',
    this.message = 'Are you sure you want to proceed?',
    this.onConfirm,
  });

  static Future<bool?> show(
    BuildContext context, {
    String? title,
    String? message,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => {{name_pascal}}Dialog(
        title: title ?? '{{name_title}}',
        message: message ?? 'Are you sure you want to proceed?',
        onConfirm: () => Navigator.of(context).pop(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: context.textTheme.titleLarge),
      content: Text(message, style: context.textTheme.bodyMedium),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop(true);
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
''';

  static const String standaloneBottomSheet = '''
import 'package:flutter/material.dart';
import 'package:{{package_name}}/core/extensions/context_extensions.dart';

class {{name_pascal}}BottomSheet extends StatelessWidget {
  const {{name_pascal}}BottomSheet({super.key});

  static Future<T?> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const {{name_pascal}}BottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 8,
        bottom: context.mediaQuery.viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '{{name_title}}',
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Configure your options below.',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}
''';

  // =========================================================================
  // API GENERATOR (DATA SOURCE, MODEL, REPOSITORY, USECASE, BLOC)
  // =========================================================================

  static const String apiResponseModel = '''
class {{name_pascal}}ResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  const {{name_pascal}}ResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory {{name_pascal}}ResponseModel.fromJson(Map<String, dynamic> json) {
    return {{name_pascal}}ResponseModel(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? 'OK',
      data: json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }
}
''';

  static const String apiDatasource = '''
import 'package:{{package_name}}/core/error/exceptions.dart';
import 'package:{{package_name}}/core/network/dio_client.dart';
import '../models/{{name}}_response_model.dart';

abstract class {{name_pascal}}RemoteDataSource {
  Future<{{name_pascal}}ResponseModel> {{name_camel}}({Map<String, dynamic>? data, Map<String, dynamic>? queryParameters});
}

class {{name_pascal}}RemoteDataSourceImpl implements {{name_pascal}}RemoteDataSource {
  final DioClient client;

  {{name_pascal}}RemoteDataSourceImpl({required this.client});

  @override
  Future<{{name_pascal}}ResponseModel> {{name_camel}}({
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.{{method_lower}}(
        '/{{name}}',
        {{#has_body}}data: data,{{/has_body}}
        queryParameters: queryParameters,
      );
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return {{name_pascal}}ResponseModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException('Request failed', response.statusCode);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
''';

  static const String apiRepository = '''
import 'package:{{package_name}}/core/utils/result.dart';
import '../../data/models/{{name}}_response_model.dart';

abstract class {{name_pascal}}Repository {
  Future<Result<{{name_pascal}}ResponseModel>> {{name_camel}}({
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  });
}
''';

  static const String apiRepositoryImpl = '''
import 'package:{{package_name}}/core/error/exceptions.dart';
import 'package:{{package_name}}/core/error/failures.dart';
import 'package:{{package_name}}/core/network/network_info.dart';
import 'package:{{package_name}}/core/utils/result.dart';
import '../../domain/repositories/{{name}}_repository.dart';
import '../datasources/{{name}}_remote_datasource.dart';
import '../models/{{name}}_response_model.dart';

class {{name_pascal}}RepositoryImpl implements {{name_pascal}}Repository {
  final {{name_pascal}}RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  {{name_pascal}}RepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<{{name_pascal}}ResponseModel>> {{name_camel}}({
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.{{name_camel}}(data: data, queryParameters: queryParameters);
        return Result.success(result);
      } on ServerException catch (e) {
        return Result.failure(ServerFailure(e.message, e.statusCode));
      } on NetworkException catch (e) {
        return Result.failure(NetworkFailure(e.message));
      } catch (e) {
        return Result.failure(UnknownFailure(e.toString()));
      }
    } else {
      return Result.failure(const NetworkFailure('No internet connection'));
    }
  }
}
''';

  static const String apiUseCase = '''
import 'package:{{package_name}}/core/utils/result.dart';
import '../../data/models/{{name}}_response_model.dart';
import '../repositories/{{name}}_repository.dart';

class {{name_pascal}}UseCase {
  final {{name_pascal}}Repository repository;

  {{name_pascal}}UseCase({required this.repository});

  Future<Result<{{name_pascal}}ResponseModel>> call({
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return repository.{{name_camel}}(data: data, queryParameters: queryParameters);
  }
}
''';

  static const String apiBlocEvent = '''
abstract class {{name_pascal}}Event {
  const {{name_pascal}}Event();
}

class Submit{{name_pascal}}Event extends {{name_pascal}}Event {
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? queryParameters;

  const Submit{{name_pascal}}Event({this.data, this.queryParameters});
}
''';

  static const String apiBlocState = '''
import '../../data/models/{{name}}_response_model.dart';

sealed class {{name_pascal}}State {
  const {{name_pascal}}State();
}

class {{name_pascal}}Initial extends {{name_pascal}}State {
  const {{name_pascal}}Initial();
}

class {{name_pascal}}Loading extends {{name_pascal}}State {
  const {{name_pascal}}Loading();
}

class {{name_pascal}}Loaded extends {{name_pascal}}State {
  final {{name_pascal}}ResponseModel data;
  const {{name_pascal}}Loaded(this.data);
}

class {{name_pascal}}Error extends {{name_pascal}}State {
  final String message;
  const {{name_pascal}}Error(this.message);
}
''';

  static const String apiBloc = '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/{{name}}_usecase.dart';
import '{{name}}_event.dart';
import '{{name}}_state.dart';

class {{name_pascal}}Bloc extends Bloc<{{name_pascal}}Event, {{name_pascal}}State> {
  final {{name_pascal}}UseCase {{name_camel}}UseCase;

  {{name_pascal}}Bloc({
    required this.{{name_camel}}UseCase,
  }) : super(const {{name_pascal}}Initial()) {
    on<Submit{{name_pascal}}Event>(_onSubmit);
  }

  Future<void> _onSubmit(
    Submit{{name_pascal}}Event event,
    Emitter<{{name_pascal}}State> emit,
  ) async {
    emit(const {{name_pascal}}Loading());
    final result = await {{name_camel}}UseCase(
      data: event.data,
      queryParameters: event.queryParameters,
    );
    result.when(
      success: (data) => emit({{name_pascal}}Loaded(data)),
      failure: (failure) => emit({{name_pascal}}Error(failure.message)),
    );
  }
}
''';

  // =========================================================================
  // ENVIRONMENT CONFIGURATION (.ENV)
  // =========================================================================

  static const String envFile = '''
# Application Environment Variables
# Do NOT commit sensitive production secrets into Git!
API_BASE_URL=https://api.example.com/v1
APP_NAME="{{app_title}}"
ENVIRONMENT=development
ENABLE_LOGGING=true
''';

  static const String envDevFile = '''
API_BASE_URL=https://dev.api.example.com/v1
APP_NAME="{{app_title}} (Dev)"
ENVIRONMENT=development
ENABLE_LOGGING=true
''';

  static const String envStagingFile = '''
API_BASE_URL=https://staging.api.example.com/v1
APP_NAME="{{app_title}} (Staging)"
ENVIRONMENT=staging
ENABLE_LOGGING=true
''';

  static const String envProdFile = '''
API_BASE_URL=https://api.example.com/v1
APP_NAME="{{app_title}}"
ENVIRONMENT=production
ENABLE_LOGGING=false
''';

  static const String envExampleFile = '''
API_BASE_URL=https://api.example.com/v1
APP_NAME="My App"
ENVIRONMENT=development
ENABLE_LOGGING=true
''';

  // =========================================================================
  // FLAVOR CONFIGURATION
  // =========================================================================

  static const String flavorConfig = '''
enum Flavor {
  development,
  staging,
  production,
}

class FlavorConfig {
  final Flavor flavor;
  final String appTitle;
  final String apiBaseUrl;

  static FlavorConfig? _instance;

  FlavorConfig._internal({
    required this.flavor,
    required this.appTitle,
    required this.apiBaseUrl,
  });

  static void initialize({
    required Flavor flavor,
    required String appTitle,
    required String apiBaseUrl,
  }) {
    _instance = FlavorConfig._internal(
      flavor: flavor,
      appTitle: appTitle,
      apiBaseUrl: apiBaseUrl,
    );
  }

  static FlavorConfig get instance {
    assert(_instance != null, 'FlavorConfig must be initialized before use');
    return _instance!;
  }

  static bool get isProduction => instance.flavor == Flavor.production;
  static bool get isStaging => instance.flavor == Flavor.staging;
  static bool get isDevelopment => instance.flavor == Flavor.development;
}
''';

  static const String mainFlavorDart = '''
import 'package:flutter/material.dart';
import 'package:{{package_name}}/flavors/flavor_config.dart';
import 'package:{{package_name}}/injection/injection_container.dart' as di;
import 'package:{{package_name}}/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.initialize(
    flavor: Flavor.{{flavor_enum}},
    appTitle: '{{app_title}} ({{flavor_title}})',
    apiBaseUrl: '{{api_base_url}}',
  );
  await di.initInjection();
  runApp(const MyApp());
}
''';

  // =========================================================================
  // LOCALIZATION TEMPLATES
  // =========================================================================

  static const String l10nYaml = '''
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
''';

  static const String arbEn = '''
{
  "@@locale": "en",
  "appTitle": "{{app_title}}",
  "@appTitle": {
    "description": "The title of the application"
  },
  "welcomeMessage": "Welcome to {{app_title}}",
  "tryAgain": "Try Again",
  "errorOccurred": "An error occurred",
  "loading": "Loading..."
}
''';

  static const String arbEs = '''
{
  "@@locale": "es",
  "appTitle": "{{app_title}}",
  "welcomeMessage": "Bienvenido a {{app_title}}",
  "tryAgain": "Intentar de nuevo",
  "errorOccurred": "Ocurrió un error",
  "loading": "Cargando..."
}
''';

  // =========================================================================
  // FIREBASE TEMPLATE
  // =========================================================================

  static const String firebaseService = '''
import 'package:flutter/foundation.dart';

/// Firebase integration helper.
///
/// NOTE: To complete Firebase setup:
/// 1. Run `flutterfire configure` to generate `firebase_options.dart`.
/// 2. Add `firebase_core: ^3.0.0` to pubspec.yaml.
/// 3. Add Crashlytics/Analytics/Messaging packages as required.
class FirebaseService {
  FirebaseService._();

  static Future<void> initialize() async {
    if (kDebugMode) {
      debugPrint('Initializing Firebase services...');
    }
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  static void logEvent(String name, [Map<String, Object>? parameters]) {
    if (kDebugMode) {
      debugPrint('Firebase Event: \$name with \$parameters');
    }
    // FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
  }

  static void recordError(dynamic exception, StackTrace? stack) {
    if (kDebugMode) {
      debugPrint('Firebase Error Recorded: \$exception');
    }
    // FirebaseCrashlytics.instance.recordError(exception, stack);
  }
}
''';
}
