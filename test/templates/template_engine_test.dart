import 'package:flutter_architect/src/templates/template_engine.dart';
import 'package:test/test.dart';

void main() {
  group('TemplateEngine', () {
    test('replaces variables accurately', () {
      const template = 'Hello, {{name}}! Welcome to {{app}}.';
      final rendered = TemplateEngine.render(template, {
        'name': 'Kishan',
        'app': 'Flutter Architect',
      });
      expect(rendered, equals('Hello, Kishan! Welcome to Flutter Architect.'));
    });

    test('handles conditional blocks', () {
      const template =
          '{{#has_network}}Network: {{network}}{{/has_network}}{{^has_network}}No Network{{/has_network}}';
      expect(
        TemplateEngine.render(
            template, {'has_network': true, 'network': 'Dio'}),
        equals('Network: Dio'),
      );
      expect(
        TemplateEngine.render(template, {'has_network': false}),
        equals('No Network'),
      );
    });
  });
}
