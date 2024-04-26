<!--

# Table of Content

[Information](#information)

[Introduce](#introduce)

[Architecture](#architecture)

[Directory](#directory)

[Trouble Shoot과 고민 지점](#trouble-shoot과-고민-지점)
- [싱글톤으로 생성하는 기준?](#싱글톤으로-생성하는-기준)
- [의존성 컨테이너의 인스턴스 고유 식별 문제](#의존성-컨테이너의-인스턴스-고유-식별-문제)
- [레지스트리 인스턴스 미등록 예외처리 문제](#레지스트리-인스턴스-미등록-예외처리-문제)
- [이미지 동시 요청 순차처리 문제](#이미지-동시-요청-순차처리-문제)
- [Keyword Cell 버튼 탭 불가 문제](#keyword-cell-버튼-탭-불가-문제)
- [검색 버튼 클릭 vs 최근 검색어 터치 포커스 차이](#검색-버튼-클릭-vs-최근-검색어-터치-포커스-차이)

<br><br>

-->

# Information
보안을 위해 API_Key가 제외되어있습니다. 빌드를 원하시는 분은 아래로 Plist를 요청해주세요!

<a href="mailto:hexter1994@naver.com">hexter1994@naver.com</a>

<br>

#### 👤 인원
- 개인

<br>

#### 🗓️ 작업 기간
- 2023.08 ~ 2023.09

<br>

#### 🖥️ 작업 환경
- iOS 14 +
- Xcode 15.0.1

<br><br>

# Introduce

알라딘 API를 활용하여 책 데이터를 받아서 List / Grid 스타일로 목록 화면을 표시하고, 책 상세정보 화면으로 이동할 수 있습니다.

라이브러리를 배제하고 의도적으로 바닐라 기능만 사용하여 구현했습니다.

<br>

- 의존성 주입에 사용한 `DI Container`를 라이브러리를 사용하지 않고 직접 구현해서 사용했습니다.
- `NSCache`를 이용한 이미지 캐싱을 구현하여 이미지 요청 횟수를 감소시켰습니다.
- 네트워크 병렬처리 로직을 구현하여 응답 소요시간을 약 3.6배 감소시켰습니다.
- `Coordinator` 패턴으로 화면 네비게이션을 관리하는 방법을 학습했습니다.
- 커스텀 `Delegate`를 만들어 사용하면서 델리게이트 패턴 사용법에 익숙해졌습니다.
- `TableView`, `CollectionView`에서 무한스크롤을 구현하여 API 요청 횟수를 최적화했습니다.

<br><br>

# 주요 기능 화면

|검색 화면|List <-> Grid 전환|무한스크롤|
|-|-|-|
|<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/c8334f34-7362-4ac7-ad84-bd882f6fb01f" width="200">|<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/83eae6ba-75f2-4a80-8086-07be0ed43857" width="200">|<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/52eac1d6-e237-4c84-a57a-d428950dcde4" width="200">|

- 검색 화면: 검색어를 입력하면 `API Endpoint`를 생성해서 알라딘 API를 호출하고, 응답 데이터를 화면에 표시합니다.
- List <-> Grid 전환: `UISegmentedControl`를 사용하여 목록 화면 스타일을 List / Grid로 전환합니다.
- 무한스크롤: 스크롤 최하단 1/3 지점을 넘어가면 다음 페이지의 데이터를 요청하여 무한스크롤로 동작합니다.

<br>

|상세화면 이동|에러 사용자 피드백|최근 검색어 저장|
|-|-|-|
|<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/304764b4-b15e-4205-ad67-3df334b0e1c0" width="200">|<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/9e95036d-6404-4a39-b506-ae8f41d09fe7" width="200">|<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/34ec8214-562f-4c3f-a046-abdaa78df98e" width="200">|

- 상세화면 이동: `Cell`을 선택하면 `Book Detail` 정보를 서버에 요청하고, 응답 결과를 포함하는 상세 화면을 `Coordinator`가 표시합니다.
- 에러 사용자 피드백: ISBN 데이터가 없어서 상세 화면으로 이동할 수 없는 경우, 에러를 방출하여 사용자에게 피드백 팝업을 표시합니다.
- 최근 검색어 저장: 최근 검색어를 최대 5개까지 저장합니다. `UserDefault`를 사용하여 로컬에 저장하고 앱이 종료되도 기록이 유지됩니다.

<br><br>

# Architecture

<img width="2500" alt="Vanilladin_Architecture" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/f56fe649-4c74-481b-990a-7a3cf035d504">

<br>

**MVVM**
- `ViewContoller`(View)는 UI 코드와 화면을 그리는 로직을 가지고 있습니다.
- `ViewModel`에서는 `ViewController`에서 발생하는 이벤트를 전달하고, UI에 반영할 데이터 가공을 담당합니다.
- 여러 `ViewModel`에서 공유 데이터를 활용할 수 있도록, `DataSource` 단계를 두어 데이터를 관리하고 `Repository`를 통해 데이터를 요청합니다.

<br>

**Coordinator**
- 네비게이션 및 사용자 `Alert`을 담당하고 있습니다.
- `push`, `pop`, `emptyOut` 등 네비게이션을 관리하는 인터페이스 함수를 `ViewModel`에 제공하여, 이벤트에 따라 간편하게 네비게이션 로직을 사용할 수 있도록 합니다.

<br>

**Dependency Container**
- 앱에서 사용되는 모든 객체의 의존성을 중앙에서 관리합니다.
- 레지스트리에 인스턴스를 등록하여, 참조가 필요한 다른 객체에게 쉽게 의존성을 전달할 수 있습니다.

<br><br>

# Directory

```
Vanilladin
├── Application
├── Config
├── Data
│   ├── DTO
│   │   └── Protocol
│   ├── Entity
│   │   └── Protocol
│   ├── Manager
│   ├── Network
│   │   ├── APIRequest
│   │   │   ├── Endpoint
│   │   │   │   ├── Parameter
│   │   │   │   └── Protocol
│   │   │   ├── Host
│   │   │   └── Scheme
│   │   ├── Error
│   │   ├── HTTP
│   │   └── Service
│   └── Repository
├── Presenter
│   ├── Common
│   │   ├── Base
│   │   ├── Coordinator
│   │   ├── DataSource
│   │   ├── ViewController
│   │   └── ViewModel
│   └── UI
│       ├── Coordinator
│       ├── DataSource
│       ├── View
│       │   ├── Cell
│       │   ├── View
│       │   └── ViewController
│       └── ViewModel
└── Utility
    ├── Constant
    ├── DependencyContainer
    └── Extension

```

<br>

<details open>
<summary>디렉토리 설명</summary>

- **Application** : App / Scene Delegate
- **Config** : Plist, Secret 파일
- **Data** : 데이터 모델과 네트워크를 담당하는 계층
  - **DTO** : 외부 데이터 소스와 통신하는 데이터 모델
  - **Entity** : 클라이언트에서 사용할 수 있도록 변환된 데이터 모델
  - **Manager** : 이미지 캐시, 동시성 처리, Plist
  - **Network** : API 요청 쿼리 생성, HTTP Request
  - **Repository** : Presenter 계층에서 데이터를 요청하고 반환받을 수 있는 인터페이스 객체
- **Presenter** : 비즈니스 로직과 UI 표시, 그리고 사용자 인터랙션을 담당하는 계층
  - **Common** : 상속을 위한 BaseView, Presenter 계층 관련 프로토콜과 에러 정의
  - **UI** : 사용자에게 화면을 표시하고, 사용자 인터랙션에 대한 로직 호출
- **Utility** : 프로젝트 전역에 사용되는 도구
  - **Constant** : 전역 상수 관리
  - **DependencyContainer** : 의존성 주입 및 관리 중앙화 객체
  - **Extension** : Swift 기존 타입에 대한 확장 메서드 정의

</details>

<br><br>

# Trouble Shoot과 고민 지점

## 싱글톤으로 생성하는 기준

<details open>
<summary>접기/펼치기</summary>
<br>

<img width="800" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/d83a22f0-a58c-4f54-9a48-cdf0d10644aa">

유틸리티성 클래스를 사용할 때, 필요한 시점에 인스턴스를 휘발적으로 생성해서 사용하거나 싱글톤으로 단일 인스턴스를 메모리에 올려두고 사용할 수 있습니다.

두 방법 모두 함수를 호출하는데 있어서는 큰 차이가 없기 때문에, 기준을 위한 다른 특징들을 고민했습니다.

싱글톤 인스턴스는 `static`으로 선언되었기 때문에 처음 사용되는 시점에 메모리에 올라가고, 그 후에는 앱 생명주기동안 유지됩니다.

반면 인스턴스를 휘발적으로 생성하면 함수가 호출된 뒤에 즉시 메모리에서 해제됩니다.

<br>

`DependencyContainer`나 `CacheManager`는 등록과 읽기, 삭제의 대상이 되는 프로퍼티를 가지고 있습니다. 이는 앱 전역에서 일관성이 유지되어야 하는 공유 데이터입니다.

반면 `AppConfigManager`나 `AsyncManager`는 별도의 프로퍼티, 즉 상태를 가지고 있지 않기 때문에 메모리에서 해제되어도 영향이 없습니다.

이를 기준으로 다른 객체에서 접근하는 공유 데이터가 있다면 싱글톤으로 구현하고, 단순 기능만 가진 클래스는 휘발적으로 인스턴스를 생성해서 작업이 종료되면 `ARC`에 의해 자동으로 해제되도록 했습니다.

<img width="300" alt="인스턴스 메모리 해제" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/053059cc-03d0-4b14-892a-f1ba1e81a7c7">

</details>

<br>

---

<br>

## 의존성 컨테이너의 인스턴스 고유 식별 문제

<details open>
<summary>접기/펼치기</summary>
<br>

`DependencyContainer`는 레지스트리를 통해 의존성을 관리합니다. 인스턴스 획득 시 이미 등록된 의존성을 체크해서 재사용할 수 있도록 합니다.

이 때 같은 타입의 인스턴스가 이미 등록되었는지를 판단하는 문제가 발생합니다.

<br>

### ObjectIdentifier

이를 해결하기 위해 `ObjectIdentifier`를 `key`로 사용하는 아이디어를 채택했습니다.

`ObjectIdentifier`는 참조 타입의 객체의 메모리 주소를 통해 키를 생성합니다.

그래서 인스턴스의 `Type`으로 `ObjectIdentifier`를 초기화하면 `Type` 자체가 정의된 메타데이터를 기반으로 키를 생성하기 때문에, 해당 타입의 인스턴스가 이미 레지스트리에 등록되어 있는지를 판단할 수 있습니다.

<br>

<img width="600" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/395994ba-9283-4edf-bb5e-fecb52522ff8">

<br>

<img width="600" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/72505233-575f-4a69-a1d0-c6027bceb2c2">

</details>

<br>

---

<br>

## 레지스트리 인스턴스 미등록 예외처리 문제

<details open>
<summary>접기/펼치기</summary>
<br>

`DependencyContainer`에서 의존성을 획득할 때, 등록되어있지 않은 경우에 대한 예외처리가 필요합니다.

<br>

### **1. Factory 패턴 적용**

<img width="600" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/fe4d5340-5d38-4baa-952c-493702535f32">

우선 적용한 해결책은 `Factory` 패턴입니다.

`resolve` 호출 시, 인스턴스가 등록되어있지 않은 경우를 대비해서 새 인스턴스를 초기화하는 클로저를 전달받아서 등록했습니다.

<img width="600" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/66a08304-f078-4002-a7cb-8a4694239527">

하지만 `Factory` 패턴을 사용하면 인스턴스를 초기화할 때, 연결된 의존성에 대해 모두 `Factory` 클로저를 작성해야하는 문제가 발생했습니다.

<br><br>

### **2. Lazy Register 로직 구현**

그 다음 적용한 해결책은 Lazy하게 Register 하는 방법입니다.

`Containable`을 채택한 제네릭을 전달해서 인스턴스가 필요한 시점에 자동으로 초기화하여 추가한다는 장점이 있습니다.

또한, 명시적으로 모든 인스턴스의 생성을 직접 작성해주지 않아도 되는 편리함이 있습니다.

하지만 이 방식은 참조 관계를 잘못 설정할 경우 순환참조의 루프로 앱이 크래시될 수 있고, 모든 `Containable` 객체가 파라미터가 없는 `init`을 구현해야하는 큰 단점이 존재했습니다.

이런 경우 이미 구현된 앱의 상당 부분을 변경해야했습니다.

<img width="600" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/81174119-fa35-4626-83a0-4d8ed3055b5a">

<br>

<img width="600" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/d87dc87d-434e-48e2-96f9-5bd65c03494c">

<br>

<img width="600" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/52932f49-998f-4f21-a5dd-67a6598157ab">

<br><br>

### **3. 컴포지션 루트 방식 채택**

최종적으로 선택한 해결책은 모든 객체와 의존성을 앱 시작지점에 구성하는 컴포지션 루트입니다.

이렇게 하면 앱 내의 모든 인스턴스를 중앙에서 관리할 수 있고, 동일한 의존성이 필요한 서로 다른 객체에 간편하게 같은 참조를 전달할 수 있는 장점이 있습니다.

`SceneDelegate`에서 앱 시작 시점에 모든 인스턴스 관계를 생성하는 `setDependency`를 호출하여 의존성을 주입하고 레지스트리에 등록하도록 했습니다.

</details>

<br>

---

<br>

## 이미지 동시 요청 순차처리 문제

<details open>
<summary>접기/펼치기</summary>
<br>

Aladin API에서 응답받은 책 데이터에는 책 이미지 URL이 포함되어 있습니다.

클라이언트에서 사용하기 전에 `BookDTO`의 이미지 URL을 요청해서 `UIImage`로 변환한 `Book Entity`로 변환하는 과정이 필요했습니다.

이 때 응답 단위인 10개의 Image URL을 요청하면 이미지 다운로드가 순차적으로 진행되는 문제가 발생했습니다.

응답 결과가 이후 로직에 활용되는 경우에는 `await`으로 실행을 중단해야하지만, 각 이미지 요청은 서로에게 의존성이 없기 때문에 병렬로 작업하는 것이 더 적합하다고 판단하여 `TaskGroup`을 도입했습니다.

<br>

### 병렬 처리 도입 후 성능 개선

<img width="600" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/d83be037-5656-4433-b856-f897a0b22d11">

<br>

`AsyncManager` 객체를 만들고 병렬로 매핑을 수행하는 `mapConcurrently` 함수를 구현했습니다.

외부에서 주입한 네트워크 요청 매핑 클로저를 작업으로 추가하고, 동시에 수행하여 완료되는 순서대로 결과에 담아 반환하도록 했습니다.

<br>

#### **이미지 직렬 요청**

<img width="600" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/0b01c21c-d86c-4c2a-a5c6-3fe733c30f22">

<br>

#### **이미지 병렬 요청**

<img width="600" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/0aa9445f-1685-4a91-a32c-7101f7935053">

<br>

로직 변경 후 테스트를 통해 동일한 조건에서 약 3.6배 정도 응답 시간의 개선을 확인했습니다.

<br>

### 데이터 순서 문제 해결

병렬 처리를 통해 성능은 개선했지만 이번에는 순서 문제가 발생했습니다.

`TaskGroup`은 비동기 병렬 처리를 수행하기 때문에 요청 결과가 오는 순서대로 배열에 추가됩니다.

그래서 처음 요청한 작업 순서와 결과 순서가 일치하지 않습니다.

검색어와 관련 없는 결과가 응답되는 것은 아니라서 큰 문제가 아닐수도 있지만, API 응답 순서가 검색어의 Accuracy를 기반으로 결정되기 때문에 이 순서를 보장해주는 것이 UX적으로 더 좋을 것이라고 생각했습니다.

그래서 이를 해결하기 위해 요청 전의 `index`를 획득해서 저장해두고, 매핑 후 결과를 반환하기 전에 `index` 기준으로 정렬하는 과정을 추가하여 요청 전 순서와 일치하도록 했습니다.

<br>

<img width="600" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/d5fb00f7-dead-4242-988f-1264bf44061b">

</details>

<br>

---

<br>

## Keyword Cell 버튼 탭 불가 문제

<details open>
<summary>접기/펼치기</summary>
<br>

<img width="200" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/95eef726-436f-4c68-b4ea-93fe99b80085">

<br>

위의 화면에서 X 버튼을 눌러도 삭제가 되지 않는 문제가 발생했습니다.

콘솔에서 확인해보니 호출되는 로직 문제가 아니라, 탭 인터랙션 자체가 발생하지 않는 상황이었습니다.

그래서 예상되는 사항들을 모두 확인해봤습니다.

- `Button`의 `Target` 설정
- `Button`의 `interaction enable` 여부
- `Button` 사이즈
- `TableView` `allowsSelection`
- 오버레이 되어서 인터랙션을 막고 있는 뷰가 존재하는지
    - <img width="300" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/433f02e0-217f-4b26-b132-d59d9323a6db">

<br>

### 원인 확인

삭제 버튼의 View 계층은 아래와 같습니다.

- contentView: Cell 전체
    - paddingView: 하위 UI에 대해 Cell 양 끝에서 padding을 주기 위한 컨테이너 View
        - deleteButton

<br>

이때 paddingView의 제약 조건은 아래와 같이 적용되어있습니다.

<br>

```swift
override func setConstraint() {
        ...
        
        paddingView.setPaddingAutoLayout(to: contentView, padding: 20)
        
        ...
}
```

<br>

setPaddingAutoLayout은 제약조건을 간편하게 설정하기 위한 커스텀 메서드로, padding 파라미터에 전달한 값을 superView를 기준으로 모든 방향에 주입합니다.

<br>

<img width="300" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/3a30ad54-ae48-48df-b7e7-163a5a4c7869">

<br>

backgroundColor를 통해서 문제를 확인할 수 있었는데, 위 이미지에서 파란색으로 그어져있는 선이 paddingView의 영역입니다.

상하에도 20씩 padding이 적용되고 나머지 영역을 height로 가져가서 선에 가깝게 그려진 것입니다.

UI에서는 정상적으로 deleteButton이 그려졌지만, superView인 paddingView가 정상적으로 그려져있더라도 인터랙션할 수 없는 범위로 인식된 것입니다.

<br>

### 문제 해결

<br>

<img width="300" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/ce914dbc-7c62-46e5-9f98-90f5ae5d34f4">

<br>

`paddingView.setPaddingAutoLayout(to: contentView, horizontal: 20)`

위와 같이 커스텀 horizontal과 vertical을 분리해서 적용할 수 있도록 커스텀 함수를 수정했습니다.

전체가 아닌 좌우에만 패딩을 적용하니 버튼이 정상적으로 인터랙션되는 점을 확인했고, UI와 상관없이 SuperView의 인터랙션 범위가 Child에 영향을 미치는 점을 학습했습니다.

</details>

<br>

---

<br>

## 검색 버튼 클릭 vs 최근 검색어 터치 포커스 차이

<details open>
<summary>접기/펼치기</summary>
<br>

|검색 버튼 클릭|최근 검색어 클릭|
|-|-|
|<img width="300" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/fbffabb1-2d0b-4c1b-a4a7-0c00d302be0d">|<img width="300" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/4a26a0d1-5253-43ea-ba54-dcb0f62fe0e7">|

<br>

위 이미지는 검색 기능을 호출할 수 있는 두 가지 UX입니다.

왼쪽은 검색어를 직접 입력하고 검색 버튼을 클릭하는 방식이고, 오른쪽은 최근 검색어 중 하나를 탭해서 해당 검색어로 검색합니다.

<br><br>

### 검색 로직

기본 검색 로직은 아래와 같습니다.

<br>

1. SearchBar의 텍스트를 KeywordHistory에 저장한다.
2. 텍스트를 쿼리에 담아서 네트워크 콜을 요청한다.
3. 결과를 응답받으면 Datasource를 업데이트한다.
4. KeywordHistory View를 BookList View로 전환한다.

<br>

```swift
// MARK: - Delegate
extension SearchBookViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색 키워드 저장
        guard let searchText: String = searchBar.text else { return }
        searchHistoryViewModel.saveKeyword(searchText)
        
        // 검색 내용으로 쿼리 요청 -> 책 리스트 뷰로 전환
        Task {
            await searchBookViewModel.fetchBooks(keyword: searchText)
            searchResultContainerViewController.showBookList()
        }
    }
	// 검색바가 포커스되면 최근 검색어 뷰로 전환
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchResultContainerViewController.showSearchHistory()
    }
}
```

이 때 검색바를 다시 탭하면 `searchBarTextDidBeginEditing`가 호출되면서 다시 최근 검색어 뷰로 전환됩니다.

<br><br>

### 최근 검색어를 통한 검색의 문제

```swift
// MARK: - Interface
extension SearchBookViewController: SearchHistoryViewDelegate {
    func submitKeyword(_ keyword: String) {
        guard let searchBar = navigationItem.searchController?.searchBar else { return }
        searchBar.text = keyword

        searchBarSearchButtonClicked(searchBar)
    }
}
```

<br>

최근 검색어 중에 하나를 탭하면 `submitKeyword` 를 호출하여 검색을 수행합니다.

선택된 검색어를 검색바에 반영하는 것 외에는 기본 검색 로직과 동일하기 때문에, 내부에서 `searchBarSearchButtonClicked` 를 재사용합니다.

이 때 검색은 정상적으로 수행되지만, 기존 검색과 차이가 발생합니다.

<img width="300" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/28a08cd9-2b98-4492-9dca-b8de79ad42d7">

검색 키워드를 통해서 검색을 수행하면, 위 검색 이미지와 같이 검색바의 포커스가 풀리지 않습니다.

검색바의 포커스가 풀리지 않으니, 다시 검색바를 탭해도 `searchBarTextDidBeginEditing` 가 호출되지 않아서 최근 검색어 Table을 볼 수 없습니다.

원인을 확인해보니 `SearchController`에서 검색 버튼을 클릭하면 `searchBarSearchButtonClicked` 이 호출되면서, 내부적으로 포커스가 해제되는 로직이 돌아가고 있었습니다.

그래서 같은 함수를 호출했지만 동일하게 작동하지 않았던 것이었습니다.

<br><br>

### 문제 해결

SearchBar 문서를 확인해보니 포커스를 해제하려면 `resignFirstResponder` 를 사용할 수 있다고 합니다.

submitKeyowrd 내부에 위 함수를 추가하고나니, 최근 검색어를 통해서 검색을 수행하도 기존 검색과 동일하게 작동하는 것을 확인할 수 있었습니다.

<br>

<img width="300" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/4a26a0d1-5253-43ea-ba54-dcb0f62fe0e7">

<br><br><br>

추가적으로 `resignFirstResponder`라는 이름이 기능 설명에 직관적이지 않은 것 같아서 찾아봤는데, `FirstResponder`는 현재 사용자의 입력을 받을 수 있는 상태인 뷰를 의미한다고 합니다.

즉, 특정 텍스트필드가 포커스를 받으면 해당 텍스트필드는 `FirstResponder`가 되는 것입니다.

FirstResponder를 resign한다 == 포커스를 해제한다 라는 의미로 이해할 수 있습니다.

</details>
