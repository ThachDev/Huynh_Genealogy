# AI Coding Guidelines — Gia Tộc Việt Project

Tài liệu này hướng dẫn các AI Assistant cách phát triển, nâng cấp mã nguồn cho dự án **Gia Tộc Việt** đảm bảo tính nhất quán, chuyên nghiệp và đúng kiến trúc.

---

## 1. Môi trường & Quản lý phiên bản (FVM)
Dự án sử dụng **FVM (Flutter Version Management)** để đồng bộ phiên bản SDK Flutter.
* **MANDATORY**: Tất cả các lệnh terminal liên quan đến Flutter/Dart phải được gọi thông qua tiền tố `fvm`.
* **Ví dụ các lệnh thường dùng**:
  * Tải dependencies: `fvm flutter pub get`
  * Phân tích mã nguồn: `fvm flutter analyze`
  * Chạy tạo file bản dịch l10n: `fvm flutter gen-l10n`
  * Chạy ứng dụng: `fvm flutter run`
  * Build release: `fvm flutter build apk --release` / `fvm flutter build ios --release`
  * Chạy tests: `fvm flutter test`

---

## 2. Kiến trúc mã nguồn (Clean Architecture)
Dự án được tổ chức theo cấu trúc **Clean Architecture** chia thành các tầng rõ rệt:

```
lib/
├── core/                  # Các thành phần dùng chung toàn hệ thống
│   ├── theme/             # Định nghĩa theme sáng/tối (AppTheme, AppColors)
│   ├── utils/             # Các bộ tiện ích (AppValidators, DateFormatter, ...)
│   ├── widgets/           # Thư viện component dùng chung (AppButton, AppTextField, ...)
│   ├── network/           # Network layer (Dio client, interceptors)
│   ├── errors/            # Error handling (Failures, Exceptions)
│   ├── config/            # App constants, env config
│   ├── routes/            # GoRouter configuration
│   └── local/             # Local storage (SharedPreferences, Hive)
└── features/              # Các chức năng của hệ thống
    └── [chức_năng]/
        ├── data/          # Models, Datasources, Repository implementations
        ├── domain/        # Entities, Usecases, Repository interfaces
        └── presentation/  # Bloc/Cubit, Pages, Widgets
```

### Quy tắc triển khai:
* **Presentation Layer**: Trang (Pages) chỉ xử lý bố cục và phản hồi sự kiện từ Bloc. Không nhúng logic nghiệp vụ hoặc logic kiểm tra dữ liệu trực tiếp trong UI.
  * Cấu trúc thư mục con trong `presentation/`:
    ```
    presentation/
    ├── bloc/          # Quản lý trạng thái (Bloc/Cubit)
    ├── pages/         # Các màn hình/trang giao diện chính
    └── widgets/       # Các widget dùng chung nội bộ cho feature này
    ```
  * **Quy tắc tổ chức**: Khi số lượng widget hoặc các file trong thư mục `pages/` quá nhiều, tạo thêm thư mục `widgets/` tại nhánh con `presentation/` để chứa các widget dùng chung hoặc widget con được tách ra từ page.
* **Domain Layer**: Phải độc lập hoàn toàn, không phụ thuộc vào bất kỳ thư viện UI nào.
* **Data Layer**: Implement repository interfaces, handle data sources (remote/local), mapping DTO ↔ Entity.

---

## 3. Giao diện Sáng/Tối & Hệ thống Component dùng chung
Dự án hỗ trợ song song hai chế độ **Giao diện sáng (Light Mode)** và **Giao diện tối (Dark Mode)**. 
* **MANDATORY**: Mỗi khi tạo mới hoặc sửa đổi Widget/Component, bắt buộc thiết kế cho cả hai chế độ (sử dụng `Theme.of(context)` hoặc `AppColors`).
* Không tự định nghĩa `InputDecoration`, `ButtonStyle` thủ công. Phải dùng `core/widgets/widgets.dart` và `core/theme/app_theme.dart`.

> [!IMPORTANT]
> **Quy tắc tạo Widget dùng chung**: Widget tái sử dụng ở nhiều nơi → tạo tại `lib/core/widgets/` và export tại `widgets.dart`.

### 3.1. Nhập liệu (TextField)
* **Light**: `AppTextFieldLight` | **Dark**: `AppTextField`
* *Tuyệt đối không tự viết `InputDecoration`*.

### 3.2. Nút bấm (Buttons)
* Dùng `AppButton` thay vì `ElevatedButton`/`OutlinedButton`/`TextButton`.
* **Variants**: `primary` (Crimson), `secondary` (Gold), `outline`, `ghost`, `danger`
* **Sizes**: `small`, `medium`, `large`

### 3.3. Thông báo (SnackBars)
* Dùng `AppSnackBar`: `.success()`, `.error()`, `.warning()`, `.info()`

### 3.4. Phân cách (Dividers)
* `AppLabeledDivider(label: 'TEXT', isLight: true/false)`

### 3.5. Biểu tượng (Icons)
* Thư viện: **`lucide_icons`** (không dùng `Icons` mặc định)
* Import: `import 'package:lucide_icons/lucide_icons.dart';`

