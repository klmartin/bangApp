import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../providers/message_payment_provider.dart';
import '../../providers/payment_provider.dart';
import 'package:bangapp/providers/user_provider.dart';


class MessagePayment extends StatefulWidget {
  final price;
  final userId;
  MessagePayment({required this.userId, required this.price});

  @override
  State<MessagePayment> createState() => _MessagePaymentState();
}

class _MessagePaymentState extends State<MessagePayment> {
  @override
  void initState() {
    print('callse');
    super.initState();
  }

  Widget build(BuildContext context) {
    final messagePaymentProvider = Provider.of<MessagePaymentProvider>(context, listen: true);
    return FutureBuilder(
      future: showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (BuildContext context) {
          return Builder(
            builder: (BuildContext innerContext) {
              final userProvider = Provider.of<UserProvider>(innerContext);
              final TextEditingController phoneNumberController =
              TextEditingController(
                text: userProvider.userData['phone_number'].toString(),
              );

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: Text(
                          'Pay to Chat ${widget.price.toString()} Tshs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.phone),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                    ),
                    messagePaymentProvider.isPaying
                        ? LoadingAnimationWidget.fallingDot(color: Colors.black, size: 30)
                        : TextButton(
                      onPressed: () async {
                        messagePaymentProvider.startPaying(
                          userProvider.userData['phone_number'].toString(),
                          widget.price,
                          widget.userId,
                          'message',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        'Pay',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

