import 'package:flutter/material.dart';

class TNCPage extends StatelessWidget {
  const TNCPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                // Your terms and conditions text here
                'Welcome to Fluxx Messenger!\n\nBy accessing and utilizing the Fluxx Messenger application, you hereby agree to abide by the following Terms and Conditions. Should you disagree with any aspect of these terms, kindly refrain from utilizing our application.\n\nUser Conduct:\n\nAs a user of Fluxx Messenger, you assume responsibility for your interactions and engagements within the application\'s ecosystem. You are bound to utilize the application in compliance with all applicable laws and regulations, refraining from any actions that may breach legal statutes or infringe upon the rights of others.\n\nUser Accounts:\n\nCertain features within Fluxx Messenger may necessitate the creation of a user account. You are tasked with maintaining the confidentiality of your account credentials. When creating an account, you are obligated to furnish accurate and complete information.\n\nIntellectual Property:\n\nAll content and materials accessible via Fluxx Messenger, encompassing textual content, graphical elements, logos, and imagery, are the exclusive property of Fluxx Messenger or its designated licensors. You are expressly prohibited from utilizing, reproducing, or disseminating any content from Fluxx Messenger without the prior explicit consent of the rightful owner.\n\nDisclaimer:\n\nFluxx Messenger is provided on an "as is" and "as available" basis, without any warranties, either express or implied. We do not warrant that Fluxx Messenger will be error-free, uninterrupted, or secure.\n\nLimitation of Liability:\n\nUnder no circumstances shall Fluxx Messenger or its affiliates be held liable for any indirect, incidental, special, or consequential damages arising out of or in connection with the use of Fluxx Messenger.\n\nChanges to Terms:\n\nFluxx Messenger reserves the right to revise, modify, or amend these Terms and Conditions at its sole discretion. Any alterations to these terms shall become effective immediately upon publication.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                // Your privacy policy text here
                'At Fluxx Messenger, safeguarding your privacy is of paramount importance to us. This Privacy Policy elucidates how Fluxx Messenger collects, utilizes, and safeguards your personal information during your engagement with our application.\n\nInformation We Collect:\n\nFluxx Messenger may collect personal information, such as your name, email address, and profile picture, upon the creation of your user account. Additionally, we may gather usage data, encompassing your IP address, device information, and browsing activity.\n\nHow We Use Your Information:\n\nThe information collected by Fluxx Messenger is utilized to facilitate, enhance, and optimize your experience within the application, including personalized content delivery and communication purposes. Furthermore, your information may be employed for promotional and marketing endeavors.\n\nData Security:\n\nFluxx Messenger employs stringent security measures to safeguard your personal information against unauthorized access, manipulation, disclosure, or destruction. Nonetheless, it is imperative to acknowledge that no method of data transmission over the internet or electronic storage can be guaranteed to be entirely secure.\n\nThird-Party Services:\n\nFluxx Messenger may integrate links to third-party websites or services. We disclaim any responsibility for the privacy practices or content of these third-party entities.\n\nChildren\'s Privacy:\n\nFluxx Messenger is not intended for use by individuals under the age of 13. We do not knowingly collect personal information from children under the specified age threshold.\n\nChanges to Privacy Policy:\n\nFluxx Messenger reserves the prerogative to update, revise, or modify this Privacy Policy at any juncture. Any alterations shall take effect immediately upon their publication.\n\nBy utilizing Fluxx Messenger, you implicitly consent to the collection, utilization, and protection of your information as delineated within this Privacy Policy.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
