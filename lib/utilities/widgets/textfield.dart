import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m2/utilities/utilities.dart';

class BuildTextField extends StatefulWidget {
  const BuildTextField({
    super.key,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.obscureText,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.focusNode,
    this.textInputAction,
    this.textAlign,
    this.hintStyle,
    this.padding,
    this.suffixIcon,
    this.maxLines,
    this.maxLength,
    this.textCapitalization,
    this.showLength = true,
  });
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String? Function(String? value)? validator;
  final Function(String value)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextAlign? textAlign;
  final TextStyle? hintStyle;
  final EdgeInsets? padding;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final bool showLength;
  final TextCapitalization? textCapitalization;
  @override
  State<BuildTextField> createState() => _BuildTextFieldState();
}

class _BuildTextFieldState extends State<BuildTextField> with AutomaticKeepAliveClientMixin {
  bool obscureText = false;
  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText ?? false;
  }

  @override
  void dispose() {
    super.dispose();
    // widget.controller.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return TextFormField(
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: obscureText,
      inputFormatters: widget.inputFormatters,
      textAlign: widget.textAlign ?? TextAlign.start,
      style: AppStyles.getRegularTextStyle(fontSize: 13, color: AppColors.fadedText),
      validator: widget.validator,
      decoration: InputDecoration(
        contentPadding: widget.padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        suffixIcon: widget.suffixIcon ??
            (widget.obscureText != null
                ? InkWell(
                    onTap: () => setState(() {
                          obscureText = !obscureText;
                        }),
                    child: Padding(
                        padding: const EdgeInsets.only(right: 15), child: Icon(obscureText ? Icons.visibility : Icons.visibility_off, color: AppColors.buttonColor, size: 20)))
                : null),
        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.evenFadedText)),
        border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.evenFadedText)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.evenFadedText)),
        hintText: widget.hint,
        hintStyle: widget.hintStyle ?? AppStyles.getLightTextStyle(fontSize: 13, color: AppColors.fadedText),
        counterText: widget.showLength ? null : "",
      ),
      maxLines: widget.maxLines ?? 1,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
    );
  }
}
