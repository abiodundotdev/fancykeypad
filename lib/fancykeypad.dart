library fancykeypad;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

///FancyKey to create a modern customizable numeric keypad
///Use [FancyKeypad] and pass the required params to use
class FancyKeypad extends StatefulWidget {
  /// A callback called every time a button is tapped
  final ValueSetter<String> onKeyTap;

  /// A callback once key tapped is equal to [maxLength]
  final ValueSetter<String>? onSubmit;

  /// Maximum number of key tap
  final int maxLength;

  /// Customizable shape [ShapeBorder]
  /// Default is [CircleBorder] can be customized using any class the subclass [Border] or [ShapeBorder] e.g [RoundedRectangleBorder]
  final ShapeBorder? shape;

  /// If set to true, [onSubmit] callback will be called once button tap is equal [maxLength]
  final bool autoSubmit;

  /// If set to true, dot button will be included, if false an empty widget will be used
  final bool enableDot;

  ///To set haptic feedback on key tap
  final HapticFeedback? hapticFeedback;

  ///Child aspect ratio, to set the size of the buttons
  final double childAspectRatio;

  ///Buttons background color
  final Color? color;

  ///Buttons background image, if [Null] it will be ingnored and color will be used
  final DecorationImage? backgroundImage;

  ///Splash animation duration
  final Duration? splashAnimationDuration;

  /// Splash animation curve
  final Curve curve;

  /// Backspace button icon
  final IconData? backspaceButtonIcon;

  ///Buttons splash color on tap
  final Color? splashColor;

  ///Buttons border color
  final Color borderColor;

  ///Buttons text color
  final Color? textColor;
  const FancyKeypad({
    Key? key,
    required this.onKeyTap,
    this.childAspectRatio = 1,
    this.autoSubmit = false,
    this.hapticFeedback,
    this.enableDot = false,
    this.borderColor = const Color(0XFFF3F3F3),
    this.color,
    this.shape,
    this.onSubmit,
    this.splashColor,
    this.textColor,
    this.splashAnimationDuration,
    this.curve = Curves.linear,
    this.backspaceButtonIcon,
    this.backgroundImage,
    required this.maxLength,
  }) : super(key: key);
  @override
  State<FancyKeypad> createState() => _FancyKeypadState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('maxAllowableCahracters', maxLength));
    properties.add(DiagnosticsProperty<Color>('color', color));
  }
}

class _FancyKeypadState extends State<FancyKeypad> {
  final List<String> buttonTexts = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    ".",
    "0",
    "DEL"
  ];
  String value = "";
  late ValueNotifier<String> activeButtonListener;
  @override
  void initState() {
    super.initState();
    activeButtonListener = ValueNotifier<String>("");
  }

  @override
  void dispose() {
    super.dispose();
    activeButtonListener.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ShapeBorder shape = widget.shape ??
        CircleBorder(
          side: BorderSide(
            color: widget.borderColor,
          ),
        );
    Duration animationDuration =
        widget.splashAnimationDuration ?? const Duration(milliseconds: 200);
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 25.0,
      crossAxisSpacing: 40.0,
      childAspectRatio: 16 / 13,
      children: [
        for (var i = 0; i < buttonTexts.length; i++)
          LayoutBuilder(
            builder: (context, constraints) {
              final buttonText = buttonTexts[i];
              return buttonTexts[i] == "DEL"
                  ? Container(
                      decoration: ShapeDecoration(
                        image: widget.backgroundImage,
                        color: widget.color,
                        shape: shape,
                      ),
                      constraints: constraints,
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                        constraints: constraints,
                        onPressed: () {
                          if (value.isNotEmpty) {
                            value = value.removeLastCharacter;
                          }
                          widget.onKeyTap(value);
                        },
                        icon: Icon(
                          widget.backspaceButtonIcon ?? Icons.backspace,
                          size: constraints.maxWidth / 3,
                          color: widget.textColor,
                        ),
                      ),
                    )
                  : (buttonText == "." && !widget.enableDot
                      ? const SizedBox()
                      : ValueListenableBuilder(
                          valueListenable: activeButtonListener,
                          builder: (context, String val, _) {
                            return FancyKeypadButton(
                              backgroundImage: widget.backgroundImage,
                              constraints: constraints,
                              key: Key("pad$buttonText"),
                              curve: widget.curve,
                              isTapped: val == buttonText,
                              splashColor: widget.splashColor ?? Colors.white,
                              textColor: widget.textColor ?? Colors.black,
                              color: widget.color ?? Colors.white,
                              splashAnimationDuration: animationDuration,
                              shape: shape,
                              onTap: () async {
                                if (value.length >= widget.maxLength &&
                                    widget.autoSubmit &&
                                    !widget.onSubmit.isNull) {
                                  widget.onSubmit!(val);
                                  return;
                                }
                                HapticFeedback.mediumImpact();
                                activeButtonListener.value = buttonText;
                                await Future.delayed(
                                  animationDuration,
                                );
                                activeButtonListener.value = "";
                                if (value.length < widget.maxLength) {
                                  if (value.contains(".")) {
                                    final precisions = value.split(".")[1];
                                    if (precisions.length <= 2) {
                                      value += buttonText;
                                    }
                                  } else {
                                    value += buttonText;
                                  }
                                }
                                widget.onKeyTap(value);
                              },
                              text: buttonText,
                            );
                          },
                        ));
            },
          ),
      ],
    );
  }
}

class FancyKeypadButton extends StatelessWidget {
  const FancyKeypadButton({
    Key? key,
    required this.constraints,
    required this.text,
    required this.isTapped,
    required this.onTap,
    required this.splashColor,
    required this.shape,
    required this.textColor,
    required this.splashAnimationDuration,
    required this.color,
    required this.curve,
    this.backgroundImage,
  }) : super(key: key);
  final BoxConstraints constraints;
  final String text;
  final bool isTapped;
  final Color textColor;
  final Duration splashAnimationDuration;
  final ShapeBorder shape;
  final Color splashColor;
  final DecorationImage? backgroundImage;
  final VoidCallback onTap;
  final Color color;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: shape,
      child: AnimatedContainer(
        curve: curve,
        duration: splashAnimationDuration,
        key: ValueKey(text),
        decoration: ShapeDecoration(
          image: backgroundImage,
          color: backgroundImage.isNull
              ? (isTapped ? splashColor : color)
              : Colors.transparent,
          shape: shape,
        ),
        constraints: constraints.tighten(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w700,
              color: isTapped ? Colors.white : textColor,
            ),
          ),
        ),
      ),
    );
  }
}

extension XObject on Object? {
  bool get isNull => this == null;
}

extension StringX on String {
  String get removeLastCharacter => substring(0, length - 1);
}
