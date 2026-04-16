import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> main(List<String> args) async {
  if (args.isEmpty || args.first != "init") {
    print('❌ Invalid command.');
    print('👉 Use: figma-color init');
    return;
  }

  showBanner();

  print('''
╔══════════════════════════════════════╗
║        Select Generator Type         ║
╠══════════════════════════════════════╣
║  [1] 🎨 Generate App Colors          ║
║  [2] 🌍 Generate ARB Strings         ║
║  [3] 🔄 Translate Existing ARB       ║
╚══════════════════════════════════════╝
''');

  stdout.write("👉 Enter your choice (1/2/3): ");
  final generatorChoice = stdin.readLineSync();

  if (generatorChoice == "1") {
    handleColorGenerator();
  } else if (generatorChoice == "2") {
    handleArbGenerator();
  } else if (generatorChoice == "3") {
    await handleTranslateArb();
  } else {
    print("❌ Invalid option selected.");
  }
}

void handleColorGenerator() {
  stdout.write("🎨 Enter HEX Colors: ");
  final input = stdin.readLineSync();

  if (input == null || input.isEmpty) return;

  stdout.write(
    "📁 Enter output path for app_color.dart [lib/utils/app_color.dart]: ",
  );

  String? path = stdin.readLineSync();

  path =
  (path == null || path.trim().isEmpty)
      ? 'lib/utils/app_color.dart'
      : path.trim();

  final outputFile = File(path);

  final colorRegex = RegExp(r'#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})');

  final matches = colorRegex.allMatches(input);

  final newColors = <String>{};

  for (final match in matches) {
    newColors.add(match.group(0)!.toUpperCase());
  }

  if (!outputFile.existsSync()) {
    createNewFile(outputFile, newColors);
    print("✅ app_color.dart created successfully!");
    return;
  }

  showOptionPanel();

  stdout.write("👉 Enter your choice (1/2): ");
  final choice = stdin.readLineSync();

  if (choice == "1") {
    createNewFile(outputFile, newColors);
  } else {
    appendUniqueColors(outputFile, newColors);
  }

  print("📍 Saved at: $path");
}

void handleArbGenerator() {
  print("📝 Enter ARB texts:");
  print("👉 Press ENTER twice for next item");
  print("👉 Type 'done' on empty line when finished\n");

  final texts = <String>[];
  final buffer = StringBuffer();

  while (true) {
    final line = stdin.readLineSync();

    if (line == null) continue;

    if (line.toLowerCase() == 'done' && buffer.isEmpty) break;

    if (line.trim().isEmpty) {
      if (buffer.isNotEmpty) {
        texts.add(buffer.toString().trim());
        buffer.clear();
      }
      continue;
    }

    buffer.writeln(line);
  }

  if (buffer.isNotEmpty) {
    texts.add(buffer.toString().trim());
  }

  stdout.write("📁 Enter ARB path [lib/l10n/en.arb]: ");

  String? path = stdin.readLineSync();

  path =
  (path == null || path.trim().isEmpty)
      ? 'lib/l10n/en.arb'
      : path.trim();

  final file = File(path);

  Map<String, dynamic> arbData = {};

  if (file.existsSync()) {
    try {
      arbData = jsonDecode(file.readAsStringSync());
    } catch (_) {
      print("❌ Invalid ARB JSON format.");
      return;
    }
  }

  for (final text in texts) {
    final cleanText = text.replaceAll("\n", " ");

    final key = generateArbKey(cleanText);

    arbData[key] = cleanText;
  }

  file.createSync(recursive: true);

  file.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(arbData),
  );

  print("✅ ARB updated successfully.");

  runFlutterGenL10n();
}