### 3.6. Chuyển trang (Page Route Transitions)
* Không lạm dụng Slide. Ưu tiên **`FadeScalePageRoute`** (Material 3).
* Khai báo tại `app_route_transitions.dart`, export tại `widgets.dart`.

---

## 4. Widget Patterns & Optimization (Theo Flutter-Dev Skill)

### 4.1. Widget Optimization
```dart
// ✅ GOOD: const constructors, extract static widgets
class MyWidget extends StatelessWidget {
  const MyWidget({super.key}); // const constructor
  
  @override
  Widget build(BuildContext context) {
    return const _StaticContent(); // extracted const widget
  }
}

class _StaticContent extends StatelessWidget {
  const _StaticContent();
  @override
  Widget build(BuildContext context) => const Text('Hello');
}
```

* **Luôn dùng `const`** cho constructor widget tĩnh
* Tách widget tĩnh thành class riêng (`_PrivateWidget`)
* Dùng `Key` cho list items: `ValueKey(item.id)` / `ObjectKey(item)`
* Ưu tiên `ConsumerWidget` / `HookWidget` thay vì `StatefulWidget`

### 4.2. Layout & Responsive
* **Spacing**: 8pt increments (8, 16, 24, 32, 48)
* **Breakpoints**: mobile (<650), tablet (650-1100), desktop (>1100)
* Dùng `LayoutBuilder` + `MediaQuery` cho responsive
* Follow Material 3 design guidelines

### 4.3. List & Scrolling
```dart
// ✅ GOOD: lazy loading
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(item: items[index]),
)

// ❌ BAD: builds all at once
Column(children: items.map((e) => ItemWidget(item: e)).toList())
```
* Dùng `ListView.builder` / `GridView.builder` cho danh sách lớn
* Phức tạp: `CustomScrollView` + Slivers (`SliverList`, `SliverGrid`, `SliverAppBar`)

---

## 5. State Management (Bloc/Cubit - Theo Skill)

### 5.1. Bloc/Cubit Patterns
```dart
// ✅ GOOD: Event-driven, immutable state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(LoginParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }
}

// ❌ BAD: mutating state, logic in UI
```

### 5.2. State Design
* **Immutable**: `Equatable` + `copyWith()` hoặc Freezed
* **Granular states**: `Loading`, `Success`, `Error`, `Empty` thay vì boolean flags
* **Selective rebuild**: `BlocBuilder<AuthBloc, AuthState>(buildWhen: (prev, curr) => prev.user != curr.user)`

### 5.3. Provider Scoping
* `BlocProvider` ở mức `MaterialApp` cho global (AuthBloc)
* `BlocProvider` ở feature level cho scoped blocs
* Dispose controllers/subscriptions trong `close()` / `dispose()`

---

## 6. Navigation (GoRouter)

### 6.1. Route Configuration
```dart
final router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;
    final isAuthenticated = authState is Authenticated;
    final isLoginRoute = state.matchedLocation == '/login';
    
    if (!isAuthenticated && !isLoginRoute) return '/login';
    if (isAuthenticated && isLoginRoute) return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (c, s) => const LoginPage()),
    ShellRoute(
      builder: (c, s, child) => UserMainNavigationPage(child: child),
      routes: [
        GoRoute(path: '/home', builder: (c, s) => const DashboardPage()),
        GoRoute(path: '/tree', builder: (c, s) => const TreeViewPage()),
        GoRoute(path: '/settings', builder: (c, s) => const SettingsPage()),
      ],
    ),
  ],
);
```

* Typed routes với `GoRouteData` (auto-generated)
* Auth guards via `redirect`
* Deep linking support
* State preservation via `ShellRoute`

---

## 7. Performance Optimization (Theo Skill)

### 7.1. Rebuild Prevention
```dart
// Selective listening
BlocBuilder<AuthBloc, AuthState>(
  buildWhen: (prev, curr) => prev is! Authenticated || curr is! Authenticated || prev.user != curr.user,
  builder: (context, state) { ... },
)

// Provider select
final userName = ref.watch(userProvider.select((u) => u.name));
```

### 7.2. Repaint Boundary
```dart
RepaintBoundary(
  child: ComplexAnimatedWidget(), // isolates repaints
)
```

### 7.3. Heavy Computation
```dart
final result = await compute(heavyFunction, input); // isolate
```

### 7.4. Image Caching
```dart
CachedNetworkImage(
  imageUrl: url,
  placeholder: (c, u) => const AppLoading(),
  errorWidget: (c, u, e) => const Icon(Icons.error),
)
```

### 7.5. DevTools Profiling
* `flutter run --profile` → DevTools → Performance tab
* Target <16ms frame (60fps)
* Check "Rebuilds" widget count in Flutter Inspector

---

## 8. Xác thực dữ liệu (Validators)
* File: `lib/core/utils/validators.dart`
* Hàm có sẵn: `validateEmail`, `validatePassword`, `validateStrongPassword`, `validateConfirmPassword`, `validateFullName`, `validatePhoneNumber`, `validateYear`, `validateRequired`
* Form validation: `Form(key: _formKey, child: ...)` + `TextFormField(validator: AppValidators.validateEmail)`

