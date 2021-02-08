import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_queries/src/models/course.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  //Set method can be used to update or add records,
  // when updating all existing data will be overwritten
  Future<void> setCourse(Course course) {
    _db.collection('courses').doc(course.courseId).set(course.toMap());
  }

  //Update just instructor field, merge into existing data
  Future<void> setCourseMerge(String courseId, String instructor) {
    var options = SetOptions(merge: true);
    _db
        .collection('courses')
        .doc(courseId)
        .set({'instructor': instructor}, options);
  }

  //Add course with default firebase id, then update record with id
  Future<void> addCourse(Course course) async {
    var documentRef = await _db.collection('courses').add(course.toMap());
    var createdId = documentRef.id;
    _db.collection('courses').doc(createdId).update(
      {'course_id': createdId},
    );
  }

  //Update entire course, any existing data will be merged
  Future<void> updateCourse(Course course) {
    _db.collection('courses').doc(course.courseId).update(course.toMap());
  }

  //Update just instructor field, merge into existing data
  Future<void> updateInstructor(String courseId, String instructor) {
    _db.collection('courses').doc(courseId).update(
      {'instructor': instructor},
    );
  }

  //Get all records from collection as Stream
  Stream<List<Course>> getAllStream() {
    return _db.collection('courses').snapshots().map((snapshot) => snapshot.docs
        .map((document) => Course.fromJson(document.data()))
        .toList());
  }

  //Get all records from collection as Future
  Future<List<Course>> getAllFuture() {
    return _db.collection('courses').get().then((snapshot) => snapshot.docs
        .map((document) => Course.fromJson(document.data()))
        .toList());
  }

  //Get one record from Id as Stream
  Stream<Course> getOneStream(String courseId) {
    return _db
        .collection('courses')
        .doc(courseId)
        .snapshots()
        .map((snapshot) => Course.fromJson(snapshot.data()));
  }

  //Get one record from Id as Future
  Future<Course> getOneFuture(String courseId) {
    return _db
        .collection('courses')
        .doc(courseId)
        .get()
        .then((snapshot) => Course.fromJson(snapshot.data()));
  }

  //Get all courses for instructor as Stream
  Stream<List<Course>> whereAsStream(String instructorName) {
    return _db
        .collection('courses')
        .where('instructor', isEqualTo: instructorName)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => Course.fromJson(document.data()))
            .toList());
  }

  //Get all courses for instructor as Future
  Future<List<Course>> whereAsFuture(String instructorName) {
    return _db
        .collection('courses')
        .where('instructor', isEqualTo: instructorName)
        .get()
        .then((snapshot) => snapshot.docs
            .map((document) => Course.fromJson(document.data()))
            .toList());
  }

  //Order all results by instructor
  Stream<List<Course>> orderByInstructor() {
    return _db
        .collection('courses')
        .orderBy('instructor', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => Course.fromJson(document.data()))
            .toList());
  }

  //Limit Results to parameter value
  Stream<List<Course>> limitResults(int limitBy) {
    return _db.collection('courses').limit(limitBy).snapshots().map(
        (snapshot) => snapshot.docs
            .map((document) => Course.fromJson(document.data()))
            .toList());
  }
}
