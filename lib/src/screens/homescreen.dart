import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_matters_v3/controllers/db_helper.dart';
import 'package:money_matters_v3/models/transaction_model.dart';
import 'package:money_matters_v3/src/screens/addtransaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_matters_v3/src/screens/flutterwave.dart';
import 'package:money_matters_v3/src/screens/widgets/confirm_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//
  DbHelper dbHelper = DbHelper();

//
  DateTime today = DateTime.now();
  late Box box;
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  List<FlSpot> dataset = [];

  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  List<FlSpot> getPlotPoints(List<TransactionModel> entireData) {
    dataset = [];
    /*entireData.forEach((key, value) {
      if (value['type'] == "Expense" &&
          (value['date'] as DateTime).month == today.month) {
        dataset.add(
          FlSpot(
            (value['date'] as DateTime).day.toDouble(),
            (value['amount'] as int).toDouble(),
          ),
        );
      }
    });*/

    List tempDataSet = [];
    for (TransactionModel data in entireData) {
      if (data.date.month == today.month && data.type == 'Expense') {
        tempDataSet.add(data);
      }
    }
    tempDataSet.sort((a, b) => a.date.day.compareTo(b.date.day));
    for (var i = 0; i < tempDataSet.length; i++) {
      dataset.add(FlSpot(tempDataSet[i].date.day.toDouble(),
          tempDataSet[i].amount.toDouble()));
    }

    return dataset;
  }

  getTotalBalance(List<TransactionModel> entireData) {
    totalBalance = 0;
    totalExpense = 0;
    totalIncome = 0;

    //entireData.forEach((key, value) {
    // if (value['type'] == 'Income') {
    //  totalBalance += (value['amount'] as int);
    //totalIncome += (value['amount'] as int);
    // } else {
    //totalBalance -= (value['amount'] as int);
    // totalExpense -= (value['amount'] as int);
    //  }
    // });

    for (TransactionModel data in entireData) {
      if (data.date.month == today.month) {
        if (data.type == 'Income') {
          totalBalance += data.amount;
          totalIncome += data.amount;
        } else {
          totalBalance -= data.amount;
          totalExpense -= data.amount;
        }
      }
    }
  }

  Future<List<TransactionModel>> fetch() async {
    if (box.values.isEmpty) {
      return Future.value([]);
    } else {
      List<TransactionModel> items = [];
      box.toMap().values.forEach((element) {
        items.add(
          TransactionModel(
            element['amount'] as int,
            element['date'] as DateTime,
            element['note'],
            element['type'],
          ),
        );
      });
      return items;
    }
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box('money');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      //
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => AddTransaction(),
            ),
          )
              .whenComplete(() {
            setState(() {});
          });
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Icon(
          Icons.add,
          size: 32.0,
        ),
      ),
      body: FutureBuilder<List<TransactionModel>>(
          future: fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('An Error Has Occured!'),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No values Found'),
                );
              }
              getTotalBalance(snapshot.data!);
              getPlotPoints(snapshot.data!);

              //if (snapshot.hasData) {
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: Colors.black12,
                              ),
                              padding: EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.emoji_emotions,
                                size: 32.0,
                                color: Colors.amber,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              'Welcome',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.amber,
                              ),
                            )
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.black12,
                          ),
                          padding: EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => flutest()));
                            },
                            child: Icon(
                              Icons.payment,
                              size: 32.0,
                              color: Colors.amber,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber,
                            Colors.amberAccent,
                          ],
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(24.0),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
                      child: Column(
                        children: [
                          Text(
                            'Total Balance',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'Ugx  $totalBalance',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                              8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cardIncome(
                                  totalIncome.toString(),
                                ),
                                cardExpense(
                                  totalExpense.toString(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //
                  //
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Expenses',
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.amber,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  //
                  //
                  dataset.length < 2
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 5,
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 40.0,
                          ),
                          margin: EdgeInsets.all(12.0),
                          child: Text(
                            'Not enough Data available.',
                            style: TextStyle(
                              fontSize: 32.0,
                              color: Colors.amber,
                              fontWeight: FontWeight.w900,
                            ),
                          ))
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 5,
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 40.0,
                          ),
                          margin: EdgeInsets.all(12.0),
                          height: 400.0,
                          child: LineChart(
                            LineChartData(
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: getPlotPoints(snapshot.data!),
                                  isCurved: false,
                                  barWidth: 2.5,
                                ),
                              ],
                            ),
                          ),
                        ),

                  //
                  //
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.amber,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  //
                  //
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      TransactionModel dataAtIndex;

                      try {
                        dataAtIndex = snapshot.data![index];
                      } catch (e) {
                        return Container();
                      }
                      //Map dataAtIndex = {};
                      if (dataAtIndex.type == 'Income') {
                        return incomeTile(
                          dataAtIndex.amount,
                          dataAtIndex.note,
                          dataAtIndex.date,
                          index,
                        );
                      } else {
                        return expenseTile(
                          dataAtIndex.amount,
                          dataAtIndex.note,
                          dataAtIndex.date,
                          index,
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                ],
              );
            } else {
              return Center(
                child: Text('An Error Has Occured!'),
              );
            }
          }),
    );
  }

  Widget cardIncome(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white70,
          ),
          padding: EdgeInsets.all(6.0),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.green[700],
          ),
          margin: EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Income',
              style: TextStyle(
                fontSize: 23.0,
                color: Colors.white70,
              ),
            ),
            Text(
              '$totalIncome',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget cardExpense(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white70,
          ),
          padding: EdgeInsets.all(6.0),
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.red[700],
          ),
          margin: EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense',
              style: TextStyle(
                fontSize: 23.0,
                color: Colors.white70,
              ),
            ),
            Text(
              '$totalExpense',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  //
  //
  Widget expenseTile(
    int value,
    String note,
    DateTime date,
    int index,
  ) {
    return InkWell(
      onLongPress: () async {
        bool? answer = await ShowConfirmDialog(context, 'WARNING!',
            'Are you sure you want to delete this record?');
        if (answer != null && answer) {
          dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_circle_up,
                        size: 28.0,
                        color: Colors.red[700],
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        '$note',
                        style: TextStyle(
                          fontSize: 21.0,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${date.day} ${months[date.month - 1]}',
                      style: TextStyle(
                        fontSize: 18.0,
                        //color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '-$value',
                    style: TextStyle(
                      fontSize: 24.0,
                      //color: Colors.white70,
                    ),
                  ),
                  Text(
                    'Expense',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget incomeTile(int value, String note, DateTime date, int index) {
    return InkWell(
      onLongPress: () async {
        bool? answer = await ShowConfirmDialog(context, 'WARNING!',
            'Are you sure you want to delete this record?');
        if (answer != null && answer) {
          dbHelper.deleteData(index);
          setState(() {});
        }
      },
      child: Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_circle_down,
                      size: 28.0,
                      color: Colors.green[700],
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      '$note',
                      style: TextStyle(
                        fontSize: 21.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${date.day} ${months[date.month - 1]}',
                    style: TextStyle(
                      fontSize: 18.0,
                      //color: Colors.white70,
                    ),
                  ),
                ),
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+$value',
                    style: TextStyle(
                      fontSize: 24.0,
                      //color: Colors.white70,
                    ),
                  ),
                  Text(
                    'Income',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18.0,
                      //color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
