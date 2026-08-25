/// ============================================================================
/// ONBOARDING FEATURE — BARREL EXPORT FILE
/// ============================================================================
/// Gom và xuất toàn bộ các thành phần của tính năng Onboarding theo 3 tầng Clean Architecture:
///   1. Domain Layer: Repository Interfaces, UseCases.
///   2. Data Layer: RemoteDataSources, Repository Implementations.
///   3. Presentation Layer: BLoC, Events, States, Pages.
/// ============================================================================
library onboarding;

// -----------------------------------------------------------------------------
// 1. DOMAIN LAYER (Nghiệp vụ thuần túy)
// -----------------------------------------------------------------------------
export 'domain/repository/onboarding_repository.dart';
export 'domain/usecase/create_family.dart';
export 'domain/usecase/verify_invite_code.dart';
export 'domain/usecase/join_family.dart';
export 'domain/usecase/link_member_to_user.dart';
export 'domain/usecase/get_family_detail.dart';

// -----------------------------------------------------------------------------
// 2. DATA LAYER (Dữ liệu & API)
// -----------------------------------------------------------------------------
export 'data/source/onboarding_remote_data_source.dart';
export 'data/repository/onboarding_repository_impl.dart';

// -----------------------------------------------------------------------------
// 3. PRESENTATION LAYER (Giao diện & State Management)
// -----------------------------------------------------------------------------
export 'presentation/bloc/onboarding_bloc.dart';
export 'presentation/bloc/onboarding_event.dart';
export 'presentation/bloc/onboarding_state.dart';
export 'presentation/pages/onboarding_page.dart';
