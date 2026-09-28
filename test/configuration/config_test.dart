import 'package:flutter_architect/flutter_architect.dart';
import 'package:test/test.dart';

void main() {
  group('ProjectConfig', () {
    test('default configuration has expected defaults', () {
      final config = ProjectConfig.defaultConfig();
      expect(config.architecture, equals(ArchitectureType.clean));
      expect(config.stateManagement, equals(StateManagementType.bloc));
      expect(config.networking, equals(NetworkingType.dio));
      expect(config.dependencyInjection, equals(DependencyInjectionType.getIt));
      expect(config.localStorage, equals(LocalStorageType.sharedPreferences));
      expect(config.theme, equals(ThemeType.material3));
      expect(config.generateEntities, isFalse);
    });

    test('serializes and deserializes to map correctly', () {
      const config = ProjectConfig(
        architecture: ArchitectureType.clean,
        stateManagement: StateManagementType.cubit,
        networking: NetworkingType.dio,
        dependencyInjection: DependencyInjectionType.getIt,
        localStorage: LocalStorageType.sharedPreferences,
        theme: ThemeType.material3,
        localization: LocalizationType.flutter,
        environment: EnvironmentType.dotenv,
        generateEntities: false,
      );

      final map = config.toMap();
      final reconstructed = ProjectConfig.fromMap(map);

      expect(reconstructed.architecture, equals(config.architecture));
      expect(reconstructed.stateManagement, equals(StateManagementType.cubit));
      expect(reconstructed.networking, equals(config.networking));
      expect(reconstructed.dependencyInjection,
          equals(config.dependencyInjection));
      expect(reconstructed.generateEntities, isFalse);
    });

    test('generates valid YAML string', () {
      final config = ProjectConfig.defaultConfig();
      final yaml = config.toYamlString();

      expect(yaml, contains('flutter_architect:'));
      expect(yaml, contains('architecture: clean'));
      expect(yaml, contains('state_management: bloc'));
      expect(yaml, contains('networking: dio'));
      expect(yaml, contains('generate_entities: false'));
    });
  });
}
