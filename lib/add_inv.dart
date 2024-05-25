// ignore_for_file: prefer_const_constructors, avoid_, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stent/gridSpaceProvider.dart';
import 'package:http/http.dart' as http;
import 'package:stent/login_page.dart';

class inventoryAddition extends StatefulWidget {
  const inventoryAddition({super.key});
  @override
  State<inventoryAddition> createState() => _inventoryAdditionState();
}

class _inventoryAdditionState extends State<inventoryAddition> {
  final String alp = 'ABCDEFGHIJKLMNOPQRSTUVXYZ';

  List dropDown = [
    {
      'title': 'Fruits and Vegetables',
      'color': Colors.red,
    },
    {
      'title': 'Stationary',
      'color': Colors.blue,
    },
    {
      'title': 'Household',
      'color': Colors.yellow,
    },
    {
      'title': 'Dairy',
      'color': Colors.green,
    },
    {
      'title': 'Bread',
      'color': Colors.purple,
    },
  ];
  bool categorySelection = false;

  @override
  Widget build(BuildContext context) {
    var wt = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;
    return Consumer<GSProvider>(
      builder: (context, data, child) {
        var x = data.cols;
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...data.selGS.map(
                (f) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: wt * 0.5,
                            width: wt * 0.5,
                            margin: EdgeInsets.symmetric(
                                vertical: wt * 0.027, horizontal: wt * 0.027),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                              ),
                            ),
                            child: GridView(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: data.cols,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                                childAspectRatio: 1,
                              ),
                              children: [
                                ...data.gridMap.map(
                                  (e) {
                                    var r = (e.i / x).ceil();
                                    var c = alp[(e.i % x)];
                                    if (c == 'A') {
                                      r++;
                                    }
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: f['key'] == e.i
                                              ? Colors.white
                                              : data.isSel(e.i)
                                                  ? Colors.white
                                                  : Color.fromARGB(
                                                      99, 158, 158, 158),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(2),
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                        color: f['key'] == e.i
                                            ? Colors.black
                                            : data.isSel(e.i)
                                                ? Colors.grey
                                                : Colors.white,
                                        child: Center(
                                          child: Text(
                                            '${r}${c}',
                                            style: TextStyle(
                                              fontSize: 12 * 6.54 / data.cols,
                                              color: f['key'] == e.i
                                                  ? Colors.white
                                                  : data.isSel(e.i)
                                                      ? Colors.white
                                                      : Colors.grey,
                                              fontWeight: f['key'] == e.i
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              // mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: categorySelection
                                  ? [
                                      ...dropDown.map(
                                        (e) {
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  InkWell(
                                                    child: Container(
                                                      width: wt * 0.054,
                                                      height: wt * 0.054,
                                                      decoration: BoxDecoration(
                                                        color: f['category'] ==
                                                                e['title']
                                                            ? e['color']
                                                                as Color
                                                            : null,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(wt),
                                                        border: Border.all(
                                                          width: 2,
                                                          color: e['color']
                                                              as Color,
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      data.addCategory(
                                                          f['key'], e['title']);
                                                      setState(() {
                                                        categorySelection =
                                                            false;
                                                      });
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: wt * 0.0135,
                                                  ),
                                                  Text(e['title']),
                                                ],
                                              ),
                                              SizedBox(
                                                height: ht * 0.0135,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ]
                                  : [
                                      Container(
                                        // width: wt - (wt * 0.6)-  wt * 0.027,
                                        margin: EdgeInsets.only(
                                            // right: wt * 0.027,
                                            ),
                                        child: TextButton(
                                          style: ButtonStyle(
                                            padding: MaterialStatePropertyAll(
                                              EdgeInsets.symmetric(
                                                horizontal: wt * 0.027,
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Color.fromARGB(107, 41, 130, 203),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              categorySelection = true;
                                            });
                                          },
                                          child: data.getCategory(f['key']) ==
                                                  ""
                                              ? Text(
                                                  'Select Category',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: ht * 0.01,
                                                      backgroundColor: dropDown[
                                                          dropDown.indexWhere(
                                                              (element) =>
                                                                  element[
                                                                      'title'] ==
                                                                  data.getCategory(
                                                                      f['key']))]['color'],
                                                    ),
                                                    Text(
                                                      data
                                                          .getCategory(
                                                            f['key'],
                                                          )
                                                          .toUpperCase(),
                                                          overflow: TextOverflow.fade,
                                                      style: TextStyle(
                                                        fontSize: ht * 0.022,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    // Text('CHANGE')
                                                  ],
                                                ),
                                        ),
                                      ),
                                      Container(
                                        // width: wt - (wt * 0.6)-  wt * 0.027,
                                        margin: EdgeInsets.only(
                                            // right: wt * 0.027,
                                            ),
                                        child: TextButton(
                                          style: ButtonStyle(
                                            padding: MaterialStatePropertyAll(
                                              EdgeInsets.symmetric(
                                                horizontal: wt * 0.054,
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Color.fromARGB(107, 41, 130, 203),
                                            ),
                                          ),
                                          onPressed: () {
                                            (f['key']);
                                            data.addSpaceforNewInventory(
                                                f['key']);
                                          },
                                          child: Text(
                                            'Add Item',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                            ),
                          ),
                        ],
                      ),
                      ...f['list'].map(
                        (g) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: wt * 0.0135, horizontal: wt * 0.027),
                            child: TextField(
                              // controller: tec,
                              onSubmitted: (value) {
                                data.addItem(f['key'], g['itemNo'], value);
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                suffix: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      style: const ButtonStyle(
                                        padding: MaterialStatePropertyAll(
                                          EdgeInsets.all(0),
                                        ),
                                      ),
                                      onPressed: () {
                                        int keyIndex = f['key'];
                                        (keyIndex);
                                        int textFormKey = g['itemNo'];
                                        data.decrementCount(
                                            keyIndex, textFormKey);
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                      ),
                                    ),
                                    Text(g['count'].toString()),
                                    IconButton(
                                      style: const ButtonStyle(
                                        padding: MaterialStatePropertyAll(
                                          EdgeInsets.all(0),
                                        ),
                                      ),
                                      onPressed: () {
                                        int keyIndex = f['key'];
                                        (keyIndex);
                                        int textFormKey = g['itemNo'];
                                        (textFormKey);
                                        data.incrementCount(
                                            keyIndex, textFormKey);
                                      },
                                      icon: Icon(
                                        Icons.add,
                                      ),
                                    ),
                                  ],
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                label: Text(
                                  'Item Name',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
              Container(
                // alignment: Alignment.center,
                margin: EdgeInsets.only(
                  left: wt * 0.01,
                  right: wt * 0.01,
                  bottom: wt * 0.0135,
                ),
                width: wt,
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(107, 41, 130, 203),
                    ),
                  ),
                  onPressed: () async {
                    var id = data.id;
                    var prevPassword = data.pw;
                    var columnCount = data.cols;
                    var shopName = data.sN;
                    var positionForEntry = data.positionForEntry;
                    var counterPositions = data.counterPositions;

                    final url = Uri.https(
                      'stent-ebe62-default-rtdb.firebaseio.com',
                      'stent-db.json',
                    );

                    http
                        .post(
                      url,
                      headers: {
                        'Content-Type': 'application/json',
                      },
                      body: json.encode(
                        {
                          'loginID': [
                            id,
                            prevPassword,
                          ],
                          'shapeInventory': json.encode(data.selGS),
                          'cols': columnCount,
                          'shopName': shopName,
                          'positionForEntry': positionForEntry,
                          'counterPositions': counterPositions,

                          // 'loginID': lID,
                        },
                      ),
                    )
                        .then((ctx) {
                      data.setId("");
                      data.setPw("");
                      data.setSN("");
                      data.setPosition(0);
                      // data.se("");
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (ctx) => AlertDialog(
                      //       title: Text(
                      //         'Stent is delighted to have you onboard!',
                      //       ),
                      //     ),
                      //   ),
                      // );
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => LoginPage(),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          // margin: EdgeInsets.all(10),
                          duration: Duration(
                            seconds: 5,
                          ),
                          // elevation: 10,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                          content: Text(
                            'Stent is delighted to have you onboard, $shopName!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.lightBlue[200],
                            ),
                          ),
                          // width: wt * 0.8,
                        ),
                      );
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: wt,
                    child: Text(
                      'Save Inventory',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
