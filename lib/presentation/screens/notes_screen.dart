// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'package:flutter_home_work12/data/services/auth_service.dart';
// import 'package:flutter_home_work12/data/services/notes_service.dart';
//
// class NotesScreen extends StatelessWidget {
//   const NotesScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final notesService = NotesService();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Notes'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () =>
//                 Provider.of<AuthService>(context, listen: false).signOut(),
//           ),
//         ],
//       ),
//       body: StreamBuilder(
//         stream: notesService.getNotes(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final notes = snapshot.data ?? [];
//
//           return ListView.builder(
//             itemCount: notes.length,
//             itemBuilder: (context, index) {
//               final note = notes[index];
//               return ListTile(
//                 title: Text(note['content']),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.delete),
//                   onPressed: () => notesService.deleteNote(
//                     note['id'],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddNoteDialog(
//           context,
//         ),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
//
//   void _showAddNoteDialog(BuildContext context) {
//     final noteController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (contex) => AlertDialog(
//         title: const Text('Add Note'),
//         content: TextField(
//           controller: noteController,
//           decoration: const InputDecoration(labelText: 'Note'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(contex).pop(),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               NotesService().addNote(noteController.text);
//               Navigator.of(contex).pop();
//             },
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }
// }
