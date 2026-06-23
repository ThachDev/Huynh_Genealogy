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

---

## 2. Kiến trúc mã nguồn (Clean Architecture)
Dự án được tổ chức theo cấu trúc **Clean Architecture** chia thành các tầng rõ rệt:

```
lib/
├── core/                  # Các thành phần dùng chung toàn hệ thống
│   ├── theme/             # Định nghĩa theme sáng/tối (AppTheme, AppColors)
│   ├── utils/             # Các bộ tiện ích (AppValidators, DateFormatter, ...)
│   └── widgets/           # Thư viện component dùng chung (AppButton, AppTextField, ...)
└── features/              # Các chức năng của hệ thống (Ví dụ: auth, family_tree)
    └── [chức_năng]/
        ├── data/          # Mô hình dữ liệu, APIs, Repositories implementation
        ├── domain/        # Thực thể (Entities), Usecases, Repositories interface
        └── presentation/  # Giao diện (Bloc/Cubit, Pages, Widgets nội bộ)
```

### Quy tắc triển khai:
* **Presentation Layer**: Trang (Pages) chỉ xử lý bố cục và phản hồi sự kiện từ Bloc. Không nhúng logic nghiệp vụ hoặc logic kiểm tra dữ liệu trực tiếp trong UI.
* **Domain Layer**: Phải độc lập hoàn toàn, không phụ thuộc vào bất kỳ thư viện UI nào.

---

## 3. Hệ thống Component & Theme dùng chung
Không tự định nghĩa lại hoặc tùy biến thủ công (ad-hoc styling) cho các widget cơ bản. Phải ưu tiên sử dụng thư viện dùng chung trong `core/widgets/widgets.dart` và `core/theme/app_theme.dart`.

> [!IMPORTANT]
> **Quy tắc tạo Widget dùng chung**: Nếu có bất kỳ Widget nào cần tái sử dụng ở nhiều nơi hoặc giữa nhiều feature khác nhau, bắt buộc phải tạo mới tệp tin widget đó trong thư mục `lib/core/widgets/` và cập nhật khai báo export vào tệp tổng hợp [widgets.dart](file:///Users/ancq/ThienThach/Code/FE/Gia_Toc_Viet/lib/core/widgets/widgets.dart). Điều này giúp đảm bảo tính nhất quán của giao diện và tránh việc khai báo trùng lặp code.

### 3.1. Nhập liệu (TextField)
* **Chế độ nền sáng**: Dùng `AppTextFieldLight`
* **Chế độ nền tối**: Dùng `AppTextField`
* *Tuyệt đối không tự viết `InputDecoration`*.

### 3.2. Nút bấm (Buttons)
* Sử dụng `AppButton` thay vì `ElevatedButton`, `OutlinedButton`, hoặc `TextButton` trực tiếp.
* Lựa chọn `AppButtonVariant`:
  * `primary`: Crimson (Đỏ thẫm dòng họ)
  * `secondary`: Gold (Vàng kim)
  * `outline`: Viền vàng kim
  * `ghost`: Nền mờ nhạt
  * `danger`: Đỏ cảnh báo
* Lựa chọn kích thước thông qua `AppButtonSize` (`small`, `medium`, `large`).

### 3.3. Thông báo (SnackBars)
* Sử dụng `AppSnackBar` thay thế cho `ScaffoldMessenger.of(context).showSnackBar`.
* Gọi trực tiếp các static helper tương ứng với ngữ cảnh:
  * Thành công: `AppSnackBar.success(context, message)`
  * Lỗi: `AppSnackBar.error(context, message)`
  * Cảnh báo: `AppSnackBar.warning(context, message)`
  * Thông tin: `AppSnackBar.info(context, message)`

### 3.4. Phân cách có chữ (Dividers)
* Sử dụng `AppLabeledDivider(label: 'TEXT', isLight: true/false)` cho các phần phân tách giữa các khối (ví dụ: dòng chữ "HOẶC").

---

## 4. Xác thực dữ liệu (Validators)
Tất cả các biểu mẫu (Form) nhập liệu phải sử dụng các hàm xác thực tập trung để đảm bảo tính nhất quán của thông điệp lỗi và logic nghiệp vụ.
* **Tệp cấu hình**: [validators.dart](file:///Users/ancq/ThienThach/Code/FE/Gia_Toc_Viet/lib/core/utils/validators.dart)
* **Các hàm có sẵn**:
  * `AppValidators.validateEmail`
  * `AppValidators.validatePassword` (Dành cho Đăng nhập)
  * `AppValidators.validateStrongPassword` (Dành cho Đăng ký/Đổi mật khẩu)
  * `AppValidators.validateConfirmPassword`
  * `AppValidators.validateFullName` (Xử lý tốt tiếng Việt unicode)
  * `AppValidators.validatePhoneNumber` (Định dạng Việt Nam)
  * `AppValidators.validateYear` (Giới hạn năm hợp lý trong Gia Phả)
  * `AppValidators.validateRequired`

---

## 5. Đa ngôn ngữ (Localization - l10n)
Dự án được bản địa hóa hoàn chỉnh sử dụng Flutter Localization chính thống. Không được hardcode bất kỳ chuỗi ký tự hiển thị nào hiển thị lên UI.

### 5.1. Khai báo chuỗi dịch:
* Thêm các key-value tương ứng vào hai tệp tài nguyên:
  * Tiếng Việt: [app_vi.arb](file:///Users/ancq/ThienThach/Code/FE/Gia_Toc_Viet/lib/resources/app_vi.arb)
  * Tiếng Anh: [app_en.arb](file:///Users/ancq/ThienThach/Code/FE/Gia_Toc_Viet/lib/resources/app_en.arb)
* Sau khi chỉnh sửa các tệp `.arb`, bắt buộc chạy lệnh sau để sinh mã:
  ```bash
  fvm flutter gen-l10n
  ```

### 5.2. Sử dụng trong code:
* Import gói thư viện sinh ra:
  ```dart
  import 'package:flutter_gen/gen_l10n/app_localizations.dart';
  ```
* Truy xuất chuỗi thông qua `AppLocalizations`:
  ```dart
  final l10n = AppLocalizations.of(context)!;
  // Ví dụ sử dụng:
  Text(l10n.loginTitle)
  ```

---

## 6. Tiêu chuẩn viết code (Code Style & Linting)
* Giữ cấu trúc tệp gọn gàng, tránh các Widget lồng nhau quá sâu. Hãy tách ra các private helper method (ví dụ: `_buildHeader()`) hoặc các Widget class riêng biệt khi vượt quá 200 dòng.
* Luôn khai báo `const` cho các Constructor của widget tĩnh để tối ưu hiệu năng hiển thị.
* Khi gặp cảnh báo từ linter, hãy khắc phục triệt để. Nếu là cảnh báo giả (false positive) từ thư viện SDK, hãy sử dụng chú thích `// ignore: lint_rule` cục bộ thay vì tắt diện rộng.
