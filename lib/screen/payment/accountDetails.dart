import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signup_07_19/const/firebaseConstr.dart';
import 'package:signup_07_19/const/screenSize.dart';
import 'package:signup_07_19/widgets/floatingButtons.dart';
import 'package:signup_07_19/widgets/height.dart';
import 'package:signup_07_19/widgets/textShow.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

class AccountDtails extends StatefulWidget {
  double amount;
  AccountDtails({required this.amount, super.key});

  @override
  State<AccountDtails> createState() => _AccountDtailsState(amount: amount);
}

class _AccountDtailsState extends State<AccountDtails> {
  _AccountDtailsState({required this.amount});
  double amount;
  final String holderName = 'MAK Madusanka';
  final String accountNumber = '1660 2005 0002';
  final String bankName = 'Hatton National Bank';
  XFile? _image; // Holds the selected image.
  File? _pdfFile; // Holds the selected PDF file.
  final picker = ImagePicker(); // Instance of ImagePicker to pick an image.
  late SharedPreferences sharedPreferences;
  String ownerId = ' ';
  String email = '';

  @override
  void initState() {
    initializedSharedReference();
    super.initState();
  }

  initializedSharedReference() async {
    sharedPreferences = await SharedPreferences.getInstance();
    ownerId = sharedPreferences.getString('ownerId').toString();

    DocumentSnapshot documentSnapshot = await firestore.doc(ownerId).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    setState(() {
      email = data['email'];
    });
  }

  void _showbottomSeet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Pick Image'),
                onTap: () {
                  pickImage();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                  leading: const Icon(Icons.attach_file),
                  title: const Text('Pick File'),
                  onTap: () {
                    pickPDF();
                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      },
    );
  }

  // Function to pick an image from the gallery.
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
        _pdfFile = null; // Clear any PDF selection.
      } else {
        print('No image selected.');
      }
    });
  }

  // Function to pick a PDF file.
  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Allow only PDF files.
    );

    setState(() {
      if (result != null) {
        _pdfFile = File(result.files.single.path!); // Assign the picked PDF.
        _image = null; // Clear any image selection.
      } else {
        print('No PDF selected.');
      }
    });
  }

  // Function to send either the selected image or PDF via WhatsApp or any other app.
  Future<void> sendFile() async {
    if (_image != null) {
      // Share image if selected.
      await Share.shareXFiles([XFile(_image!.path)],
          text:
              "Hello Madusanka! I have made a payment to the following email: $email.");
    } else if (_pdfFile != null) {
      // Share PDF if selected.
      await Share.shareXFiles([XFile(_pdfFile!.path)],
          text:
              "Hello Madusanka! I have made a payment to the following email: $email.");
    } else {
      print('No file selected to send.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextShow(
          text: "Account Details",
          fontSize: 30,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil.screenWidth * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Payment Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.account_balance_wallet,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildDetailRow('Holder Name:', holderName),
                      _buildDetailRow('Account Number:', accountNumber),
                      _buildDetailRow('Bank Name:', bankName),
                      Divider(),
                      SizedBox(height: 10),
                      _buildDetailRow(
                        'Amount to Pay:',
                        '\$$amount',
                        textColor: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
              Heights(height: 0.02),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextShow(
                    text:
                        'After payment, please use the box below to attach your payment receipt and send it via WhatsApp to \'+94728684828\'. You can also send the recipe PDF or a screenshot to this number.',
                    fontSize: 18,
                  ),
                ),
              ),
              Heights(height: 0.03),
              MaterialButton(
                onPressed: () {
                  _showbottomSeet();
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10),
                  dashPattern: [6, 3], // Length of dashes and gaps
                  color: Colors.grey, // Color of the dotted border
                  strokeWidth: 2, // Thickness of the dotted line
                  child: Container(
                    width: ScreenUtil.screenWidth * 0.8,
                    height: ScreenUtil.screenHeight * 0.5,
                    color: Colors.grey[200], // Background color of the box
                    child: _image != null
                        ? Image.file(
                            File(_image!.path),
                            fit: BoxFit.cover,
                          )
                        : _pdfFile != null
                            ? Image.asset(
                                'assets/icon/pdfImage.png',
                                fit: BoxFit.cover,
                              )
                            : const Center(
                                child: Icon(
                                  Icons.add,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                  ),
                ),
              ),
              Heights(height: 0.1)
            ],
          ),
        ),
      ),
      floatingActionButton: _image != null || _pdfFile != null
          ? FloatingButton(
              tooltip: 'Send',
              onPressed: () {
                sendFile();
              },
              size: ScreenUtil.screenWidth * 0.5,
              fontSize: 20,
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDetailRow(String label, String value,
      {Color textColor = Colors.black,
      FontWeight fontWeight = FontWeight.normal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
