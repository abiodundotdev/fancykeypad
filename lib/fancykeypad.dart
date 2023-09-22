library fancykeypad;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class FancyKeypad extends StatefulWidget {
  final ValueSetter<String> onKeyTap;
  final ValueSetter<String>? onSubmit;
  final int maxAllowableCharacters;
  final ShapeBorder? shape;
  final bool autoSubmit;
  final bool enableDot;
  final HapticFeedback? hapticFeedback;
  final double childAspectRatio;
  final Color? color;
  final Duration? splashAnimationDuration;
  final Color? splashColor;
  final Color? borderColor;
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
    required this.maxAllowableCharacters,
  }) : super(key: key);
  @override
  State<FancyKeypad> createState() => _FancyKeypadState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(IntProperty('maxAllowableCahracters', maxAllowableCharacters));
    properties.add(DiagnosticsProperty<Function>('animateColor', onKeyTap));
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
        const CircleBorder(
          side: BorderSide(
            color: Color(0XFFF3F3F3),
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
                          Icons.backspace,
                          size: constraints.maxWidth / 2,
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
                              constraints: constraints,
                              key: Key("pad$buttonText"),
                              isTapped: val == buttonText,
                              splashColor: widget.splashColor ?? Colors.white,
                              textColor: widget.textColor ?? Colors.black,
                              color: widget.color ?? Colors.white,
                              splashAnimationDuration: animationDuration,
                              shape: shape,
                              onTap: () async {
                                HapticFeedback.mediumImpact();
                                activeButtonListener.value = buttonText;
                                await Future.delayed(
                                  animationDuration,
                                );
                                activeButtonListener.value = "";
                                if (value.length <
                                    widget.maxAllowableCharacters) {
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
  }) : super(key: key);
  final BoxConstraints constraints;
  final String text;
  final bool isTapped;
  final Color textColor;
  final Duration splashAnimationDuration;
  final ShapeBorder shape;
  final Color splashColor;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: AnimatedContainer(
        duration: splashAnimationDuration,
        key: ValueKey(text),
        decoration: ShapeDecoration(
          color: isTapped ? splashColor : color,
          shape: const CircleBorder(
            side: BorderSide(
              color: Color(0XFFF3F3F3),
            ),
          ),
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
