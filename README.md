# 자취 백과사전
## 2022-2 오픈소스 팀 프로젝트
  
  
  
  
  
  
  
### 앱 실행 영상

### 코드 사용법
1. 해당 소스코드는 자료구조를 정의해놓은 DB 폴더, UI가 정리되어있는 UI폴더, LOGIN API를 사용하는 API폴더, PROVIDER 클래스를 정의해놓은 PROVIDERS 폴더가 있습니다.

#### 1. DB
DictionaryItem, CommunityItem, Map, Review, QuestionItem 클래스가 각각 있으며 각각 백과사전, 커뮤니티, 맛집지도, 맛집리뷰, 문의사항에 관련된 클래스입니다.
이름대로, 각 탭(또는 페이지)에서 데이터를 읽어올 때, 해당 클래스를 만들어서 사용합니다.
기본적으로 각 클래스에는 add 함수(DB에 삽입하기), getDataFromDoc(DB에서 데이터 읽기)가 있으며 데이터를 읽었을 때, 위젯을 반환하는 함수도 포함되어 있습니다.

#### 2. UI
UI 폴더는 각 탭마다 클래스를 구분하였습니다.  
가장 기본이 되는 main과 그 아래의 MainPage, DictionaryPage, CommunityPage, RestaurantPage, MyPage 가 있습니다.
UI 폴더 아래에 Supplementary라는 폴더가 있습니다.  
해당 폴더는 각 탭마다 필요한 추가 페이지 클래스를 모아놓은 폴더입니다. CommunityPostPage, CommnunityWritePage, Search 등이 있습니다.

