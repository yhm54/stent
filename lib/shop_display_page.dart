// ignore_for_file: prefer_const_constructors
import 'dart:convert';
// import 'dart:html';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

// import 'package:intl/intl.dart';

class ShopViewer extends StatefulWidget {

  dynamic shop;

  ShopViewer(this.shop, {super.key}){
    print(shop);
  }

  // print(shop);
  // print(shop as String);

  @override
  State<ShopViewer> createState() => _ShopViewerState(shop);
}

class _ShopViewerState extends State<ShopViewer> {
  dynamic shopD;
  bool keyFound = false;

  _ShopViewerState(this.shopD);
// print(shopD.toString());

  String alp = 'abcdefghijklmnopqrstuvwxyz'.toUpperCase();

  TextEditingController searched = TextEditingController();

  bool searchEntered = false;
  bool searchAddedToCart = false;
  bool keyNotFound = false;
  bool multipleItems = false;

  dynamic key = -1;

  int addedCount = 0;

  List multipleItemsIfThere = [];

  bool searchFocus = true;

  List category = [
    {
      'title': 'Fruits and Vegetables',
      'color': Colors.red,
      'bg': "assets/images/fruits and vegetables.png"
    },
    {
      'title': 'Stationary',
      'color': Colors.blue,
      'bg': "assets/images/stationary.png"
    },
    {
      'title': 'Household',
      'color': Colors.yellow,
      'bg': "assets/images/household.png"
    },
    {
      'title': 'Dairy',
      'color': Colors.green,
      'bg': "assets/images/dairy.png",
    },
    {
      'title': 'Bread',
      'color': Colors.purple,
      'bg': "assets/images/bread.png",
    },
    {
      'bg': "assets/images/other.png",
    }
  ];

