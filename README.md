# 프로젝트

### 스크린샷

![image](https://github.com/wontaeyoung/Vanilladin/assets/45925685/cbfbb37a-95ba-41ab-8478-6d7267890154)

### 한 줄 소개

알라딘 책 정보 조회 앱

<br>

### 서비스 기능

- 텍스트 기반 검색 기능
- 책 상세정보 조회 기능
- 최근검색어 기능

<br>

## 프로젝트 환경

**개발 인원**  
iOS 1인

**개발 기간**  
2023.08 ~ 2023.09 (6주)

<br>

## 개발 환경

**iOS 최소 버전**  
14.0+

**Xcode**  
15.0.1

<br>

## 작동 화면

|검색 화면|List <-> Grid 전환|스크롤 페이지네이션|
|-|-|-|
|<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/c8334f34-7362-4ac7-ad84-bd882f6fb01f" width="160">|<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/83eae6ba-75f2-4a80-8086-07be0ed43857" width="160">|<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/52eac1d6-e237-4c84-a57a-d428950dcde4" width="160">|

<br>

|상세화면|에러 사용자 피드백|최근 검색어|
|-|-|-|
|<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/304764b4-b15e-4205-ad67-3df334b0e1c0" width="160">|<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/9e95036d-6404-4a39-b506-ae8f41d09fe7" width="160">|<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/34ec8214-562f-4c3f-a046-abdaa78df98e" width="160">|

<br>

## 구현 고려사항

- **바닐라 프로그래밍**으로 ****라이브러리를 사용하지 않고 개발
- **커스텀 DI Container**를 구현해서 **의존성 관리** 및 **참조 인스턴스 재사용**
- 데이터 변경 사항을 **MVP**와 **`Delegate`** 패턴으로 UI에 반영
- 책 리스트 조회에 오프셋 **기반 페이지네이션** 적용

<br>

## 기술 활용

### 이미지 캐싱 적용

<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/e123e776-69b1-4676-b16b-b482020a005a" width="500">

- NSCache를 이용하여 이미지 캐싱을 구현하고, 이미지 요청 시점에 캐시 적용 분기 추가

<br>

<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/9854d86a-68b8-4ec0-ada9-46becddcc5c9" width="400">

- Scene 라이프사이클에 메모리 경고 옵저버를 연결해서 리소스 사용 및 회수

<br>

<details>

  <summary>이미지 캐시 매니저 소스코드</summary>
  
```swift
final class ImageCacheManager {
    // MARK: - Property
    static let shared: ImageCacheManager = .init()
    private let cache: NSCache<NSString, UIImage>
    private let memoryWarningNotification: NSNotification.Name
    
    // MARK: - Initializer
    private init() {
        self.cache = .init()
        self.memoryWarningNotification = UIApplication.didReceiveMemoryWarningNotification
        
        addMemoryObserver()
    }
    
    // MARK: - Method
    func getObject(for key: String) -> UIImage? {
        let cacheKey: NSString = .init(string: key)
        let cachedImage: UIImage? = cache.object(forKey: cacheKey)
        
        return cachedImage
    }
    
    func setObject(
        _ object: UIImage,
        for key: String
    ) {
        let cacheKey: NSString = .init(string: key)
        cache.setObject(object, forKey: cacheKey)
    }
    
    func removeObject(for key: String) {
        let cacheKey: NSString = .init(string: key)
        cache.removeObject(forKey: cacheKey)
    }
    
    @objc func removeAllObjects() {
        cache.removeAllObjects()
    }
    
    func addMemoryObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(removeAllObjects),
            name: memoryWarningNotification,
            object: nil)
    }
    
    func removeMemoryObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: memoryWarningNotification,
            object: nil)
    }
}
```
  
</details>

<br>

### 다중 이미지 요청 병렬처리 적용

- 책 리스트 조회 과정에서 10개의 이미지 **순차 요청** 문제 발생
  
- TaskGroup을 사용한 병렬 처리를 적용하여 응답 시간 **약 3.6배**(테스트 기준) 개선
  
- 병렬 처리 결과를 **요청 인덱스** 기준으로 재정렬하여, 검색의 정렬 기준인 Accuracy 보장
  
<br>
  
<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/0177aeaa-9e63-4be5-9769-d22c1877b857" width=400>

<br><br>
  
### 의존성 컨테이너 고유 인스턴스 식별

- **`DependencyContainer`** 는 레지스트리를 사용하여 의존성 관리 
인스턴스 요청 시, 이미 등록된 의존성을 체크해서 재사용

- 인스턴스 등록 여부를 식별하기 위해, **`ObjectIdentifier`** 를 레지스트리 Key로 채택

- **`ObjectIdentifier`** 는 **Type** 자체가 정의된 메타데이터를 기반으로 생성되기 때문에, 인스턴스의 레지스트리 등록 여부 판단 가능

<br>

## 아키텍처

![image](https://github.com/wontaeyoung/Vanilladin/assets/45925685/2e5cb5bf-0a90-4642-9347-a5cba0a9563f)

<br>

## 트러블슈팅
  
### HitTest 영역 미인식 문제

<img src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/a4eb4e40-22b5-4e9e-bd6f-59e40aa87f2a"><br>

- 삭제 버튼의 탭 인터랙션 미반응 문제 발생
- 예상 가능한 원인인 Interaction Enabled, View Hierarchy를 검토했으나 이슈 확인 불가
  
<br>

#### 원인 확인

삭제 버튼의 View 계층

- contentView
    - paddingView
        - deleteButton


<br>

```swift
override func setConstraint() {
	...
        
	paddingView.setPaddingAutoLayout(to: contentView, padding: 20)
        
	...
}
```

- paddingView은 contentView를 기준으로 20의 inner padding 적용

<br><br>

<img width="300" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/cb2e22a6-b976-4fcc-bbae-b742a5e387eb">

<br>

- 위 사진의 파란색 선이 paddingView 영역으로, 상하 20 padding이 적용되어 선에 가까운 높이로 드로잉

- iOS의 터치 이벤트 처리 시스템에 따라서 paddingView의 **`hitTest`** 에서 터치 이벤트 영역이 존재하지 않아, 하위 뷰인 삭제버튼으로 터치 가능한 뷰로 인식하지 않음
	- 시각적으로 뷰가 보이는 것과, 터치 이벤트 영역은 별개로 작동
  
- paddingView의 상하 padding 조절로 이슈 해결

<br><br>

<img width="300" alt="image" src="https://github.com/wontaeyoung/Vanilladin/assets/45925685/fd78c015-0999-496d-a481-9987e1911419">

<br><br>
