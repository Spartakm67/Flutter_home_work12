// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class NotesService {
//   final _firestore = FirebaseFirestore.instance;
//
//   Stream<List<Map<String, dynamic>>> getNotes() {
//     return _firestore.collection('notes').snapshots().map(
//           (snapshot) => snapshot.docs.map(
//             (doc) {
//               final data = doc.data();
//               data['id'] = doc.id;
//               return data;
//             },
//           ).toList(),
//         );
//   }
//
//   Future<void> addNote(String content) async {
//     await _firestore.collection('notes').add(
//       {
//         'content': content,
//       },
//     );
//   }
//
//   Future<void> deleteNote(String id) async {
//     await _firestore.collection('notes').doc(id).delete();
//   }
// }
