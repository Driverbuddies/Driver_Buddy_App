import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:paytm/paytm.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Payment Options'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Handle cash payment here
                },
                child: Text('Cash'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle stripe payment here
                },
                child: Text('Stripe'),
              ),
              ElevatedButton(
                onPressed: () {
                  onPressed: () async {
                    PhonePay _phonePay = PhonePay();

                    var response = await _phonePay.startTransaction(
                      phoneNumber: '9999999999',
                      amount: '100.00',
                      requestId: '1234567890',
                      orderId: 'ORD12345',
                      accountId: 'acc_id_1234567890',
                      subscriptionId: 'sub_id_1234567890',
                      currency: 'INR',
                      email: 'abc@xyz.com',
                      offerKey: 'offer_key_1234567890',
                      subscriptionDetails: {
                        'start_time': '2021-09-20T10:30:00+05:30',
                        'end_time': '2021-12-31T23:59:59+05:30',
                        'no_of_recurring': '5',
                        'frequency': 'monthly',
                        'max_redemption': '5',
                        'payment_amount': '1000',
                        'free_trial_duration': '1',
                        'free_trial_units': 'day',
                      },
                    );

                    if (response.success) {
                      // Handle successful payment here
                    } else {
                      // Handle unsuccessful payment here
                    }
                  }
                },
                child: Text('Phonepe'),
              ),
              ElevatedButton(
                onPressed: () {
                  onPressed: () async {
                    String _mId = 'your_merchant_id';
                    String _orderId = 'your_order_id';
                    String _customerId = 'your_customer_id';
                    String _checksumHash = 'your_checksum_hash';

                    var response = await Paytm.startTransaction(
                      mid: _mId,
                      orderId: _orderId,
                      customerId: _customerId,
                      checksumHash: _checksumHash,
                    );

                    if (response.success) {
                      // Handle successful payment here
                    } else {
                      // Handle unsuccessful payment here
                    }
                  }
                },
                child: Text('Paytm'),
              ),
              ElevatedButton(
                onPressed: () try {
              final GooglePayRequest request = GooglePayRequest(
              gateway: 'example',
              gatewayMerchantId: 'exampleMerchantId',
              merchantName: 'Your Merchant Name',
              subMerchantParams: SubMerchantParams(
              id: 'subMerchantId',
              name: 'Sub Merchant Name',
              subMerchant: true,
              ),
              allowedPaymentMethods: [
              PaymentMethod(
              type: 'CARD',
              parameters: {
              'allowedAuthMethods': ['PAN_ONLY', 'CRYPTOGRAM_3DS'],
              'allowedCardNetworks': ['AMEX', 'DISCOVER', 'INTERAC', 'JCB', 'MASTERCARD', 'VISA'],
              },
              tokenizationSpecification: TokenizationSpecification(
              type: 'PAYMENT_GATEWAY',
              parameters: {
              'gateway': 'example',
              'gatewayMerchantId': 'exampleMerchantId',
              },
              ),
              ),
              ],
              transactionInfo: TransactionInfo(
              totalPriceStatus: 'FINAL',
              totalPrice: '123.45',
              currencyCode: 'USD',
              countryCode: 'US',
              ),
              emailRequired: true,
              shippingAddressRequired: true,
              shippingAddressParameters: ShippingAddressParameters(
              allowedCountryCodes: ['US'],
              phoneNumberRequired: true,
              ),
              );

              final result = await request.makePayment();
              if (result != null) {
              print('Successful GPay transaction');
              } else {
              print('Failed GPay transaction');
              }
              } catch (e) {
      print('Error during GPay transaction: $e');
      },
                child: Text('GPay'),
              ),
              ElevatedButton(
                onPressed: () {
                  onPressed: () async {
                    String _razorpayId = 'your_razorpay_id';
                    double _amount = 100.0; // Replace with your own amount

                    var options = {
                      'key': _razorpayId,
                      'amount': _amount * 100,
                      'name': 'Your Name',
                      'description': 'Test Transaction',
                      'prefill': {
                        'contact': '9999999999',
                        'email': 'abc@xyz.com',
                      },
                    };

                    Razorpay _razorpay = Razorpay();
                    _razorpay.open(options);

                    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
                      print('PAYMENT_SUCCESS: ' + response.paymentId);
                      // Handle successful payment here
                    });

                    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
                      print('PAYMENT_ERROR: ' + response.code.toString() + " - " + response.message);
                      // Handle unsuccessful payment here
                    });

                    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
                      print('EXTERNAL_WALLET: ' + response.walletName);
                    });
                  }
                },
                child: Text('Razorpay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}