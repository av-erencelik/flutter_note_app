import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/style/app_style.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key, this.doc});
  final QueryDocumentSnapshot? doc;
  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  int colorId = Random().nextInt(AppStyle.cardsColors.length);
  String date = DateTime.now().toString();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _mainController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _titleController.text = widget.doc != null ? widget.doc!["note_title"] : "";
    _mainController.text =
        widget.doc != null ? widget.doc!["note_content"] : "";
    date = DateFormat.yMMMd().add_jm().format(Timestamp.now().toDate());
    colorId = widget.doc != null ? widget.doc!["color_id"] : colorId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardsColors[colorId],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColors[colorId],
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: const Text(
          "Add a new note",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Note Title',
            ),
            style: AppStyle.mainTitle,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(date, style: AppStyle.dateTitle),
          const SizedBox(
            height: 28,
          ),
          TextField(
            controller: _mainController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Note Content",
            ),
            style: AppStyle.mainContent,
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (widget.doc != null) {
            int count = 0;
            await FirebaseFirestore.instance
                .collection("Notes")
                .doc(widget.doc!.id)
                .update({
                  "note_title": _titleController.text,
                  "note_content": _mainController.text,
                  "color_id": colorId,
                  "creation_date": Timestamp.now()
                })
                .then((value) =>
                    Navigator.of(context).popUntil((route) => count++ >= 2))
                .catchError((error) => print("Failed to add note: $error"));
            return;
          }
          await FirebaseFirestore.instance
              .collection("Notes")
              .add({
                "note_title": _titleController.text,
                "note_content": _mainController.text,
                "color_id": colorId,
                "creation_date": Timestamp.now()
              })
              .then((value) => Navigator.pop(context))
              .catchError((error) => print("Failed to add note: $error"));
        },
        backgroundColor: AppStyle.accentColor,
        child: const Icon(Icons.save),
      ),
    );
  }
}