  @override
  Widget build(BuildContext context) {
    Color shelvesBorderColor = Theme.of(context).colorScheme.onPrimary;

    var wt = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;
    // (shopD);
    List gridSize = List.generate(shopD['cols'] * shopD['cols'], (index) {
      return index;
    });
    List selected = [];
    List sel = [];

    // (e);
    // bool l
    // decoded.add((e));

    // var i = availableShops.indexOf(e['shapeInventory']);

    // (i);
    var last = shopD['shapeInventory'].length;
    for (var x = 0; x < last; x++) {
      sel.add(shopD['shapeInventory'][x]['key']);
      selected.add(
        {'k': x, 'l': false, 'r': false, 't': false, 'b': false},
      );
    }

    //  ();
    for (var y = 0; y < last; y++) {
      bool l = false, r = false, b = false, t = false;
      if (sel.contains(sel[y] + 1)) {
        if (((sel[y] + 1) % shopD['cols']) != 0) {
          r = true;
        }
      }
      if (sel.contains(sel[y] + shopD['cols'])) {
        b = true;
      }
      if (sel.contains((sel[y] - 1))) {
        if (((sel[y] - 1) % shopD['cols']) != (shopD['cols'] - 1)) {
          l = true;
        }
      }
      if (sel.contains(sel[y] - shopD['cols'])) {
        t = true;
      }

      selected[y] = {'k': y, 'l': l, 'r': r, 't': t, 'b': b};

      // (false);
    }

    findKey(String searchedItem, List Data) {
      searchedItem = searchedItem.trim().toLowerCase();
      multipleItemsIfThere = [];
      for (var i = 0; i < Data.length; i++) {
        for (var element in Data[i]['list']) {
          if (element['name'].toLowerCase().contains(searchedItem)) {
            multipleItemsIfThere
                .add([Data[i]['key'], element['count'], element['name']]);
          }
        }
      }
      if (multipleItemsIfThere.length == 1) {
        return multipleItemsIfThere[0];
      } else if (multipleItemsIfThere.length > 1) {
        setState(() {
          multipleItems = true;
        });
        return [multipleItemsIfThere.length, -1];
      } else {
        return [-1, -1];
      }
    }

    // print('shopD');
    // print(shopD);

    // var shopDH = json.decode(shopD["positonForEntry"]);
    // print(shopDH);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          shopD['shopName'],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24.0,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.favorite, color: Colors.white),
        //     onPressed: () {
        //       // Handle button press
        //     },
        //   ),
        // ],
      ),
      body: Container(
        height: ht,
        decoration: BoxDecoration(
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            opacity: 0.1,
            image: AssetImage("assets/images/stent_bg_1.jpeg"),
          ),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
        ),
        child: SingleChildScrollView(
          child: searchEntered == false
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: wt * 0.96,
                      width: wt * 0.96,
                      padding: EdgeInsets.only(
                        left: wt * 0.03,
                        right: wt * 0.03,
                        top: wt * 0.03,
                        // bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      // color: Colors.red,
                      decoration: BoxDecoration(
                        // image: ,
                        color: Theme.of(context).colorScheme.primary,
                        // borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onPrimary,
                          width: 6,
                        ),
                      ),
                      margin: EdgeInsets.all(
                        wt * 0.02,
                      ),
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: shopD['cols'],
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          childAspectRatio: 1,
                        ),
                        children: [
                          ...gridSize.map(
                            (f) {
                              print(shopD['cols']);
                              bool entry = (f ==
                                      (shopD['cols'] * (shopD['cols'] - 1)) +
                                          shopD['positionForEntry'])
                                  ? true
                                  : false;
                              bool counter = shopD['counterPositions'] == null
                                  ? false
                                  : shopD['counterPositions'].contains(f)
                                      ? true
                                      : false;
                              bool topp = false,
                                  rightt = false,
                                  bottomm = false,
                                  leftt = false;
                              bool present = sel.contains(f) ? true : false;

                              int? ind = present
                                  ? shopD['shapeInventory']
                                      .indexWhere((e) => e['key'] == f)
                                  : null;

                              print(ind);
                              // (present);
                              int indexIfPresent = 9999;
                              // (indexIfPresent);
                              if (present) {
                                indexIfPresent = sel.indexOf(f);
                                selected[indexIfPresent]['l'] == true
                                    ? leftt = true
                                    : ();
                                selected[indexIfPresent]['r'] == true
                                    ? rightt = true
                                    : ();
                                selected[indexIfPresent]['b'] == true
                                    ? bottomm = true
                                    : ();
                                selected[indexIfPresent]['t'] == true
                                    ? topp = true
                                    : ();
                              }

                              // x.

                              // (i);
                              // (sel);
                              // (selected);

                              // List gridSize = List.generate(
                              //     shopD['cols'] * shopD['cols'],
                              //     (index) => index);

                              // var r = (f.i / x).ceil();
                              // var c = alp[(f.i % x)];
                              // if (c == 'A') {
                              //   r++;
                              // }

                              bool categoried = present
                                  ? shopD['shapeInventory'][ind]['category'] ==
                                          null
                                      ? false
                                      : true
                                  : false;
                              print(shopD);
                              print(present
                                  ? shopD['shapeInventory'][ind]['cateogory']
                                  : null);
                              return Container(
                                decoration: BoxDecoration(
                                  image: present && !categoried
                                      ? DecorationImage(
                                          image: AssetImage(
                                              "assets/images/other.png"))
                                      : present && categoried
                                          ? DecorationImage(
                                              fit: BoxFit.scaleDown,
                                              image: AssetImage(
                                                category[category.indexWhere(
                                                          (element) =>
                                                              element[
                                                                  'title'] ==
                                                              shopD['shapeInventory']
                                                                      [ind]
                                                                  ['category'],
                                                        ) ==
                                                        -1
                                                    ? 5
                                                    : category.indexWhere(
                                                        (element) =>
                                                            element['title'] ==
                                                            shopD['shapeInventory']
                                                                    [ind]
                                                                ['category'],
                                                      )]['bg'],
                                              ),
                                            )
                                          : null,

                                  // color: counter && present?null: counter?Colors.green:null,
                                  border: present
                                      ? Border(
                                          top: topp
                                              ? BorderSide(
                                                  color: shelvesBorderColor,
                                                  width: 0.135)
                                              : BorderSide(
                                                  color: shelvesBorderColor,
                                                  width: 4,
                                                ),
                                          bottom: bottomm
                                              ? BorderSide(
                                                  color: shelvesBorderColor,
                                                  width: 0.135)
                                              : BorderSide(
                                                  color: shelvesBorderColor,
                                                  width: 4,
                                                ),
                                          left: leftt
                                              ? BorderSide(
                                                  color: shelvesBorderColor,
                                                  width: 0.135)
                                              : BorderSide(
                                                  color: shelvesBorderColor,
                                                  width: 4,
                                                ),
                                          right: rightt
                                              ? BorderSide(
                                                  color: shelvesBorderColor,
                                                  width: 0.135)
                                              : BorderSide(
                                                  color: shelvesBorderColor,
                                                  width: 4,
                                                ),
                                        )
                                      : null,

                                  // borderRadius: BorderRadius.circular(1),
                                  // color: selected.contains(f)
                                  //     ? Colors.black
                                  //     : Colors.white,
                                  color: counter
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withOpacity(0.3)
                                      : null,
                                ),
                                child: entry
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'ENTRY',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: (ht *
                                                  0.027 *
                                                  4 /
                                                  shopD['cols']),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.red,
                                                width: 5,
                                              ),
                                            ),
                                            height:
                                                ((wt * 0.96) / shopD['cols']) *
                                                    0.3,
                                          )
                                        ],
                                      )
                                    : null,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      // color: shelvesBorderColor,
                      // margin: EdgeInsets.symmetric(horizontal: wt * 0.02,),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: wt * 0.02,
                              right: wt * 0.02,
                              top: wt * 0.01,
                            ),
                            decoration: BoxDecoration(
                              // color: Colors.red,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: TextFormField(
                              autofocus: searchFocus,
                              controller: searched,
                              onFieldSubmitted: (value) {
                                key = findKey(value, shopD['shapeInventory']);
                                if (key[1] == -1) {
                                  if (key[0] > 0) {
                                    setState(() {
                                      keyNotFound = false;
                                      multipleItems = true;
                                    });
                                  } else {
                                    setState(() {
                                      keyNotFound = true;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    keyNotFound = false;
                                    searched.text = key[2];
                                    searchEntered = true;
                                  });
                                }
                              },
                              cursorColor: shelvesBorderColor,
                              cursorHeight: ht * 0.05,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: shelvesBorderColor,
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                    bottomRight:
                                        Radius.circular(multipleItems ? 0 : 10),
                                    bottomLeft:
                                        Radius.circular(multipleItems ? 0 : 10),
                                  ),
                                  borderSide: BorderSide(
                                    color: shelvesBorderColor,
                                  ),
                                ),
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: shelvesBorderColor,
                                      size: 30,
                                      weight: 30,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Search',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: shelvesBorderColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 27,
                              ),
                            ),
                          ),
                          multipleItems
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: wt * 0.02,
                                  ),
                                  // color: shelvesBorderColor,
                                  child: Column(
                                    children: [
                                      ...multipleItemsIfThere.map(
                                        (m) => Column(
                                          children: [
                                            Container(
                                              // margin: EdgeInsets.symmetric(horizontal: wt * 0.02,),
                                              width: wt - (wt * 0.04),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    searched.text = m[2];
                                                    searchEntered = true;
                                                    key = [
                                                      m[0],
                                                      m[1],
                                                      m[2],
                                                    ];
                                                    multipleItems = false;
                                                  });
                                                },
                                                child: Text(
                                                  m[2].toString(),
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              height: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: wt * 0.96,
                      width: wt * 0.96,
                      padding: EdgeInsets.all(wt * 0.02),
                      // color: Colors.red,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        // borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 6,
                          color: shelvesBorderColor,
                        ),
                      ),
                      margin: EdgeInsets.all(
                        wt * 0.02,
                      ),
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: shopD['cols'],
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          childAspectRatio: 1,
                        ),
                        children: [
                          ...gridSize.map(
                            (f) {
                              keyFound = keyNotFound ? false : true;
                              bool topp = false,
                                  rightt = false,
                                  bottomm = false,
                                  leftt = false;
                              bool present = sel.contains(f) ? true : false;
                              // (present);
                              int indexIfPresent = 9999;
                              // (indexIfPresent);
                              if (present) {
                                indexIfPresent = sel.indexOf(f);
                                selected[indexIfPresent]['l'] == true
                                    ? leftt = true
                                    : ();
                                selected[indexIfPresent]['r'] == true
                                    ? rightt = true
                                    : ();
                                selected[indexIfPresent]['b'] == true
                                    ? bottomm = true
                                    : ();
                                selected[indexIfPresent]['t'] == true
                                    ? topp = true
                                    : ();
                              }

                              // x.

                              // (i);
                              // (sel);
                              // (selected);

                              // List gridSize = List.generate(
                              //     shopD['cols'] * shopD['cols'],
                              //     (index) => index);

                              // var r = (f.i / x).ceil();
                              // var c = alp[(f.i % x)];
                              // if (c == 'A') {
                              //   r++;
                              var row = keyFound
                                  ? ((key[0] / shopD['cols']) + 1).floor()
                                  : -1;
                              var col =
                                  keyFound ? alp[(key[0] % shopD['cols'])] : -1;
                              // }
                              bool entry = (f ==
                                      shopD['positionForEntry'] +
                                          (shopD['cols'] * (shopD['cols'] - 1)))
                                  ? true
                                  : false;
                              bool counter = shopD['counterPositions'] == null
                                  ? false
                                  : shopD['counterPositions'].contains(f)
                                      ? true
                                      : false;
                              return Container(
                                  decoration: BoxDecoration(
                                    border: present
                                        ? Border(
                                            top: topp
                                                ? keyFound
                                                    ? f == key[0]
                                                        ? BorderSide(
                                                            color: Colors.black,
                                                            width: 4,
                                                          )
                                                        : BorderSide(
                                                            color: Colors.black,
                                                            width: 0.135,
                                                          )
                                                    : BorderSide(
                                                        color: Colors.black,
                                                        width: 0.135)
                                                : BorderSide(
                                                    color: Colors.black,
                                                    width: 4,
                                                  ),
                                            bottom: bottomm
                                                ? keyFound
                                                    ? f == key[0]
                                                        ? BorderSide(
                                                            color: Colors.black,
                                                            width: 4,
                                                          )
                                                        : BorderSide(
                                                            color: Colors.black,
                                                            width: 0.135,
                                                          )
                                                    : BorderSide(
                                                        color: Colors.black,
                                                        width: 0.135)
                                                : BorderSide(
                                                    color: Colors.black,
                                                    width: 4,
                                                  ),
                                            left: leftt
                                                ? keyFound
                                                    ? f == key[0]
                                                        ? BorderSide(
                                                            color: Colors.black,
                                                            width: 4,
                                                          )
                                                        : BorderSide(
                                                            color: Colors.black,
                                                            width: 0.135,
                                                          )
                                                    : BorderSide(
                                                        color: Colors.black,
                                                        width: 0.135)
                                                : BorderSide(
                                                    color: Colors.black,
                                                    width: 4,
                                                  ),
                                            right: rightt
                                                ? keyFound
                                                    ? f == key[0]
                                                        ? BorderSide(
                                                            color: Colors.black,
                                                            width: 4,
                                                          )
                                                        : BorderSide(
                                                            color: Colors.black,
                                                            width: 0.135,
                                                          )
                                                    : BorderSide(
                                                        color: Colors.black,
                                                        width: 0.135)
                                                : BorderSide(
                                                    color: Colors.black,
                                                    width: 4,
                                                  ),
                                          )
                                        : null,
                                    color: keyFound
                                        ? f == key[0]
                                            ? Color.fromARGB(157, 36, 128, 203)
                                            : counter
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary
                                                    .withOpacity(0.3)
                                                : null
                                        : null,
                                    // borderRadius: BorderRadius.circular(1),
                                    // color: selected.contains(f)
                                    //     ? Colors.black
                                    //     : Colors.white,
                                  ),
                                  child: keyFound && f == key[0]
                                      ? Center(
                                          child: Text(
                                            "$row$col",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: ht * 0.03,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      : Text(''));
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: wt * 0.02,
                        vertical: wt * 0.01,
                      ),
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: keyNotFound
                          ? Text('Not found')
                          : Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: wt * 0.040,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Card(
                                    child: Container(
                                      width: wt * 0.4,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ht * 0.02,
                                        vertical: ht * 0.0054,
                                      ),
                                      child: Text(
                                        
                                        searched.text,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: ht * 0.026,
                                          // fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          // print('working');
                                          setState(() {
                                            // print('checking');
                                            // keyFound = false;
                                            key = -1;

                                            searchEntered = false;

                                            searchAddedToCart = false;

                                            addedCount = 0;
                                          });
                                          // print('Bananaworking');
                                        },
                                        icon: Icon(
                                          Icons.highlight_remove_rounded,
                                        ),
                                      ),
                                      Container(
                                        // height: ht * 0.054,
                                        padding: EdgeInsets.symmetric(
                                          // horizontal: ht * 0.02,
                                          vertical: ht * 0.0054,
                                        ),
                                        child: Text(
                                          '${key[1]} available',
                                          style: TextStyle(
                                            fontSize: ht * 0.027,
                                            // fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                    ),
                    keyFound == false
                        ? SizedBox()
                        : Container(
                            margin: EdgeInsets.only(
                              top: ht * 0.02,
                              left: wt * 0.054,
                              right: wt * 0.054,
                            ),
                            // padding: EdgeInsets.all(10),
                            child: Card(
                              elevation: 10,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: ht * 0.02,
                                      left: ht * 0.02,
                                      right: ht * 0.02,
                                      bottom: ht * 0.01,
                                    ),
                                    // height: ht * 0.054,
                                    child: Text(
                                      'Have you added this to your cart?',
                                      style: TextStyle(
                                        fontSize: ht * 0.02,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: ht * 0.0054,
                                      // horizontal: wt * 0054,
                                    ),
                                    child: searchAddedToCart == false
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: wt * 0.1,
                                                  vertical: ht * 0.02,
                                                ),
                                                // ),
                                                child: TextButton(
                                                  style: ButtonStyle(
                                                    shape:
                                                        MaterialStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          wt * 0.02,
                                                        ),
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      const Color.fromARGB(
                                                          255, 95, 255, 100),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      searchAddedToCart = true;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                wt * 0.02),
                                                    child: Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                        letterSpacing:
                                                            ht * 0.0009,
                                                        fontSize: ht * 0.02,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: wt * 0.1,
                                                ),
                                                child: TextButton(
                                                  style: ButtonStyle(
                                                    shape:
                                                        MaterialStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          wt * 0.02,
                                                        ),
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      const Color.fromARGB(
                                                          255, 255, 77, 65),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    String timeRN =
                                                        DateTime.now()
                                                            .toString();

                                                    print('//' + timeRN);

                                                    final url = Uri.https(
                                                      'stent-c581d-default-rtdb.firebaseio.com',
                                                      'stent-search-db.json',
                                                    );
                                                    // var response =
                                                    //     await http.get(url);
                                                    // print('working');

                                                    http.post(
                                                      url,
                                                      headers: {
                                                        'Content-Type':
                                                            'application/json',
                                                      },
                                                      body: json.encode(
                                                        {
                                                          'shopName':
                                                              shopD['shopName'],
                                                          'search': key[2],
                                                          'addedToCart':
                                                              searchAddedToCart,
                                                          'countAdded':
                                                              addedCount,
                                                          'date': DateTime.now()
                                                              .toString(),
                                                          'key': key[0],

                                                          // 'loginID': lID,
                                                        },
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        duration: Duration(
                                                            seconds: 2),
                                                        content:
                                                            Text('Thanks!'),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            10,
                                                          ),
                                                        ),
                                                      ),
                                                    );

                                                    setState(() {
                                                      key = -1;

                                                      searchEntered = false;

                                                      searchAddedToCart = false;

                                                      addedCount = 0;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                wt * 0.02),
                                                    child: Text(
                                                      'No',
                                                      style: TextStyle(
                                                        letterSpacing:
                                                            ht * 0.0009,
                                                        fontSize: ht * 0.02,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(
                                            padding: EdgeInsets.all(0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 3,
                                                color: Color.fromARGB(
                                                    255, 95, 255, 100),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                wt * 0.027,
                                              ),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: wt * 0.1,
                                              vertical: ht * 0.02,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      // horizontal: wt * 0.1,
                                                      horizontal: 2.54,
                                                      vertical: 1.54),
                                                  // ),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      padding:
                                                          MaterialStatePropertyAll(
                                                        EdgeInsets.all(
                                                            wt * 0.022),
                                                      ),
                                                      shape:
                                                          MaterialStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(wt *
                                                                      0.0154),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        const Color.fromARGB(
                                                            255, 95, 255, 100),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        searchAddedToCart =
                                                            true;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  wt * 0.02),
                                                      child: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                          letterSpacing:
                                                              ht * 0.0009,
                                                          fontSize: ht * 0.027,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          Icons.remove,
                                                        ),
                                                      ),
                                                      Text(
                                                        addedCount.toString(),
                                                        style: TextStyle(
                                                          fontSize: ht * 0.027,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            addedCount < key[1]
                                                                ? addedCount++
                                                                : ();
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons.add,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () async {
                                                      dynamic shopData;
                                                      dynamic shopDataId;
                                                      final url = Uri.https(
                                                        'stent-c581d-default-rtdb.firebaseio.com',
                                                        'stent-search-db.json',
                                                      );
                                                      // var response =
                                                      //     await http.get(url);

                                                      http.post(
                                                        url,
                                                        headers: {
                                                          'Content-Type':
                                                              'application/json',
                                                        },
                                                        body: json.encode(
                                                          {
                                                            'shopName': shopD[
                                                                'shopName'],
                                                            'search':
                                                                searched.text,
                                                            'addedToCart':
                                                                searchAddedToCart,
                                                            'countAdded':
                                                                addedCount,
                                                            'date':
                                                                DateTime.now()
                                                                    .toString(),
                                                            'key': key[0] ?? 0,

                                                            // 'loginID': lID,
                                                          },
                                                        ),
                                                      );

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          duration: Duration(
                                                              seconds: 2),
                                                          content:
                                                              Text('Thanks!'),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          margin:
                                                              EdgeInsets.all(
                                                                  10),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              10,
                                                            ),
                                                          ),
                                                        ),
                                                      );

                                                      setState(() {
                                                        var indexOfKeySearched =
                                                            shopD['shapeInventory']
                                                                .indexWhere((e) =>
                                                                    e['key'] ==
                                                                    key[0]);
                                                        print(shopD['shapeInventory']
                                                                [
                                                                indexOfKeySearched]
                                                            ['list']);

                                                        print(
                                                            indexOfKeySearched);
                                                        var indexOfSearch =
                                                            shopD['shapeInventory']
                                                                        [
                                                                        indexOfKeySearched]
                                                                    ['list']
                                                                .indexWhere((e) =>
                                                                    e["name"] ==
                                                                    searched
                                                                        .text);
                                                        print(indexOfSearch);
                                                        print(shopD['shapeInventory']
                                                                        [
                                                                        indexOfKeySearched]
                                                                    ['list']
                                                                [indexOfSearch]
                                                            ['count']);
                                                        shopD['shapeInventory'][
                                                                        indexOfKeySearched]
                                                                    ['list']
                                                                [indexOfSearch][
                                                            'count'] -= addedCount;

                                                        key = -1;

                                                        searchEntered = false;

                                                        searchAddedToCart =
                                                            false;

                                                        addedCount = 0;
                                                      });

                                                      final url2 = Uri.https(
                                                          'stent-c581d-default-rtdb.firebaseio.com',
                                                          'stent-db.json');
                                                      var response2 =
                                                          await http.get(url2);
                                                      var respBody =
                                                          json.decode(
                                                              response2.body);
                                                      if (respBody == 'null') {
                                                      } else {
                                                        for (var element
                                                            in respBody
                                                                .entries) {
                                                          if (element.value[
                                                                  'shopName'] ==
                                                              shopD[
                                                                  'shopName']) {
                                                            shopDataId =
                                                                element.key;
                                                            shopData =
                                                                element.value;
                                                          }
                                                        }
                                                        final url3 = Uri.https(
                                                            'stent-c581d-default-rtdb.firebaseio.com',
                                                            'stent-db/$shopDataId.json');
                                                        http.put(
                                                          url3,
                                                          headers: {
                                                            'Content-Type':
                                                                'application/json',
                                                          },
                                                          body: json.encode(
                                                            {
                                                              'loginID': [
                                                                shopData[
                                                                    'loginID'][0],
                                                                shopData[
                                                                    'loginID'][1],
                                                              ],
                                                              'shapeInventory':
                                                                  json.encode(shopD[
                                                                      'shapeInventory']),
                                                              'cols': shopData[
                                                                  'cols'],
                                                              'shopName':
                                                                  shopData[
                                                                      'shopName'],
                                                              'positionForEntry':
                                                                  shopData[
                                                                      'positionForEntry'],

                                                              // 'loginID': lID,
                                                            },
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.check,
                                                      color: Colors.black,
                                                      // opticalSize: ht * 0.,
                                                      size: ht * 0.04,
                                                    ))
                                              ],
                                            ),
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}
