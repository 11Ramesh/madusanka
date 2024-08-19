import 'package:flutter/material.dart';
import 'package:signup_07_19/screen/payment/accountDetails.dart';
import 'package:signup_07_19/widgets/textShow.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextShow(
          text: "Payment Details",
          fontSize: 30,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Unlock Premium Features',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Choose your plan and enjoy unlimited access',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            // Plan Cards with background color
            PlanCard(
              title: '1 Month Plan',
              price: '\$4.99 / month',
              benefits: ['Unlimited access', 'No Ads', 'Exclusive content'],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountDtails(amount: 4.99)));
              },
              backgroundColor: Colors.orange[100]!, // Change background color
            ),
            PlanCard(
              title: '6 Months Plan',
              price: '\$11.99 / 6 months',
              benefits: ['Unlimited access', 'No Ads', 'Exclusive content'],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountDtails(amount: 11.99)));
              },
              backgroundColor: Colors.green[100]!, // Change background color
            ),
            PlanCard(
              title: '1 Year Plan',
              price: '\$24.99 / year',
              benefits: ['Best value', 'Unlimited access', 'Exclusive content'],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountDtails(amount: 24.99)));
              },
              backgroundColor: Colors.blue[100]!, // Change background color
            ),
          ],
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> benefits;
  final VoidCallback onTap;
  final Color backgroundColor;

  PlanCard({
    required this.title,
    required this.price,
    required this.benefits,
    required this.onTap,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: backgroundColor, // Use the passed backgroundColor parameter
        elevation: 3,
        child: ListTile(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(price, style: TextStyle(fontSize: 16, color: Colors.purple)),
              SizedBox(height: 8),
              ...benefits.map((benefit) => Text('- $benefit')).toList(),
            ],
          ),
          trailing: Icon(Icons.arrow_forward),
          onTap: onTap,
        ),
      ),
    );
  }
}
