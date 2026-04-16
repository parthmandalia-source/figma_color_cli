import 'dart:io';

void main(List<String> args) {
  showBanner();

  if (args.isEmpty) {
    print("❌ No colors provided.");
    print('👉 Example: figma-color "#254C82 #FFFFFF"');
    return;
  }

  final input = args.join(" ");

  stdout.write("📁 Enter output path for app_color.dart [lib/utils/app_color.dart]: ");
  String? path = stdin.readLineSync();

  path = (path == null || path.trim().isEmpty)
      ? 'lib/utils/app_color.dart'
      : path.trim();

  final outputFile = File(path);

  final colorRegex = RegExp(r'#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})');
  final matches = colorRegex.allMatches(input);

  final newColors = <String>{};

  for (final match in matches) {
    newColors.add(match.group(0)!.toUpperCase());
  }

  if (newColors.isEmpty) {
    print("❌ No valid HEX colors found.");
    return;
  }

  if (!outputFile.existsSync()) {
    createNewFile(outputFile, newColors);

    print("\n✅ app_color.dart created successfully!");
    print("📍 Saved at: $path");
    return;
  }

  showOptionPanel();

  stdout.write("👉 Enter your choice (1/2): ");
  final choice = stdin.readLineSync();

  if (choice == "1") {
    createNewFile(outputFile, newColors);
    print("\n✅ File replaced successfully!");
  } else if (choice == "2") {
    appendUniqueColors(outputFile, newColors);
  } else {
    print("❌ Invalid option selected.");
    return;
  }

  print("📍 Saved at: $path");
}

void showBanner() {
  print('''
╔══════════════════════════════════════╗
║        🎨 FIGMA COLOR CLI v1.0       ║
╠══════════════════════════════════════╣
║  Convert Figma HEX → Flutter Color   ║
╚══════════════════════════════════════╝
''');
}

void showOptionPanel() {
  print('''
╔══════════════════════════════════════╗
║     ⚠️ app_color.dart Exists         ║
╠══════════════════════════════════════╣
║  [1] 🗑️ Replace File                 ║
║  [2] ➕ Add New Colors Only          ║
╚══════════════════════════════════════╝
''');
}

void createNewFile(File file, Set<String> colors) {
  final buffer = StringBuffer();

  buffer.writeln("import 'package:flutter/material.dart';");
  buffer.writeln("");
  buffer.writeln("class AppColor {");

  for (final hex in colors) {
    buffer.writeln(generateColorLine(hex));
  }

  buffer.writeln("}");

  file.createSync(recursive: true);
  file.writeAsStringSync(buffer.toString());
}

void appendUniqueColors(File file, Set<String> newColors) {
  String content = file.readAsStringSync();

  final existingRegex = RegExp(r'k([A-Fa-f0-9]{6,8})');

  final existingColors =
  existingRegex
      .allMatches(content)
      .map((e) => e.group(1)!.toUpperCase())
      .toSet();

  final uniqueToAdd =
  newColors.where((hex) {
    return !existingColors.contains(
      hex.replaceAll("#", "").toUpperCase(),
    );
  }).toList();

  if (uniqueToAdd.isEmpty) {
    print("\n⚡ No new unique colors found.");
    return;
  }

  final insertIndex = content.lastIndexOf("}");

  final newLines = uniqueToAdd.map(generateColorLine).join("\n");

  final updatedContent =
      content.substring(0, insertIndex) +
          newLines +
          "\n" +
          content.substring(insertIndex);

  file.writeAsStringSync(updatedContent);

  print("\n✅ ${uniqueToAdd.length} new colors added.");
}

String generateColorLine(String hex) {
  final cleanHex = hex.replaceAll("#", "");

  if (cleanHex.length == 6) {
    return "  static const Color k$cleanHex = Color(0xFF$cleanHex);";
  }

  final rgb = cleanHex.substring(0, 6);
  final alpha = cleanHex.substring(6, 8);

  return "  static const Color k$cleanHex = Color(0x$alpha$rgb);";
}