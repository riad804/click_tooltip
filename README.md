# ClickTooltip

A lightweight, customizable Flutter widget that displays a **click-to-show tooltip** with an arrow/triangle indicator.  
It uses an `OverlayEntry` to position the tooltip **above** the tapped widget and automatically hides after a short delay.

---

## ✨ Features
- 🖱️ **Tap to show** – tooltip appears when the child widget is tapped.
- 🎯 **Smart positioning** – automatically keeps the tooltip within the screen bounds.
- 🔺 **Arrow indicator** – points directly to the triggering widget.
- 🎨 **Customizable** – easily set height, background color, shadow color, and tooltip content.

---

## 🚀 Installation
No external dependencies are required.  
Simply copy the `click_tooltip.dart` file into your project.

---

## 🛠️ Usage

```dart
import 'package:flutter/material.dart';
import 'click_tooltip.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClickTooltip Example')),
      body: Center(
        child: ClickTooltip(
          tooltipHeight: 60,
          shapeColor: Colors.white,
          shadowColor: Colors.black26,
          tipContent: const Text(
            'Hello, I am a tooltip!',
            style: TextStyle(fontSize: 16),
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            color: Colors.blue,
            child: const Text(
              'Tap Me',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 🔧 Parameters

| Parameter      | Type         | Default       | Description                                                                 |
|----------------|--------------|---------------|-----------------------------------------------------------------------------|
| `child`        | `Widget`     | **Required**  | The widget that triggers the tooltip when tapped.                           |
| `tipContent`   | `Widget`     | **Required**  | The content inside the tooltip (text, image, custom widget).                |
| `tooltipHeight`| `double`     | `60`          | Approximate height of the tooltip container (excluding arrow).              |
| `shapeColor`   | `Color`      | `Colors.white`| Background color of the tooltip.                                           |
| `shadowColor`  | `Color`      | `Colors.black12`| Shadow color applied behind the tooltip.                                   |

---

## 📋 Notes
- The tooltip **auto-hides** after **2 seconds** (configured inside `_showTooltip`).  
  Adjust the duration if needed.
- Tooltip width is currently fixed to `237` (via `toolTipWidth` variable).  
  You can make it dynamic if desired.

---

## 🧩 Customization Ideas
- Replace `toolTipWidth` with a calculated size based on the content.
- Add animations (e.g., fade/scale) when showing or hiding.
- Allow manual dismissal on tap outside.

---

## 📜 License
This code is free to use in personal or commercial projects.  
Attribution is appreciated but not required.
