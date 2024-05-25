// import 'dart:js_interop';

// import 'dart:js_interop_unsafe';

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:stent/shop_display_page.dart';
import 'dart:convert';
// import 'package:http/http.dart' as http;

class Customer extends StatefulWidget {
  List availableShops;
  List shopNames;
  List cols;
  List allData;
  List positionForEntry;
  // int cols = 5;
  Customer(this.allData, this.shopNames, this.availableShops, this.cols,
      this.positionForEntry);

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  TextEditingController searchC = TextEditingController();

  List allData2 = [];

  @override
  void initState() {
    allData2 = List.generate(widget.availableShops.length, (index) {
      return {
        'shopName': widget.shopNames[index],
        'shapeInventory': widget.availableShops[index],
        'cols': widget.cols[index],
        'positionForEntry': widget.positionForEntry[index],
      };
    });
    print('allData');
    print(widget.allData);
    // print('allData2');
    // print(allData2);
    super.initState();
  }

  void productSearch(String search) {
    allData2 = [];
    for (var element in widget.allData) {
      for (var ele in json.decode(element['shapeInventory'])) {
        for (var e in ele['list']) {
          if (e['name']
              .toString()
              .toLowerCase()
              .contains(search.toLowerCase())) {
            if (allData2.indexWhere(
                    (el) => el['shopName'] == element['shopName']) ==
                -1) {
              allData2.add({
                'shopName': element['shopName'],
                'shapeInventory': json.decode(element['shapeInventory']),
                'cols': element['cols'],
                'positionForEntry': element['positionForEntry'],
              });
            }
          }
        }
      }
    }
  }

  void shopSearch(String search) {
    allData2 = [];
    for (var element in widget.allData) {
      if (element['shopName']
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase())) {
        allData2.add({
          'shopName': element['shopName'],
          'shapeInventory': json.decode(element['shapeInventory']),
          'cols': element['cols'],
          'positionForEntry': element['positionForEntry'],
        });
      }
    }
  }

  bool searchReq = false;
  bool shopSearchReq = false;
  bool productSearchReq = false;

  Color shelveBorderColor = Colors.black;
  Color gridAllSpacesBorderColor = Colors.black;
  Color layoutBorderColor = Colors.black;

  double allGridSpacesBorderWidth = 0.0;
