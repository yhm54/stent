// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InventoryPage extends StatefulWidget {
  String shopName;
  InventoryPage(this.shopName, {super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState(shopName);
}

class _InventoryPageState extends State<InventoryPage> {
  String shopName;

  _InventoryPageState(this.shopName);

  int k = 0;

  bool _isDelayed = true;

  dynamic respBody;

  String newCategory = "";
  String newItemName = "";
  int newCount = 0;
  int key = 0;

  TextEditingController keyC = TextEditingController();
  TextEditingController itemNameC = TextEditingController();
  TextEditingController itemCountC = TextEditingController();
  // TextEditingController categor = TextEditingController();

  List shapeInventory = [];
  bool keySelected(int key) {
    return shapeInventory.indexWhere((element) => element['key'] == key) != -1
        ? true
        : false;
  }

  void addInventory(int key, String itemName, int count) {
    print(key);
    print("index");
    // print(shapeInventory);
    print(shapeInventory.indexWhere((element) => element['key'] == key));
    shapeInventory.indexWhere((element) => element['key'] == key) != -1
        ?
          // print("key in si");
          // print(shapeInventory
                // .indexWhere((element) => element['key'] == key));
          shapeInventory[shapeInventory
                .indexWhere((element) => element['key'] == key)]['list']
            .add(
            {
              'itemNo': shapeInventory[shapeInventory
                      .indexWhere((element) => element['key'] == key)]['list']
                  .length,
              'name': itemName,
              'count': count,
              'description': [],
            },
          )
        // }
        : shapeInventory.add({
            'key': key,
            'list': [
              {
                'itemNo': 0,
                'name': itemName,
                'count': count,
                'description': [],
              }
            ],
            'category': "",
          });

    print(shapeInventory);

    
  }

  bool addItem = false;

  var shopData;
  var shopId;
  int cols = 1;
  Future<void> dbAccess() async {
    // print('//');
    final url =
        Uri.https('stent-ebe62-default-rtdb.firebaseio.com', 'stent-db.json');
    dynamic response = await http.get(url);
    respBody = json.decode(response.body);
    for (var element in respBody.entries) {
      // print(element);
      if (element.value['shopName'] == shopName) {
        shopData = element.value;
        shopId = element.key;

        shapeInventory = json.decode(element.value['shapeInventory']);
        cols = element.value['cols'];

        break;
        // shopData =(shopData);
      }
    }

    // print(shopData);

    // return shopData['cols'];

    // print(shapeInventory);
  }

  @override
  void initState() {
    dbAccess();

    // print(x);
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isDelayed = false;
      });
      // super.initState();
    });
    super.initState();

    // Future.wait(dbAccess());

    // Fetch user data from API using BuildContext
    // userData = fetchUserData(context);
  }

  String alp = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  // print(shapeInventory);
  // print(shapeInventory);
  // print(shapeInventory);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    var ht = MediaQuery.of(context).size.height;
    var wt = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ht * 0.1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop(shapeInventory);
          },
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              shopName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                // letterSpacing: wt * 0.0027,
                fontSize: ht * 0.03,
              ),
            ),
            Text(
              ' /Inventory',
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
      body: _isDelayed
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: wt * 0.03),
                child: Column(
                  children: [
                    ...shapeInventory.map(
                      (e) {
                        var keyIndex = shapeInventory.indexOf(e);
                        keyIndex == 0 ? print(shapeInventory) : ();
                        return Column(
                          children: [
                            ...e['list'].map(
                              (f) {
                                var row = (e['key'] / cols).floor() + 1;
                                var col = alp[(e['key'] % cols)];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: wt * 0.01,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                            ),
                                            child: Text('$row$col')),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: wt * 0.03,
                                          ),
                                          decoration: BoxDecoration(
                                              // border: Border.fromBorderSide(top: Border.all()),
                                              ),
                                          child: Text(f['name'].toString()),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              shapeInventory[keyIndex]['list']
                                                  [f['itemNo']]['count']--;
                                              // shapeInventory[shapeInventory.indexOf(element)]
                                            });
                                          },
                                          icon: Icon(Icons.remove),
                                        ),
                                        Text(f['count'].toString()),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              shapeInventory[keyIndex]['list']
                                                  [f['itemNo']]['count']++;
                                              // shapeInventory[shapeInventory.indexOf(element)]
                                            });
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    addItem
                        ? Row(
                            children: [
                              Container(
                                width: wt * 0.1,
                                child: TextFormField(
                                  controller: keyC,
                                  onFieldSubmitted: (val) {
                                    var counterColumn =
                                        alp.indexOf(val[val.length - 1]);
                                    (counterColumn);
                                    var counterRow = int.parse(
                                            val.substring(0, val.length - 1)) -
                                        1;

                                    (counterRow);

                                    k = (counterRow * cols) + counterColumn;
                                    print(k);

                                    // var col = value[value.length-1];
                                    keySelected(k);
                                  },
                                ),
                              ),
                              Container(
                                width: wt * 0.4,
                                child: TextFormField(
                                  controller: itemNameC,
                                  onFieldSubmitted: (val) {},
                                ),
                              ),
                              Container(
                                width: wt * 0.1,
                                child: TextFormField(
                                  controller: itemCountC,
                                  onFieldSubmitted: (val) {
                                    // var col = value[value.length-1];
                                    // keySelected(k);
                                  },
                                ),
                              ),
                              TextButton(
                                  child: Text('submit'),
                                  onPressed: () {
                                    var counterColumn =
                                        alp.indexOf(keyC.text[keyC.text.length - 1]);
                                    (counterColumn);
                                    var counterRow = int.parse(
                                            keyC.text.substring(0, keyC.text.length - 1)) -
                                        1;

                                    (counterRow);

                                    k = (counterRow * cols) + counterColumn;
                                    // print(k);

                                    addInventory(
                                      k,
                                      itemNameC.text,
                                      int.parse(itemCountC.text),
                                    );
                                  })
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  addItem = true;
                });
              },
              icon: Icon(Icons.add)),
          IconButton(
            onPressed: () {
              final url2 = Uri.https('stent-ebe62-default-rtdb.firebaseio.com',
                  'stent-db/$shopId.json');
              http.put(
                url2,
                headers: {
                  'Content-Type': 'application/json',
                },
                body: json.encode(
                  {
                    'loginID': [
                      shopData['loginID'][0],
                      shopData['loginID'][1],
                    ],
                    'shapeInventory': json.encode(shapeInventory),
                    'cols': shopData['cols'],
                    'shopName': shopName,
                    'positionForEntry': shopData['positionForEntry'],

                    // 'loginID': lID,
                  },
                ),
              );
              Navigator.pop(context);
              // Navigator.of(context).pop();
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
