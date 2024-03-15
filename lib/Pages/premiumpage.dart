import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart'; // Import Razorpay package

class PremiumPage extends StatefulWidget {
  const PremiumPage({Key? key}) : super(key: key);

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  final bool _passwordVisible = false;
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  late Razorpay _razorpay; // Define Razorpay instance

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay(); // Initialize Razorpay instance
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _razorpay.clear(); // Clear Razorpay instance
    super.dispose();
  }

  // Handle payment success event
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
    print('Payment Success: ${response.paymentId}');
  }

  // Handle payment error event
  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    print('Payment Error: ${response.code} - ${response.message}');
  }

  // Handle external wallet event
  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    print('External Wallet: ${response.walletName}');
  }

  // Function to initiate Razorpay payment
  void _startPayment(double amount) {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY', // Replace with your Razorpay key
      'amount': (amount * 100)
          .toInt(), // Amount in smallest currency unit (e.g., paise)
      'name': 'Fluxx Premium Plan', // Your company name or product name
      'description': 'Premium Plan Subscription', // Payment description
      'prefill': {
        'contact': 'CUSTOMER_PHONE_NUMBER', // Customer phone number
        'email': 'CUSTOMER_EMAIL_ADDRESS', // Customer email address
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              height: 400,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF5800),
                    Color(0xFF0050FF),
                    Color(0xFFA400FF),
                  ],
                  stops: [0.2, 0.6, 0.8],
                  begin: AlignmentDirectional(-1, 0.98),
                  end: AlignmentDirectional(1, -0.98),
                ),
              ),
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Color(0x00FFFFFF), Colors.white],
                    stops: [0, 0.01, 0.999],
                    begin: AlignmentDirectional(0, -1),
                    end: AlignmentDirectional(0, 1),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/fluxxlogo.png',
                          width: 100,
                          height: 66,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                      child: Text(
                        'Fluxx Premium',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Text(
                      'Get started with Premium features Fluxx',
                      style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 87, 99, 108),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _startPayment(99.0); // Monthly plan amount
                          },
                          child: const Text('₹99/Month'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            _startPayment(999.0); // Yearly plan amount
                          },
                          child: const Text('₹999/Year'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
