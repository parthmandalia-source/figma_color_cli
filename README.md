# 🎨 Figma Color CLI

> A powerful Flutter utility CLI to generate **App Colors**, **ARB Localization Strings**, and **Translate ARB files** instantly from terminal.

[![pub package](https://img.shields.io/pub/v/figma_color_cli.svg)](https://pub.dev/packages/figma_color_cli)
[![likes](https://img.shields.io/pub/likes/figma_color_cli)](https://pub.dev/packages/figma_color_cli)
[![popularity](https://img.shields.io/pub/popularity/figma_color_cli)](https://pub.dev/packages/figma_color_cli)

---

# ✨ Features

### 🎨 App Color Generator
Convert HEX colors into Flutter `AppColor` constants.

### 🌍 ARB String Generator
Generate localization keys/values into `en.arb`.

### 🔄 ARB Translator
Translate existing `en.arb` into:

- Hindi
- French
- Spanish
- German
- Dutch
- Italian
- Portuguese
- Russian
- Arabic
- Japanese
- Korean
- Chinese
- Turkish
- Polish
- Thai

### ⚙️ Auto Localization Generation
Automatically runs:

```bash
flutter gen-l10n
```

after ARB updates.

---

# 📦 Installation

Activate globally:

```bash
dart pub global activate figma_color_cli
```

---

# 🚀 Usage

Run:

```bash
figma-color init
```

---

# 🖥️ CLI Menu

```text
╔══════════════════════════════════════╗
║        Select Generator Type         ║
╠══════════════════════════════════════╣
║  [1] 🎨 Generate App Colors          ║
║  [2] 🌍 Generate ARB Strings         ║
║  [3] 🔄 Translate Existing ARB       ║
╚══════════════════════════════════════╝
```

---

# 🎨 Color Generator Example

### Input:

```text
#254C82 #FFFFFF #00000080
```

### Output:

```dart
class AppColor {
  static const Color k254C82 = Color(0xFF254C82);
  static const Color kFFFFFF = Color(0xFFFFFFFF);
  static const Color k00000080 = Color(0x80000000);
}
```

---

# 🌍 ARB Generator Example

### Input Text:

```text
Cancel Your Plan?

Update Profile

Delete Account
```

### Output `en.arb`:

```json
{
  "cancelYourPlan": "Cancel Your Plan?",
  "updateProfile": "Update Profile",
  "deleteAccount": "Delete Account"
}
```

---

# 🔄 Translation Example

### Source `en.arb`

```json
{
  "deleteAccount": "Delete Account"
}
```

### Hindi Output `hi.arb`

```json
{
  "deleteAccount": "खाता हटाएं"
}
```

---

# 📁 Default Output Paths

| Feature | Default Path |
|--------|-------------|
| App Colors | `lib/utils/app_color.dart` |
| ARB Strings | `lib/l10n/en.arb` |
| Translations | `lib/l10n/{lang}.arb` |

---

# ⚠️ Flutter Localization Setup

Ensure your Flutter project has this in **pubspec.yaml**:

```yaml
flutter:
  generate: true
```

Required for `flutter gen-l10n`.

---

# 🛠 Supported Languages

| Code | Language |
|------|---------|
| hi | Hindi |
| fr | French |
| es | Spanish |
| de | German |
| nl | Dutch |
| it | Italian |
| pt | Portuguese |
| ru | Russian |
| ar | Arabic |
| ja | Japanese |
| ko | Korean |
| zh | Chinese |
| tr | Turkish |
| pl | Polish |
| th | Thai |

---

# 💡 Why Use Figma Color CLI?

Stop wasting time:

- Copying HEX manually
- Writing ARB keys manually
- Translating files manually
- Running gen-l10n manually

Automate everything in seconds ⚡

---

# 🤝 Contributing

Contributions are welcome!

Feel free to open issues or PRs.

---

# 📄 License

MIT License

---

Made with ❤️ for Flutter Developers