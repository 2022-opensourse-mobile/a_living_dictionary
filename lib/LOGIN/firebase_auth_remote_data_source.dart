import 'dart:convert';
import 'package:http/http.dart' as http;


// 카카오 로그인 토큰만드는거
class FirebaseAuthRemoteDataSource {
    final String kakaoUrl = 'https://loveyou.run.goorm.io/kakao';      // 백엔드 서버 url
    
    // 서버와 통신해서 토큰을 만들어주는
    Future<String> createCustomToken(Map<String, dynamic> user) async {

      // 토큰 발급을 위한 post요청
      final customTokenResponse = await http.post(
        Uri.parse(kakaoUrl), 
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json'
        },
        body:json.encode( user )
      );    //  json형태의 데이터를 보낸다
      
      return customTokenResponse.body;
    }
}
