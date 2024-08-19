import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_07_19/bloc/firebase/firebase_bloc.dart';
import 'package:signup_07_19/const/screenSize.dart';
import 'package:signup_07_19/screen/home/allview/calender.dart';
import 'package:signup_07_19/widgets/noDataLoad.dart';
import 'package:signup_07_19/screen/home/allview/pieChart.dart';
import 'package:signup_07_19/widgets/height.dart';
import 'package:signup_07_19/widgets/homePageListview.dart';
import 'package:signup_07_19/widgets/indicator.dart';
import 'package:signup_07_19/widgets/processBar.dart';
import 'package:signup_07_19/widgets/textShow.dart';

class Sale extends StatefulWidget {
  const Sale({super.key});

  @override
  State<Sale> createState() => _SaleState();
}

class _SaleState extends State<Sale> {
  final EasyInfiniteDateTimelineController _controllerCalender =
      EasyInfiniteDateTimelineController();

  DateTime _focusDate = DateTime.now();
  late SharedPreferences sharedPreferences;
  late FirebaseBloc firebaseBloc;
  String ownerId = "";
  num profit = 0;
  bool waiting = false;
  String monthName = '';

  @override
  void initState() {
    super.initState();
    initializedSharedReference();
  }

  initializedSharedReference() async {
    firebaseBloc = BlocProvider.of<FirebaseBloc>(context);
    sharedPreferences = await SharedPreferences.getInstance();
    ownerId = sharedPreferences.getString('ownerId').toString();
  }

  Future<void> simulateWaiting() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      waiting = false;
    });
  }

  void getDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2040));
    if (date != null) {
      setState(() {
        waiting = true;
        simulateWaiting();
        _getMonth(date.month);
        _focusDate = date;

        _controllerCalender.animateToDate(_focusDate,
            duration: const Duration(milliseconds: 1000));

        firebaseBloc
            .add(HomePageEvent(ownerId, _focusDate.toString().split(" ")[0]));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil.screenWidth * 0.02,
            right: ScreenUtil.screenWidth * 0.02),
        child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //empty height
          Heights(height: 0.005),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextShow(
                text: _focusDate.toString().split(" ")[0] ==
                        DateTime.now().toString().split(" ")[0]
                    ? 'Today'
                    : "${monthName}, ${_focusDate.year}",
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              IconButton(
                  onPressed: () {
                    getDate();
                  },
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    size: 30,
                    color: Colors.black,
                  ))
            ],
          ),
          //empty height
          Heights(height: 0.025),
          //calender view
          CalenderHome(
            controller: _controllerCalender,
            focusDate: _focusDate,
            onDateChange: (selectedDate) {
              setState(() {
                waiting = true;
                simulateWaiting();
                _getMonth(selectedDate.month);
                _focusDate = selectedDate;
                firebaseBloc.add(HomePageEvent(
                    ownerId, selectedDate.toString().split(" ")[0]));
              });
            },
          ),
          //empty height
          Heights(height: 0.025),

          // text show
          TextShow(
            text: 'Your Summery Sheet',
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),

          BlocBuilder<FirebaseBloc, FirebaseState>(
            builder: (context, state) {
              if (waiting) {
                return ProcessBars();
              }
              if (state is HomePageState) {
                // product data
                final List<String> title = List.generate(
                    state.productAllData.length,
                    (index) => state.productAllData[index]['type']);
                final List<String> subtitle = List.generate(
                    state.productAllData.length,
                    (index) =>
                        state.productAllData[index]['totalPrice'].toString());

                final List<String> midleTitle = List.generate(
                    state.productAllData.length,
                    (index) =>
                        state.productAllData[index]['sellQuantity'].toString());
                // Spent data
                final List<String> titleSpent = List.generate(
                    state.spentIds.length,
                    (index) => state.spentAllData[index]['spentType']);
                final List<String> subtitleSpent = List.generate(
                    state.spentIds.length,
                    (index) =>
                        state.spentAllData[index]['spentPrice'].toString());

                Map<String, double> dataMap = {
                  "Sale": state.allTotal.toDouble(),
                  "Spend": state.totalSpent.toDouble(),
                };

                return (state.allTotal == 0 && state.totalSpent == 0)
                    ? NoDataLoad()
                    : Column(
                        children: [
                          Container(
                            width: ScreenUtil.screenWidth / 1.1,
                            height: ScreenUtil.screenHeight / 2.8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1), // Shadow color
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 1, // Blur radius
                                  offset: Offset(
                                      0, 3), // Offset in x and y direction
                                ),
                              ],
                            ),
                            child: PieChartHome(
                              dataMap: dataMap,
                            ),
                          ),
                          //empty hieght
                          Heights(height: 0.05),

                          // text show
                          TextShow(
                            text: 'Sales',
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                          ),

                          // list view for sales data show
                          HomePageListView(
                            title: title,
                            midleTitle: midleTitle,
                            subtitle: subtitle,
                            leading: Icons.home_work,
                          ),
                          Heights(height: 0.03),
                          Container(
                              margin: EdgeInsets.only(right: 25),
                              alignment: Alignment.bottomRight,
                              child: TextShow(
                                text: 'Total : Rs.${state.allTotal}',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),

                          //empty hieght
                          Heights(height: 0.05),

                          // text show
                          TextShow(
                            text: 'Spend',
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                          ),

                          // list view for spent data show
                          HomePageListView(
                            title: titleSpent,
                            subtitle: subtitleSpent,
                            midleTitle: [''],
                            leading: Icons.attach_money,
                          ),
                          Heights(height: 0.03),
                          Container(
                              margin: EdgeInsets.only(right: 25),
                              alignment: Alignment.bottomRight,
                              child: TextShow(
                                text: 'Total : Rs.${state.totalSpent}',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                          const SizedBox(height: 100),
                        ],
                      );
              } else {
                return Center(child: ProcessBars());
              }
            },
          )
        ])),
      ),
      floatingActionButton: BlocBuilder<FirebaseBloc, FirebaseState>(
        builder: (context, state) {
          if (waiting) {
            return Container();
          }
          if (state is HomePageState) {
            profit = state.profit;
            return state.allTotal == 0 && state.totalSpent == 0
                ? Container()
                : Container(
                    width: state.profit.toString().length <= 3
                        ? 230
                        : state.profit.toString().length <= 5
                            ? 250
                            : 300,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: state.profit.isNegative
                          ? Colors.red
                          : Color.fromARGB(207, 23, 30, 234),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4), // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 2, // Blur radius
                          offset: Offset(3, 3), // Offset in x and y direction
                        ),
                      ],
                    ),
                    child: TextShow(
                      text: 'Your Profit : Rs.${profit} ',
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );

            //
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  String _getMonth(int month) {
    switch (month) {
      case 1:
        monthName = 'January';
        break;
      case 2:
        monthName = 'February';
        break;
      case 3:
        monthName = 'March';
        break;
      case 4:
        monthName = 'April';
        break;
      case 5:
        monthName = 'May';
        break;
      case 6:
        monthName = 'June';
        break;
      case 7:
        monthName = 'July';
        break;
      case 8:
        monthName = 'August';
        break;
      case 9:
        monthName = 'September';
        break;
      case 10:
        monthName = 'October';
        break;
      case 11:
        monthName = 'November';
        break;
      case 12:
        monthName = 'December';
        break;
      default:
        monthName = 'Invalid month';
    }

    return monthName;
  }
}
