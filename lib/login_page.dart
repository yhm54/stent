// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stent/shopkeeper_home.dart';
import 'package:stent/sign_up_page.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  showSignUpPage(BuildContext ctx) {
    Navigator.of(ctx).pop();
    Navigator.of(ctx).push(
      MaterialPageRoute(builder: (ctx) => SignUpPage()),
    );
  }

  // showHomePage(BuildContext ctx) {
  //   Navigator.of(ctx).pop();
  //   Navigator.of(ctx).push(
  //     MaterialPageRoute(builder: (ctx) => ShopkeeperHomePage(shopSearchData)),
  //   );
  // }

  bool credentialsEntered = false;

  bool idCorr = false;

  Color specialBlue = Color.fromARGB(107, 41, 130, 203);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    TextEditingController enteredId = TextEditingController(text: "hi");
    TextEditingController enteredPassword = TextEditingController();
    var ht = MediaQuery.of(context).size.height;
    var wt = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          toolbarHeight: ht * 0.1,
          title: const Text(
            'Login Page',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          flexibleSpace: Container(
            // ,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.only(
              //   bottomLeft: Radius.circular(10),
              //   bottomRight: Radius.circular(10),
              // ),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        body: Container(
          height: ht,
          width: wt,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            image: DecorationImage(
              opacity: 0.1,
              // fit: BoxFit.scaleDown,
              // scale: 0.5,
              repeat: ImageRepeat.repeat,
              image: AssetImage(
                "assets/images/stent_bg_1.jpeg",
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(
            // vertical: ht * 0.027,
            horizontal: wt * 0.024,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              credentialsEntered == false
                  ? SizedBox(
                      height: 0,
                    )
                  : idCorr
                      ? SizedBox(height: 0)
                      : Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: ht * 0.01),
                          width: wt,
                          color: Colors.red,
                          height: ht * 0.054,
                          child: Text(
                            'Incorrect credentials.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
              credentialsEntered == false
                  ? SizedBox(
                      height: ht * 0.027,
                    )
                  : SizedBox(
                      height: 0,
                    ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                  // color: primaryColor,
                ),
                child: TextField(
                  controller: enteredId,
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
                      'Enter Login ID',
                      style: TextStyle(
                        fontSize: ht * 0.0254,
                        color: onPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ht * 0.027,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: TextField(
                  controller: enteredPassword,
                  decoration: InputDecoration(
                    // color: Theme.of(context).colorScheme.primary,
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
                      'Enter Password',
                      style: TextStyle(
                          fontSize: ht * 0.0254,
                          color: onPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ht * 0.027,
              ),
              TextButton(
                
                style: ButtonStyle(
                  splashFactory: InkSplash.splashFactory,
                  backgroundColor: MaterialStateProperty.all(
                    onPrimaryColor,
                  ),
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(
                      vertical: ht * 0.0154,
                      horizontal: wt * 0.04,
                    ),
                  ),
                ),
                onPressed: () async {
                  dynamic allShopSearchData = [];
                  dynamic shopSearchData = [];
                  final url = Uri.https(
                    'stent-ebe62-default-rtdb.firebaseio.com',
                    'stent-db.json',
                  );
                  var response = await http.get(url);
                  Map<String, dynamic> data = json.decode(response.body);
                  final url2 = Uri.https(
                    'stent-ebe62-default-rtdb.firebaseio.com',
                    'stent-search-db.json',
                  );
                  var response2 = await http.get(url2);
                  if (response2.body != 'null') {
                    Map<String, dynamic> data2 = json.decode(response2.body);
                    for (var element in data2.entries) {
                      allShopSearchData.add(element.value);
                    }
                  }
                  // print(data2);
              
                  //   List elData = element
                  //       .toString()
                  //       .substring(element.toString().indexOf('{') + 1)
                  //       .replaceAll('}', '')
                  //       .replaceAll(')', '')
                  //       .replaceAll(' ', '')
                  //       .split(',');
                  //   print('elData');
                  //   print(elData);
                  //   allShopSearchData.add(
                  //     {
                  //       'shopName': elData[3]
                  //           .toString()
                  //           .trim()
                  //           .replaceAll("shopName:", ''),
                  //       'search': elData[2]
                  //           .toString()
                  //           .trim()
                  //           .replaceAll("search:", ''),
                  //       'countAdded': elData[1]
                  //           .toString()
                  //           .trim()
                  //           .replaceAll("countAdded:", ''),
                  //       'addedToCart': elData[0]
                  //           .toString()
                  //           .trim()
                  //           .replaceAll("addedToCart:", ''),
                  //     },
                  //   );
                  // }
              
                  // print('allShopSearchData');
                  // print(allShopSearchData);
                  for (var ent in data.entries) {
                    // print(ent.value);
                    if ((ent.value['loginID'][0] == enteredId.text) &&
                        (ent.value['loginID'][1] == enteredPassword.text)) {
                      dynamic shopLayoutData = ent.value;
              
                      for (var el in allShopSearchData) {
                        if ((el['shopName']) == ent.value['shopName']) {
                          shopSearchData.add(el);
                        }
                      }
              
                      // print("shopSearchData");
                      // print("shopSearchData");
                      // print(shopSearchData);
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (ctx) => ShopkeeperHomePage(
                            shopLayoutData,
                            shopSearchData,
                          ),
                          // builder: (ctx) => ShopkeeperHomePage(shopSearchData),
                        ),
                      )
                          .then((value) {
                        setState(() {
                          credentialsEntered = false;
                          idCorr = true;
                        });
                      });
              
                      break;
                    } else {
                      setState(() {
                        credentialsEntered = true;
                        idCorr = false;
                      });
                    }
                  }
                  // }
                },
                child: Text(
                  'LOGIN ->',
                  style: TextStyle(
                    fontSize: ht * 0.027,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: ht * 0.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New?',
                    style: TextStyle(
                        fontSize: ht * 0.0254,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      showSignUpPage(context);
                    },
                    child: Text(
                      'COME ONBOARD',
                      style: TextStyle(
                        // background: ,
                        fontSize: ht * 0.0254,
                        color: onPrimaryColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
