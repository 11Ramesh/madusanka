import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signup_07_19/bloc/firebase/firebase_bloc.dart';
import 'package:signup_07_19/widgets/homePageListview.dart';
import 'package:signup_07_19/widgets/textShow.dart';

class Sale extends StatefulWidget {
  const Sale({super.key});

  @override
  State<Sale> createState() => _SaleState();
}

class _SaleState extends State<Sale> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //  mainAxisSize: MainAxisSize.max,
            children: [
          TextShow(
            text: 'Your date Summery Sheet',
            fontSize: 20,
          ),
          TextShow(text: 'sales'),
          BlocBuilder<FirebaseBloc, FirebaseState>(
            builder: (context, state) {
              if (state is HomePageState) {
                // product data
                final List<String> title = List.generate(
                    state.productAllData.length,
                    (index) => state.productAllData[index]['type']);
                final List<String> subtitle = List.generate(
                    state.productAllData.length,
                    (index) =>
                        state.productAllData[index]['totalPrice'].toString());

                // Spent data
                final List<String> titleSpent = List.generate(
                    state.spentIds.length,
                    (index) => state.spentAllData[index]['spentType']);
                final List<String> subtitleSpent = List.generate(
                    state.spentIds.length,
                    (index) =>
                        state.spentAllData[index]['spentPrice'].toString());
                return Column(
                  children: [
                    HomePageListView(title: title, subtitle: subtitle),
                    TextShow(text: 'Total :  ${state.allTotal}'),
                    TextShow(text: 'Spent'),
                    HomePageListView(
                        title: titleSpent, subtitle: subtitleSpent),
                    TextShow(text: 'Total Spent :  ${state.totalSpent}'),
                    const SizedBox(height: 100),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )
        ]));
  }
}
