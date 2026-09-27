import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Enforces feature isolation: a file outside `lib/features/<x>/` must not
/// import `package:app_template/features/<x>/src/...`. Cross-feature access
/// goes through the public barrel `package:app_template/features/<x>/<x>.dart`.
///
/// Why this matters: `src/` is a feature's private implementation. If
/// outsiders depend on it, the feature can't refactor freely. The barrel is
/// the contract.
void main() {
  test('no file outside features/<x>/ imports features/<x>/src/', () {
    const packageName = 'app_template';
    final libDir = Directory('lib');
    final importPattern = RegExp(
      r'''import\s+['"]package:''' +
          packageName +
          r'''/features/([a-z0-9_]+)/src/[^'"]+['"]''',
    );

    final violations = <String>[];
    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;

      // Normalize to forward-slash path for the prefix check below.
      final filePath = entity.path.replaceAll(r'\', '/');

      for (final match in importPattern.allMatches(entity.readAsStringSync())) {
        final importedFeature = match.group(1)!;
        final ownFeaturePrefix = 'lib/features/$importedFeature/';
        if (!filePath.startsWith(ownFeaturePrefix)) {
          violations.add('$filePath  →  ${match.group(0)}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'These files import another feature\'s private src/ directly. '
          'Import the public barrel (e.g. '
          'package:$packageName/features/<feature>/<feature>.dart) instead, '
          'and add the symbol to that barrel\'s exports if missing.\n'
          '${violations.join('\n')}',
    );
  });
}
