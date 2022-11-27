import 'package:a_living_dictionary/LOGIN/kakao_login.dart';
import 'package:a_living_dictionary/LOGIN/naver_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:a_living_dictionary/LOGIN/firebase_auth_remote_data_source.dart';
import 'package:a_living_dictionary/LOGIN/social_login.dart';


// firebase function은 서버없이 기능을 만들어서 올릴 수 ㅇ
// 기본요금제에서는 못한다... blaze요금제...
// 사용한 만큼 지불된다..
// firebase init
// 서버쪽 코드 작성해야한다. - 이걸로 토큰발급, 배포해서 사용할거야
// 본인 서버에서 토큰발급 진행 ㄱㄱ


class MainViewModel {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  final SocialLogin _socialLogin;
  bool isLogined = false;
  kakao.User? user;

  MainViewModel(this._socialLogin);

  Future login() async {
    isLogined = await _socialLogin.login();

    if (!isLogined) {
      return;
    }

    if (_socialLogin.runtimeType == KakaoLogin) {
      user = await kakao.UserApi.instance.me();

      // 토큰 발급은 user정보를 얻은 후 해야함. USER정보 보내야하니까
      // 인증이 된다. 필요 데이터 던져주기
      final token = await _firebaseAuthDataSource.createCustomToken({
        'uid': user!.id.toString(),
        'displayName': user!.kakaoAccount!.profile!.nickname,
        'email': user!.kakaoAccount!.email!,
        'photoURL': user!.kakaoAccount!.profile!.profileImageUrl!,
      });

      await FirebaseAuth.instance.signInWithCustomToken(token);

    } else if (_socialLogin.runtimeType is NaverLogin) {
      
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    await FirebaseAuth.instance.signOut();

    isLogined = false;
    user = null;
  }
}