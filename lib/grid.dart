// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stent/add_inv.dart';
import 'package:stent/gridSpaceProvider.dart';
import 'grid_spaces.dart';

class GridLayoutBuilder extends StatefulWidget {
  GridLayoutBuilder({super.key});
  @override
  State<GridLayoutBuilder> createState() => _GridLayoutBuilderState();
}

class _GridLayoutBuilderState extends State<GridLayoutBuilder> {
  final String alp = 'ABCDEFGHIJKLMNOPQRSTUVXYZ';
  bool change = false;

  // var colForEntry = 3.54;
  // var position = '${cols}A';
  var positionForEntry = 0;
  var position = 1;
  @override
  Widget build(BuildContext context) {
    return Consumer<GSProvider>(
      builder: (context, data, child) {
        (data.gridMap.toString());

        positionForEntry = (data.cols * (data.cols - 1)) + position;
        (positionForEntry);
        int x = data.cols;
        var ht = MediaQuery.of(context).size.height;
        var wt = MediaQuery.of(context).size.width;
        Widget changeSizeWidget = Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(),
              padding: EdgeInsets.all(4),
              margin: EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 0,
              ),
              child: Center(
                child: Text(
                  'Please note: Any changes made will dispose of all the selections made thus far.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  onPressed: data.decrementCols,
                  icon: Icon(Icons.remove),
                  style: ButtonStyle(
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.all(0),
                    ),
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(107, 41, 130, 203),
                    ),
                    iconSize: MaterialStatePropertyAll(33),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: wt * 0.054),
                  child: Text(
                    data.cols.toString(),
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  onPressed: () {
                    data.incrementCols();
                  },
                  icon: Icon(
                    Icons.add_outlined,
                    weight: 20,
                  ),
                  style: ButtonStyle(
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.all(0),
                    ),
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(107, 41, 130, 203),
                    ),
                    iconSize: MaterialStatePropertyAll(33),
                  ),
                ),
              ],
            ),
          ],
        );
        // (data.counterPositions);
        // (d)
        return Container(
          height: change == false ? ht * 0.88 : ht * 0.9,
          padding: EdgeInsets.symmetric(),
          width: wt,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            border: Border.all(
              width: 2,
              color: Colors.blue[900]!,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    height: wt * 0.9,
                    width: wt * 0.9,
                    margin: change == false
                        ? EdgeInsets.only(
                            top: ht * 0.027,
                            bottom: 0,
                            left: ht * 0.027,
                            right: ht * 0.027)
                        : EdgeInsets.only(
                            top: ht * 0.02,
                            bottom: 0,
                            left: ht * 0.02,
                            right: ht * 0.02),
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: data.cols,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 3,
                        childAspectRatio: 1,
                      ),
                      children: [
                        ...data.gridMap.map(
                          (f) {
                            var r = (f.i / x).ceil();
                            var c = alp[(f.i % x)];
                            if (c == 'A') {
                              r++;
                            }

                            bool entry = f.i ==
                                    ((data.cols * (data.cols - 1)) + position)
                                ? true
                                : false;

                            bool counter = data.counterPositions.contains(f.i)
                                ? true
                                : false;

                            (data.counterPositions);

                            (counter);

                            // (positionForEntry);
                            return InkWell(
                              onTap: counter || entry
                                  ? null
                                  : data.selGS.indexWhere((element) =>
                                              element['key'] == f.i) !=
                                          -1
                                      ? () => data.removeSelGS(f.i)
                                      : () {
                                          if (change == true) {
                                            setState(() {
                                              change = false;
                                            });
                                          }
                                          data.changeGS(f.i);
                                        },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: counter
                                      ? Border.all(
                                          color: Colors.grey,
                                        )
                                      : Border.all(
                                          color: f.border,
                                        ),
                                  borderRadius: BorderRadius.circular(5),
                                  color: counter ? Colors.red : f.bg,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: f.i ==
                                            (data.cols * (data.cols - 1) +
                                                position)
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        counter
                                            ? 'COUNTER'
                                            : entry
                                                ? 'ENTRY'
                                                : '${r}${c}',
                                        style: f.bg == Colors.white
                                            ? TextStyle(
                                                fontSize: counter
                                                    ? ht * 0.0135 * (5 / x)
                                                    : entry
                                                        ? ht * 0.0135 * (6 / x)
                                                        : ht * 0.022 * (6 / x),
                                                fontWeight: FontWeight.bold,
                                                color: counter
                                                    ? Colors.white
                                                    : entry
                                                        ? Colors.red
                                                        : Color.fromARGB(
                                                            107, 41, 130, 203),
                                              )
                                            : TextStyle(
                                                // overflow: TextOverflow.clip,
                                                fontSize: 18 * (6 / x),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontStyle: FontStyle.italic),
                                      ),
                                      f.i ==
                                              (data.cols * (data.cols - 1) +
                                                  position)
                                          ? Container(
                                              // color: Colors.red,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5),
                                                ),
                                                border: Border.all(
                                                  color: Colors.red,
                                                  width: 5 - (data.cols / 5),
                                                ),
                                              ),
                                              // width: (wt*0.9)
                                              height: ((wt * 0.9) / data.cols) *
                                                  0.3,
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ht * 0.0135,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: wt * 0.03,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: wt * 0.9 / 10,
                              height: wt * 0.9 / 20,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.red,
                                  width: 5,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: wt * 0.027,
                              ),
                              child: Text(
                                'Entry',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  setState(() {
                                    position--;
                                  });
                                },
                                icon: Icon(Icons.chevron_left)),
                            IconButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  setState(() {
                                    position++;
                                  });
                                },
                                icon: Icon(Icons.chevron_right)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ht * 0.0135,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: null,
                        child: Text(
                          'Counter(s):',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      // Text('c'),
                      Row(
                        children: [
                          ...data.counterPositions.map(
                            (cP) => Container(
                              height: wt * 0.054,
                              width: wt * 0.5 / data.counterPositions.length,
                              child: TextFormField(
                                // scrollController: ,
                                onFieldSubmitted: (val) {
                                  // ('running');
                                  var counterColumn =
                                      alp.indexOf(val[val.length - 1]);
                                  (counterColumn);
                                  var counterRow = int.parse(
                                          val.substring(0, val.length - 1)) -
                                      1;

                                  (counterRow);

                                  int k =
                                      (counterRow * data.cols) + counterColumn;
                                  (k);
                                  data.setCounterPositions(k);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              data.removeCounterPosition();
                            },
                            icon: Icon(Icons.remove),
                          ),
                          IconButton(
                            onPressed: () {
                              data.addCounterPosition();
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: ht * 0.0135,
                  ),
                ],
              ),
              change == false
                  ? TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(107, 41, 130, 203),
                        ),
                      ),
                      onPressed: () {
                        setState(
                          () {
                            change = true;
                          },
                        );
                      },
                      child: Text(
                        'Change Size',
                        style: TextStyle(
                          fontSize: ht * 0.027,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : changeSizeWidget,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Layout set?',
                    style: TextStyle(
                        fontSize: ht * 0.02,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      padding: MaterialStatePropertyAll(
                        EdgeInsets.only(left: 5),
                      ),
                    ),
                    onPressed: () {
                      data.setPosition(
                        position,
                      );
                      Navigator.of(context).pop();
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          isScrollControlled: true,
                          isDismissible: true,
                          context: context,
                          builder: (context) {
                            return Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: inventoryAddition());
                          });
                    },
                    child: Text(
                      'Proceed to adding your inventory',
                      style: TextStyle(
                        fontSize: ht * 0.02,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

