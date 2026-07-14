import 'package:dio/dio.dart';
import '../../constants/app_constants.dart';
import '../../errors/exceptions.dart';
import '../model/event_model.dart';

abstract class EventsRemoteDataSource {
  Future<List<EventModel>> getEvents({required int familyId});
  Future<EventModel> saveEvent(EventModel event);
  Future<bool> deleteEvent(int id);
}

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final Dio dio;

  EventsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<EventModel>> getEvents({required int familyId}) async {
    try {
      final response = await dio.get(
        AppConstants.eventsEndpoint,
        queryParameters: {'familyId': familyId},
      );
      final responseData = _parseMapResponse(response.data);
      final data = _parseListData(responseData);
      return data
          .map((json) => EventModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: null,
      );
    }
  }

  @override
  Future<EventModel> saveEvent(EventModel event) async {
    try {
      final isNew = event.id == 0;
      final response = isNew
          ? await dio.post(
              AppConstants.eventsEndpoint,
              data: event.toJson(),
            )
          : await dio.put(
              '${AppConstants.eventsEndpoint}/${event.id}',
              data: event.toJson(),
            );
      final responseData = _parseMapResponse(response.data);
      final rawData = responseData['data'];
      if (rawData is Map<String, dynamic>) {
        return EventModel.fromJson(rawData);
      }
      throw const ServerException(
        message: 'Dữ liệu phản hồi không hợp lệ',
        statusCode: null,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: null,
      );
    }
  }

  @override
  Future<bool> deleteEvent(int id) async {
    try {
      final response = await dio.delete('${AppConstants.eventsEndpoint}/$id');
      final responseData = _parseMapResponse(response.data);
      return responseData['success'] == true;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: null,
      );
    }
  }

  Map<String, dynamic> _parseMapResponse(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    throw const ServerException(
      message: 'Dữ liệu trả về không đúng định dạng',
      statusCode: null,
    );
  }

  List<dynamic> _parseListData(Map<String, dynamic> responseData) {
    final raw = responseData['data'];
    if (raw is List<dynamic>) return raw;
    throw const ServerException(
      message: 'Dữ liệu danh sách trả về không đúng định dạng',
      statusCode: null,
    );
  }
}
