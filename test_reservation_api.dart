import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3031/api',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  try {
    print('🔍 Testing reservation API...');
    
    final testData = {
      "customerName": "JBL",
      "customerPhone": "85842192", 
      "partySize": 2,
      "reservationDate": "2025-07-17",
      "reservationTime": "21:30:00",
      "specialRequests": "alergias"
    };
    
    print('🔍 Sending data: $testData');
    
    final response = await dio.post(
      '/tables/39/reservations',
      data: testData,
    );
    
    print('🔍 Success! Response: ${response.data}');
    
  } catch (e) {
    if (e is DioException) {
      print('🔍 Error: ${e.message}');
      print('🔍 Status: ${e.response?.statusCode}');
      print('🔍 Response: ${e.response?.data}');
    } else {
      print('🔍 Error: $e');
    }
  }
} 