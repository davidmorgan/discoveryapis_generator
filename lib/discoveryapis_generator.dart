// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library discoveryapis_generator;

import "dart:io";
import "dart:convert";

import 'src/generated_googleapis/discovery/v1.dart';
import 'src/apis_package_generator.dart';
import 'src/utils.dart';

export 'src/generated_googleapis/discovery/v1.dart';
export 'src/utils.dart' show GenerateResult;

/**
 * Specifaction of the pubspec.yaml for a generated package.
 */
class Pubspec {
  final String name;
  final String version;
  final String description;
  final String author;
  final String homepage;

  Pubspec(this.name,
          this.version,
          this.description,
          {this.author,
           this.homepage});

  String get sdkConstraint => '>=1.0.0 <2.0.0';

  Map<String, Object> get dependencies => const {
    'http': '\'>=0.11.1 <0.12.0\'',
    'crypto': '\'>=0.9.0 <0.10.0\'',
    '_discoveryapis_commons': '\'>=0.1.0 <0.2.0\'',
  };

  Map<String, Object> get devDependencies => const {
    'unittest': '\'>=0.10.0 <0.12.0\'',
  };
}

List<GenerateResult> generateApiPackage(List<RestDescription> descriptions,
                                        String outputDirectory,
                                        Pubspec pubspec) {
  var apisPackageGenerator = new ApisPackageGenerator(
      descriptions, pubspec, outputDirectory);

  return apisPackageGenerator.generateApiPackage();
}

List<GenerateResult> generateAllLibraries(String inputDirectory,
                                          String outputDirectory,
                                          Pubspec pubspec) {
  var apiDescriptions = new Directory(inputDirectory).listSync()
      .where((fse) => fse is File && fse.path.endsWith('.json'))
      .map((File file) {
    return new RestDescription.fromJson(JSON.decode(file.readAsStringSync()));
  }).toList();
  return generateApiPackage(apiDescriptions, outputDirectory, pubspec);
}