import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:a_living_dictionary/LOGIN/social_login.dart';
// ㅋ카오 ios 번들 설정..?

class KakaoLogin implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      bool isInstalled = await kakao.isKakaoTalkInstalled();  // 카카오톡이 설치되어 있는지 확인


      print("@@!isInstalled: " + isInstalled.toString());
      if (isInstalled) {    // 카카오톡으로 인증
        try {
          await kakao.UserApi.instance.loginWithKakaoTalk();
          print("@@!loginWithKakaoTalk: ");
          return true;
        } catch (e) {
          return false;
        }
      } else {            // 카카오 계정으로 인증

        try {
          await kakao.UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (e) {
          return false;
        }     
      }

    } catch(e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await kakao.UserApi.instance.unlink();
      return true;
    } catch (error) {
      return false;
    }
  }
  
}