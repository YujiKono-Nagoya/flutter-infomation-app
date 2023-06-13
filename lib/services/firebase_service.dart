import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  //全部
  Stream<QuerySnapshot> getInfomationsStream() {
    return _firestore.collection('infomations').orderBy('date').snapshots();
  }

  //年齢昇順
  Stream<QuerySnapshot> getAgeInfomationsStream() {
    return _firestore
        .collection('infomations')
        .orderBy('age', descending: false)
        .snapshots();
  }

  //年齢降順
  Stream<QuerySnapshot> getAgeDescendingInfomationsStream() {
    return _firestore
        .collection('infomations')
        .orderBy('age', descending: true)
        .snapshots();
  }

  //犬のみ
  Stream<QuerySnapshot> getDogInfomationsStream() {
    return _firestore
        .collection('infomations')
        .where('animal', isEqualTo: '犬')
        .snapshots();
  }

  //猫のみ
  Stream<QuerySnapshot> getCatInfomationsStream() {
    return _firestore
        .collection('infomations')
        .where('animal', isEqualTo: '猫')
        .snapshots();
  }

  Future<void> addInfomation(Map<String, dynamic> infomations) async {
    await _firestore.collection('infomations').add(infomations);
  }
}
