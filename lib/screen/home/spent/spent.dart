import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_07_19/bloc/firebase/firebase_bloc.dart';
import 'package:signup_07_19/const/firebaseConstr.dart';
import 'package:signup_07_19/const/screenSize.dart';
import 'package:signup_07_19/widgets/addButton.dart';
import 'package:signup_07_19/widgets/button.dart';
import 'package:signup_07_19/widgets/height.dart';
import 'package:signup_07_19/widgets/noDataLoad.dart';
import 'package:signup_07_19/widgets/processBar.dart';
import 'package:signup_07_19/widgets/textInpuField.dart';
import 'package:signup_07_19/widgets/textShow.dart';
import 'package:signup_07_19/widgets/totalSowBox.dart';

class Spent extends StatefulWidget {
  const Spent({super.key});

  @override
  State<Spent> createState() => _SpentState();
}

class _SpentState extends State<Spent> {
  String formattedDate = DateTime.now().toString().split(' ')[0];

  late SharedPreferences sharedPreferences;
  late FirebaseBloc firebaseBloc;
  String ownerId = "";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeSpent = TextEditingController();
  final TextEditingController _PriceSpent = TextEditingController();
  List<String> spentIds = [];
  List spentAllData = [];
  int _totalSpent = 0;

  final List<String> headers = [
    'Type',
    ' ',
    'Unit Price',
  ];

  // validate item type
  String? _validateSpentType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }

    return null;
  }

  //validate item price

  String? _validateSpentPrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    final numericRegex = RegExp(r'^[0-9]+$');
    if (!numericRegex.hasMatch(value)) {
      return 'Please enter a Numeric Value';
    }

    return null;
  }

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

  saveDataFirebase() async {
    try {
      await firestore
          .doc(ownerId)
          .collection('sale')
          .doc('spent')
          .collection(formattedDate)
          .doc()
          .set({
        'spentType': _typeSpent.text,
        'spentPrice': int.parse(_PriceSpent.text),
      });
    } catch (e) {
      print(e);
    }
  }

  updateDataFirebase(String id) async {
    try {
      await firestore
          .doc(ownerId)
          .collection('sale')
          .doc('spent')
          .collection(formattedDate)
          .doc(id)
          .update({
        'spentType': _typeSpent.text,
        'spentPrice': int.parse(_PriceSpent.text),
      });
    } catch (e) {
      print(e);
    }
  }

  clearAllController() {
    _PriceSpent.clear();
    _typeSpent.clear();
  }

  void beforeDeleteShowAlertDialogBox(
      BuildContext context, String id, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextShow(
              text: 'Do You Want Delete Type of ${type} From the Spent ?'),
          actions: [
            Button(
              text: 'cancel',
              radius: 10,
              onclick: () {
                Navigator.of(context).pop();
              },
            ),
            Button(
              text: 'Ok',
              radius: 10,
              onclick: () {
                firestore
                    .doc(ownerId)
                    .collection('sale')
                    .doc('spent')
                    .collection(formattedDate)
                    .doc(id)
                    .delete();
                Navigator.of(context).pop();
                firebaseBloc.add(SpentAddEvent(ownerId, formattedDate));
              },
            )
          ],
        );
      },
    );
  }

  void addSpentNotification(
      BuildContext context, String id, bool whichFunction) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextShow(text: 'Enter your Spent Details'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// product type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextShow(
                        text: 'Spent Type',
                      ),
                      Expanded(
                        child: TextInPutField(
                            text: 'Enter Here',
                            controller: _typeSpent,
                            validator: _validateSpentType,
                            radius: 10),
                      ),
                    ],
                  ),

                  /// product type unit price

                  Row(
                    children: [
                      TextShow(
                        text: 'How many Spent',
                      ),
                      Expanded(
                        child: TextInPutField(
                            text: 'Enter Here',
                            controller: _PriceSpent,
                            keyboardType: TextInputType.number,
                            validator: _validateSpentPrice,
                            radius: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Button(
              text: 'cancel',
              radius: 10,
              onclick: () {
                Navigator.of(context).pop();
              },
            ),
            Button(
              text: 'Ok',
              radius: 10,
              onclick: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.of(context).pop();
                  whichFunction ? saveDataFirebase() : updateDataFirebase(id);
                  firebaseBloc.add(SpentAddEvent(ownerId, formattedDate));
                }
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: ScreenUtil.screenWidth * 0.02,
          right: ScreenUtil.screenWidth * 0.02),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextShow(
                  text: 'Today',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                AddButton(
                  text: 'ADD',
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  radius: 100,
                  onClick: () {
                    clearAllController();
                    addSpentNotification(context, 'id', true);
                  },
                ),
              ],
            ),
            BlocBuilder<FirebaseBloc, FirebaseState>(
              builder: (context, state) {
                if (state is SpentAddState) {
                  spentIds = state.spentIds;
                  spentAllData = state.spentAllData;
                  _totalSpent = int.parse(state.totalSpent.toString());
                  return _totalSpent == 0
                      ? Column(
                          children: [
                            Heights(height: 0.15),
                            NoDataLoad(),
                          ],
                        )
                      : Column(
                          children: [
                            //height size box
                            Heights(height: 0.04),

                            TotalShowBox(
                              text: "Total Spent : \nRs.$_totalSpent",
                            ),

                            //height size box
                            Heights(height: 0.02),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue[200],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: headers.map((header) {
                                        return Expanded(
                                          child: TextShow(
                                            text: header,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: spentIds.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextShow(
                                          text: spentAllData[index]
                                              ['spentType'],
                                          fontSize: 18,
                                        ),
                                      ),
                                      TextShow(
                                          text: spentAllData[index]
                                                  ['spentPrice']
                                              .toString()),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.edit_document),
                                    onPressed: () {
                                      _PriceSpent.text = spentAllData[index]
                                              ['spentPrice']
                                          .toString();
                                      _typeSpent.text =
                                          spentAllData[index]['spentType'];

                                      addSpentNotification(
                                          context, spentIds[index], false);
                                    },
                                  ),
                                  onLongPress: () {
                                    beforeDeleteShowAlertDialogBox(
                                        context,
                                        spentIds[index],
                                        spentAllData[index]['spentType']);
                                  },
                                );
                              },
                            ),
                          ],
                        );
                }
                return Column(
                  children: [
                    Heights(height: 0.2),
                    ProcessBars(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
