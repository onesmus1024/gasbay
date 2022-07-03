
import 'package:gasbay/keys/globay_key.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class TwilioSendMessage{
  TwilioSendMessage({required this.phoneNumber,required this.message});
  String phoneNumber;
  String message;

  TwilioFlutter twilioFlutter = TwilioFlutter(
        accountSid: twilioAccountSid,
        authToken: twilioAuthToken,
        twilioNumber: '+19529006184');


  Future<void> sendSms() async {
    phoneNumber = phoneNumber.replaceFirst('0', '+254');
    twilioFlutter.sendSMS(
        toNumber:'+254710383551', messageBody: message);
  }
 
}