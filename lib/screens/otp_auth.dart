import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:land_registration/providers/MetamaskProvider.dart';
import 'package:land_registration/constant/loadingScreen.dart';
import 'package:land_registration/screens/registerUser.dart';
import 'package:provider/provider.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../providers/LandRegisterModel.dart';
import '../constant/utils.dart';
import 'dart:async'; 
import 'dart:convert'; 
import 'package:http/http.dart' as http;

class CheckOtp extends StatefulWidget {
  final String val;
  const CheckOtp({Key? key, required this.val}) : super(key: key);

  @override
  _CheckOtpState createState() => _CheckOtpState();
}

class _CheckOtpState extends State<CheckOtp> {
  String otp = "";
  String errorMessage = "";
  bool isDesktop = false;
  double width = 590;
  bool _isObscure = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController keyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<LandRegisterModel>(context);
    var model2 = Provider.of<MetaMaskProvider>(context);
    width = MediaQuery.of(context).size.width;

    if (width > 600) {
      isDesktop = true;
      width = 590;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF272D34),
        title: const Text('Login'),
      ),
      body: Container(
        //width: 500,
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            // SvgPicture.asset(
            //   'assets/otp.svg',
            //   height: 300.0,
            //   width: 520.0,
            //   allowDrawingOutsideViewBox: true,
            // ),
            Image.asset(
              'assets/otp.jpg',
              height: 280,
              width: 600,
            ),
            const Text(
                '\nPlease enter the OTP sent to your mobile', style:TextStyle(fontSize:18.0,height:1)),
            SizedBox(
              width: 350,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: keyController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter otp';
                      }
                      return null;
                    },
                    obscureText: _isObscure,
                    onChanged: (val) {
                      otp = val;
                    },
                    decoration: InputDecoration(
                      suffixIcon: MaterialButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () async {
                          final clipPaste =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          keyController.text = clipPaste!.text!;
                          otp = keyController.text;
                          setState(() {});
                        },
                        child: const Text(
                          "Paste",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      suffix: IconButton(
                          iconSize: 20,
                          constraints: const BoxConstraints.tightFor(
                              height: 15, width: 15),
                          padding: const EdgeInsets.all(0),
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }),
                      border: const OutlineInputBorder(),
                      labelText: 'OTP',
                      hintText: 'Enter Your OTP',
                    ),
                  ),
                ),
              ),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
            CustomButton(
                'Verify',
                isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          otp = otp;
                          //print(privateKey);
                          connectedWithMetamask = false;
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await model.initiateSetup();

                           
                              }catch (e) {
                            print(e);
                            showToast("Something Went Wrong",
                                context: context, backgroundColor: Colors.red);
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }),
            
            isLoading ? spinkitLoader : Container()
          ],
        ),
      ),
    );
  }
}
