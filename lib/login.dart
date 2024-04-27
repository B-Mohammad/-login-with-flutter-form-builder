import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:tanker_login/custom_input.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool active = false;
  bool error = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
          ),
          height: height * 0.5,
          width: width * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: [
                    FormBuilderField(
                        builder: (field) {
                          return CoustomTextFiled(
                              width: width * 0.33,
                              height: height * 0.06,
                              // keyboardType: TextInputType.phone,
                              hintText: "شماره موبایل",
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              maxLength: 11,
                              onChanged: (value) {
                                field.didChange(value);
                              });
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.equalLength(11),
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric()
                        ]),
                        name: "phone"),
                    const SizedBox(
                      height: 20,
                    ),
                    FormBuilderField(
                      builder: (field) {
                        return CoustomTextFiled(
                            width: width * 0.33,
                            height: height * 0.06,
                            passwordType: true,
                            hintText: "رمز عبور",
                            onChanged: (value) {
                              field.didChange(value);
                            });
                      },
                      name: "pass",
                      // autovalidateMode: AutovalidateMode.always,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    Container(
                        alignment: AlignmentDirectional.centerEnd,
                        width: width * 0.33,
                        height: height * 0.06,
                        child: error
                            ? Text(
                                "رمز اشتباه است",
                                style: TextStyle(color: Colors.red[800]),
                              )
                            : null),
                    const SizedBox(
                      height: 60,
                    ),
                    ElevatedButton(
                      onPressed: active
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                error = false;
                                String phone = _formKey
                                    .currentState!.fields["phone"]!.value
                                    .toString();
                                String pass = _formKey
                                    .currentState!.fields["pass"]!.value
                                    .toString();
                                bool access = false;
                                await login(phone, pass).then((value) {
                                  setState(() {
                                    access = value;
                                  });
                                  if (access == true) {
                                    // print(access);
                                    context.go("/dashboard");
                                  }
                                });
                              } else {
                                setState(() {
                                  error = true;
                                });
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          fixedSize: Size(width * 0.33, height * 0.06),
                          backgroundColor: Colors.blue.shade800),
                      child: const Text(
                        "ارسال",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                onChanged: () {
                  if (_formKey.currentState!.fields["phone"]!.value
                          .toString()
                          .length ==
                      11) {
                    setState(() {
                      active = true;
                    });
                  } else {
                    setState(() {
                      active = false;
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  //check user and pass
  Future<bool> login(String user, String pass) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool access = false;
    try {
      //post request for take token
      var response = await Dio().post(
          "https://organization.darkube.app/account/auth/token",
          options: Options(headers: {"X-Device-id": "1234"}),
          data: {
            "username": user,
            "password": pass,
          });
      if (response.statusCode == 200) {
        String token = response.data["access_token"];
        pref.setString("token", token); //save tocken in local storage
        access = true;
      }
    } on Exception catch (e) {
      print("error: ${e.toString()}");

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("user name or pass is invalid!")));
    }
    return access;
  }
}
