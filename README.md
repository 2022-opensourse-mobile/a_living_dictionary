# 자취 백과사전
## 2022-2 오픈소스 팀 프로젝트
  
  
  
  
  
  
  
## 앱 실행 영상  

// 유튜브 주소  

## 코드 사용법  
### 1. lib 폴더
#### 디렉토리 구조
1. DB 폴더  
2. PROVIDERS 폴더  
3. LOGIN 폴더  
4. UI 폴더  
5. main.dart    
   
#### 설명
가장 기본이 되는 main.dart와 그 아래에 각 탭에 해당하는 PageClass가 존재함.   
DB 폴더는 말 그대로 각 탭에서 필요한 자료구조를 정의한 Class 모음   
PROVIDERS 는 앱 전반에서 필요한 정보(로그인 유저 정보 등)를 PROVIDER Class 로 정의해서 정리해둔 폴더.   
LOGIN 폴더는 로그인을 할 때 필요한 소스코드 모음  
UI 폴더는 각 탭에 해당하는 UI PageClass 모음  
  
  
### 2. DB 폴더  
#### 디렉토리 구조  
1. CommunityItem.dart  
2. DictionaryItem.dart  
3. Question.dart  
4. Data.dart  
5. Map.dart
6. Review.dart  
   
#### 설명
각 탭에서 필요한 자료구조를 정의한 Class 모음임  
이름 그대로 1번부터 커뮤니티, 백과사전, 문의사항, (Data는 추상클래스이므로 생략), 맛집지도, 맛집리뷰 자료구조임.  
해당 앱은 Firebase를 사용하기 때문에, 각 클래스마다 기본적으로 add 함수와 getData 함수가 존재함.(각 firebase로부터 쓰기와 읽기)  
추가적으로 해당 데이터를 Firebase(이하 FB)에서 삭제하거나 갱신하는 등의 함수가 포함됨.   
또한 FB로부터 데이터를 읽어서 위젯을 반환하는 함수도 일부 정의되어 있음.  
  
  
### 3. LOGIN 폴더  
#### 디렉토리 구조  
1. Authentication.dart   
2. firebase_auth_remote_data_source.dart  
3. kakao_login.dart  
4. main_view_model.dart  
5. naver_login.dart  
6. social_login.dart  
  
#### 설명  
// 로그인 디렉토리 설명 //  
  
  
### 4. PROVIDER 폴더  
#### 디렉토리 구조  
1. dictionaryItemInfo.dart
2. loginedUser.dart
3. MapInfo.dart
  
#### 설명  
모든 탭에서 정보가 필요한 LoginedUser 클래스와 기타 일부 탭에서 필요한 DictionaryItemInfo, MapInfo 클래스를 PROVIDER로 정의함.  
백과사전과 맛집정보는 각각 2번째, 4번째 탭에 존재하는데, 설정 탭에 스크랩한 사전, 작성한 리뷰 등을 볼 수 있도록 하기 위하여 해당 정보를 PROVIDER로 정의함  
PROVIDER는 flutter에서 특정 객체의 통신을 위한 Class로, 만약 Scaffold 위젯을 PROVIDER로 wrapping 하게 된다면, Scaffold 하위 위젯들이 해당 PROVIDER 객체를 사용할 수 있음. 
  
  
### 5. UI 폴더  
#### 디렉토리 구조  
1. Supplementary  
2. CommunityPage.dart  
3. DictionaryPage.dart  
4. MainPage.dart  
5. MyPage.dart  
6. RestaurantPage.dart  
  
#### 설명  










