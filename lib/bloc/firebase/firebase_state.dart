part of 'firebase_bloc.dart';

@immutable
abstract class FirebaseState {}

final class FirebaseInitial extends FirebaseState {}

class EmailPassSendState extends FirebaseState {
  String email;
  String password;
  bool isreg;

  EmailPassSendState(
      {required this.email, required this.password, required this.isreg});
}

class ProductAddState extends FirebaseState {
  List productAllData;
  List<String> productIds;
  num allTotal;

  ProductAddState(
      {required this.productAllData,
      required this.productIds,
      required this.allTotal});
}

class SpentAddState extends FirebaseState {
  List spentAllData;
  List<String> spentIds;
  num totalSpent;

  SpentAddState(
      {required this.spentAllData,
      required this.spentIds,
      required this.totalSpent});
}

class HomePageState extends FirebaseState {
  List productAllData;
  List<String> productIds;
  num allTotal;
  List spentAllData;
  List<String> spentIds;
  num totalSpent;
  num profit;

  HomePageState({
    required this.productAllData,
    required this.productIds,
    required this.allTotal,
    required this.spentAllData,
    required this.spentIds,
    required this.totalSpent,
    required this.profit,
  });
}
