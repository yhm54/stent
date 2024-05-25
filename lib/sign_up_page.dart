// ignore_for_file: use_build_context_synchronously, prefer__ructors, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stent/grid.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'gridSpaceProvider.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool idCorr = true;
  bool pwCorr = true;
  bool confirmPw = true;

  bool idFocus = true;
  bool passwordFocus = false;
  bool cPasswordFocus = false;
  bool shopNameFocus = false;

  TextEditingController shopName = TextEditingController();

  TextEditingController lID = TextEditingController();

  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();

  void submit(value) async {
    if (validate(
      lID.text,
      password.text,
      cPassword.text,
    ))
    // this.validateId(lID.text);
    {
      print('happening');
      final url = Uri.https(
        'stent-ebe62-default-rtdb.firebaseio.com',
        'stent-db.json',
      );
      // http.post(
      //   url,
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      //   body: json.encode(
      //     {
      //       'loginID': [
      //         lID.text,
      //         cPassword.text,
      //       ],
      //       // 'loginID': lID,
      //       'shapeInventory': value.selGS,
      //     },
      //   ),
      // );
      var response = await http.get(url);
      print("resbody" + response.body);
      if (response.body != 'null') {
        Map<String, dynamic> data = json.decode(response.body);
        for (var ent in data.entries) {
          // print()
          if (ent.value['loginID'][0] == lID.text) {
            setState(() {
              incorrectCredentials = true;
              helperText =
                  "Choose another ID. '${lID.text}' already exists. Else log in.";
            });
            return;
            // break;
          } else {
            setState(
              () {
                incorrectCredentials = false;
              },
            );
            // break;
          }
        }
        incorrectCredentials = false;
      }

      // if (!validatepassword(password.text)) {
      //   setState(() {
      //     pwCorr = false;
      //   });
      // } else {
      //   setState(() {
      //     pwCorr = true;
      //   });
      // }
      // if (password.text != cPassword.text) {
      //   setState(() {
      //     confirmPw = false;
      //   });
      // } else {
      //   setState(() {
      //     confirmPw = true;
      //   });
      // }

      value.setId(lID.text);
      value.setPw(cPassword.text);
      value.setSN(shopName.text);

      !incorrectCredentials
          ? showModalBottomSheet(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              isScrollControlled: true,
              // useSafeArea: true,
              context: context,
              builder: (ctx) {
                return GridLayoutBuilder();
              },
            )
          : ();
    } else {
      setState(() {
        incorrectCredentials = true;
      });
    }

    lID.text = "";
    password.text = "";
    cPassword.text = "";

    // lID.text ="";
    // shopName.text = "";
    // password.text = "";
    // cPassword.text = "";

    // else {
    //   Navigator.of(context).push(
    //     MaterialPageRoute<void>(
    //       builder: (BuildContext context) =>  AlertDialog(
    //         title: Text('Yash'),
    //       ),
    //     ),
    //   );
    // }
  }

  bool validate(String id, String password, String cPassword) {
    if (RegExp(r'[!@#$%^&*()_]').hasMatch(id) || id.length < 5) {
      setState(() {
        helperText =
            "ID can't contain special characters and should have a minimum length of 5 characters.";
      });
      return false;
    } else if (RegExp(r' ').hasMatch(password) || password.length < 5) {
      setState(() {
        helperText = "Password can't contain spaces.";
      });

      return false;
    } else if (password != cPassword) {
      setState(() {
        helperText = "passwords don't match.";
      });

      return false;
    }
    return true;
  }

  bool incorrectCredentials = false;

  String helperText = "Some error occured. Please try again.";

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color onPrimaryColor = Theme.of(context).colorScheme.onPrimary;

    var wt = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;

    return Consumer<GSProvider>(
      builder: (BuildContext context, GSProvider value, Widget? child) {
        lID.text = value.id;
        shopName.text = value.sN;
        password.text = value.pw;
        cPassword.text = value.pw;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            toolbarHeight: ht * 0.1,
            title: Text(
              'Sign-Up Page',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: onPrimaryColor,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              // padding:
              //     EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              height: ht,
              padding: EdgeInsets.symmetric(
                vertical: wt * 0.054,
                // vertical: wt * 0.1,
                horizontal: wt * 0.024,
              ),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.6),
                image: DecorationImage(
                  repeat: ImageRepeat.repeat,
                  opacity: 0.1,
                  image: AssetImage(
                    "assets/images/stent_bg_1.jpeg",
                  ),
                ),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  incorrectCredentials
                      ? Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: ht * 0.027),
                          width: wt,
                          // color: Colors.white.withOpacity(0.6),
                          height: ht * 0.054,
                          child: Text(
                            "$helperText",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : SizedBox(),
                  TextFormField(
                    // focusNode: ,
                    // autofocus: idFocus,
                    // onFieldSubmitted: (v) => Focus.of(context).unfocus(),

                    controller: lID,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: onPrimaryColor,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: onPrimaryColor,
                        ),
                      ),
                      label: Text(
                        'Create Login ID',
                        style: TextStyle(
                            fontSize: ht * 0.0254,
                            color: onPrimaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ht * 0.0254,
                  ),
                  TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: onPrimaryColor,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: onPrimaryColor,
                        ),
                      ),
                      label: Text(
                        'Create password',
                        style: TextStyle(
                            fontSize: ht * 0.0254,
                            color: onPrimaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ht * 0.0254,
                  ),
                  TextFormField(
                    controller: cPassword,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: onPrimaryColor,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: onPrimaryColor,
                        ),
                      ),
                      label: Text(
                        'Confirm password',
                        style: TextStyle(
                            fontSize: ht * 0.0254,
                            color: onPrimaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ht * 0.0254,
                  ),
                  TextFormField(
                    onFieldSubmitted: (v) => submit(value),
                    controller: shopName,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      label: Text(
                        'Shop Name',
                        style: TextStyle(
                            fontSize: ht * 0.0254,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ht * 0.0254,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: TextButton(
            style: ButtonStyle(
              padding: MaterialStatePropertyAll(
                EdgeInsets.all(
                  ht * 0.02,
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                onPrimaryColor,
              ),
            ),
            onPressed: () => submit(value),
            child: Text(
              'Create Store Layout ->',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
