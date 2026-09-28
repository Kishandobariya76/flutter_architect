/// Supported architecture types.
enum ArchitectureType {
  clean('clean'),
  featureFirst('feature_first');

  final String value;
  const ArchitectureType(this.value);

  static ArchitectureType fromString(String val) {
    return ArchitectureType.values.firstWhere(
      (e) => e.value.toLowerCase() == val.toLowerCase().replaceAll('-', '_'),
      orElse: () => ArchitectureType.clean,
    );
  }
}

/// Supported state management libraries.
enum StateManagementType {
  bloc('bloc'),
  cubit('cubit'),
  none('none');

  final String value;
  const StateManagementType(this.value);

  static StateManagementType fromString(String val) {
    return StateManagementType.values.firstWhere(
      (e) => e.value.toLowerCase() == val.toLowerCase(),
      orElse: () => StateManagementType.bloc,
    );
  }
}

/// Supported networking clients.
enum NetworkingType {
  dio('dio'),
  none('none');

  final String value;
  const NetworkingType(this.value);

  static NetworkingType fromString(String val) {
    return NetworkingType.values.firstWhere(
      (e) => e.value.toLowerCase() == val.toLowerCase(),
      orElse: () => NetworkingType.dio,
    );
  }
}

/// Supported dependency injection mechanisms.
enum DependencyInjectionType {
  getIt('get_it'),
  none('none');

  final String value;
  const DependencyInjectionType(this.value);

  static DependencyInjectionType fromString(String val) {
    final clean = val.toLowerCase().replaceAll('-', '_');
    return DependencyInjectionType.values.firstWhere(
      (e) => e.value == clean,
      orElse: () => DependencyInjectionType.getIt,
    );
  }
}

/// Supported local storage solutions.
enum LocalStorageType {
  sharedPreferences('shared_preferences'),
  none('none');

  final String value;
  const LocalStorageType(this.value);

  static LocalStorageType fromString(String val) {
    final clean = val.toLowerCase().replaceAll('-', '_');
    return LocalStorageType.values.firstWhere(
      (e) => e.value == clean,
      orElse: () => LocalStorageType.sharedPreferences,
    );
  }
}

/// Supported theme systems.
enum ThemeType {
  material3('material3'),
  standard('standard');

  final String value;
  const ThemeType(this.value);

  static ThemeType fromString(String val) {
    return ThemeType.values.firstWhere(
      (e) => e.value.toLowerCase() == val.toLowerCase(),
      orElse: () => ThemeType.material3,
    );
  }
}

/// Supported localization types.
enum LocalizationType {
  flutter('flutter'),
  none('none');

  final String value;
  const LocalizationType(this.value);

  static LocalizationType fromString(String val) {
    return LocalizationType.values.firstWhere(
      (e) => e.value.toLowerCase() == val.toLowerCase(),
      orElse: () => LocalizationType.flutter,
    );
  }
}

/// Supported environment strategies.
enum EnvironmentType {
  dotenv('dotenv'),
  none('none');

  final String value;
  const EnvironmentType(this.value);

  static EnvironmentType fromString(String val) {
    return EnvironmentType.values.firstWhere(
      (e) => e.value.toLowerCase() == val.toLowerCase(),
      orElse: () => EnvironmentType.dotenv,
    );
  }
}

/// Configuration settings for flutter_architect in a target Flutter project.
class ProjectConfig {
  final ArchitectureType architecture;
  final StateManagementType stateManagement;
  final NetworkingType networking;
  final DependencyInjectionType dependencyInjection;
  final LocalStorageType localStorage;
  final ThemeType theme;
  final LocalizationType localization;
  final EnvironmentType environment;
  final bool generateEntities;
  final String? customTemplatePath;

  const ProjectConfig({
    this.architecture = ArchitectureType.clean,
    this.stateManagement = StateManagementType.bloc,
    this.networking = NetworkingType.dio,
    this.dependencyInjection = DependencyInjectionType.getIt,
    this.localStorage = LocalStorageType.sharedPreferences,
    this.theme = ThemeType.material3,
    this.localization = LocalizationType.flutter,
    this.environment = EnvironmentType.dotenv,
    this.generateEntities = false,
    this.customTemplatePath,
  });

