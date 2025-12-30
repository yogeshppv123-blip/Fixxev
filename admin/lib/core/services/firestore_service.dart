import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ============ PAGES CONTENT ============

  // Get page content
  Future<Map<String, dynamic>?> getPageContent(String pageName) async {
    try {
      final doc = await _db.collection('pages').doc(pageName).get();
      return doc.data();
    } catch (e) {
      print('Error getting page content: $e');
      return null;
    }
  }

  // Update page content
  Future<void> updatePageContent(String pageName, Map<String, dynamic> data) async {
    await _db.collection('pages').doc(pageName).set(data, SetOptions(merge: true));
  }

  // ============ BLOG POSTS ============

  // Get all blog posts
  Stream<QuerySnapshot> getBlogPosts() {
    return _db.collection('blog')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get single blog post
  Future<DocumentSnapshot> getBlogPost(String postId) {
    return _db.collection('blog').doc(postId).get();
  }

  // Create blog post
  Future<DocumentReference> createBlogPost(Map<String, dynamic> data) {
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();
    return _db.collection('blog').add(data);
  }

  // Update blog post
  Future<void> updateBlogPost(String postId, Map<String, dynamic> data) {
    data['updatedAt'] = FieldValue.serverTimestamp();
    return _db.collection('blog').doc(postId).update(data);
  }

  // Delete blog post
  Future<void> deleteBlogPost(String postId) {
    return _db.collection('blog').doc(postId).delete();
  }

  // ============ PRODUCTS ============

  // Get all products
  Stream<QuerySnapshot> getProducts() {
    return _db.collection('products').orderBy('order').snapshots();
  }

  // Create product
  Future<DocumentReference> createProduct(Map<String, dynamic> data) {
    data['createdAt'] = FieldValue.serverTimestamp();
    return _db.collection('products').add(data);
  }

  // Update product
  Future<void> updateProduct(String productId, Map<String, dynamic> data) {
    data['updatedAt'] = FieldValue.serverTimestamp();
    return _db.collection('products').doc(productId).update(data);
  }

  // Delete product
  Future<void> deleteProduct(String productId) {
    return _db.collection('products').doc(productId).delete();
  }

  // ============ LEADS ============

  // Get all leads
  Stream<QuerySnapshot> getLeads({String? type}) {
    Query query = _db.collection('leads').orderBy('createdAt', descending: true);
    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }
    return query.snapshots();
  }

  // Update lead status
  Future<void> updateLeadStatus(String leadId, String status) {
    return _db.collection('leads').doc(leadId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete lead
  Future<void> deleteLead(String leadId) {
    return _db.collection('leads').doc(leadId).delete();
  }

  // ============ SETTINGS ============

  // Get settings
  Future<Map<String, dynamic>?> getSettings() async {
    final doc = await _db.collection('settings').doc('general').get();
    return doc.data();
  }

  // Update settings
  Future<void> updateSettings(Map<String, dynamic> data) {
    return _db.collection('settings').doc('general').set(data, SetOptions(merge: true));
  }

  // ============ STATS ============

  // Get dashboard stats
  Future<Map<String, int>> getDashboardStats() async {
    final leadsCount = await _db.collection('leads').count().get();
    final blogCount = await _db.collection('blog').count().get();
    final productsCount = await _db.collection('products').count().get();

    return {
      'leads': leadsCount.count ?? 0,
      'blog': blogCount.count ?? 0,
      'products': productsCount.count ?? 0,
    };
  }
}