// .get()
  @override
  Widget build(BuildContext context) {
    // List allData2 = List.generate(widget.availableShops.length, (index) {
    //   return {
    //     'shopName': widget.shopNames[index],
    //     'shopGridData': widget.availableShops[index],
    //     'cols': widget.cols[index],
    //     'positonForEntry': widget.positionForEntry[index],
    //   };
    // });
    // print('allData2');
    // print(allData2);

    // @override
    // void initState() {
    //   super.initState();
    // }

    // bool change = true;

    // print('This is all of the data: ');
    // print(allData2);

    // print(availableShops[0]['key']);
    // print(shopNames);

    var ht = MediaQuery.of(context).size.height;
    var wt = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ht * 0.1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          iconSize: ht * 0.03,
          padding: EdgeInsets.all(0),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        // toolbarHeight: ht * 0.07,
        // leadingWidth: wt * 0.077,
        title: searchReq
            ? Container(
                padding: EdgeInsets.symmetric(
                  vertical: ht * 0.01,
                ),
                height: ht * 0.09,
                child: TextFormField(
                  onFieldSubmitted: (value) {
                    // searchC.text = "";
                    FocusScope.of(context).unfocus();
                    productSearchReq
                        ? (value) => productSearch(value)
                        : shopSearchReq
                            ? (value) => shopSearch(value)
                            : null;
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();

                    productSearchReq
                        ? productSearch(searchC.text)
                        : shopSearchReq
                            ? shopSearch(searchC.text)
                            : null;
                  },
                  onChanged: (value) {
                    // FocusScope.of(context).unfocus();
                    productSearchReq
                        ? (value) => productSearch(value)
                        : shopSearchReq
                            ? (value) => shopSearch(value)
                            : null;
                  },
                  autofocus: true,
                  cursorColor: Theme.of(context).colorScheme.primary,
                  decoration: InputDecoration(
                    labelText: productSearchReq
                        ? "Search Products"
                        : shopSearchReq
                            ? "Search Shops"
                            : null,
                    labelStyle:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    suffixIconConstraints: BoxConstraints.tight(
                      Size.zero,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    // focusedBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(10),
                    //   borderSide: BorderSide(
                    //     color: Colors.black,
                    //   ),
                    // ),
                  ),
                  // focusNode: FocusNode(),
                  controller: searchC,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: ht * 0.024,
                  ),
                  // onFieldSubmitted: (value) =>
                  //     // availableShopsBasedOnSearch(value),
                ),
              )
            : Text(
                'Available Shops',
                style: TextStyle(
                  color: Colors.white,

                  fontWeight: FontWeight.w500,
                  // letterSpacing: wt * 0.00135,

                  fontSize: ht * 0.033,
                ),
              ),
        actions: searchReq
            ? [
                InkWell(
                  onTap: () {
                    shopSearch("");
                    setState(() {
                      searchReq = false;
                      shopSearchReq = false;
                      productSearchReq = false;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: wt * 0.02,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ]
            : [
                InkWell(
                  onTap: () {
                    setState(() {
                      searchReq = true;
                      shopSearchReq = true;
                    });
                  },
                  child: Container(
                    height: ht * 0.054,
                    width: ht * 0.054,
                    decoration: BoxDecoration(
                      // color: Colors.transparent,
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/images/shop_search.png"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: wt * 0.054,
                ),
                InkWell(
                  onTap: () {
                    setState(
                      () {
                        searchReq = true;
                        productSearchReq = true;
                      },
                    );
                  },
                  child: Container(
                    height: ht * 0.05,
                    width: ht * 0.05,
                    decoration: BoxDecoration(
                      // color: Colors.transparent,
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/images/product_search.png"),
                      ),
                    ),
                  ),
                ),
              ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
        padding: EdgeInsets.symmetric(
          vertical: ht * 0.01,
          horizontal: wt * 0.01,
        ),
        child: Column(
          children: [
            productSearchReq
                ? Row(
                    children: [
                      Text('Shops that have "${searchC.text}"'),
                      // Divider(),
                    ],
                  )
                : SizedBox(),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: ht * 0.01,
                  crossAxisSpacing: wt * 0.01,
                  childAspectRatio: 0.840,
                ),
                children: [
                  ...allData2.map(
                    (e) {
                      print("e");
                      print(e);
                      List selected = [];
                      List sel = [];
                      // print(e);
                      // bool l
                      // decoded.add((e));

                      var i =
                          widget.availableShops.indexOf(e['shapeInventory']);
                      // print(i);
                      var last = e['shapeInventory'].length;
                      for (var x = 0; x < last; x++) {
                        sel.add(e['shapeInventory'][x]['key']);
                        selected.add(
                          {
                            'k': x,
                            'l': false,
                            'r': false,
                            't': false,
                            'b': false
                          },
                        );
                      }

                      //  print();
                      for (var y = 0; y < last; y++) {
                        bool l = false, r = false, b = false, t = false;
                        if (sel.contains(sel[y] + 1)) {
                          if (((sel[y] + 1) % e['cols']) != 0) {
                            r = true;
                          }
                        }
                        if (sel.contains(sel[y] + e['cols'])) {
                          b = true;
                        }
                        if (sel.contains((sel[y] - 1))) {
                          if (((sel[y] - 1) % e['cols']) != (e['cols'] - 1)) {
                            l = true;
                          }
                        }
                        if (sel.contains(sel[y] - e['cols'])) {
                          t = true;
                        }

                        selected[y] = {'k': y, 'l': l, 'r': r, 't': t, 'b': b};

                        // print(false);
                      }

                      // x.

                      // print(i);
                      // print(sel);
                      // print(selected);

                      List gridSize = List.generate(
                          e['cols'] * e['cols'], (index) => index);

                      return Card(
                        elevation: 10,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: Container(
                          // color: Theme.of(context).colorScheme.secondary,
                          color: Theme.of(context).colorScheme.onPrimary,
                          padding: EdgeInsets.only(
                            top: ht * 0.0054,
                            right: ht * 0.0054,
                            left: ht * 0.0054,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => ShopViewer(
                                    e,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      10 - ht * 0.0054,
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Container(
                                    // height: wt * 0.39,
                                    height: wt * 0.44,
                                    width: wt * 0.44,

                                    // margin: change == false
                                    //     ? EdgeInsets.all(ht * 0.027)
                                    //     : EdgeInsets.all(ht * 0.02),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        10 - ht * 0.0054,
                                      ),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.8),
                                      border: Border.all(
                                        color: layoutBorderColor,
                                        width: 0,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: GridView(
                                      // scrollDirection:Axis.horizontal,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: e['cols'],
                                        crossAxisSpacing: 0,
                                        mainAxisSpacing: 0,
                                        childAspectRatio: 1,
                                      ),
                                      children: [
                                        ...gridSize.map(
                                          (f) {
                                            // print(e['positionForEntry']);
                                            bool entry = f ==
                                                    (e['positionForEntry'] +
                                                        (e['cols'] *
                                                            (e['cols'] - 1)))
                                                ? true
                                                : false;
                                            print(entry);
                                            bool topp = false,
                                                rightt = false,
                                                bottomm = false,
                                                leftt = false;
                                            bool present =
                                                sel.contains(f) ? true : false;
                                            // print(present);
                                            int indexIfPresent = 9999;
                                            // print(indexIfPresent);
                                            if (present) {
                                              indexIfPresent = sel.indexOf(f);
                                              selected[indexIfPresent]['l'] ==
                                                      true
                                                  ? leftt = true
                                                  : ();
                                              selected[indexIfPresent]['r'] ==
                                                      true
                                                  ? rightt = true
                                                  : ();
                                              selected[indexIfPresent]['b'] ==
                                                      true
                                                  ? bottomm = true
                                                  : ();
                                              selected[indexIfPresent]['t'] ==
                                                      true
                                                  ? topp = true
                                                  : ();
                                            }

                                            // var r = (f.i / x).ceil();
                                            // var c = alp[(f.i % x)];
                                            // if (c == 'A') {
                                            //   r++;
                                            // }
                                            return Container(
                                              decoration: BoxDecoration(
                                                border: present
                                                    ? Border(
                                                        top: topp
                                                            ? BorderSide(
                                                                color:
                                                                    shelveBorderColor,
                                                                width:
                                                                    allGridSpacesBorderWidth)
                                                            : BorderSide(
                                                                color:
                                                                    shelveBorderColor,
                                                                width: 2,
                                                              ),
                                                        bottom: bottomm
                                                            ? BorderSide(
                                                                color:
                                                                    shelveBorderColor,
                                                                width:
                                                                    allGridSpacesBorderWidth)
                                                            : BorderSide(
                                                                color:
                                                                    shelveBorderColor,
                                                                width: 2,
                                                              ),
                                                        left: leftt
                                                            ? BorderSide(
                                                                color:
                                                                    shelveBorderColor,
                                                                width:
                                                                    allGridSpacesBorderWidth)
                                                            : BorderSide(
                                                                color:
                                                                    shelveBorderColor,
                                                                width: 2,
                                                              ),
                                                        right: rightt
                                                            ? BorderSide(
                                                                color:
                                                                    shelveBorderColor,
                                                                width:
                                                                    allGridSpacesBorderWidth)
                                                            : BorderSide(
                                                                color:
                                                                    shelveBorderColor,
                                                                width: 2,
                                                              ),
                                                      )
                                                    : entry
                                                        ? Border(
                                                            bottom: BorderSide(
                                                              color: Colors.red,
                                                              width: 3,
                                                            ),
                                                          )
                                                        : null,

                                                // borderRadius: BorderRadius.circular(1),
                                                // color: selected.contains(f)
                                                //     ? Colors.black
                                                //     : gridAllSpacesBorderColor,
                                              ),
                                              // child: Center(
                                              //   child: Text(
                                              //     // 'awesome',
                                              //   ),
                                              // ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(e['shopName'].toString(),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: ht * 0.024,
                                          letterSpacing: 1,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
