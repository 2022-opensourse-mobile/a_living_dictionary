# 자취 백과사전
## 2022-2 오픈소스 팀 프로젝트
  
  
  
  
  
  
  
## 앱 실행 영상

## 코드 사용법
#### 디렉토리 구조  
1. DB 폴더  
2. PROVIDERS 폴더  
3. LOGIN 폴더  
4. UI 폴더  
5. main.dart  

### 1. DB  
#### 디렉토리 구조  


DictionaryItem, CommunityItem, Map, Review, QuestionItem 클래스가 각각 있으며 각각 백과사전, 커뮤니티, 맛집지도, 맛집리뷰, 문의사항에 관련된 클래스입니다.  
이름대로, 각 탭(또는 페이지)에서 데이터를 읽어올 때, 해당 클래스를 만들어서 사용합니다.  
기본적으로 각 클래스에는 add 함수(DB에 삽입하기), getDataFromDoc(DB에서 데이터 읽기)가 있으며 데이터를 읽었을 때, 위젯을 반환하는 함수도 포함되어 있습니다.  


#### 2. UI
UI 폴더는 각 탭마다 클래스를 구분하였습니다.  
가장 기본이 되는 main과 그 아래의 MainPage, DictionaryPage, CommunityPage, RestaurantPage, MyPage 가 있습니다.   
UI 폴더 아래에 Supplementary라는 폴더가 있습니다.  
해당 폴더는 각 탭마다 필요한 추가 페이지 클래스를 모아놓은 폴더입니다. CommunityPostPage, CommnunityWritePage, Search 등이 있습니다.  
main.dart에서는 최상위 위젯에 Provider를 적용하였고, 로그인을 위한 함수가 있습니다. 로그인을 성공적으로 마치면, 화면 아래에 TabBar가 생기게 되고, 메인 화면인 MainPage 로 이동하게 됩니다. 또한 로그인을 한 유저의 정보가 Logineduser라는 프로바이더 객체에 저장됩니다.   

각 페이지 클래스에는 해당 페이지를 출력하기 위한 함수가 만들어져 있습니다.  





