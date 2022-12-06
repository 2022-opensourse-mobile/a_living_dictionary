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
  
  
### 3. UI 폴더  
#### 디렉토리 구조  
1. 





