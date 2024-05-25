// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:stent/analysis.dart';
import 'package:stent/gridSpaceProvider.dart';
import 'package:stent/login_page.dart';
import 'customer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    ChangeNotifierProvider<GSProvider>(
      create: (_) => GSProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STENT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          onPrimary: Color.fromARGB(255, 27, 67, 76),
          primary: Color.fromARGB(255, 247, 228, 217),
          secondary: Colors.brown,
        ),
        useMaterial3: true,
      ),
      home: const Stent(),
    );
  }
}

class Stent extends StatefulWidget {
  const Stent({super.key});

  @override
  State<Stent> createState() => _StentState();
}

class _StentState extends State<Stent> {
  bool connectingToDB = false;

  void customerPage(BuildContext ctx, List allData, List dbID, List dbshopD,
      List dbCol, List dbPFE, List dbCP) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (ctx) {
          return Customer(allData, dbID, dbshopD, dbCol, dbPFE);
        },
      ),
    );
  }

  void loginPage(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (ctx) => const LoginPage(),
      ),
    );
  }

  Color headerBarColor = Color.fromARGB(255, 27, 67, 76);

  @override
  Widget build(BuildContext context) {
    List dbShopD = [];
    List dbD = [];
    List dbID = [];
    List<int> dbCol = [];
    List dbSN = [];
    List dbPFE = [];
    List dbCP = [];
    var ht = MediaQuery.of(context).size.height;
    var wt = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ht * 0.127,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: ht * 0.09,
              width: wt * 0.2,
              padding: EdgeInsets.only(
                bottom: ht * 0.01,
                // vertical: ht * 0.01,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  // colorFilter: ColorFilter.linearToSrgbGamma(),
                  // invertColors: true,
                  fit: BoxFit.fitHeight,
                  image: AssetImage(
                    "assets/images/stent_logo-removebg-preview.png",
                  ),
                ),
              ),
            ),
            Text(
              "STENT",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: ht * 0.036,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          // height: ht * 0.3,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                  wt * 0.1,
                ),
              ),
              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.centerRight,
              //   colors: <Color>[
              //     Colors.blue,
              //     Colors.blue,
              //   ],
              // ),
              color: headerBarColor,
            ),
          ),
        ),
      ),
      body: Container(
      
        color: Theme.of(context).colorScheme.onPrimary,
        child: Container(
          decoration: BoxDecoration(
            // boxShadow: List.filled(),
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(
                wt * 0.077,
              ),
              
            ),
            // color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: ht * 0.054,
            ),
            width: wt,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  wt * 0.077,
                ),
                
              ),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/stent_bg_1.jpeg",
                ),
                repeat: ImageRepeat.repeat,
                opacity: 0.1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                connectingToDB
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.symmetric(
                          horizontal: wt * 0.02,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            wt * 0.054,
                          ),
                          color: headerBarColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: null,
                              child: Container(
                                // margin: EdgeInsets.all(10),
                                height: ht * 0.12,
                                padding: EdgeInsets.symmetric(
                                  horizontal: wt * 0.054,
                                ),
                                decoration: BoxDecoration(
                                  // color: Color.fromARGB(255, 247, 228, 217),
                                  color: Theme.of(context).colorScheme.primary,
      
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/customer_bg.png",
                                    ),
                                    repeat: ImageRepeat.noRepeat,
                                    opacity: 0.154,
                                  ),
                                  border: Border.all(
                                    color: headerBarColor,
                                    width: 4,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    wt * 0.054,
                                  ),
                                  // color: Color.fromARGB(255, 247, 228, 217),
                                ),
                                child: Center(
                                  child: Text(
                                    'CUSTOMER',
                                    style: TextStyle(
                                      color: headerBarColor,
                                      fontSize: ht * 0.03,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                // margin: EdgeInsets.only(
                                //   right: wt * 0.1,
                                // ),
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.symmetric(
                          horizontal: wt * 0.02,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            wt * 0.054,
                          ),
                          color: headerBarColor,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                // var x = [];
      
                                setState(() => connectingToDB = true);
      
                                final url = Uri.https(
                                  'stent-ebe62-default-rtdb.firebaseio.com',
                                  'stent-db.json',
                                );
                                var response = await http.get(url);
                                if (response.body == "null") {
                                  setState(() {
                                    connectingToDB = false;
                                  });
                                  return;
                                }
                                print(response.body);
                                Map<String, dynamic> dbData =
                                    json.decode(response.body);
                                for (var element in dbData.entries) {
                                  // print('element in dbentries');
                                  print(element.value);
                                  dbD.add(element.value);
                                  dbID.add(element.value['loginID']);
                                  dbShopD.add(json
                                      .decode(element.value['shapeInventory']));
                                  dbCol.add(element.value['cols']);
                                  dbSN.add(element.value['shopName']);
                                  dbPFE.add(element.value['positionForEntry']);
                                  dbCP.add(element.value['counterPositions']);
                                }

      
                                print('///');
                                print(dbD);
                                print('///');
                                print(dbPFE);
      
                                setState(() {
                                  connectingToDB = false;
                                });
                                // print(json.decode(dbD[1])[0]);
      
                                // dbD == sample ? print('yesh') : print('no');
      
                                customerPage(
                                  context,
                                  // json.decode(dbD),
      
                                  dbD,
                                  dbSN,
                                  dbShopD,
                                  dbCol,
                                  dbPFE,
                                  dbCP,
                                );
                              },
                              // style: ButtonStyle(
                              //   backgroundColor:
                              //       MaterialStateProperty.all(Colors.white),
                              //   shape: MaterialStateProperty.all(
                              //     RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(15),
                              //     ),
                              //   ),
                              //   padding: MaterialStateProperty.all(
                              //     EdgeInsets.symmetric(
                              //         horizontal:
                              //             MediaQuery.of(context).size.width * 0.1,
                              //         vertical:
                              //             MediaQuery.of(context).size.height * 0.025),
                              //   ),
                              // ),
                              child: Container(
                                // margin: EdgeInsets.all(10),
                                height: ht * 0.12,
                                // width: ht * 0.22,
                                padding: EdgeInsets.symmetric(
                                  horizontal: wt * 0.054,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                            
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/customer_bg.png",
                                    ),
                                    repeat: ImageRepeat.noRepeat,
                                    opacity: 0.154,
                                  ),
                                  border: Border.all(
                                    color: headerBarColor,
                                    width: 4,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    wt * 0.054,
                                  ),
                                  // color: Color.fromARGB(255, 247, 228, 217),
                                ),
                                child: Center(
                                  child: Text(
                                    'CUSTOMER',
                                    style: TextStyle(
                                      color: headerBarColor,
                                      fontSize: ht * 0.03,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: 8,
                              ),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.circle,
                                            size: ht * 0.0127,
                                            color: Colors.white),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            'Search Product',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ht * 0.018,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.circle,
                                            size: ht * 0.0127,
                                            color: Colors.white),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            'Locate Product',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ht * 0.018,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.circle,
                                            size: ht * 0.0127,
                                            color: Colors.white),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            'Buy Product',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ht * 0.018,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.symmetric(
                    horizontal: wt * 0.02,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      wt * 0.054,
                    ),
                    color: headerBarColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.circle,
                                    size: ht * 0.0127, color: Colors.white),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    'Shop Analytics',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ht * 0.018,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.circle,
                                    size: ht * 0.0127, color: Colors.white),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    'Inventory Management',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ht * 0.018,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: connectingToDB
                            ? null
                            : () {
                                loginPage(context);
                              },
                        // style: ButtonStyle(
                        //   backgroundColor: MaterialStateProperty.all(Colors.white),
                        //   shape: MaterialStateProperty.all(
                        //     RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(15),
                        //     ),
                        //   ),
                        //   padding: MaterialStateProperty.all(
                        //     EdgeInsets.symmetric(
                        //         horizontal: MediaQuery.of(context).size.width * 0.1,
                        //         vertical: MediaQuery.of(context).size.height * 0.025),
                        //   ),
                        // ),
                        child: Container(
                          height: ht * 0.12,
                          padding: EdgeInsets.symmetric(
                            horizontal: wt * 0.054,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
      
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/shopkeeper_bg-removebg-preview.png",
                              ),
                              repeat: ImageRepeat.noRepeat,
                              opacity: 0.154,
                            ),
                            border: Border.all(
                              color: headerBarColor,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(
                              wt * 0.054,
                            ),
                            // color: Color.fromARGB(255, 247, 228, 217),
                          ),
                          child: Center(
                            child: Text(
                              'SHOPKEEPER',
                              style: TextStyle(
                                color: headerBarColor,
                                fontSize: ht * 0.03,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                // Container(
                //   child: InkWell(
                //     onTap: connectingToDB
                //         ? null
                //         : () {
                //             loginPage(context);
                //           },
                //     // style: ButtonStyle(
                //     //   backgroundColor: MaterialStateProperty.all(Colors.white),
                //     //   shape: MaterialStateProperty.all(
                //     //     RoundedRectangleBorder(
                //     //       borderRadius: BorderRadius.circular(15),
                //     //     ),
                //     //   ),
                //     //   padding: MaterialStateProperty.all(
                //     //     EdgeInsets.symmetric(
                //     //         horizontal: MediaQuery.of(context).size.width * 0.1,
                //     //         vertical: MediaQuery.of(context).size.height * 0.025),
                //     //   ),
                //     // ),
                //     child: Container(
                //       height: ht * 0.12,
                //       width: wt * 0.54,
                //       padding: EdgeInsets.symmetric(
                //         horizontal: wt * 0.054,
                //       ),
                //       decoration: BoxDecoration(
                //         color: Theme.of(context).colorScheme.primary,
      
                //         image: DecorationImage(
                //           image: AssetImage(
                //             "assets/images/shopkeeper_bg-removebg-preview.png",
                //           ),
                //           repeat: ImageRepeat.noRepeat,
                //           opacity: 0.154,
                //         ),
                //         border: Border.all(
                //           color: headerBarColor,
                //           width: 4,
                //         ),
                //         borderRadius: BorderRadius.circular(
                //           wt * 0.054,
                //         ),
                //         // color: Color.fromARGB(255, 247, 228, 217),
                //       ),
                //       child: Center(
                //         child: Text(
                //           'SHOPKEEPER',
                //           style: TextStyle(
                //             color: headerBarColor,
                //             fontSize: ht * 0.03,
                //             fontWeight: FontWeight.w900,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.03,
                // ),
                // Container(
                //   child: InkWell(
                //     onTap: connectingToDB
                //         ? null
                //         : () {
                //             loginPage(context);
                //           },
                //     // style: ButtonStyle(
                //     //   backgroundColor: MaterialStateProperty.all(Colors.white),
                //     //   shape: MaterialStateProperty.all(
                //     //     RoundedRectangleBorder(
                //     //       borderRadius: BorderRadius.circular(15),
                //     //     ),
                //     //   ),
                //     //   padding: MaterialStateProperty.all(
                //     //     EdgeInsets.symmetric(
                //     //         horizontal: MediaQuery.of(context).size.width * 0.1,
                //     //         vertical: MediaQuery.of(context).size.height * 0.025),
                //     //   ),
                //     // ),
                //     child: Container(
                //       height: ht * 0.12,
                //       width: wt * 0.54,
                //       padding: EdgeInsets.symmetric(
                //         horizontal: wt * 0.054,
                //       ),
                //       decoration: BoxDecoration(
                //         color: Theme.of(context).colorScheme.primary,
      
                //         image: DecorationImage(
                //           image: AssetImage(
                //             "assets/images/customer_bg.png",
                //           ),
                //           repeat: ImageRepeat.noRepeat,
                //           opacity: 0.154,
                //         ),
                //         border: Border.all(
                //           color: headerBarColor,
                //           width: 4,
                //         ),
                //         borderRadius: BorderRadius.circular(
                //           wt * 0.054,
                //         ),
                //         // color: Color.fromARGB(255, 247, 228, 217),
                //       ),
                //       child: Center(
                //         child: Text(
                //           'CUSTOMER',
                //           style: TextStyle(
                //             color: headerBarColor,
                //             fontSize: ht * 0.03,
                //             fontWeight: FontWeight.w900,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.03,
                // ),
                // Container(
                //   margin: EdgeInsets.symmetric(
                //     horizontal: wt * 0.027,
                //   ),
                //   height: ht * 0.1,
                //   alignment: Alignment.center,
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).colorScheme.primary,
                //     borderRadius: BorderRadius.circular(
                //       wt * 0.027,
                //     ),
                //     border: Border.all(
                //       color: Theme.of(context).colorScheme.onPrimary,
                //       width: wt * 0.0054,
                //     ),
                //   ),
                //   child: ListTile(
                //     // style: ListTileStyle.list,
      
                //     leading: null,
                //     title: Text('CUSTOMER'),
                //     titleTextStyle: TextStyle(
                //       color: headerBarColor,
                //       fontSize: ht * 0.026,
                //       fontWeight: FontWeight.w800,
                //     ),
                //     subtitle: Text(
                //       'SEARCH AND LOCATE PRODUCTS',
                //       style: TextStyle(
                //         color: headerBarColor,
                //         fontSize: ht * 0.01632,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //     trailing: Image(
                //       image: AssetImage("assets/images/customer_bg.png"),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.03,
                // ),
                // Container(
                //   margin: EdgeInsets.symmetric(
                //     horizontal: wt * 0.027,
                //   ),
                //   height: ht * 0.1,
                //   alignment: Alignment.center,
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).colorScheme.primary,
                //     borderRadius: BorderRadius.circular(
                //       wt * 0.027,
                //     ),
                //     border: Border.all(
                //       color: Theme.of(context).colorScheme.onPrimary,
                //       width: wt * 0.0054,
                //     ),
                //   ),
                //   child: ListTile(
                //     horizontalTitleGap: 0,
                //     // style: ListTileStyle.list,
      
                //     leading: null,
                //     title: Text('SHOPKEEPER'),
                //     titleTextStyle: TextStyle(
                //       color: headerBarColor,
                //       fontSize: ht * 0.026,
                //       fontWeight: FontWeight.w800,
                //     ),
                //     subtitle: Text(
                //       'ANALYTICS AND INVENTORY MANAGEMENT',
                //       style: TextStyle(
                //         color: headerBarColor,
                //         fontSize: ht * 0.01632,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //     trailing: Image(
                //       // opacity: Animation.fromValueListenable(),
                //       image: AssetImage(
                //           "assets/images/shopkeeper_bg-removebg-preview.png"),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.03,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
