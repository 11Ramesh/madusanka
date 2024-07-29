part of 'firebase_bloc.dart';

@immutable
abstract class FirebaseEvent {}

class EmailPassSendEvent extends FirebaseEvent {
  String password;
  String email;
  bool isreg;
  EmailPassSendEvent(this.email, this.password, this.isreg);
}

class ProductAddEvent extends FirebaseEvent {
  String ownerId;
  String formattedDate;

  ProductAddEvent(this.ownerId, this.formattedDate);
}

class SpentAddEvent extends FirebaseEvent {
  String ownerId;
  String formattedDate;

  SpentAddEvent(this.ownerId, this.formattedDate);
}

class HomePageEvent extends FirebaseEvent {
  String ownerId;
  String formattedDate;

  HomePageEvent(this.ownerId, this.formattedDate);
}
