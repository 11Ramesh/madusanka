import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

CollectionReference firestore = FirebaseFirestore.instance.collection('user');

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
