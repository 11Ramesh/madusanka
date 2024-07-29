import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_07_19/bloc/firebase/firebase_bloc.dart';
import 'package:signup_07_19/const/firebaseConstr.dart';
import 'package:signup_07_19/widgets/button.dart';
import 'package:signup_07_19/widgets/textButton.dart';
import 'package:signup_07_19/widgets/textInpuField.dart';
import 'package:signup_07_19/widgets/textShow.dart';

class SalesAdd extends StatefulWidget {
  const SalesAdd({super.key});

  @override
  State<SalesAdd> createState() => _SalesAddState();
}

class _SalesAddState extends State<SalesAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _type = TextEditingController();
  final TextEditingController _unitPrice = TextEditingController();

  final TextEditingController _initialQuantity = TextEditingController();
  final TextEditingController _sellQuantity = TextEditingController();

  late SharedPreferences sharedPreferences;
  late FirebaseBloc firebaseBloc;
  String ownerId = "";

  String formattedDate =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  List productAllData = [];
  List<String> productIds = [];

  int _oneTypeTotalPrice = 0;
  int _allTotal = 0;

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

  void dipose() {
    clearAllController();
  }

  saveDataFirebase() async {
    try {
      _oneTypeTotalPrice =
          int.parse(_unitPrice.text) * int.parse(_sellQuantity.text);

      await firestore
          .doc(ownerId)
          .collection('sale')
          .doc('sale')
          .collection(formattedDate)
          .doc()
          .set({
        'type': _type.text,
        'unitPrice': int.parse(_unitPrice.text),
        'initialQuantity': int.parse(_initialQuantity.text),
        'sellQuantity': int.parse(_sellQuantity.text),
        'totalPrice': _oneTypeTotalPrice,
      });
    } catch (e) {
      print(e);
    }
  }

  updateDataFirebase(String id) async {
    try {
      _oneTypeTotalPrice =
          int.parse(_unitPrice.text) * int.parse(_sellQuantity.text);

      await firestore
          .doc(ownerId)
          .collection('sale')
          .doc('sale')
          .collection(formattedDate)
          .doc(id)
          .update({
        'type': _type.text,
        'unitPrice': int.parse(_unitPrice.text),
        'initialQuantity': int.parse(_initialQuantity.text),
        'sellQuantity': int.parse(_sellQuantity.text),
        'totalPrice': _oneTypeTotalPrice,
      });
    } catch (e) {
      print(e);
    }
  }

  clearAllController() {
    _type.clear();
    _unitPrice.clear();
    _initialQuantity.clear();
    _sellQuantity.clear();
  }

  void beforeDeleteShowAlertDialogBox(
      BuildContext context, String type, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextShow(
              text: 'Do You Want Delete Type of ${type} From the Stock ?'),
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
                    .doc('sale')
                    .collection(formattedDate)
                    .doc(id)
                    .delete();
                Navigator.of(context).pop();
                firebaseBloc.add(ProductAddEvent(ownerId, formattedDate));
              },
            )
          ],
        );
      },
    );
  }

  void addSellsNotification(
      BuildContext context, bool wichFunction, String id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: TextShow(text: 'Enter your product details'),
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
                        text: 'Product Type',
                      ),
                      Expanded(
                        child: TextInPutField(
                            text: 'Enter Here', controller: _type, radius: 10),
                      ),
                    ],
                  ),

                  /// product type unit price

                  Row(
                    children: [
                      TextShow(
                        text: 'Unit Price',
                      ),
                      Expanded(
                        child: TextInPutField(
                            text: 'Enter Here',
                            controller: _unitPrice,
                            radius: 10),
                      ),
                    ],
                  ),

                  ///Initial  quantity of the stock
                  Row(
                    children: [
                      TextShow(
                        text: 'Initial Quantity',
                      ),
                      Expanded(
                        child: TextInPutField(
                            text: 'Enter Here',
                            controller: _initialQuantity,
                            radius: 10),
                      ),
                    ],
                  ),

                  /// sell quantity of the stock
                  Row(
                    children: [
                      TextShow(
                        text: 'Sell Quantity',
                      ),
                      Expanded(
                        child: TextInPutField(
                            text: 'Enter Here',
                            controller: _sellQuantity,
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
                  wichFunction ? saveDataFirebase() : updateDataFirebase(id);
                  firebaseBloc.add(ProductAddEvent(ownerId, formattedDate));
                  Navigator.of(context).pop();
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
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            TextShow(text: formattedDate),
            Button(
              text: 'ADD',
              radius: 20,
              onclick: () {
                clearAllController();
                addSellsNotification(context, true, 'id');
              },
            ),
            BlocBuilder<FirebaseBloc, FirebaseState>(
              builder: (context, state) {
                if (state is ProductAddState) {
                  productAllData = state.productAllData;
                  productIds = state.productIds;
                  _allTotal = int.parse(state.allTotal.toString());

                  return Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 10.0, // Spacing between columns
                          mainAxisSpacing: 10.0, // Spacing between rows
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.blue,
                            child: Container(
                                child: Column(
                              children: [
                                TextShow(
                                    text:
                                        'Type : ${productAllData[index]['type']}'),
                                TextShow(
                                    text:
                                        'totalPrice : ${productAllData[index]['totalPrice']}'),
                                Row(
                                  children: [
                                    TextsButton(
                                        text: 'Edit',
                                        onclick: () {
                                          _type.text =
                                              productAllData[index]['type'];
                                          _unitPrice.text =
                                              productAllData[index]['unitPrice']
                                                  .toString();
                                          _sellQuantity.text =
                                              productAllData[index]
                                                      ['sellQuantity']
                                                  .toString();
                                          _initialQuantity.text =
                                              productAllData[index]
                                                      ['initialQuantity']
                                                  .toString();

                                          addSellsNotification(context, false,
                                              productIds[index]);
                                        }),
                                    TextsButton(
                                        text: 'Delete',
                                        onclick: () {
                                          beforeDeleteShowAlertDialogBox(
                                              context,
                                              productAllData[index]['type'],
                                              productIds[index]);
                                        })
                                  ],
                                )
                              ],
                            )),
                          );
                        },
                        itemCount: productAllData
                            .length, // Number of items in the grid
                      ),
                      TextShow(text: 'Total sell Item price : ${_allTotal}')
                    ],
                  );
                }
                return Container(
                  child: const Center(
                    child: Text('No Data'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
