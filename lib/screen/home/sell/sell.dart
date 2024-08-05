import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_07_19/bloc/firebase/firebase_bloc.dart';
import 'package:signup_07_19/const/colors.dart';
import 'package:signup_07_19/const/firebaseConstr.dart';
import 'package:signup_07_19/const/screenSize.dart';
import 'package:signup_07_19/widgets/addButton.dart';
import 'package:signup_07_19/widgets/button.dart';
import 'package:signup_07_19/widgets/height.dart';
import 'package:signup_07_19/widgets/noDataLoad.dart';
import 'package:signup_07_19/widgets/processBar.dart';
import 'package:signup_07_19/widgets/textButton.dart';
import 'package:signup_07_19/widgets/textInpuField.dart';
import 'package:signup_07_19/widgets/textShow.dart';
import 'package:signup_07_19/widgets/totalSowBox.dart';

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

  String formattedDate = DateTime.now().toString().split(' ')[0];
  List productAllData = [];
  List<String> productIds = [];
  int _oneTypeTotalPrice = 0;
  int _allTotal = 0;

  final List<String> headers = [
    'Type',
    'Unit \nPrice',
    'Initial \nQuantity',
    'Sell \nQuantity',
    'Total \nPrice',
  ];

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

  @override
  void dispose() {
    clearAllController();
    super.dispose();
  }

  clearAllController() {
    _type.clear();
    _unitPrice.clear();
    _initialQuantity.clear();
    _sellQuantity.clear();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextShow(text: 'Product Type : '),
                      Expanded(
                        child: TextInPutField(
                          text: 'Enter Here',
                          controller: _type,
                          validator: _validateSellType,
                          radius: 20,
                        ),
                      ),
                    ],
                  ),
                  Heights(height: 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextShow(text: 'Unit Price : '),
                      Expanded(
                        child: TextInPutField(
                          text: 'Enter Here',
                          controller: _unitPrice,
                          keyboardType: TextInputType.number,
                          validator: _validateSellUnitPrice,
                          radius: 20,
                          prefixIcon: Icons.attach_money_outlined,
                        ),
                      ),
                    ],
                  ),
                  Heights(height: 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextShow(text: 'Initial Quantity : '),
                      Expanded(
                        child: TextInPutField(
                          text: 'Enter Here',
                          keyboardType: TextInputType.number,
                          controller: _initialQuantity,
                          validator: _validateSellInitialQuantity,
                          radius: 20,
                        ),
                      ),
                    ],
                  ),
                  Heights(height: 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextShow(text: 'Sell Quantity : '),
                      Expanded(
                        child: TextInPutField(
                          text: 'Enter Here',
                          controller: _sellQuantity,
                          keyboardType: TextInputType.number,
                          validator: _validateSellQuantity,
                          radius: 20,
                        ),
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
              backgroundColor: ShowDialogColors.ButtonColor,
              foregroundColor: ShowDialogColors.ButtonTextcolor,
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
              backgroundColor: ShowDialogColors.ButtonColor,
              foregroundColor: ShowDialogColors.ButtonTextcolor,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: ScreenUtil.screenWidth * 0.02),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          // physics: AlwaysScrollableScrollPhysics(),
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
                      addSellsNotification(context, true, 'id');
                    },
                  ),
                ],
              ),
              Heights(height: 0.02),
              BlocBuilder<FirebaseBloc, FirebaseState>(
                builder: (context, state) {
                  if (state is ProductAddState) {
                    productAllData = state.productAllData;
                    productIds = state.productIds;
                    _allTotal = int.parse(state.allTotal.toString());

                    return _allTotal == 0
                        ? Column(
                            children: [
                              Heights(height: 0.15),
                              NoDataLoad(),
                            ],
                          )
                        : Column(
                            children: [
                              //height size box
                              Heights(height: 0.02),

                              TotalShowBox(
                                text: "Total Spent : \nRs.$_allTotal",
                              ),

                              //height size box
                              Heights(height: 0.02),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[200],
                                  borderRadius: BorderRadius.circular(10),
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
                                itemCount: productAllData.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextShow(
                                                text:
                                                    '${productAllData[index]['type']}',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: TextShow(
                                                text:
                                                    'Rs.${productAllData[index]['unitPrice']}',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: TextShow(
                                                text:
                                                    '${productAllData[index]['initialQuantity']}',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: TextShow(
                                                text:
                                                    '${productAllData[index]['sellQuantity']}',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: TextShow(
                                                text:
                                                    '${productAllData[index]['totalPrice']}',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Column(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {
                                                      _type.text =
                                                          productAllData[index]
                                                              ['type'];
                                                      _unitPrice.text =
                                                          productAllData[index]
                                                                  ['unitPrice']
                                                              .toString();
                                                      _sellQuantity.text =
                                                          productAllData[index][
                                                                  'sellQuantity']
                                                              .toString();
                                                      _initialQuantity
                                                          .text = productAllData[
                                                                  index][
                                                              'initialQuantity']
                                                          .toString();

                                                      addSellsNotification(
                                                          context,
                                                          false,
                                                          productIds[index]);
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {
                                                      beforeDeleteShowAlertDialogBox(
                                                          context,
                                                          productAllData[index]
                                                              ['type'],
                                                          productIds[index]);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
      ),
    );
  }

  // Validators moved out of build to avoid rebuilding the methods
  String? _validateSellType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a product type';
    }
    return null;
  }

  String? _validateSellUnitPrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Unit price can\'t be empty';
    }
    if (value == "0") {
      return 'Unit price can\'t be zero';
    }
    final numericRegex = RegExp(r'^[0-9]+$');
    if (!numericRegex.hasMatch(value)) {
      return 'Please enter a numeric value';
    }
    return null;
  }

  String? _validateSellInitialQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Initial quantity can\'t be empty';
    }
    if (value == "0") {
      return 'Initial quantity can\'t be zero';
    }
    final numericRegex = RegExp(r'^[0-9]+$');
    if (!numericRegex.hasMatch(value)) {
      return 'Please enter a numeric value';
    }
    return null;
  }

  String? _validateSellQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Sell quantity can\'t be empty';
    }
    final numericRegex = RegExp(r'^[0-9]+$');
    if (!numericRegex.hasMatch(value)) {
      return 'Please enter a numeric value';
    }
    if (int.parse(_initialQuantity.text) < int.parse(_sellQuantity.text)) {
      return 'Sell quantity can\'t be greater than initial quantity';
    }
    return null;
  }
}
