// import 'dart:convert';

import 'package:a_living_dictionary/LOGIN/social_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
// import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class NaverLogin implements SocialLogin {

  late Uri tokenUrl;

  @override
  Future<bool> login() async {
    final clientState = Uuid().v4();

    final url = Uri.https('nid.naver.com', '/oauth2.0/authorize', {
      'response_type': 'code',
      'client_id': 'bTYjIh0nr6vnD0mi8SWh',
      'response_mode': 'form_post',
      'redirect_uri': 
        'https://loveyou.run.goorm.io/callbacks/naver/sign_in',
      'state': clientState
    });

    final result = await FlutterWebAuth.authenticate(
        url: url.toString(),
        callbackUrlScheme: "webauthcallback");
      
    
    final body = Uri.parse(result).queryParameters;
    tokenUrl = Uri.https('nid.naver.com', '/oauth2.0/token', {
      'grant_type' : 'authorization_code',
      'client_id': 'bTYjIh0nr6vnD0mi8SWh',
      'client_secret': 'yXkEij1Zvt',
      
      'state': clientState,
      'code': body['code']
    });

    return true;
  }

  Uri getTokenUrl() {
    return tokenUrl;
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}