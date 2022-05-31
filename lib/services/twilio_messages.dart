
import 'package:gasbay/keys/globay_key.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class TwilioSendMessage{
  TwilioSendMessage({required this.phoneNumber,required this.message});
  String phoneNumber;
  String message;

  TwilioFlutter twilioFlutter = TwilioFlutter(
        accountSid: twilioAccountSid,
        authToken: twilioAuthToken,
        twilioNumber: '+18059247938');


  Future<void> sendSms() async {
    phoneNumber = phoneNumber.replaceFirst('0', '+254');
    twilioFlutter.sendSMS(
        toNumber:'+254741445868', messageBody: message);
  }
 
}