# Huỳnh Genealogy - Ứng dụng Quản lý Huỳnh Gia Tộc

**Huỳnh Genealogy** là một ứng dụng di động hiện đại được xây dựng bằng Flutter, giúp lưu trữ, quản lý và trực quan hóa sơ đồ gia phả của dòng họ một cách trực quan và sinh động. Với kiến trúc Clean Architecture chuẩn mực, ứng dụng đảm bảo tính mở rộng và khả năng bảo trì cao.

---

## ✨ Tính năng nổi bật

- 🌳 **Sơ đồ Gia phả Trực quan**: Hiển thị mối quan hệ giữa các thành viên qua nhiều đời bằng sơ đồ cây sinh động.
- 👨‍👩‍👧‍👦 **Quản lý Thành viên**: Thêm, sửa, xóa thông tin chi tiết của từng thành viên (họ tên, ngày sinh, giới tính, cha mẹ, vợ chồng).
- 🌿 **Phân chia Chi/Nhánh**: Hỗ trợ quản lý theo từng chi, nhánh lớn nhỏ trong dòng họ.
- 📊 **Dashboard Thống kê**: Tổng hợp số lượng thành viên, các nhánh và thông tin quan trọng khác.
- 🌐 **Đa ngôn ngữ**: Hỗ trợ Tiếng Việt và Tiếng Anh.
- ☁️ **Sẵn sàng kết nối Cloud**: Đã tích hợp cấu hình để dễ dàng chuyển đổi giữa dữ liệu Offline (Local) và Online (API).

---

## 🛠 Công nghệ sử dụng

### Mobile (Flutter)

- **State Management**: BLoC (Business Logic Component).
- **Architecture**: Clean Architecture (Domain, Data, Presentation layers).
- **Dependency Injection**: GetIt.
- **Navigation**: GoRouter.
- **UI & UX**: Custom Painters, Animation, Glassmorphism.

### Backend (NodeJS) - _Đang phát triển_

- **Framework**: Express 5.
- **ORM**: Sequelize (MySQL).
- **Architecture**: Modular Architecture.

---

## 📁 Cấu trúc Thư mục (Flutter)

```text
lib/
├── base/                # Các lớp cơ sở (UseCase, Failure)
├── config/              # Cấu hình routes, themes, constants
├── di/                  # Dependency Injection (injection_container.dart)
├── features/            # Các module tính năng (Gia phả, Dashboard...)
│   └── family_tree/
│       ├── data/        # Models, Repositories Impl, Data Sources
│       ├── domain/      # Entities, Repositories Interface, UseCases
│       └── presentation/# BLoCs, Pages, Widgets
└── main.dart            # Điểm khởi chạy ứng dụng
```

---

## 🚀 Hướng dẫn Cài đặt & Khởi chạy

### 1. Yêu cầu hệ thống

- Flutter SDK: `^3.x`
- Dart SDK: `^3.x`
- MySQL Server (nếu chạy Backend)
- Docker Desktop (khuyên dùng để chạy MySQL nhanh)

### 2. Cài đặt App Mobile

```bash
# Clone dự án
git clone https://github.com/ThachDev/Huynh_Genealogy.git

# Cài đặt dependencies
flutter pub get

# Chạy ứng dụng
flutter run
```

### 3. Cài đặt Backend (Tùy chọn)

Hướng dẫn chi tiết nằm trong thư mục `BE_Family_Tree`. Ní cần copy file `.env.example` thành `.env`, sau đó chạy:

```bash
docker-compose up -d
npm install
npm run dev
```

---

## 📸 Ảnh chụp màn hình

```carousel
![Dashboard](https://raw.githubusercontent.com/ThachDev/Huynh_Genealogy/dev/assets/readme/dashboard.png)
<!-- slide -->
![Sơ đồ Cây](https://raw.githubusercontent.com/ThachDev/Huynh_Genealogy/dev/assets/readme/tree_view.png)
<!-- slide -->
![Thêm Thành viên](https://raw.githubusercontent.com/ThachDev/Huynh_Genealogy/dev/assets/readme/add_member.png)
```

---

## 🤝 Đóng góp

Dự án được phát triển bởi **Thạch Dev**. Mọi đóng góp hoặc ý kiến phản hồi xin vui lòng liên hệ trực tiếp hoặc tạo Pull Request.

---

## 📄 Giấy phép

Bản quyền thuộc về **ThachDev/Huynh_Genealogy**.
