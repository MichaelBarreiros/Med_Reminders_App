import 'package:http/http.dart' as http;
import 'dart:convert' show base64, json, utf8;


// IMPORTANT:
// IN ORDER TO USE THE API IMPORT THIS CLASS LIKE SO
// import '../api/twilio_api.dart';
//
// CREATE AN INSTANCE OF THE CLASS
// TwilioApi _twilioApi = TwilioApi();
//
// FIRST PARAMETER: THE PHONE NUMBER YOU WANT TO SEND A TEXT TO
// SECOND PARAMETER: IS THE MESSAGE THAT WANTS TO BE SENT
// void _sendSMS() {
//   _twilioApi.create("+15198702735", "Text Message Works");
// }

class TwilioApi {
  final String _accountSid = 'ACb1be8591a0f9a632ecc8bebffc3a9bc7';
  final String _authToken = '1c813040c5bc1a0edfa6a035abc28963';
  final String TWILIO_SMS_API_BASE_URL = 'https://api.twilio.com/2010-04-01';
  final String _phoneNumber = '+17164532891';

  const TwilioApi();

  String toAuthCredentials(String accountSid, String authToken) =>
      base64.encode(utf8.encode(accountSid + ':' + authToken));

  Future<Map> create(String to, String body) async {
    var client = http.Client();

    var url = '${TWILIO_SMS_API_BASE_URL}/Accounts/${_accountSid}/Messages.json';

    var uri = Uri.parse(url);

    try {
      var response = await client.post(uri, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ' + toAuthCredentials(_accountSid, _authToken)
      }, body: {
        'From': _phoneNumber,
        'To': to,
        'Body': body
      });

      return (json.decode(response.body));
    } catch (e) {
      return ({'Runtime Error': e});
    } finally {
      client.close();
    }
  }
}