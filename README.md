# 🎨 Figma Color CLI

[![pub package](https://img.shields.io/pub/v/figma_color_cli.svg)](https://pub.dev/packages/figma_color_cli)
[![likes](https://img.shields.io/pub/likes/figma_color_cli)](https://pub.dev/packages/figma_color_cli/score)
[![popularity](https://img.shields.io/pub/popularity/figma_color_cli)](https://pub.dev/packages/figma_color_cli/score)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Convert **Figma HEX colors** into **Flutter AppColor constants** instantly from terminal 🚀

Perfect for Flutter developers who frequently copy colors from Figma and want to generate clean `app_color.dart` files automatically.

---

## ✨ Features

- 🎯 Convert HEX → Flutter `Color()` format
- 📁 Auto-generate `app_color.dart`
- ♻️ Replace or append to existing color file
- 🚫 Prevent duplicate color entries
- 🌈 Supports opacity HEX (`#254C8280`)
- 🖥 Beautiful CLI interface
- ⚡ Lightweight and dependency-free

---

## 📦 Installation

Activate globally:

```bash
dart pub global activate figma_color_cli
```

---

## 🚀 Usage

Run command:

```bash
figma-color "#254C82 #FFFFFF #254C8280"
```

---

## 💡 Demo

### Input:

```bash
figma-color "#254C82 #FFFFFF"
```

### CLI Output:

```bash
╔══════════════════════════════════════╗
║        🎨 FIGMA COLOR CLI v1.0       ║
╠══════════════════════════════════════╣
║  Convert Figma HEX → Flutter Color   ║
╚══════════════════════════════════════╝
```

---

## 📂 Generated Output

Creates:

```dart
import 'package:flutter/material.dart';

class AppColor {
  static const Color k254C82 = Color(0xFF254C82);
  static const Color kFFFFFF = Color(0xFFFFFFFF);
}
```

---

## 🛠 Example Workflow

### 1. Copy colors from Figma:

```text
#254C82
#FFFFFF
#000000
```

### 2. Run CLI:

```bash
figma-color "#254C82 #FFFFFF #000000"
```

### 3. Done 🎉

---

## 📈 Versioning

Current Version:

```yaml
1.0.1
```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

Feel free to fork and submit PRs.

---

## 📄 License

MIT License © 2026 Parth Mandalia