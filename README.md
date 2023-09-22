# FancyKeypad

A fancy numeric keypad in flutter

## 🎖 Installing

```yaml
dependencies:
  fancykeypad : ^1.0.0
```

### ⚡️ Import
```dart
import 'package:fancykeypad/fancykeypad.dart';
```

## 🎮 How To Use

### Simply create a `FancyKeypad` widget and pass the required params:

```dart
FancyKeypad(
    onKeyTap: (String val) {
        print(val);                
    },
    maxLength: 5,
    splashColor: Colors.green,
)
```

### `FancyKeypad` widget with custom shapes :

```dart
FancyKeypad(
    onKeyTap: (String val) {
        print(val);                
    },
    maxLength: 5,
    shape: Border.all(
        color: Color(0XFFF3F3F3),
    ),
    textColor: Colors.white,
    splashColor: Colors.green,
)
```

### `FancyKeypad` widget with image as background :

```dart
FancyKeypad(
    onKeyTap: (String val) {
        print(val);                
    },
    maxLength: 5,
     backgroundImage: const DecorationImage(
                    image: NetworkImage(
     "https://images.unsplash.com/32/Mc8kW4x9Q3aRR3RkP5Im_IMG_4417.jpg?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGJhY2tncm91bmQlMjBpbWFnZXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60")),
)
```


## Example

Example UI for the widget:
![Example](https://raw.githubusercontent.com/abiodundotdev/fancykeypad/main/example1.png)

![Example](https://raw.githubusercontent.com/abiodundotdev/fancykeypad/main/example2.png)


If something is missing, feel free to open a ticket or contribute!