// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:stent/inventory.dart';
import 'dart:convert';
import 'analysis.dart';
// import 'package:http/http.dart' as http;
// import 'package:fancy_button_flutter/fancy_button_flutter.dart';

class ShopkeeperHomePage extends StatefulWidget {
  final dynamic shopLayoutData;

  final dynamic shopSearchData;
  const ShopkeeperHomePage(this.shopLayoutData, this.shopSearchData,
      {super.key});

  @override
  State<ShopkeeperHomePage> createState() =>
      _ShopkeeperHomePageState(shopLayoutData, shopSearchData);
}

class _ShopkeeperHomePageState extends State<ShopkeeperHomePage> {
  dynamic shopLayoutData;

  dynamic shopSearchData;
  _ShopkeeperHomePageState(
    this.shopLayoutData,
    this.shopSearchData,
  );
  // var i = 0;
  var showTF = 0;

  var mostSeachedForItem = [];
  var leastSeachedForItem = [];
  var mostConvertedSearch = [];
  var leastConvertedSearch = [];

  bool expandConvertedSearches = false;
// print(mostSeachedForItem);

  // shopLayoutData = shopLayoutData.toString().
  @override
  Widget build(BuildContext context) {
    // print('new Page');
    // print(shopSearchData);
    // print('another one');
    // print(shopLayoutData);
    var cols = shopLayoutData['cols'];

    List gridSize = List.generate(
        shopLayoutData['cols'] * shopLayoutData['cols'], (index) => index);

    // var shopName = shopSearchData[0]['shopName'];

    var wt = MediaQuery.of(context).size.width;
    var ht = MediaQuery.of(context).size.height;

    List availableProducts = [];

    for (var element in json.decode(shopLayoutData['shapeInventory'])) {
      for (var el in element['list']) {
        availableProducts.add(el['name']);
      }
    }
    // (shopD);

    List selected = [];
    List sel = [];
    List searches = [];
    List searchesAndCount = [];

    String alp = 'aabcdefghijklmnopqrstuvwxyz'.toUpperCase();

    var max, least;
    double maxCS = 0.0, leastCS = 0.0;

    if (shopSearchData.length > 0) {
      for (var element in shopSearchData) {
        if (searches.contains(element['search']) == false) {
          searches.add(element['search']);
          searchesAndCount.add(
            {
              'search': element['search'],
              'count': 1,
              'convertedSearch': element['addedToCart'] == false
                  ? {
                      false: 1,
                      true: 0,
                    }
                  : {
                      false: 0,
                      true: 1,
                    },
            },
          );
        } else {
          searchesAndCount[searchesAndCount.indexWhere(
              (el) => el['search'] == element['search'])]['count']++;
          if (element['countAdded'] == 0) {
            searchesAndCount[searchesAndCount
                    .indexWhere((el) => el['search'] == element['search'])]
                ['convertedSearch'][false]++;
          } else {
            searchesAndCount[searchesAndCount
                    .indexWhere((el) => el['search'] == element['search'])]
                ['convertedSearch'][true]++;
          }
        }
      }

      for (var i = 0; i < searchesAndCount.length; i++) {
        for (var j = 0; j < searchesAndCount.length; j++) {
          if (searchesAndCount[i]['count'] < searchesAndCount[j]['count']) {
            dynamic temp = searchesAndCount[i];
            searchesAndCount[i] = searchesAndCount[j];
            searchesAndCount[j] = temp;
          }
        }
      }

      mostSeachedForItem.add(searchesAndCount[searchesAndCount.length - 1]);
      max = searchesAndCount[searchesAndCount.length - 1]['count'];
      leastSeachedForItem.add(searchesAndCount[0]);
      least = searchesAndCount[0];

      maxCS = 0;

      for (var element in searchesAndCount) {
        var percent = element['convertedSearch'][true] /
            (element['convertedSearch'][true] +
                element['convertedSearch'][false]);
        if (percent > maxCS) {
          maxCS = percent;
          mostConvertedSearch = [];
          mostConvertedSearch.add(element);
        } else if (percent == maxCS && maxCS != 0) {
          mostConvertedSearch.add(element);
        }
      }

      leastCS = 0;

      for (var element in searchesAndCount) {
        var percent = element['convertedSearch'][false] /
            (element['convertedSearch'][true] +
                element['convertedSearch'][false]);
        if (leastCS < percent) {
          leastCS = percent;
          leastConvertedSearch = [];
          leastConvertedSearch.add(element);
        } else if ((leastCS == percent)) {
          if (percent != 0) {
            leastConvertedSearch.add(element);
          }
        }
      }
    }
    List mostCSInVolume = [];
    List leastCSInVolume = [];
    List inventory = [];

    // print('//searches//');
    // print(searches);

    // print(searchesAndCount);

    // (e);
    // bool l
    // decoded.add((e));

    // var i = availableShops.indexOf(e['shopGridData']);

    // (i);
    var last = json.decode(shopLayoutData['shapeInventory']).length;
    for (int x = 0; x < last; x++) {
      var y = json.decode(shopLayoutData['shapeInventory']);
      // print('//');
      // print(y[x]);
      sel.add(y[x]['key']);
      for (var index = 0; index < y[x]['list'].length; index++) {
        inventory.add({
          'key': y[x]['key'],
          'item': y[x]['list'][index]['name'],
          'count': y[x]['list'][index]['count'],
        });
      }
      selected.add(
        {'k': x, 'l': false, 'r': false, 't': false, 'b': false},
      );
    }

    // print(inventory);

    //  ();
    for (var y = 0; y < last; y++) {
      bool l = false, r = false, b = false, t = false;
      if (sel.contains(sel[y] + 1)) {
        if (((sel[y] + 1) % shopLayoutData['cols']) != 0) {
          r = true;
        }
      }
      if (sel.contains(sel[y] + shopLayoutData['cols'])) {
        b = true;
      }
      if (sel.contains((sel[y] - 1))) {
        if (((sel[y] - 1) % shopLayoutData['cols']) !=
            (shopLayoutData['cols'] - 1)) {
          l = true;
        }
      }
      if (sel.contains(sel[y] - shopLayoutData['cols'])) {
        t = true;
      }

      selected[y] = {'k': y, 'l': l, 'r': r, 't': t, 'b': b};

      // (false);
    }

    findKey(String searchedItem, List Data) {
      for (var i = 0; i < Data.length; i++) {
        for (var element in Data[i]['list']) {
          if (searchedItem == element['name']) {
            return [Data[i]['key'], element['count']];
          }
        }
      }
      return -1;
    }

    List statsWidget = [
      {
        'title': 'Most: ',
        'result': mostSeachedForItem,
        'quantity': '$max',
      },
      {
        'title': 'Least(of those searched): ',
        'result': leastSeachedForItem,
        'quantity': '$least',
      },
      {
        'title': 'Most converted search: ',
        'result': mostConvertedSearch,
        'quantity': '${(maxCS * 100).toStringAsFixed(0)}%'
      },
      {
        'title': 'Least converted search: ',
        'result': leastConvertedSearch,
        'quantity': '${(100 - (leastCS * 100)).toStringAsFixed(0)}%'
      },
      {
        'title': 'Most converted(in volume): ',
        'result': [],
        'quantity': '',
      },
      {
        'title': 'Least converted(in volume): ',
        'result': [],
        'quantity': '',
      },
    ];

    // print(maxCS.to)

    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color onPrimaryColor = Theme.of(context).colorScheme.onPrimary;

    Color bgColor = Color.fromARGB(255, 0, 0, 0);
    return Scaffold(
      appBar: AppBar(
        // height: ,
        toolbarHeight: ht * 0.1,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              shopLayoutData['shopName'],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                // letterSpacing: wt * 0.0027,
                fontSize: ht * 0.03,
              ),
            ),
            Text(
              ' /Home',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                // letterSpacing: wt * 0.00135,

                fontSize: ht * 0.028,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: onPrimaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.6),
            image: DecorationImage(
              opacity: 0.154,
              // scale: 0.1,
              repeat: ImageRepeat.repeat,
              image: AssetImage(
                "assets/images/stent_bg_1.jpeg",
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: ht * 0.027,
              ),
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: wt * 0.0254,
                  vertical: ht * 0.01,
                ),
                // shadowColor: Colors.transparent,
                // color: Colors.transparent,
                elevation: 10,
                child: Column(
                  children: [
                    Container(
                      // color: Colors.white,
                      // height: ht * 0.11,
                      padding: EdgeInsets.symmetric(
                        horizontal: wt * 0.05,
                        vertical: ht * 0.01,
                      ),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'LAYOUT ',
                            style: TextStyle(
                              fontSize: ht * 0.027,
                              fontWeight: FontWeight.w900,
                              // fontStyle: FontStyle.italic,
                              color: onPrimaryColor,
                            ),
                          ),
                          Text(
                            '[Click to edit...]',
                            style: TextStyle(
                              color: onPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: wt * 0.88,
                      width: wt * 0.88,
                      padding: EdgeInsets.all(wt * 0.03),
                      // color: onPrimaryColor.withOpacity(0.5),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        // borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 6,
                          color: onPrimaryColor.withOpacity(0.5),
                          // width: 4,
                        ),
                      ),
                      margin: EdgeInsets.only(
                        top: wt * 0.02,
                        left: wt * 0.02,
                        right: wt * 0.02,
                        // vertical: wt * 0.02,
                      ),
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: shopLayoutData['cols'],
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          childAspectRatio: 1,
                        ),
                        children: [
                          ...gridSize.map(
                            (f) {
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
                              //     cols * cols,
                              //     (index) => index);

                              // var r = (f.i / x).ceil();
                              // var c = alp[(f.i % x)];
                              // if (c == 'A') {
                              //   r++;
                              // }
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: present
                                      ? Border(
                                          top: topp
                                              ? BorderSide(
                                                  color: Colors.lightBlueAccent,
                                                  width: 0.5)
                                              : BorderSide(
                                                  color: onPrimaryColor
                                                      .withOpacity(0.5),
                                                  width: 4,
                                                ),
                                          bottom: bottomm
                                              ? BorderSide(
                                                  color: Colors.lightBlueAccent,
                                                  width: 0.5)
                                              : BorderSide(
                                                  color: onPrimaryColor
                                                      .withOpacity(0.5),
                                                  width: 4,
                                                ),
                                          left: leftt
                                              ? BorderSide(
                                                  color: Colors.lightBlueAccent,
                                                  width: 0.5)
                                              : BorderSide(
                                                  color: onPrimaryColor
                                                      .withOpacity(0.5),
                                                  width: 4,
                                                ),
                                          right: rightt
                                              ? BorderSide(
                                                  color: Colors.lightBlueAccent,
                                                  width: 0.5)
                                              : BorderSide(
                                                  color: onPrimaryColor
                                                      .withOpacity(0.5),
                                                  width: 4,
                                                ),
                                        )
                                      : Border.all(
                                          color: Colors.grey,
                                          width: 0.054,
                                        ),

                                  // borderRadius: BorderRadius.circular(1),
                                  // color: selected.contains(f)
                                  //     ? Colors.black
                                  //     : Colors.white,
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
                    SizedBox(
                      height: ht * 0.027,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: ht * 0.027,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => AnalysisPage(
                        shopLayoutData['shopName'],
                        shopLayoutData['cols'],
                        sel,
                        availableProducts,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: wt * 0.0254,
                    vertical: ht * 0.01,
                  ),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: ht * 0.01,
                    ),
                    // height: ht * 0.36,
                    // width: wt * 0.92,
                    // alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          // height: ht * 0.11,
                          padding: EdgeInsets.symmetric(
                            horizontal: wt * 0.03,
                            vertical: ht * 0.01,
                          ),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'OVERALL STATS',
                                style: TextStyle(
                                  fontSize: ht * 0.027,
                                  fontWeight: FontWeight.w900,
                                  // fontStyle: FontStyle.italic,
                                  color: onPrimaryColor,
                                ),
                              ),
                              Text(
                                '[Click to explore...]',
                                style: TextStyle(
                                  color: onPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: wt * 0.9,
                          margin: EdgeInsets.symmetric(
                            horizontal: wt * 0.03,
                          ),
                          child: Column(
                            children: [
                              ...statsWidget.map(
                                (e) => Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          e['title'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: onPrimaryColor,
                                            fontSize: ht * 0.018,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        e["result"].length > 0
                                            ? Container(
                                              alignment: Alignment.centerRight,
                                              width: wt*0.4,
                                              child: Text(
                                                  e["result"][0]["search"]
                                                      .toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: onPrimaryColor,
                                                    fontSize: ht * 0.018,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                            )
                                            : SizedBox(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ht * 0.027,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) =>
                              InventoryPage(shopLayoutData['shopName'])));
                },
                child: Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: wt * 0.03,
                    vertical: ht * 0.01,
                  ),
                  // clipBehavior: Clip.hardEdge,
                  elevation: 10,
                  child: Column(
                    children: [
                      Container(
                        // height: ht * 0.11,
                        padding: EdgeInsets.only(
                          right: wt * 0.03,
                          left: wt * 0.03,
                          top: ht * 0.01,
                          bottom: ht * 0.01,
                          // vertical: ht * 0.01,
                        ),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'INVENTORY',
                              style: TextStyle(
                                fontSize: ht * 0.027,
                                fontWeight: FontWeight.w900,
                                // fontStyle: FontStyle.italic,
                                color: onPrimaryColor,
                              ),
                            ),
                            Text(
                              '[Click to manage...]',
                              style: TextStyle(
                                // fontSize: ht * 0.02,
                                // fontWeight: FontWeight.w900,
                                // fontStyle: FontStyle.italic,
                                color: onPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: wt * 0.03,
                          // vertical: ht * 0.01,
                        ),
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 3, 168, 244),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: TextField(
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            label: Text(
                              'Search',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: ht * 0.66,
                        // width: wt * 0.92,
                        // color: onPrimaryColor.withOpacity(0.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // margin: EdgeInsets.all(
                        // ),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          // alignment: Alignment.centerLeft,
                          child: SingleChildScrollView(
                            child: Column(children: [
                              ...inventory.map((e) {
                                var row = (e['key'] / cols).floor() + 1;
                                var col = alp[(e['key'] % cols) + 1];
                                return Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              child: Text(
                                                row.toString() + col,
                                                style: TextStyle(
                                                  letterSpacing: 2,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: ht * 0.024,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: wt * 0.054),
                                            Text(
                                              e['item'],
                                              style: TextStyle(
                                                color: onPrimaryColor,
                                                fontSize: ht * 0.027,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          e['count'].toString(),
                                          style: TextStyle(
                                            color: onPrimaryColor,
                                            fontSize: ht * 0.027,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                      height: ht * 0.0054,
                                    )
                                  ],
                                );
                              })
                            ]),
                            // child: Column(children: []),
                          ),
                        ),
                      ),
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