Future<void> handleTranslateArb() async {
  stdout.write("📁 Enter source ARB path [lib/l10n/en.arb]: ");

  String? sourcePath = stdin.readLineSync();

  sourcePath =
  (sourcePath == null || sourcePath.trim().isEmpty)
      ? 'lib/l10n/en.arb'
      : sourcePath.trim();

  final sourceFile = File(sourcePath);

  if (!sourceFile.existsSync()) {
    print("❌ Source file not found.");
    return;
  }

  Map<String, dynamic> arbData;

  try {
    arbData = jsonDecode(sourceFile.readAsStringSync());
  } catch (_) {
    print("❌ Invalid source ARB.");
    return;
  }

  final languages = {
    "1": "hi",
    "2": "fr",
    "3": "es",
    "4": "de",
    "5": "nl",
    "6": "it",
    "7": "pt",
    "8": "ru",
    "9": "ar",
    "10": "ja",
    "11": "ko",
    "12": "zh",
    "13": "tr",
    "14": "pl",
    "15": "th",
  };

  print('''
1 Hindi
2 French
3 Spanish
4 German
5 Dutch
6 Italian
7 Portuguese
8 Russian
9 Arabic
10 Japanese
11 Korean
12 Chinese
13 Turkish
14 Polish
15 Thai
''');

  stdout.write("👉 Select language: ");
  final choice = stdin.readLineSync();

  if (!languages.containsKey(choice)) {
    print("❌ Invalid selection.");
    return;
  }

  final langCode = languages[choice]!;

  final translatedMap = <String, dynamic>{};

  for (final entry in arbData.entries) {
    translatedMap[entry.key] = await translateText(
      entry.value.toString(),
      langCode,
    );
  }

  final sourceDir = sourceFile.parent.path;

  final outputFile = File("$sourceDir/$langCode.arb");

  outputFile.createSync(recursive: true);

  outputFile.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(translatedMap),
  );

  print("✅ Translation completed → ${outputFile.path}");
}

Future<String> translateText(String text, String targetLang) async {
  try {
    final uri = Uri.parse(
      'https://translate.googleapis.com/translate_a/single'
          '?client=gtx'
          '&sl=en'
          '&tl=$targetLang'
          '&dt=t'
          '&q=${Uri.encodeComponent(text)}',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body[0][0][0];
    }

    return text;
  } catch (e) {
    print("Translation Error: $e");
    return text;
  }
}
void runFlutterGenL10n() {
  Process.runSync("flutter", ["gen-l10n"]);
}

String generateArbKey(String text) {
  final cleaned = text.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '');

  final words =
  cleaned
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .take(3)
      .toList();

  if (words.isEmpty) return '';

  String key = words.first.toLowerCase();

  for (int i = 1; i < words.length; i++) {
    key +=
        words[i][0].toUpperCase() +
            words[i].substring(1).toLowerCase();
  }

  return key;
}

void showBanner() {
  print('''
╔══════════════════════════════════════╗
║        🎨 FIGMA COLOR CLI v2.0       ║
╠══════════════════════════════════════╣
║   Flutter Utility Generator Tool 🚀  ║
╚══════════════════════════════════════╝
''');
}

void showOptionPanel() {
  print('''
1 Replace File
2 Add New Colors Only
''');
}

void createNewFile(File file, Set<String> colors) {
  final buffer = StringBuffer();

  buffer.writeln("import 'package:flutter/material.dart';");
  buffer.writeln("class AppColor {");

  for (final hex in colors) {
    buffer.writeln(generateColorLine(hex));
  }

  buffer.writeln("}");

  file.writeAsStringSync(buffer.toString());
}

void appendUniqueColors(File file, Set<String> newColors) {
  String content = file.readAsStringSync();

  final insertIndex = content.lastIndexOf("}");

  final newLines = newColors.map(generateColorLine).join("\n");

  file.writeAsStringSync(
    content.substring(0, insertIndex) +
        newLines +
        "\n" +
        content.substring(insertIndex),
  );
}

String generateColorLine(String hex) {
  final cleanHex = hex.replaceAll("#", "");

  if (cleanHex.length == 6) {
    return "static const Color k$cleanHex = Color(0xFF$cleanHex);";
  }

  final rgb = cleanHex.substring(0, 6);

  final alpha = cleanHex.substring(6, 8);

  return "static const Color k$cleanHex = Color(0x$alpha$rgb);";
}