import 'package:covid_app/blocs/authentication/authentication_bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/widgets/app_widget.dart';
import 'package:covid_app/views/widgets/button.dart';
import 'package:flutter/material.dart';
// import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BarcodeScanScreen extends StatefulWidget {
  final AppUser appUser;

  const BarcodeScanScreen({Key key, this.appUser}) : super(key: key);
  @override
  _BarcodeScanScreenState createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  AppUser appUser;

  AuthenticationBloc _authenticationBloc;
  TextEditingController codeController;

  void fetchUser() async {
    appUser = await _authenticationBloc.getCurrentUser();
    setState(() {});
  }

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    if (widget.appUser != null) {
      appUser = widget.appUser;
    } else
      fetchUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pair 2 Ride'),
        backgroundColor: AppTheme.primaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  QrImage(
                    size: 200,
                    data: appUser.userId,
                    // foregroundColor: AppTheme.primaryColor,
                    version: QrVersions.auto,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CODE: ',
                        style: AppTheme.textFieldTitlePrimaryColored,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        appUser.userId,
                        style: AppTheme.textFieldTitlePrimaryColored.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Button(
                    text: 'Scan to Pair',
                    onTap: () async {
                      // if ÷ {
                      // ScanResult result = await BarcodeScanner.scan(
                      //     options: ScanOptions(
                      //   autoEnableFlash: true,
                      // ));
                      // String data = result.rawContent;
                    },
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Button(
                    isOutlined: true,
                    text: 'Enter code to Pair',
                    onTap: () {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        backgroundColor: Color(0xFFFDFDFD),
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => CodeScreenModal(
                          codeEditController: codeController,
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CodeScreenModal extends StatelessWidget {
  final TextEditingController codeEditController;
  final VoidCallback onPair;
  const CodeScreenModal({
    Key key,
    this.codeEditController,
    this.onPair,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: 3,
              decoration: ShapeDecoration(
                shape: StadiumBorder(),
                color: Color(0xFFF4F5F4),
              ),
            ),
            SizedBox(height: 18),
            Text(
              'Enter Code to Pair',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            // SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 18),

            Container(
              height: MediaQuery.of(context).viewInsets.bottom + 100,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppWidgets().getCustomEditTextField(
                    hintValue: 'xxxxxxxxx',
                    prefixWidget: Padding(
                      padding: const EdgeInsets.only(left: 9),
                      child: Image.asset(
                        'assets/images/icons/hash.png',
                        scale: 3,
                      ),
                    ),
                    controller: codeEditController,
                    style: AppTheme.textFieldTitlePrimaryColored,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            Button(
              text: 'Pair',
              onTap: onPair,
            ),
          ],
        ),
      ),
    );
  }
}