  /// Default production config.
  factory ProjectConfig.defaultConfig() => const ProjectConfig();

  /// Parse from YAML map or plain Map.
  factory ProjectConfig.fromMap(Map<dynamic, dynamic> map) {
    final root =
        map['flutter_architect'] is Map ? map['flutter_architect'] as Map : map;

    return ProjectConfig(
      architecture: ArchitectureType.fromString(
        root['architecture']?.toString() ?? 'clean',
      ),
      stateManagement: StateManagementType.fromString(
        root['state_management']?.toString() ?? 'bloc',
      ),
      networking: NetworkingType.fromString(
        root['networking']?.toString() ?? 'dio',
      ),
      dependencyInjection: DependencyInjectionType.fromString(
        root['dependency_injection']?.toString() ?? 'get_it',
      ),
      localStorage: LocalStorageType.fromString(
        root['local_storage']?.toString() ?? 'shared_preferences',
      ),
      theme: ThemeType.fromString(
        root['theme']?.toString() ?? 'material3',
      ),
      localization: LocalizationType.fromString(
        root['localization']?.toString() ?? 'flutter',
      ),
      environment: EnvironmentType.fromString(
        root['environment']?.toString() ?? 'dotenv',
      ),
      generateEntities: root['generate_entities'] == true,
      customTemplatePath: root['custom_template_path']?.toString(),
    );
  }

  /// Exports as Map.
  Map<String, dynamic> toMap() {
    return {
      'architecture': architecture.value,
      'state_management': stateManagement.value,
      'networking': networking.value,
      'dependency_injection': dependencyInjection.value,
      'local_storage': localStorage.value,
      'theme': theme.value,
      'localization': localization.value,
      'environment': environment.value,
      'generate_entities': generateEntities,
      if (customTemplatePath != null)
        'custom_template_path': customTemplatePath,
    };
  }

  /// Serializes into formatted YAML string for `flutter_architect.yaml`.
  String toYamlString() {
    final buffer = StringBuffer();
    buffer.writeln('# Flutter Architect Project Configuration');
    buffer.writeln(
        '# Documentation: https://github.com/Kishandobariya76/flutter_architect');
    buffer.writeln('flutter_architect:');
    buffer.writeln('  architecture: ${architecture.value}');
    buffer.writeln('  state_management: ${stateManagement.value}');
    buffer.writeln('  networking: ${networking.value}');
    buffer.writeln('  dependency_injection: ${dependencyInjection.value}');
    buffer.writeln('  local_storage: ${localStorage.value}');
    buffer.writeln('  theme: ${theme.value}');
    buffer.writeln('  localization: ${localization.value}');
    buffer.writeln('  environment: ${environment.value}');
    buffer.writeln('  generate_entities: $generateEntities');
    if (customTemplatePath != null) {
      buffer.writeln('  custom_template_path: $customTemplatePath');
    }
    return buffer.toString();
  }

  ProjectConfig copyWith({
    ArchitectureType? architecture,
    StateManagementType? stateManagement,
    NetworkingType? networking,
    DependencyInjectionType? dependencyInjection,
    LocalStorageType? localStorage,
    ThemeType? theme,
    LocalizationType? localization,
    EnvironmentType? environment,
    bool? generateEntities,
    String? customTemplatePath,
  }) {
    return ProjectConfig(
      architecture: architecture ?? this.architecture,
      stateManagement: stateManagement ?? this.stateManagement,
      networking: networking ?? this.networking,
      dependencyInjection: dependencyInjection ?? this.dependencyInjection,
      localStorage: localStorage ?? this.localStorage,
      theme: theme ?? this.theme,
      localization: localization ?? this.localization,
      environment: environment ?? this.environment,
      generateEntities: generateEntities ?? this.generateEntities,
      customTemplatePath: customTemplatePath ?? this.customTemplatePath,
    );
  }
}
