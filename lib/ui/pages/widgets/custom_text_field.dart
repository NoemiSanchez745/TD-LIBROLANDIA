import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.label,
    Key? key,
    this.controller,
    this.obscureText = false,
    this.iconWidget,
    this.onChanged,
    this.enabled = true,
    this.type = TextInputType.text,
    this.validator,
    this.onSaved,
    this.maxLength,
    this.inputFormatters,
    this.maxLines,
    this.maxlines,
    this.style, // Agregar la propiedad style
    this.width, // Agregar la propiedad para ajustar el ancho
    this.height,

  }) : super(key: key);

  final String label;
  final TextEditingController? controller;
  final int? maxLength;
  final int? maxlines;
  final bool obscureText;
  final Widget? iconWidget; // Puede ser una imagen u otro widget personalizado
  final void Function(String?)? onChanged;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType type;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final maxLines;
   final double? width; // Propiedad para ajustar el ancho
  final double? height; 
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Usar el ancho proporcionado
      height: height, 
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        maxLines: maxLines,
        obscureText: obscureText,
        onChanged: onChanged,
        keyboardType: type,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          labelStyle: TextStyle(
              //color: Theme.of(context).primaryColor,
              fontSize: 14,
              color: Color(0xFF716B6B)),
          prefixIcon: iconWidget != null
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: iconWidget,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
        enabled: enabled,
        validator: validator,
        onSaved: onSaved,
        style: style,
      ),
    );
  }
}
