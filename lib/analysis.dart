// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, no_logic_in_create_state

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AnalysisPage extends StatefulWidget {
  String shopName;
  int cols;
  List keysSelectedInLayout;
  List availableProducts;
  AnalysisPage(this.shopName, this.cols, this.keysSelectedInLayout,
      this.availableProducts,
      {super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState(
        shopName,
        cols,
        keysSelectedInLayout,
        availableProducts,
      );
}

class _AnalysisPageState extends State<AnalysisPage> {
  final String shopName;
  final int cols;
  final List keysSelectedInLayout;
  final List availableProducts;

  _AnalysisPageState(
    this.shopName,
    this.cols,
    this.keysSelectedInLayout,
    this.availableProducts,
  );
  // String shopname;

  dynamic respBody;

  bool byMonth = false;

  List searchData = [];
  List shopSearchData = [];
  List searchDataCopy = [];
  List shopSearchDataThisMonth = [];
  List shopSearchDataThisMonthInWeek = [];
  List shopSearchDataByDayOfWeek = [];
  List convertedSearches = [];
  List notConvertedSearches = [];
  List searchedKeys = [];
  List productNameAndSearches = [];

  List<bool> sel = [true, false];
  // List searchedKeysCount = [];

  Map<String, List> shopSearchDataThisWeek = {};
  Map<String, List> shopSearchDataWeekWise = {};

  List day1 = [];
  List day2 = [];
  List day3 = [];
  List day4 = [];
  List day5 = [];
  List day6 = [];
  List day7 = [];
  List week1 = [];
  List week2 = [];
  List week3 = [];
  List week4 = [];

  List xyzDOW = [];

  var maxSearchDay = 0;
  var maxSearchWeek = 0;
  var maxSearchProduct = 0;
  var convertedSearchShare = 0.0;
  var notConvertedSearchShare = 0.0;
  Map<String, int> maxSearchedKey = {};
  var maxSearchedKeyCount = 0;

  bool _isDelayed = true;
  bool productWiseConvertedSearches = false;
  bool searchesMade = false;
  void dbAccess() async {
    final url = Uri.https(
      'stent-ebe62-default-rtdb.firebaseio.com',
      'stent-search-db.json',
    );
    dynamic response = await http.get(url);
    print('response');
    print(response.body);
    if (response.body == 'null') {
      searchesMade = false;
    } else {
      respBody = json.decode(response.body);
      // print(searchData);
      for (var element in respBody.entries) {
        searchData.add(element.value);

        searchDataCopy.add({
          'addedToCart': element.value['addedToCart'],
          'countAdded': element.value['countAdded'],
          'date': DateTime.parse(element.value['date'].toString()),
          'search': element.value['search'],
          'shopName': element.value['shopName'],
          'key': element.value['key'],
        });
      }

      for (var element in searchDataCopy) {
        if (element['shopName'] == shopName) {
          searchesMade = true;

          shopSearchData.add(element);

          // print(element['date'].month);
          // print('//');
        }
      }

      if (shopSearchData == []) {
        searchesMade = false;
      }

      for (var element in availableProducts) {
        productNameAndSearches.add({
          'name': element,
          'count': 0,
          'convertedCount': 0,
        });
      }

      // print(shopSearchData);
      // print('//');

      for (var element in shopSearchData) {
        print('//' + '${element['date'].month}' + '//');
        if (element['date'].month == DateTime.now().month &&
            element['date'].year == DateTime.now().year) {
          shopSearchDataThisMonth.add(element);
        }
        if (element['addedToCart'] == true) {
          convertedSearches.add(element);
          productNameAndSearches[productNameAndSearches.indexWhere(
              (e) => e['name'] == element['search'])]['convertedCount']++;
        } else {
          notConvertedSearches.add(element);
        }
        if (searchedKeys.indexWhere((e) => e['key'] == element['key']) == -1) {
          searchedKeys.add(
            {
              'key': element['key'],
              'count': 1,
            },
          );
        } else {
          var keyIndex = searchedKeys.indexWhere(
            (el) => el['key'] == element['key'],
          );
          searchedKeys[keyIndex]['count']++;
        }
        productNameAndSearches[productNameAndSearches
            .indexWhere((e) => e['name'] == element['search'])]['count']++;
      }

      for (var i = 0; i < productNameAndSearches.length; i++) {
        // maxSearchProduct = productNameAndSearches[i]['count'];
        for (var j = i + 1; j < productNameAndSearches.length; j++) {
          if (productNameAndSearches[i]['count'] <
              productNameAndSearches[j]['count']) {
            var temp = productNameAndSearches[i];
            productNameAndSearches[i] = productNameAndSearches[j];
            productNameAndSearches[j] = temp;
          }
        }
      }

      maxSearchProduct = productNameAndSearches[0]['count'];

      for (var i = 0; i < searchedKeys.length; i++) {
        for (var j = i + 1; j < searchedKeys.length; j++) {
          if (searchedKeys[i]['count'] < searchedKeys[j]['count']) {
            maxSearchedKey = {
              'key': searchedKeys[j]['key'],
              'count': searchedKeys[j]['count'],
            };
            i = j - 1;
            break;
          } else {
            maxSearchedKey = {
              'key': searchedKeys[i]['key'],
              'count': searchedKeys[i]['count'],
            };
          }
        }
      }

      searchedKeys.length == 1
          ? maxSearchedKeyCount = searchedKeys[0]['count']
          : maxSearchedKeyCount = maxSearchedKey['count'] ?? 0;

      convertedSearchShare = (convertedSearches.length / shopSearchData.length);
      notConvertedSearchShare =
          (notConvertedSearches.length / shopSearchData.length);

      // print(shopSearchDataThisMonth);

      for (var element in shopSearchDataThisMonth) {
        var x = element['date'].day;
        // print(x);

        if ((DateTime.now().subtract(const Duration(days: 6)).day) == x) {
          day1.add(element);
        } else if ((DateTime.now().subtract(const Duration(days: 5)).day) ==
            element['date'].day) {
          day2.add(element);
        } else if ((DateTime.now().subtract(const Duration(days: 4)).day) ==
            element['date'].day) {
          day3.add(element);
        } else if ((DateTime.now().subtract(const Duration(days: 3)).day) ==
            element['date'].day) {
          day4.add(element);
        } else if ((DateTime.now().subtract(const Duration(days: 2)).day) ==
            element['date'].day) {
          day5.add(element);
        } else if ((DateTime.now().subtract(const Duration(days: 1)).day) ==
            element['date'].day) {
          day6.add(element);
        } else if ((DateTime.now().subtract(const Duration(days: 0)).day) ==
            element['date'].day) {
          day7.add(element);
        }
      }

      shopSearchDataThisWeek = {
        'day_1': day1,
        'day_2': day2,
        'day_3': day3,
        'day_4': day4,
        'day_5': day5,
        'day_6': day6,
        'day_7': day7,
      };

      // print('shopSearchDataThisWeek');
      // print(shopSearchDataThisWeek);

      shopSearchDataByDayOfWeek = [
        day1,
        day2,
        day3,
        day4,
        day5,
        day6,
        day7,
      ];
      // print('shopSearchDataByDayOfWeek');
      // print(shopSearchDataByDayOfWeek);

      for (var element in shopSearchDataByDayOfWeek) {
        xyzDOW.add(element);
      }
      // print('shopSearchDataWeekWise');
      // print(shopSearchDataWeekWise);

      for (var i = 0; i < 7; i++) {
        for (var j = i + 1; j < 7; j++) {
          if (xyzDOW[i].length < xyzDOW[j].length) {
            var temp = xyzDOW[i];
            xyzDOW[i] = xyzDOW[j];
            xyzDOW[j] = temp;
          }
        }
      }
      maxSearchDay = xyzDOW.first.length;

      // print('maxSearchDay');
      // print(maxSearchDay);

      for (var element in shopSearchDataThisMonth) {
        if (element['date']
            .isAfter(DateTime.now().subtract(Duration(days: 7)))) {
          week4.add(element);
        } else if (element['date']
                .isBefore(DateTime.now().subtract(Duration(days: 7))) &&
            element['date']
                .isAfter(DateTime.now().subtract(Duration(days: 14)))) {
          week3.add(element);
        } else if (element['date']
                .isBefore(DateTime.now().subtract(Duration(days: 14))) &&
            element['date']
                .isAfter(DateTime.now().subtract(Duration(days: 21)))) {
          week2.add(element);
        } else if (element['date']
                .isBefore(DateTime.now().subtract(Duration(days: 21))) &&
            element['date']
                .isAfter(DateTime.now().subtract(Duration(days: 28)))) {
          week1.add(element);
        }
      }

      shopSearchDataThisMonthInWeek = [
        week1,
        week2,
        week3,
        week4,
      ];

      xyzDOW = [];

      for (var element in shopSearchDataThisMonthInWeek) {
        xyzDOW.add(element);
      }

      for (var i = 0; i < 4; i++) {
        for (var j = i + 1; j < 4; j++) {
          if (xyzDOW[i].length < xyzDOW[j].length) {
            var temp = xyzDOW[i];
            xyzDOW[i] = xyzDOW[j];
            xyzDOW[j] = temp;
          }
        }
      }
      maxSearchWeek = xyzDOW.first.length;

      shopSearchDataWeekWise = {
        'week_1': week1,
        'week_2': week2,
        'week_3': week3,
        'week_4': week4,
      };
    }

    print('donedbAc');
    // print(searchDataCopy);
    // print('//');

    // print('maxSearchWeek');
    // print(maxSearchWeek);
  }

  @override
  void initState() {
    super.initState();

    dbAccess();
    print('doneinit');
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isDelayed = false;
      });
    });

    // Fetch user data from API using BuildContext
    // userData = fetchUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    List gridSize = List.generate(cols * cols, (index) => index);

    print('building');

    int day = 0;

    var ht = MediaQuery.of(context).size.height;
    var wt = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$shopName',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                // letterSpacing: wt * 0.0027,
                fontSize: ht * 0.03,
              ),
            ),
            Text(
              ' /Analytics',
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
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.blue,
                Colors.lightBlueAccent,
              ],
            ),
          ),
        ),
      ),
      body: _isDelayed
          ? Center(child: CircularProgressIndicator())
          : searchesMade
              ? SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetweens,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: wt * 0.02,
                          vertical: ht * 0.01,
                        ),
                        child: Card(
                          elevation: 10,
                          child: Container(
                            alignment: Alignment.center,
                            // ,
                            height: ht * 0.456,
                            padding: EdgeInsets.symmetric(
                              horizontal: wt * 0.02,
                              vertical: ht * 0.01,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          right: wt * 0.01,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Overall Searches ',
                                              style: TextStyle(
                                                fontSize: ht * 0.024,
                                                fontWeight: FontWeight.w600,
                                                // fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              byMonth
                                                  ? 'Week 4 being the last 7 days'
                                                  : 'Day 7 being today',
                                              style: TextStyle(
                                                fontSize: ht * 0.02,
                                                fontWeight: FontWeight.w400,
                                                // fontStyle: FontStyle.italic,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          child: FilledButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                !byMonth
                                                    ? Colors.blueAccent
                                                    : Colors
                                                        .blueAccent.shade100,
                                              ),
                                              padding: MaterialStatePropertyAll(
                                                EdgeInsets.symmetric(
                                                  horizontal: wt * 0.027,
                                                ),
                                              ),
                                              shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                      wt * 0.03,
                                                    ),
                                                    bottomLeft: Radius.circular(
                                                      wt * 0.03,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                byMonth = false;
                                                day = 0;
                                              });
                                            },
                                            child: Text(
                                              'Week',
                                              style: TextStyle(
                                                color: !byMonth
                                                    ? Colors.black
                                                    : Colors.white,
                                                letterSpacing: wt * 0.0036,
                                                fontSize: ht * 0.02,
                                                fontWeight: FontWeight.w900,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          child: FilledButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                byMonth
                                                    ? Colors.blueAccent
                                                    : Colors
                                                        .blueAccent.shade100,
                                              ),
                                              padding: MaterialStatePropertyAll(
                                                EdgeInsets.symmetric(
                                                  horizontal: wt * 0.027,
                                                ),
                                              ),
                                              shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight: Radius.circular(
                                                      wt * 0.03,
                                                    ),
                                                    bottomRight:
                                                        Radius.circular(
                                                      wt * 0.03,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                byMonth = true;
                                                day = 1;
                                              });
                                            },
                                            child: Text(
                                              'Month',
                                              style: TextStyle(
                                                color: byMonth
                                                    ? Colors.black
                                                    : Colors.white,
                                                letterSpacing: wt * 0.0036,
                                                fontSize: ht * 0.02,
                                                fontWeight: FontWeight.w900,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: wt * 0.0054,
                                      // vertical: ht * 0.01,
                                    ),
                                    margin: EdgeInsets.only(
                                      top: ht * 0.01,
                                    ),
                                    // color: Colors.red,
                                    child: byMonth
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ...shopSearchDataThisMonthInWeek
                                                  .map(
                                                (e) {
                                                  // print(convertedSearchShare);
                                                  day++;
                                                  return Column(
                                                    children: [
                                                      Text(e.length.toString()),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    ht * 0.01),
                                                            topRight:
                                                                Radius.circular(
                                                                    ht * 0.01),
                                                            bottomLeft: e
                                                                        .length >
                                                                    0
                                                                ? Radius.zero
                                                                : Radius.circular(
                                                                    ht * 0.01),
                                                            bottomRight: e
                                                                        .length >
                                                                    0
                                                                ? Radius.zero
                                                                : Radius.circular(
                                                                    ht * 0.01),
                                                          ),
                                                          color: Color.fromARGB(
                                                              102,
                                                              130,
                                                              178,
                                                              255),
                                                        ),
                                                        width: wt * 0.2,
                                                        height: (1 -
                                                                (e.length /
                                                                    maxSearchWeek)) *
                                                            ht *
                                                            0.27,
                                                        // (1 -
                                                        //     (e.length /
                                                        //         maxSearchDay)),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          // Radius.circular(ht * 0.01)
                                                          color:
                                                              Colors.blueAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(ht *
                                                                      0.01),
                                                        ),
                                                        width: wt * 0.2,
                                                        height: ht *
                                                            0.27 *
                                                            e.length /
                                                            maxSearchWeek,
                                                      ),
                                                      Text(
                                                        'Week ' +
                                                            day.toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  );
                                                },
                                              )
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ...shopSearchDataByDayOfWeek.map(
                                                (e) {
                                                  day++;
                                                  return Column(
                                                    children: [
                                                      Text(
                                                        e.length.toString(),
                                                      ),
                                                      SizedBox(
                                                        width: wt * 0.2 * 4 / 7,
                                                        height: ht * 0.33,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: ht *
                                                                  0.3 *
                                                                  (1 -
                                                                      (e.length /
                                                                          maxSearchDay)),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(ht *
                                                                          0.01),
                                                                  topRight: Radius
                                                                      .circular(ht *
                                                                          0.01),
                                                                  bottomLeft: e
                                                                              .length >
                                                                          0
                                                                      ? Radius
                                                                          .zero
                                                                      : Radius.circular(ht *
                                                                          0.01),
                                                                  bottomRight: e
                                                                              .length >
                                                                          0
                                                                      ? Radius
                                                                          .zero
                                                                      : Radius.circular(ht *
                                                                          0.01),
                                                                ),
                                                                color: Color
                                                                    .fromARGB(
                                                                        102,
                                                                        130,
                                                                        178,
                                                                        255),
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  ht * 0.01,
                                                                ),
                                                                color: Colors
                                                                    .blueAccent,
                                                              ),
                                                              height: ht *
                                                                  0.3 *
                                                                  e.length /
                                                                  maxSearchDay,
                                                              // height: ht * 0.26,
                                                            ),
                                                            Text(
                                                              'Day ' +
                                                                  day.toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: wt * 0.02,
                          // vertical: ht * 0.01,
                        ),
                        // height: ht * 0.48,
                        child: Card(
                          elevation: 10,
                          child: Column(
                            children: [
                              Container(
                                // height: ht * 0.11,
                                padding: EdgeInsets.symmetric(
                                  horizontal: wt * 0.02,
                                  vertical: ht * 0.027,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Converted Searches ',
                                      style: TextStyle(
                                        fontSize: ht * 0.024,
                                        fontWeight: FontWeight.w600,
                                        // fontStyle: FontStyle.italic,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'When added to cart after searching, it is referred to as a converted search. ',
                                      style: TextStyle(
                                        fontSize: ht * 0.02,
                                        fontWeight: FontWeight.w400,
                                        // fontStyle: FontStyle.italic,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: wt - (wt * 0.08),
                                height: ht * 0.07,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: ht * 0.07,
                                    minHeight: ht * 0.07,
                                    maxWidth: wt - (wt * 0.8),
                                    minWidth: wt - (wt * 0.8),
                                  ),
                                  // height: ht * 0.09,
                                  // width: (wt),
                                  margin: EdgeInsets.only(
                                    left: wt * 0.027,
                                    right: wt * 0.027,
                                    bottom: ht * 0.01,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      wt * 0.03,
                                    ),
                                    color: Color.fromARGB(102, 130, 178, 255),
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            height: ht * 0.06,
                                            width: (wt - wt * 0.134) *
                                                convertedSearchShare,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                wt * 0.03,
                                              ),
                                              color: Colors.blueAccent,
                                              // color: Colors.blue,
                                            ),
                                            child: Center(
                                              child: Text(
                                                (convertedSearchShare * 100)
                                                        .toStringAsFixed(0) +
                                                    '%',
                                                style: TextStyle(
                                                  fontSize: ht * 0.02,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              productWiseConvertedSearches
                                  ? Container(
                                      // height: ht * 0.11,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: wt * 0.02,
                                        vertical: ht * 0.027,
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                bottom: ht * 0.02,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Converted Searches by Product ',
                                                    style: TextStyle(
                                                      fontSize: ht * 0.024,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      // fontStyle: FontStyle.italic,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Darker bar shows the no. of searches and the other one shows the converted share.',
                                                    style: TextStyle(
                                                      fontSize: ht * 0.02,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      // fontStyle: FontStyle.italic,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ...productNameAndSearches.map((e) {
                                              bool noCount = e['count'] == 0
                                                  ? true
                                                  : false;
                                              bool noConverted =
                                                  e['convertedCount'] == 0
                                                      ? true
                                                      : false;
                                              bool convertedShareOverflow =
                                                  e['count'] /
                                                              maxSearchProduct <
                                                          0.5
                                                      ? false
                                                      : true;
                                              //  bool? insideMaxConverted = e['count']==maxSearchProduct?e['convertedCount']/e['count']<0.1?false:true:null;
                                              return Row(
                                                children: [
                                                  Container(
                                                    width: wt * 0.2,
                                                    child: Text(
                                                      e['name'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: ht * 0.022,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        ht * 0.01,
                                                      ),
                                                      color: noCount
                                                          ? Colors.transparent
                                                          : Color.fromARGB(102,
                                                              130, 178, 255),
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      vertical: ht * 0.01,
                                                    ),
                                                    width: wt * 0.696,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        noCount
                                                            ? SizedBox()
                                                            : noConverted
                                                                ? Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          ht *
                                                                              0.01,
                                                                    ),
                                                                    child:
                                                                        SizedBox(
                                                                      height: ht *
                                                                          0.036,
                                                                      child:
                                                                          Text(
                                                                        '0%',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              ht * 0.024,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Row(
                                                                    children: [
                                                                      Container(
                                                                        width: (wt *
                                                                            0.696 *
                                                                            (e['convertedCount'] /
                                                                                maxSearchProduct)),
                                                                        height: ht *
                                                                            0.036,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              107,
                                                                              164,
                                                                              255),
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            topRight:
                                                                                Radius.circular(ht * 0.01),
                                                                            topLeft:
                                                                                Radius.circular(
                                                                              ht * 0.01,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        child: convertedShareOverflow
                                                                            ? Center(
                                                                                child: Text(
                                                                                  ((e['convertedCount'] / e['count']) * 100).toStringAsFixed(0) + '%',
                                                                                  style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: ht * 0.024,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : null,
                                                                      ),
                                                                      convertedShareOverflow
                                                                          ? SizedBox()
                                                                          : Center(
                                                                              child: Text(
                                                                                ((e['convertedCount'] / e['count']) * 100).toStringAsFixed(0) + '%',
                                                                                style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: ht * 0.024,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                    ],
                                                                  ),
                                                        noCount
                                                            ? SizedBox(
                                                                height:
                                                                    ht * 0.072,
                                                                child: Center(
                                                                  child: Text(
                                                                    '(No searches)',
                                                                    style:
                                                                        TextStyle(
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                width: wt *
                                                                    0.696 *
                                                                    e['count'] /
                                                                    maxSearchProduct,
                                                                height:
                                                                    ht * 0.036,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomRight:
                                                                        Radius
                                                                            .circular(
                                                                      ht * 0.01,
                                                                    ),
                                                                    bottomLeft:
                                                                        Radius
                                                                            .circular(
                                                                      ht * 0.01,
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    e['count']
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize: ht *
                                                                          0.024,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            })
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              Center(
                                child: IconButton(
                                  style: ButtonStyle(
                                    padding: MaterialStatePropertyAll(
                                      EdgeInsets.all(0),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      !productWiseConvertedSearches
                                          ? productWiseConvertedSearches = true
                                          : productWiseConvertedSearches =
                                              false;
                                    });
                                  },
                                  icon: Icon(
                                    productWiseConvertedSearches
                                        ? Icons.close
                                        : Icons.expand_circle_down,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: wt * 0.02,
                          vertical: ht * 0.01,
                        ),
                        child: Card(
                          elevation: 10,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // height: ht * 0.11,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: wt * 0.02,
                                      vertical: ht * 0.027,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hottest Racks ',
                                          style: TextStyle(
                                            fontSize: ht * 0.024,
                                            fontWeight: FontWeight.w600,
                                            // fontStyle: FontStyle.italic,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          'The darker the blue, the more searched. ',
                                          style: TextStyle(
                                            fontSize: ht * 0.02,
                                            fontWeight: FontWeight.w400,
                                            // fontStyle: FontStyle.italic,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: wt * 0.02,
                                      vertical: ht * 0.01,
                                    ),
                                    // color: Colors.red,
                                    height: wt * 0.88,
                                    width: wt * 0.88,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 4,
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      color: Colors.transparent,
                                      child: GridView(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: cols,
                                          childAspectRatio: 1,
                                        ),
                                        children: [
                                          ...gridSize.map(
                                            (e) {
                                              // maxSearchedKeyCount =
                                              //     maxSearchedKey['count'];
                                              bool keyInLayoutSearched;
                                              bool keyInLayout;
                                              int countOfSearchedKey = 0;
                                              Color colorOfTile =
                                                  Colors.transparent;

                                              if (searchedKeys.indexWhere(
                                                      (element) =>
                                                          element['key'] ==
                                                          e) ==
                                                  -1) {
                                                keyInLayoutSearched = false;
                                              } else {
                                                keyInLayoutSearched = true;
                                                countOfSearchedKey =
                                                    searchedKeys[searchedKeys
                                                        .indexWhere((element) =>
                                                            element['key'] ==
                                                            e)]['count'];
                                                if (countOfSearchedKey ==
                                                    maxSearchedKeyCount) {
                                                  colorOfTile = Colors
                                                      .blueAccent.shade700;
                                                } else if (countOfSearchedKey >=
                                                    (maxSearchedKeyCount *
                                                        77 /
                                                        100)) {
                                                  colorOfTile =
                                                      Colors.blueAccent;
                                                } else if (countOfSearchedKey >=
                                                    (maxSearchedKeyCount *
                                                        44 /
                                                        100)) {
                                                  colorOfTile = Colors
                                                      .blueAccent.shade400;
                                                } else if (countOfSearchedKey >=
                                                    (maxSearchedKeyCount *
                                                        22 /
                                                        100)) {
                                                  colorOfTile = Colors
                                                      .blueAccent.shade200;
                                                } else {
                                                  colorOfTile = Colors
                                                      .blueAccent.shade100;
                                                }
                                              }
                                              if (keysSelectedInLayout
                                                      .indexWhere((element) =>
                                                          element == e) ==
                                                  -1) {
                                                keyInLayout = false;
                                              } else {
                                                keyInLayout = true;
                                              }

                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: keyInLayoutSearched
                                                      ? colorOfTile
                                                      : const Color.fromARGB(
                                                          0, 255, 0, 0),
                                                  border: keyInLayout
                                                      ? Border.all(
                                                          color: Colors.brown,
                                                          width: 2,
                                                        )
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text('hi'),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    'No searches made on $shopName',
                  ),
                ),
    );
  }
}

// class
