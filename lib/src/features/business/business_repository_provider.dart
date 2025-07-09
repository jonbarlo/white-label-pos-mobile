import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import 'business_repository.dart';
import 'business_repository_impl.dart';

part 'business_repository_provider.g.dart';

@riverpod
Future<BusinessRepository> businessRepository(BusinessRepositoryRef ref) async {
  final dio = Dio();
  return BusinessRepositoryImpl(dio);
} 