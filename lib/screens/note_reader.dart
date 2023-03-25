import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/screens/note_editor.dart';
import 'package:note_app/style/app_style.dart';

class NoteReader extends StatefulWidget {
  const NoteReader(this.doc, {super.key});
  final QueryDocumentSnapshot doc;
  @override
  State<NoteReader> createState() => _NoteReaderState();
}

class _NoteReaderState extends State<NoteReader> {
  @override
  Widget build(BuildContext context) {
    int colorId = widget.doc["color_id"];
    return Scaffold(
      backgroundColor: AppStyle.cardsColors[colorId],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColors[colorId],
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.doc["note_title"], style: AppStyle.mainTitle),
            const SizedBox(height: 4),
            Text(
                DateFormat.yMMMd()
                    .add_jm()
                    .format(widget.doc["creation_date"].toDate()),
                style: AppStyle.dateTitle),
            const SizedBox(height: 28),
            Text(
              widget.doc["note_content"],
              style: AppStyle.mainContent,
            )
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "edit",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NoteEditor(doc: widget.doc);
              }));
            },
            child: const Icon(Icons.edit),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: "delete",
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("Notes")
                  .doc(widget.doc.id)
                  .delete();
              Navigator.pop(context);
            },
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
