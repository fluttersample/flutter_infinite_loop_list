# flutter_infinite_loop_list

A simple and lightweight Flutter widget for creating **infinite looping lists** with optional **auto-scroll** support.  
Perfect for carousels, banners, news tickers, and any scrollable content that should repeat infinitely.

---

## 🎥 Preview

![Preview](https://raw.githubusercontent.com/fluttersample/flutter_infinite_loop_list/main/assets/preview.gif)


---

## 🚀 Features

✅ Infinite scroll (loop) in both directions  
✅ Works with both horizontal and vertical lists  
✅ Supports any custom item widget  
✅ Smooth and efficient scrolling  
✅ Easy to integrate into any Flutter project  

---


## 📦 Installation

Add this to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_infinite_loop_list: ^1.0.0
```



## Usage/Examples

```dart
import 'package:flutter/material.dart';
import 'package:flutter_infinite_loop_list/flutter_infinite_loop_list.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Infinite Auto Scroll List")),
      body: InfiniteLoopList(
        itemCount: 10,
        scrollDirection: Axis.vertical,
        scrollSpeed: 3.0,
        pauseDuration: const Duration(seconds: 3),
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Container(
            height: 90,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[400]!, Colors.green[700]!],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 6, offset: const Offset(0, 3))
              ],
            ),
            child: Center(
              child: Text(
                "Item ${index + 1}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}

```

## License

This project is released under the MIT License — see the [LICENSE](./LICENSE) file for details.
© 2025 mohamad dev

---


Created with ❤️ by <mohamad.drm159@gmail.com>
