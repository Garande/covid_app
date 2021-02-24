import 'package:covid_app/utils/app_theme.dart';
import 'package:flutter/material.dart';

class AppWidgets {
  static Widget getLogo({String logoPath, double height}) => Material(
        type: MaterialType.transparency,
        elevation: 10.0,
        child: logoPath != null
            ? Image(image: AssetImage(logoPath), height: height)
            : Icon(
                Icons.account_circle,
                size: height,
                color: AppTheme.nearlyWhite.withOpacity(.7),
              ),
      );

  static Widget titleView(String label) => Text(
        label,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: AppTheme.fontName,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: 0.5,
          color: AppTheme.darkText,
        ),
      );

  static Widget searchField(
          {TextEditingController controller, String hintText}) =>
      Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          top: 8.0,
          bottom: 2.0,
          right: 8.0,
        ),
        child: Card(
          child: TextFormField(
            autofocus: true,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
              border: InputBorder.none,
            ),
          ),
        ),
      );

  static Widget customTextInputField({
    TextEditingController controller,
    String prefix = '',
    String key,
    String hintText,
    TextInputType inputType = TextInputType.phone,
  }) =>
      Card(
        child: TextFormField(
          controller: controller,
          autofocus: true,
          keyboardType: inputType,
          key: Key('$key-TextFormField'),
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            errorMaxLines: 1,
            prefix: Text("  " + prefix + "  "),
          ),
        ),
      );

  static Widget phoneNumberFieldWidget({
    TextEditingController controller,
    String code,
    String key,
    String flag,
    String hintText,
    Function onPressed,
    bool autofocus = true,
    double fontSize = 18.0,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: <Widget>[
            Container(
              child: InkWell(
                onTap: onPressed,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        ' $flag  $code ',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontFamily: AppTheme.fontName,
                          color: Colors.green,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 24.0,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller,
                autofocus: autofocus,
                keyboardType: TextInputType.phone,
                key: Key('$key-TextFormField'),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  errorMaxLines: 1,
                  hintText: hintText,
                ),
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: AppTheme.fontName,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      );

  static Widget selectableTextField({
    VoidCallback onTap,
    TextEditingController controller,
    String key,
    String hintText,
    bool autofocus = true,
    double fontSize = 18.0,
    TextInputType inputType = TextInputType.text,
    BorderRadius borderRadius,
    Icon icon,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: IgnorePointer(
            child: textField(
              controller: controller,
              key: key,
              hintText: hintText,
              autofocus: autofocus,
              fontSize: fontSize,
              inputType: inputType,
              borderRadius: borderRadius,
              icon: icon,
            ),
          ),
        ),
      );

  static Widget dropDownField({
    String key,
    String hintText,
    BorderRadius borderRadius,
    bool isExpanded = true,
    String value,
    List<DropdownMenuItem<String>> items,
    Function(String txt) onChanged,
    bool showIcon = false,
    Icon icon,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius:
              borderRadius != null ? borderRadius : BorderRadius.circular(7),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              showIcon ? icon : Container(),
              showIcon
                  ? SizedBox(
                      width: 10,
                    )
                  : Container(),
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: isExpanded,
                  value: value,
                  hint: Text(hintText),
                  items: items,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      );

  static Widget textField({
    TextEditingController controller,
    String key,
    String hintText,
    bool autofocus = true,
    double fontSize = 18.0,
    TextInputType inputType = TextInputType.text,
    BorderRadius borderRadius,
    Icon icon,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius:
              borderRadius != null ? borderRadius : BorderRadius.circular(7),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: TextFormField(
            controller: controller,
            autofocus: autofocus,
            keyboardType: inputType,
            key: Key('$key-TextFormField'),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorMaxLines: 1,
              hintText: hintText,
              icon: icon,
            ),
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: AppTheme.fontName,
              color: Colors.green,
            ),
          ),
        ),
      );

  static Widget formField({
    String label,
    TextEditingController controller,
    String key,
    String hintText,
    bool autofocus = true,
    double fontSize = 18.0,
    TextInputType inputType,
  }) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: AppTheme.fontName,
                color: Colors.green,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            textField(
              controller: controller,
              key: key,
              hintText: hintText,
              autofocus: autofocus,
              fontSize: fontSize,
              inputType: inputType,
            ),
          ],
        ),
      );

  static Widget phoneNumberWidget({
    TextEditingController controller,
    String code,
    String key,
    String flag,
    String hintText,
    Function onPressed,
    Color color,
    bool autofocus = true,
    double fontSize = 18.0,
  }) =>
      phoneNumberFieldWidget(
        code: code,
        controller: controller,
        flag: flag,
        hintText: hintText,
        onPressed: onPressed,
        autofocus: autofocus,
        fontSize: fontSize,
      );

  static Widget phoneNumberInputField({
    TextEditingController controller,
    String code,
    String key,
    String flag,
    String hintText,
    Function onPressed,
    Color color,
    bool autofocus = true,
  }) =>
      Card(
        color: color,
        child: phoneNumberFieldWidget(
          code: code,
          controller: controller,
          flag: flag,
          hintText: hintText,
          onPressed: onPressed,
          autofocus: autofocus,
        ),
      );

  static Widget selectableWidget(
          {String displayText, Object object, Function selectThisObject}) =>
      Material(
        color: Colors.white,
        type: MaterialType.canvas,
        child: InkWell(
          onTap: () => selectThisObject(object),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: Text(
              displayText,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );

  static Widget selectDropDown({
    String prefixText,
    String text,
    Function onPressed,
  }) =>
      Card(
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text(' $prefixText  $text ')),
                Icon(Icons.arrow_drop_down, size: 24.0)
              ],
            ),
          ),
        ),
      );

  static Widget subTitle(
          {String text, Color color = Colors.white, double fontSize = 14.0}) =>
      Align(
          alignment: Alignment.centerLeft,
          child: Text(' $text',
              style: TextStyle(color: color, fontSize: fontSize)));

  TextFormField getCustomEditTextField(
      {String hintValue = "",
      TextEditingController controller,
      EdgeInsetsGeometry contentPadding =
          const EdgeInsets.symmetric(vertical: 5),
      Widget prefixWidget,
      Widget suffixWidget,
      TextStyle style,
      Function validator,
      bool obscureValue = false,
      int maxLines = 1,
      TextInputType keyboardType}) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixWidget,
        suffixIcon: suffixWidget,
        contentPadding: contentPadding,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 5.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: AppTheme.lightColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: AppTheme.lightColor),
        ),
        hintText: hintValue,
        hintStyle: style,
      ),
      style: style,
      validator: validator,
      obscureText: obscureValue,
    );
  }
}
