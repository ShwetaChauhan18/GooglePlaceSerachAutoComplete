import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:testing/src/prediction_response.dart';
import 'package:testing/src/resources/images.dart';
import 'package:testing/src/values/app_text_style.dart';

import 'values/app_colors.dart';

class OutlineBorderAutoCompleteTextFormField extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController tempTextEditingController;
  final String labelText;
  final TextInputType keyboardType;
  final bool autofocus;
  final TextInputAction textInputAction;
  final List<TextInputFormatter> inputFormatters;
  final Function validation;
  final bool checkOfErrorOnFocusChange;
  final double? verticalPadding;
  final bool isEditIcon;
  final bool isReadOnly;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final Future<List<Suggestion>> Function(String) getSuggestion;
  final void Function(Suggestion) onSuggestionSelected;

  @override
  State<StatefulWidget> createState() {
    return _OutlineBorderAutoCompleteTextFormField();
  }

  OutlineBorderAutoCompleteTextFormField({
    required this.labelText,
    this.autofocus = false,
    required this.tempTextEditingController,
    required this.focusNode,
    required this.inputFormatters,
    required this.keyboardType,
    required this.textInputAction,
    required this.validation,
    this.checkOfErrorOnFocusChange = true,
    this.verticalPadding,
    this.isEditIcon = false,
    this.isReadOnly = false,
    this.onFieldSubmitted,
    this.onTap,
    required this.getSuggestion,
    required this.onSuggestionSelected,
  });
}

class _OutlineBorderAutoCompleteTextFormField
    extends State<OutlineBorderAutoCompleteTextFormField> {
  bool isError = false;
  String errorString = "";

  Color getBorderColor(bool isFocus) =>
      isFocus ? AppColors.colorPrimary : AppColors.greyShade2;

  InputBorder getOutlineBorder() => InputBorder.none;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: widget.verticalPadding ?? 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FocusScope(
            child: Focus(
              onFocusChange: (focus) {
                setState(() {
                  getBorderColor(focus);
                  if (widget.checkOfErrorOnFocusChange &&
                      widget
                          .validation(widget.tempTextEditingController.text)
                          .toString()
                          .isNotEmpty &&
                      !focus) {
                    isError = true;
                    errorString = widget
                        .validation(widget.tempTextEditingController.text);
                  } else {
                    isError = false;
                    errorString = widget
                        .validation(widget.tempTextEditingController.text);
                  }
                });
              },
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                        left: 9, right: widget.isEditIcon ? 45 : 9),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      border: Border.all(
                        width: 1,
                        style: BorderStyle.solid,
                        color: isError
                            ? Colors.red
                            : getBorderColor(widget.focusNode.hasFocus),
                      ),
                    ),
                    child: TypeAheadFormField<Suggestion>(
                      suggestionsCallback: (text) => widget.getSuggestion(text),
                      itemBuilder: (context, text) {
                        return ListTile(
                          title: Text(text.description),
                        );
                      },
                      onSuggestionSelected: widget.onSuggestionSelected,
                      validator: (string) {
                        if (widget
                            .validation(widget.tempTextEditingController.text)
                            .toString()
                            .isNotEmpty) {
                          setState(() {
                            isError = true;
                            errorString = widget.validation(
                                widget.tempTextEditingController.text);
                          });
                          return "";
                        } else {
                          setState(() {
                            isError = false;
                            errorString = widget.validation(
                                widget.tempTextEditingController.text);
                          });
                        }
                        return null;
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                        focusNode: widget.focusNode,
                        controller: widget.tempTextEditingController,
                        style: AppTextStyles.textRobotoRegular.copyWith(
                          fontSize: 19,
                        ),
                        onTap: widget.onTap,
                        cursorColor: AppColors.colorPrimary,
                        autofocus: widget.autofocus,
                        keyboardType: widget.keyboardType,
                        textInputAction: widget.textInputAction,
                        inputFormatters: widget.inputFormatters,
                        enabled: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: widget.labelText,
                          labelStyle: isError
                              ? AppTextStyles.textRobotoBold.copyWith(
                                  fontSize: 18,
                                  color: Colors.red,
                                  height: 1.35,
                                )
                              : AppTextStyles.textRobotoBold.copyWith(
                                  fontSize: 18,
                                  color: AppColors.greyShade3,
                                  height: 1.35,
                                ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          enabledBorder: getOutlineBorder(),
                          errorBorder: getOutlineBorder(),
                          border: getOutlineBorder(),
                          errorStyle: TextStyle(height: 0),
                          focusedErrorBorder: getOutlineBorder(),
                          disabledBorder: getOutlineBorder(),
                          focusedBorder: getOutlineBorder(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, right: 8),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Visibility(
                        visible: widget.isEditIcon,
                        child: IconButton(
                          onPressed: () {},
                          splashRadius: 0.5,
                          iconSize: 30,
                          icon: Image.asset(Images.edit),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isError ? true : false,
            child: Container(
              padding: EdgeInsets.only(left: 10.0, top: 3.0),
              child: Text(
                errorString,
                style: AppTextStyles.textRobotoBold.copyWith(
                  fontSize: 13,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
