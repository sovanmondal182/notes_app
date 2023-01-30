import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteAddScreen extends StatefulWidget {
  final QueryDocumentSnapshot? docs;
  const NoteAddScreen({super.key, this.docs});

  @override
  State<NoteAddScreen> createState() => _NoteAddScreenState();
}

class _NoteAddScreenState extends State<NoteAddScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  DateTime now = DateTime.now();
  Color scaffoldBackgroundColor = Color.fromRGBO(
    Random().nextInt(255),
    Random().nextInt(255),
    Random().nextInt(255),
    1,
  ).withOpacity(0.3);
  @override
  Widget build(BuildContext context) {
    titleController.text =
        (widget.docs != null) ? widget.docs!['notes_title'] ?? "" : "";
    desController.text =
        (widget.docs != null) ? widget.docs!['notes_des'] ?? "" : "";
    String pubDate = (widget.docs != null)
        ? widget.docs!['notes_pubDate'] ?? ""
        : DateFormat('dd MMM, yyyy hh:mm a').format(now);
    String pubDateNow = DateFormat('dd MMM, yyyy hh:mm a').format(now);

    return WillPopScope(
      onWillPop: () => onWillpop(pubDateNow, context, pubDate),
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            (widget.docs?.id != null)
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('Notes')
                          .doc(widget.docs!.id)
                          .delete();
                      Navigator.pop(context);
                    },
                  )
                : Container(
                    height: 0,
                  )
          ],
        ),
        body: Container(
          padding:
              const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 0),
          child: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              TextField(
                cursorColor: Colors.white,
                cursorWidth: 1,
                cursorHeight: 25,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                controller: titleController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade200,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: TextField(
                  cursorColor: Colors.white,
                  cursorWidth: 1,
                  cursorHeight: 20,
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  controller: desController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Note',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade200,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            pubDate,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillpop(
      String pubDateNow, BuildContext context, String pubDate) async {
    {
      if (widget.docs?.id != null) {
        if (titleController.text != widget.docs!["notes_title"] ||
            desController.text != widget.docs!["notes_des"]) {
          await FirebaseFirestore.instance
              .collection('Notes')
              .doc(widget.docs!.id)
              .update({
                'notes_title': titleController.text,
                'notes_des': desController.text,
                'notes_pubDate': pubDateNow,
              })
              .then((value) => debugPrint("Notes Updated"))
              .catchError((error) =>
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(error.toString()),
                  )));
        }
        if (titleController.text == "" && desController.text == "") {
          await FirebaseFirestore.instance
              .collection('Notes')
              .doc(widget.docs!.id)
              .delete()
              .then((value) => debugPrint("Notes Deleted"))
              .catchError((error) =>
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(error.toString()),
                  )));
        }
        if (titleController.text == widget.docs!["notes_title"] ||
            desController.text == widget.docs!["notes_des"]) {
          return true;
        }
      }

      if ((titleController.text != "" || desController.text != "") &&
          widget.docs?.id == null) {
        await FirebaseFirestore.instance
            .collection('Notes')
            .add({
              'notes_title': titleController.text,
              'notes_des': desController.text,
              'notes_pubDate': pubDate,
            })
            .then((value) => debugPrint("Notes Added"))
            .catchError(
                (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(error.toString()),
                    )));
      }
      return true;
    }
  }
}
