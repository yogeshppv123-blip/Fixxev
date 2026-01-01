import 'package:dio/dio.dart';

class ApiService {
  /* 
   * LOCALHOST URL:
   * For Chrome: http://localhost:5000/api
   * For Android Emulator: http://10.0.2.2:5000/api
   * For iOS Simulator: http://localhost:5000/api
   * For Production: Your hosted backend URL
   */
  final Dio _dio = Dio(BaseOptions(
    baseUrl: const String.fromEnvironment('API_URL', defaultValue: 'http://127.0.0.1:5001/api'),
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

  Future<dynamic> createService(Map<String, dynamic> serviceData) async {
    try {
      final response = await _dio.post('/services', data: serviceData);
      return response.data;
    } catch (e) {
      throw Exception('Failed to create service: $e');
    }
  }

  Future<dynamic> updateService(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/services/$id', data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to update service: $e');
    }
  }

  Future<void> deleteService(String id) async {
    try {
      await _dio.delete('/services/$id');
    } catch (e) {
      throw Exception('Failed to delete service: $e');
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
  
  Future<dynamic> createTeamMember(Map<String, dynamic> memberData) async {
    try {
      final response = await _dio.post('/team', data: memberData);
      return response.data;
    } catch (e) {
      throw Exception('Failed to add team member: $e');
    }
  }

  Future<dynamic> updateTeamMember(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/team/$id', data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to update team member: $e');
    }
  }

  Future<void> deleteTeamMember(String id) async {
    try {
      await _dio.delete('/team/$id');
    } catch (e) {
      throw Exception('Failed to delete team member: $e');
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
  
  Future<dynamic> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _dio.post('/products', data: productData);
      return response.data;
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<dynamic> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/products/$id', data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _dio.delete('/products/$id');
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // --- Blog ---
  Future<List<dynamic>> getBlogs() async {
    try {
      final response = await _dio.get('/blog');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load blogs: $e');
    }
  }

  Future<dynamic> createBlog(Map<String, dynamic> blogData) async {
    try {
      final response = await _dio.post('/blog', data: blogData);
      return response.data;
    } catch (e) {
      throw Exception('Failed to add blog: $e');
    }
  }

  Future<dynamic> updateBlog(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/blog/$id', data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to update blog: $e');
    }
  }

  Future<void> deleteBlog(String id) async {
    try {
      await _dio.delete('/blog/$id');
    } catch (e) {
      throw Exception('Failed to delete blog: $e');
    }
  }

  // --- Settings ---
  Future<dynamic> getSettings() async {
    try {
      final response = await _dio.get('/settings');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load settings: $e');
    }
  }

  Future<dynamic> updateSettings(Map<String, dynamic> settingsData) async {
    try {
      final response = await _dio.put('/settings', data: settingsData);
      return response.data;
    } catch (e) {
      throw Exception('Failed to update settings: $e');
    }
  }

  // --- Dashboard ---
  Future<dynamic> getDashboardStats() async {
    try {
      final response = await _dio.get('/dashboard/stats');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load dashboard stats: $e');
    }
  }

  // --- Media ---
  Future<List<dynamic>> getMedia() async {
    try {
      final response = await _dio.get('/media');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load media: $e');
    }
  }

  Future<dynamic> createMedia(Map<String, dynamic> mediaData) async {
    try {
      final response = await _dio.post('/media', data: mediaData);
      return response.data;
    } catch (e) {
      throw Exception('Failed to add media: $e');
    }
  }

  Future<void> deleteMedia(String id) async {
    try {
      await _dio.delete('/media/$id');
    } catch (e) {
      throw Exception('Failed to delete media: $e');
    }
  }

  Future<void> seedMedia() async {
    try {
      await _dio.post('/media/seed');
    } catch (e) {
      throw Exception('Failed to seed media: $e');
    }
  }

  // --- Page Content ---
  Future<Map<String, dynamic>> getPageContent(String pageName) async {
    try {
      final response = await _dio.get('/page-content/$pageName');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load page content: $e');
    }
  }

  Future<void> updatePageContent(String pageName, Map<String, dynamic> content) async {
    try {
      await _dio.post('/page-content/$pageName', data: {'content': content});
    } catch (e) {
      throw Exception('Failed to update page content: $e');
    }
  }

  // --- Leads ---
  Future<List<dynamic>> getLeads() async {
    try {
      final response = await _dio.get('/leads');
      return response.data;
    } catch (e) {
      throw Exception('Failed to load leads: $e');
    }
  }

  Future<void> updateLeadStatus(String id, String status) async {
    try {
      await _dio.put('/leads/$id', data: {'status': status});
    } catch (e) {
      throw Exception('Failed to update lead status: $e');
    }
  }

  Future<void> deleteLead(String id) async {
    try {
      await _dio.delete('/leads/$id');
    } catch (e) {
      throw Exception('Failed to delete lead: $e');
    }
  }

  // --- About Sections ---
  Future<List<Map<String, dynamic>>> getAboutSections() async {
    try {
      final response = await _dio.get('/about-sections');
      return (response.data as List).map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> createAboutSection(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/about-sections', data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to create section: $e');
    }
  }

  Future<dynamic> updateAboutSection(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/about-sections/$id', data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to update section: $e');
    }
  }

  Future<void> deleteAboutSection(String id) async {
    try {
      await _dio.delete('/about-sections/$id');
    } catch (e) {
      throw Exception('Failed to delete section: $e');
    }
  }

  Future<void> seedAboutSections() async {
    try {
      await _dio.post('/about-sections/seed');
    } catch (e) {
      throw Exception('Failed to seed about sections: $e');
    }
  }

  // --- Franchise Types ---
  Future<List<Map<String, dynamic>>> getFranchiseTypes() async {
    try {
      final response = await _dio.get('/franchise-types');
      return (response.data as List).map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> createFranchiseType(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/franchise-types', data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to create franchise type: $e');
    }
  }

  Future<dynamic> updateFranchiseType(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/franchise-types/$id', data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to update franchise type: $e');
    }
  }

  Future<void> deleteFranchiseType(String id) async {
    try {
      await _dio.delete('/franchise-types/$id');
    } catch (e) {
      throw Exception('Failed to delete franchise type: $e');
    }
  }

  Future<void> seedFranchiseTypes() async {
    try {
      await _dio.post('/franchise-types/seed');
    } catch (e) {
      throw Exception('Failed to seed franchise types: $e');
    }
  }

  // --- CKD Features ---
  Future<List<Map<String, dynamic>>> getCKDFeatures() async {
    try {
      final response = await _dio.get('/ckd-features');
      return (response.data as List).map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> createCKDFeature(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/ckd-features', data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to create feature: $e');
    }
  }

  Future<dynamic> updateCKDFeature(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/ckd-features/$id', data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to update feature: $e');
    }
  }

  Future<void> deleteCKDFeature(String id) async {
    try {
      await _dio.delete('/ckd-features/$id');
    } catch (e) {
      throw Exception('Failed to delete feature: $e');
    }
  }

  Future<void> seedCKDFeatures() async {
    try {
      await _dio.post('/ckd-features/seed');
    } catch (e) {
      throw Exception('Failed to seed CKD features: $e');
    }
  }
}
