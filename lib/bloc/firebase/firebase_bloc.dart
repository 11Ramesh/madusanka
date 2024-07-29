import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:signup_07_19/const/firebaseConstr.dart';

part 'firebase_event.dart';
part 'firebase_state.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  FirebaseBloc() : super(FirebaseInitial()) {
    on<FirebaseEvent>((event, emit) async {
      if (event is EmailPassSendEvent) {
        String password = event.password;
        String email = event.email;
        bool isreg = event.isreg;

        print(email);

        emit(
            EmailPassSendState(email: email, password: password, isreg: isreg));
      } else if (event is ProductAddEvent) {
        String ownerId = event.ownerId;
        String formattedDate = event.formattedDate;
        List<String> productIds = [];
        List productAllData = [];
        num allTotal = 0;

        try {
          QuerySnapshot querySnapshot = await firestore
              .doc(ownerId)
              .collection('sale')
              .doc('sale')
              .collection(formattedDate)
              .get();

          querySnapshot.docs.forEach((doc) {
            productIds.add(doc.id);
          });

          for (var id in productIds) {
            DocumentSnapshot documentSnapshot = await firestore
                .doc(ownerId)
                .collection('sale')
                .doc('sale')
                .collection(formattedDate)
                .doc(id)
                .get();
            Map<String, dynamic> data =
                documentSnapshot.data() as Map<String, dynamic>;
            productAllData.add(data);
            allTotal += data['totalPrice'];
          }
        } catch (e) {
          print(e);
        }
        print(allTotal);

        emit(ProductAddState(
            productAllData: productAllData,
            productIds: productIds,
            allTotal: allTotal));
      } else if (event is SpentAddEvent) {
        String ownerId = event.ownerId;
        String formattedDate = event.formattedDate;
        List<String> spentIds = [];
        List spentAllData = [];
        num _totalSpent = 0;
        try {
          QuerySnapshot querySnapshot = await firestore
              .doc(ownerId)
              .collection('sale')
              .doc('spent')
              .collection(formattedDate)
              .get();

          querySnapshot.docs.forEach((doc) {
            spentIds.add(doc.id);
          });

          for (var id in spentIds) {
            DocumentSnapshot documentSnapshot = await firestore
                .doc(ownerId)
                .collection('sale')
                .doc('spent')
                .collection(formattedDate)
                .doc(id)
                .get();
            Map<String, dynamic> data =
                documentSnapshot.data() as Map<String, dynamic>;
            spentAllData.add(data);
            _totalSpent += data['spentPrice'];
          }
        } catch (e) {
          print(e);
        }

        emit(SpentAddState(
          spentAllData: spentAllData,
          spentIds: spentIds,
          totalSpent: _totalSpent,
        ));
      } else if (event is HomePageEvent) {
        //
        // productAdd table data get from the backend
        //
        String ownerId = event.ownerId;
        String formattedDate = event.formattedDate;
        List<String> productIds = [];
        List productAllData = [];
        num allTotal = 0;
        List<String> spentIds = [];
        List spentAllData = [];
        num _totalSpent = 0;
        num profit = 0;

        try {
          QuerySnapshot querySnapshot = await firestore
              .doc(ownerId)
              .collection('sale')
              .doc('sale')
              .collection(formattedDate)
              .get();

          querySnapshot.docs.forEach((doc) {
            productIds.add(doc.id);
          });

          for (var id in productIds) {
            DocumentSnapshot documentSnapshot = await firestore
                .doc(ownerId)
                .collection('sale')
                .doc('sale')
                .collection(formattedDate)
                .doc(id)
                .get();
            Map<String, dynamic> data =
                documentSnapshot.data() as Map<String, dynamic>;
            productAllData.add(data);
            allTotal += data['totalPrice'];
          }

          ///
          // productAdd table data get from the backend
          //

          QuerySnapshot querySnapshotSpent = await firestore
              .doc(ownerId)
              .collection('sale')
              .doc('spent')
              .collection(formattedDate)
              .get();

          querySnapshotSpent.docs.forEach((doc) {
            spentIds.add(doc.id);
          });

          for (var id in spentIds) {
            DocumentSnapshot documentSnapshot = await firestore
                .doc(ownerId)
                .collection('sale')
                .doc('spent')
                .collection(formattedDate)
                .doc(id)
                .get();
            Map<String, dynamic> data =
                documentSnapshot.data() as Map<String, dynamic>;
            spentAllData.add(data);
            _totalSpent += data['spentPrice'];
          }

          profit = allTotal - _totalSpent;
        } catch (e) {
          print(e);
        }
        emit(HomePageState(
          productAllData: productAllData,
          productIds: productIds,
          allTotal: allTotal,
          spentAllData: spentAllData,
          spentIds: spentIds,
          totalSpent: _totalSpent,
          profit :profit
        ));
      }
    });
  }
}