---

## 9. Error Handling (Failures & Exceptions)
* Thư mục: `lib/core/errors/`
* **Failures**: `ServerFailure`, `CacheFailure`, `NetworkFailure`, `AuthFailure`, `ValidationFailure`, `NotFoundFailure`, `PermissionFailure`, `TimeoutFailure`
* Tất cả `Failure` phải implement `getMessage(BuildContext context)` → localized message từ `.arb`
* **Exceptions**: `ServerException`, `CacheException` → map thành Failure ở Repository

---

## 10. Localization (l10n)
* Files: `lib/resources/app_vi.arb`, `app_en.arb`
* Chạy `fvm flutter gen-l10n` sau khi sửa `.arb`
* Usage: `AppLocalizations.of(context)!.keyName`
* **Default params**: không dùng `AppLocalizations.of(context)` ở default param → dùng `null` fallback trong build

---

## 11. Networking (Dio)
* `lib/core/network/dio_client.dart` - singleton Dio instance
* Interceptors: auth token, logging, error handling, retry
* Timeout: connect 10s, receive 15s
* Base URL từ `AppConstants.baseUrl`

---

## 12. Forms & Input
* `Form(key: _formKey)` + `TextFormField`
* Validators từ `AppValidators`
* Input formatters: `FilteringTextInputFormatter.digitsOnly`, `LengthLimitingTextInputFormatter`
* Focus management: `FocusNode`, `FocusScope.of(context).requestFocus()`

---

## 13. Animations (Theo Skill)

### 13.1. Implicit Animations
```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  width: isExpanded ? 200 : 100,
)
```

### 13.2. Explicit Animations
```dart
AnimationController _controller;
@override void initState() {
  super.initState();
  _controller = AnimationController(vsync: this, duration: 300.ms);
}
@override void dispose() { _controller.dispose(); super.dispose(); }
```

### 13.3. Page Transitions
* `FadeScalePageRoute` cho màn hình độc lập
* `SlidePageRoute` cho navigation stack
* Hero animations cho shared elements

---

## 14. Testing Strategies

### 14.1. Unit Tests (Bloc)
```dart
blocTest<AuthBloc, AuthState>(
  'emits [AuthLoading, Authenticated] when login succeeds',
  build: () => AuthBloc(loginUseCase: mockLoginUseCase),
  act: (bloc) => bloc.add(AuthLoginRequested(email: 'a@b.c', password: '123')),
  expect: () => [AuthLoading(), isA<Authenticated>()],
);
```

### 14.2. Widget Tests
```dart
testWidgets('LoginPage shows error on invalid email', (tester) async {
  await tester.pumpWidget(MaterialApp(home: LoginPage()));
  await tester.enterText(find.byType(TextFormField).first, 'invalid');
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
  expect(find.text('Email không hợp lệ'), findsOneWidget);
});
```

### 14.2. Integration Tests
* `integration_test/` - full user flows
* `flutter test integration_test/app_test.dart`

---

## 15. Platform Integration (iOS/Android)

### 15.1. iOS
* Info.plist: permissions, URL schemes, LSApplicationQueriesSchemes
* Push notifications: APNs, Firebase Messaging
* App Transport Security (ATS)

### 15.2. Android
* AndroidManifest: permissions, intent-filters, network security config
* ProGuard/R8 rules for release
* Keystore signing

### 15.3. Platform Channels
```dart
// Dart
const channel = MethodChannel('com.giatocviet/native');
final result = await channel.invokeMethod('getBatteryLevel');

// Native (Kotlin/Swift) implements handler
```

---

## 16. Code Style & Linting
* `fvm flutter analyze` - zero issues
* `const` constructors everywhere possible
* Extract widgets at >200 lines or deep nesting
* Import sorting: dart: → package: → relative
* No trailing commas in single-line, required in multi-line

---

## 17. Phối hợp Backend
* Kiểm tra API contract tại `/Users/ancq/ThienThach/Code/BE/BE_Huynh_Genealogy`
* Đồng bộ: Database schema, API endpoints, DTOs
* Nếu BE thiếu logic → AI implement bổ sung tại BE

---

## Quick Reference Card

| Task | Command / Pattern |
|------|-------------------|
| Analyze | `fvm flutter analyze` |
| Gen l10n | `fvm flutter gen-l10n` |
| Run dev | `fvm flutter run` |
| Test | `fvm flutter test` |
| Profile | `fvm flutter run --profile` |
| Build apk | `fvm flutter build apk --release` |
| Bloc test | `blocTest<Bloc, State>(...)` |
| Widget test | `testWidgets('desc', (tester) async {})` |
| Compute | `await compute(fn, input)` |
| RepaintBoundary | `RepaintBoundary(child: widget)` |
| GoRouter push | `context.go('/path')` |
| SnackBar | `AppSnackBar.success(context, msg)` |
| Validate | `AppValidators.validateEmail` |

---

**References**: Flutter-Dev Skill references in `/Users/ancq/.cursor/minimax-skills/skills/flutter-dev/references/`