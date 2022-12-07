# 자취 백과사전
#### 2022-2 오픈소스 팀 모바일  
해당 프로그램은 안드로이드 기반 휴대폰과 태블릿에서 작동하는 앱으로 유저에게 가사, 자취 등의 정보를 사전 형식으로 제공합니다.  
주요 기능은 자취 사전, 커뮤니티, 혼밥 지도 등이 있으며,  각각 자취 정보를 제공하는 사전, 다양한 태그를 지원하는 커뮤니티, 본인만의 맛집을 저장하고 리뷰를 공유하는 맵 기능을 포함합니다.  
  
  
  
사용 언어: Dart, flutter  
사용 패키지 및 API : Firebase(NSQL), Google Map, Kakao, Naver(Sign In)  
목적 : 자취 전반의 정보 제공을 통한 삶의 질 향상  
DB 구조 : 

![img](https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/DB%20Structure.png?alt=media&token=4c21c918-3ffd-4009-b60d-35b2a8689876)




  
  
  
  
  
  
  
## 앱 실행 영상  

<div align="center">  
  
  [![Thumbnail](https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/%EC%9C%A0%ED%8A%9C%EB%B8%8C%20%EC%8D%B8%EB%84%A4%EC%9D%BC25.jpg?alt=media&token=5decdd19-14c8-40d4-ac4a-08db25b20753)](https://youtu.be/MkGTi_HMDGY)  
  
</div>  
  
  
  
  
## 코드 사용법  
### 디렉토리 구조
![img](https://firebasestorage.googleapis.com/v0/b/a-living-dictionary.appspot.com/o/DIR%20Structure.png?alt=media&token=d7d01223-3d56-401f-b2d5-b8f928309317)
### 설명
### -lib 폴더
가장 기본이 되는 main.dart와 그 아래에 각 탭에 해당하는 PageClass가 존재합니다.  
DB 폴더 : 말 그대로 각 탭에서 필요한 자료구조를 정의한 Class 모음   
PROVIDERS 폴더 : 앱 전반에서 필요한 정보(로그인 유저 정보 등)를 PROVIDER Class 로 정의해서 정리해둔 폴더   
LOGIN 폴더 : 로그인을 할 때 필요한 소스코드 모음  
UI 폴더 : 각 탭에 해당하는 UI PageClass 모음  
  
### -DB 폴더  
각 탭에서 필요한 자료구조를 정의한 Class 모음입니다.  
이름 그대로 1번부터 커뮤니티, 백과사전, 문의사항, (Data는 추상클래스이므로 생략), 맛집지도, 맛집리뷰 자료구조를 정의하였고, 해당 앱은 Firebase를 사용하기 때문에, 각 클래스마다 기본적으로 add 함수와 getData 함수가 존재합니다. (각 firebase로부터 쓰기와 읽기)  
추가적으로 해당 데이터를 Firebase(이하 FB)에서 삭제하거나 갱신하는 등의 함수가 포함됩니다.   
또한 FB로부터 데이터를 읽어서 위젯을 반환하는 함수도 일부 정의되어 있습니다.  
  
### -LOGIN 폴더  
로그인과 관련된 파일 모음입니다.
EmailLoginPage.dart는 이메일 로그인 시 보여지는 화면에 대한 파일입니다. 
social_login.dart 은 소셜로그인과 관련된 클래스가 상속받아야하는 추상클래스를 정의한 파일입니다. kakao_login과 naver_login파일의 클래스는 이를 상속받습니다. 
firebase_auth_remote_data_source.dart 는 카카오 로그인 토큰을 만들어주는 클래스를 포함합니다.
main_view_model.dart 은 소셜 로그인 시 토큰을 받고 firebaseAuth에 로그인하는 과정을 수행합니다.
  
### -PROVIDER 폴더  
모든 탭에서 정보가 필요한 LoginedUser 클래스와 기타 일부 탭에서 필요한 DictionaryItemInfo, MapInfo 클래스를 PROVIDER로 정의하였습니다.  
백과사전과 맛집정보는 각각 2번째, 4번째 탭에 존재하는데, 설정 탭에 스크랩한 사전, 작성한 리뷰 등을 볼 수 있도록 하기 위하여 해당 정보를 PROVIDER로 정의하였습니다.  
PROVIDER는 flutter에서 특정 객체의 통신을 위한 Class로, 만약 Scaffold 위젯을 PROVIDER로 wrapping 하게 된다면, Scaffold 하위 위젯들이 해당 PROVIDER 객체를 사용할 수 있습니다. 
  
### -UI 폴더  
Supplementary 폴더 : 각 탭에서 추가적으로 필요한 페이지나 클래스가 정리  
그 외에는 main.dart 의 하위 위젯들로 각 탭(백과사전, 커뮤니티, 맛집지도, 설정)을 출력하는 주요 Class 들이 포함되어 있습니다.  
  
### -Supplementary 폴더  
해당 폴더는 각 탭에서 추가적으로 필요한 클래스 모음 폴더입니다.  
파일 이름에 Page가 들어가면 추가 Page가 출력되는 클래스이고, 그렇지 않을 클래스는 탭의 DomainLogic을 돕기 위한 클래스입니다.  
예를 들어 CheckClick이나 ThemeColor Class의 경우 각각 더블 클릭을 방지하기 위한 함수가 정의된 클래스, 앱의 테마 색을 정해둔 클래스로 각 탭의 원활한 동작을 돕습니다. 반대로 Page가 들어간 클래스는 예를 들어 CommunityPostPage 의 경우 커뮤니티 탭에서 특정 게시글을 터치(클릭)했을 때, 해당 게시글을 자세하게 출력하기 위한 클래스로 추가적인 페이지가 생성됩니다.  
  
  
  
## 오픈소스 출처와 API 버전  
#### GOOGLE MAP API  
- google_maps_flutter: ^2.2.1  
##### PLACES API  
- flutter_google_places: ^0.3.0  
##### GEOCODING API  
##### NAVER API  
#### KAKAO API  
- kakao_flutter_sdk_user: ^1.2.2  
#### FireBase  
- firebase_core: ^2.1.0  
- firebase_storage: ^11.0.5  
- firebase_auth: ^4.1.3  
- flutterfire_ui: ^0.4.3+20  
#### Server(Nodejs)  
- firebase-admin  ^11.3.0  
- firebase-auth   ^0.1.2  







