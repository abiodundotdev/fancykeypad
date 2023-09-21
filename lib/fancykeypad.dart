library fancykeypad;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class AppKeyPad extends StatefulWidget {
  final ValueSetter<String>? onKeyTap;
  final bool showLocalAuth;
  final int maxAllowableCharacters;
  final double? height;
  const AppKeyPad({
    Key? key,
    this.onKeyTap,
    this.height,
    this.showLocalAuth = false,
    required this.maxAllowableCharacters,
  }) : super(key: key);
  @override
  State<AppKeyPad> createState() => _AppKeyPadState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(IntProperty('maxAllowableCahracters', maxAllowableCharacters));
    properties.add(DiagnosticsProperty<Function>('animateColor', onKeyTap));
  }
}

class _AppKeyPadState extends State<AppKeyPad> {
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
    " ",
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
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 25.0,
      crossAxisSpacing: 40.0,
      children: [
        for (var i = 0; i < buttonTexts.length; i++)
          LayoutBuilder(builder: (context, constraints) {
            final buttonText = buttonTexts[i];
            return buttonTexts[i] == "DEL"
                ? Container(
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: Color(0XFFF3F3F3),
                        ),
                      ),
                    ),
                    constraints: constraints,
                    padding: widget.showLocalAuth
                        ? EdgeInsets.zero
                        : const EdgeInsets.all(10.0),
                    child: IconButton(
                      constraints: constraints,
                      onPressed: () {
                        if (value.isNotEmpty) {
                          // value = value.removeLastCharacter;
                        }
                        if (widget.onKeyTap != null) {
                          widget.onKeyTap!(value);
                        }
                      },
                      icon: Icon(
                        Icons.delete,
                        size: constraints.maxWidth / 2,
                        //color: widget.,
                      ),
                    ),
                  )
                : (buttonText == " "
                    ? const SizedBox()
                    : ValueListenableBuilder(
                        valueListenable: activeButtonListener,
                        builder: (context, String val, _) {
                          return AppKeyPadButton(
                            constraints: constraints,
                            key: Key("pad$buttonText"),
                            isTapped: val == buttonText,
                            onTap: () async {
                              HapticFeedback.mediumImpact();
                              activeButtonListener.value = buttonText;
                              await Future.delayed(
                                const Duration(
                                  milliseconds: 100,
                                ),
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
                              if (widget.onKeyTap != null) {
                                widget.onKeyTap!(value);
                              }
                            },
                            text: buttonText,
                          );
                        },
                      ));
          }),
      ],
    );
  }
}

class AppKeyPadButton extends StatelessWidget {
  const AppKeyPadButton({
    Key? key,
    required this.constraints,
    required this.text,
    required this.isTapped,
    required this.onTap,
  }) : super(key: key);
  final BoxConstraints constraints;
  final String text;
  final bool isTapped;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Container(
          key: ValueKey(text),
          decoration: ShapeDecoration(
            //  color: isTapped ? AppColors.primary : Colors.white,
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
                //color: isTapped ? AppColors.white : AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
