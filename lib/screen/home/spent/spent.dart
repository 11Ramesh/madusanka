import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_07_19/bloc/firebase/firebase_bloc.dart';
import 'package:signup_07_19/const/firebaseConstr.dart';
import 'package:signup_07_19/widgets/button.dart';
import 'package:signup_07_19/widgets/textInpuField.dart';
import 'package:signup_07_19/widgets/textShow.dart';

class Spent extends StatefulWidget {
  const Spent({super.key});

  @override
  State<Spent> createState() => _SpentState();
}

class _SpentState extends State<Spent> {
  String formattedDate =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  late SharedPreferences sharedPreferences;
  late FirebaseBloc firebaseBloc;
  String ownerId = "";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeSpent = TextEditingController();
  final TextEditingController _PriceSpent = TextEditingController();
  List<String> spentIds = [];
  List spentAllData = [];
  int _totalSpent = 0;

  @override
  void initState() {
    super.initState();
    initializedSharedReference();
  }

  initializedSharedReference() async {
    firebaseBloc = BlocProvider.of<FirebaseBloc>(context);
    sharedPreferences = await SharedPreferences.getInstance();
    ownerId = sharedPreferences.getString('ownerId').toString();
    print(ownerId);
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
    return SingleChildScrollView(
      child: Column(
        children: [
          TextShow(text: formattedDate),
          Button(
            text: 'Add',
            radius: 20,
            onclick: () {
              clearAllController();
              addSpentNotification(context, 'id', true);
            },
          ),
          BlocBuilder<FirebaseBloc, FirebaseState>(
            builder: (context, state) {
              if (state is SpentAddState) {
                spentIds = state.spentIds;
                spentAllData = state.spentAllData;
                _totalSpent = int.parse(state.totalSpent.toString());
                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: spentIds.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: TextShow(
                            text: spentAllData[index]['spentType'],
                            fontSize: 18,
                          ),
                          subtitle: TextShow(
                              text:
                                  spentAllData[index]['spentPrice'].toString()),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _PriceSpent.text =
                                  spentAllData[index]['spentPrice'].toString();
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
                    TextShow(text: 'Today total Spent : ${_totalSpent}'),
                  ],
                );
              }
              return TextShow(text: 'No Data');
            },
          ),
        ],
      ),
    );
  }
}
