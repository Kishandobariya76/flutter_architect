import 'dart:io';
import 'package:flutter_architect/flutter_architect.dart';
import 'package:test/test.dart';

void main() {
  group('Generators', () {
    late Directory tempDir;
    late FileManager fm;
    late ProjectConfig config;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('fa_gen_');
      // Create minimal pubspec
      File('${tempDir.path}/pubspec.yaml')
          .writeAsStringSync('name: test_shop\n');
      fm = FileManager(baseDir: tempDir);
      config = ProjectConfig.defaultConfig();
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('CoreGenerator generates core files and main.dart', () async {
      final gen =
          CoreGenerator(fileManager: fm, config: config, projectDir: tempDir);
      final results = await gen.generate();

      expect(results, isNotEmpty);
      expect(File('${tempDir.path}/lib/core/error/failures.dart').existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/core/error/exceptions.dart').existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/core/network/dio_client.dart').existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/injection/injection_container.dart')
              .existsSync(),
          isTrue);
      expect(File('${tempDir.path}/lib/main.dart').existsSync(), isTrue);
    });

    test(
        'FeatureGenerator creates complete Clean Architecture structure without entities',
        () async {
      final gen = FeatureGenerator(
          featureName: 'cart',
          fileManager: fm,
          config: config,
          projectDir: tempDir);
      final results = await gen.generate();

      expect(results, isNotEmpty);
      // Models
      expect(
          File('${tempDir.path}/lib/features/cart/data/models/cart_model.dart')
              .existsSync(),
          isTrue);
      // Datasources
      expect(
          File('${tempDir.path}/lib/features/cart/data/datasources/cart_remote_datasource.dart')
              .existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/features/cart/data/datasources/cart_local_datasource.dart')
              .existsSync(),
          isTrue);
      // Repositories
      expect(
          File('${tempDir.path}/lib/features/cart/domain/repositories/cart_repository.dart')
              .existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/features/cart/data/repositories/cart_repository_impl.dart')
              .existsSync(),
          isTrue);
      // UseCases
      expect(
          File('${tempDir.path}/lib/features/cart/domain/usecases/get_cart_usecase.dart')
              .existsSync(),
          isTrue);
      // Presentation BLoC
      expect(
          File('${tempDir.path}/lib/features/cart/presentation/bloc/cart_bloc.dart')
              .existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/features/cart/presentation/bloc/cart_event.dart')
              .existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/features/cart/presentation/bloc/cart_state.dart')
              .existsSync(),
          isTrue);
      // Presentation UI
      expect(
          File('${tempDir.path}/lib/features/cart/presentation/pages/cart_page.dart')
              .existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/features/cart/presentation/widgets/cart_item_view.dart')
              .existsSync(),
          isTrue);
      // Confirm NO entities folder
      expect(
          Directory('${tempDir.path}/lib/features/cart/domain/entities')
              .existsSync(),
          isFalse);
    });

    test('BlocGenerator generates bloc, event, and state files', () async {
      final gen = BlocGenerator(
          name: 'counter',
          fileManager: fm,
          config: config,
          projectDir: tempDir);
      final results = await gen.generate();

      expect(results.length, equals(3));
      expect(
          File('${tempDir.path}/lib/presentation/bloc/counter/counter_bloc.dart')
              .existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/presentation/bloc/counter/counter_event.dart')
              .existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/presentation/bloc/counter/counter_state.dart')
              .existsSync(),
          isTrue);
    });

    test('CubitGenerator generates cubit and state files', () async {
      final gen = CubitGenerator(
          name: 'settings',
          fileManager: fm,
          config: config,
          projectDir: tempDir);
      final results = await gen.generate();

      expect(results.length, equals(2));
      expect(
          File('${tempDir.path}/lib/presentation/cubit/settings/settings_cubit.dart')
              .existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/presentation/cubit/settings/settings_state.dart')
              .existsSync(),
          isTrue);
    });

    test('ModelGenerator generates model with fromJson and toJson', () async {
      final gen = ModelGenerator(
          name: 'product',
          fileManager: fm,
          config: config,
          projectDir: tempDir);
      final results = await gen.generate();

      expect(results.length, equals(1));
      final file = File('${tempDir.path}/lib/data/models/product_model.dart');
      expect(file.existsSync(), isTrue);
      final content = file.readAsStringSync();
      expect(content, contains('class ProductModel'));
      expect(content, contains('fromJson'));
      expect(content, contains('toJson'));
    });

    test('ApiGenerator generates full API stack with custom HTTP method',
        () async {
      final gen = ApiGenerator(
          name: 'checkout',
          method: 'post',
          fileManager: fm,
          config: config,
          projectDir: tempDir);
      final results = await gen.generate();

      expect(results, isNotEmpty);
      final dsFile = File(
          '${tempDir.path}/lib/features/checkout/data/datasources/checkout_remote_datasource.dart');
      expect(dsFile.existsSync(), isTrue);
      final dsContent = dsFile.readAsStringSync();
      expect(dsContent, contains('client.post'));
    });

    test('UI Generators create Page, Widget, Dialog, and BottomSheet',
        () async {
      await PageGenerator(
              name: 'home',
              fileManager: fm,
              config: config,
              projectDir: tempDir)
          .generate();
      await WidgetGenerator(
              name: 'header',
              fileManager: fm,
              config: config,
              projectDir: tempDir)
          .generate();
      await DialogGenerator(
              name: 'confirm',
              fileManager: fm,
              config: config,
              projectDir: tempDir)
          .generate();
      await BottomSheetGenerator(
              name: 'filter',
              fileManager: fm,
              config: config,
              projectDir: tempDir)
          .generate();

      expect(
          File('${tempDir.path}/lib/presentation/pages/home_page.dart')
              .existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/presentation/widgets/header_widget.dart')
              .existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/presentation/dialogs/confirm_dialog.dart')
              .existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/presentation/bottomsheets/filter_bottom_sheet.dart')
              .existsSync(),
          isTrue);
    });

    test(
        'FlavorsGenerator creates dev, staging, prod main files and flavor config',
        () async {
      final gen = FlavorsGenerator(
          fileManager: fm, config: config, projectDir: tempDir);
      final results = await gen.generate();

      expect(results, isNotEmpty);
      expect(
          File('${tempDir.path}/lib/flavors/flavor_config.dart').existsSync(),
          isTrue);
      expect(File('${tempDir.path}/lib/main_development.dart').existsSync(),
          isTrue);
      expect(
          File('${tempDir.path}/lib/main_staging.dart').existsSync(), isTrue);
      expect(File('${tempDir.path}/lib/main_production.dart').existsSync(),
          isTrue);
      expect(File('${tempDir.path}/.env.dev').existsSync(), isTrue);
    });

    test('LocalizationGenerator creates l10n.yaml and arb templates', () async {
      final gen = LocalizationGenerator(
          fileManager: fm, config: config, projectDir: tempDir);
      final results = await gen.generate();

      expect(results, isNotEmpty);
      expect(File('${tempDir.path}/l10n.yaml').existsSync(), isTrue);
      expect(File('${tempDir.path}/lib/l10n/app_en.arb').existsSync(), isTrue);
      expect(File('${tempDir.path}/lib/l10n/app_es.arb').existsSync(), isTrue);
    });

    test('FirebaseGenerator creates firebase_service.dart', () async {
      final gen = FirebaseGenerator(
          fileManager: fm, config: config, projectDir: tempDir);
      final results = await gen.generate();

      expect(results, isNotEmpty);
      expect(
          File('${tempDir.path}/lib/core/firebase/firebase_service.dart')
              .existsSync(),
          isTrue);
    });
  });
}
