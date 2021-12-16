import 'package:flutter/material.dart';
import 'package:health_and_hope/src/utils/helpers.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';


class DatePickerFieldCustomWidget extends StatelessWidget {
  final String formControlTextName;
  final IconData? icon;
  final Map<String, String> validationMessages;
  final String labelText;
  final DateTime firstDate;
  final DateTime lastDate;

  late FocusNode _focusNode;
  DatePickerFieldCustomWidget({
    this.icon,
    required this.formControlTextName,
    required this.validationMessages,
    required this.labelText,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    _focusNode = FocusNode();
    final decoration = InputDecoration(
      labelStyle: TextStyle(
        color: HelpersAppsColors().colorBase,
      ),
      hintStyle: TextStyle(
          color: Colors.grey
      ),
      labelText: labelText,
      border: OutlineInputBorder(
        // borderRadius: BorderRadius.circular(30),
          gapPadding: 2
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: HelpersAppsColors().colorBase,
            width: 2
        ),
        // borderRadius: BorderRadius.circular(30),
      ),

    );

    final datePicker = ReactiveDatePicker<DateTime>(
      formControlName: formControlTextName,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, picker, child) {
        Widget suffix = InkWell(
          onTap: () {
            _focusNode.unfocus();
            _focusNode.canRequestFocus = false;
            picker.control.value = null;
            Future.delayed(const Duration(milliseconds: 100), () {
              _focusNode.canRequestFocus = true;
            });
          },
          child: const Icon(Icons.clear),
        );
        if (picker.value == null) {
          suffix = const Icon(Icons.calendar_today);
        }
        return ReactiveTextField(
          validationMessages: (control) => validationMessages,
          onTap: () {
            if (_focusNode.canRequestFocus) {
              _focusNode.unfocus();
              picker.showPicker();
            }
          },
          valueAccessor: DateTimeValueAccessor(
            dateTimeFormat: DateFormat('yyyy-MM-dd'),
          ),
          focusNode: _focusNode,
          formControlName: formControlTextName,
          readOnly: true,
          decoration: (icon!=null)?
          decoration.copyWith(
            prefixIcon: Icon( icon, color: HelpersAppsColors().colorBase),
            suffixIcon: suffix,
          ): decoration.copyWith(suffixIcon: suffix),
        );
      },
    );

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: datePicker
        )
    );
  }
}