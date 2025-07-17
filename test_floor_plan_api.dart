import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:3031/api',
    headers: {
      'Authorization': 'Bearer YOUR_TOKEN_HERE', // Replace with actual token
    },
  ));

  try {
    print('🔍 Testing floor plans API...');
    final response = await dio.get('/floor-plans');
    print('✅ Response status: ${response.statusCode}');
    print('✅ Response data: ${response.data}');
    
    // Check the structure
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      print('✅ Response has success field: ${data.containsKey('success')}');
      print('✅ Success value: ${data['success']}');
      
      if (data.containsKey('data')) {
        final floorPlansData = data['data'];
        print('✅ Data type: ${floorPlansData.runtimeType}');
        
        if (floorPlansData is List) {
          print('✅ Data is a list with ${floorPlansData.length} items');
          if (floorPlansData.isNotEmpty) {
            print('✅ First item: ${floorPlansData.first}');
            print('✅ First item type: ${floorPlansData.first.runtimeType}');
            
            if (floorPlansData.first is Map<String, dynamic>) {
              final firstFloorPlan = floorPlansData.first as Map<String, dynamic>;
              print('✅ Floor plan fields:');
              firstFloorPlan.forEach((key, value) {
                print('   $key: $value (${value.runtimeType})');
              });
            }
          }
        }
      }
    }
  } catch (e) {
    print('❌ Error: $e');
  }
} 