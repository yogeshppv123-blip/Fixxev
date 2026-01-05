import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: const String.fromEnvironment('API_URL', defaultValue: 'https://api.fixxev.in/api'),
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // --- Services ---
  Future<List<dynamic>> getServices() async {
    try {
      final response = await _dio.get('/services');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load services: $e');
    }
  }

  // --- Team ---
  Future<List<dynamic>> getTeam() async {
    try {
      final response = await _dio.get('/team');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load team: $e');
    }
  }

  // --- Products ---
  Future<List<dynamic>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
  // --- Blogs ---
  Future<List<dynamic>> getBlogs() async {
    try {
      final response = await _dio.get('/blog');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load blogs: $e');
    }
  }

  // --- Page Content ---
  Future<Map<String, dynamic>> getPageContent(String pageName) async {
    try {
      final response = await _dio.get('/page-content/$pageName');
      final content = response.data['content'];
      if (content != null) {
        return (content as Map).cast<String, dynamic>();
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  // --- Leads ---
  Future<bool> submitLead(Map<String, dynamic> leadData) async {
    try {
      final response = await _dio.post('/leads', data: leadData);
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // --- Settings ---
  Future<Map<String, dynamic>> getSettings() async {
    try {
      final response = await _dio.get('/settings');
      if (response.data != null) {
        return (response.data as Map).cast<String, dynamic>();
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  // --- About Sections ---
  Future<List<dynamic>> getAboutSections() async {
    try {
      final response = await _dio.get('/about-sections');
      return response.data;
    } catch (e) {
      return [];
    }
  }

  // --- Franchise Types ---
  Future<List<dynamic>> getFranchiseTypes() async {
    try {
      final response = await _dio.get('/franchise-types');
      return response.data;
    } catch (e) {
      return [];
    }
  }

  // --- CKD Features ---
  Future<List<dynamic>> getCKDFeatures() async {
    try {
      final response = await _dio.get('/ckd-features');
      return response.data;
    } catch (e) {
      return [];
    }
  }
}
