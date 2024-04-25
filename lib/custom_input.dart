
import 'package:flutter/material.dart';

class CoustomTextFiled extends StatefulWidget {
  final double width;
  final double height;
  final double redius;
  final Color shadowColor;
  final Color borderColor;
  final Color borderFocusedColor;
  final int maxLength;
  final bool passwordType;
  final String hintText;
  final TextInputType keyboardType;
  final onChanged;

  const CoustomTextFiled({
    super.key,
    required this.width,
    required this.height,
    this.redius = 12,
    this.maxLength = 9999999,
    this.keyboardType = TextInputType.none,
    this.shadowColor = const Color.fromARGB(184, 119, 174, 246),
    this.borderColor = Colors.blue,
    this.borderFocusedColor = const Color.fromRGBO(21, 101, 192, 1),
    this.passwordType = false,
    this.hintText = "",
    required this.onChanged,
  });

  @override
  State<CoustomTextFiled> createState() => _CoustomTextFiledState();
}

class _CoustomTextFiledState extends State<CoustomTextFiled> {
  // final TextEditingController _textEditingController1 = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  bool _isfocused1 = false;
  bool _ishover1 = false;
  bool _visibilityHover = false;
  late bool _visibility ;

  @override
  void initState() {
    _focusNode1.addListener(_onFcousChange);
    _visibility = widget.passwordType;
    super.initState();
  }

  @override
  void dispose() {
    _focusNode1.removeListener(_onFcousChange);
    _focusNode1.dispose();
    // _textEditingController1.dispose();
    super.dispose();
  }

  void _onFcousChange() {
    setState(() {
      _isfocused1 = _focusNode1.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _ishover1 = true;
        });
      },
      onExit: (_) {
        setState(() {
          _ishover1 = false;
        });
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.redius),
            boxShadow: _isfocused1
                ? [
                    BoxShadow(
                      color: widget.shadowColor,
                      blurRadius: 0,
                      spreadRadius: 2,
                    )
                  ]
                : null),
        child: TextField(
          // controller: _textEditingController1,
          focusNode: _focusNode1,
          onChanged: widget.onChanged,
          obscureText: _visibility,
          cursorColor: Colors.blue,
          keyboardType: TextInputType.number,
          maxLength: widget.maxLength,
          cursorWidth: 1,
          obscuringCharacter: "*",
          decoration: InputDecoration(
            counterText: "",
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: widget.passwordType
                ? Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 8),
                    child: MouseRegion(
                      onEnter: (event) {
                        setState(() {
                          _visibilityHover = true;
                        });
                      },
                      onExit: (event) {
                        setState(() {
                          _visibilityHover = false;
                        });
                      },
                      child: IconButton(
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              _visibility = !_visibility;
                            });
                          },
                          icon: Icon(
                              _visibility
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color:
                                  Colors.grey[_visibilityHover ? 700 : 400])),
                    ),
                  )
                : null,
            filled: false,
            hintText: widget.hintText,
            hintTextDirection: TextDirection.rtl,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: _ishover1 ? widget.borderColor : Colors.grey),
                borderRadius: BorderRadius.circular(widget.redius)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.redius),
                borderSide: BorderSide(color: widget.borderFocusedColor)),
          ),
        ),
      ),
    );
  }
}
