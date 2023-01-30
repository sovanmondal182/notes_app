import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc) {
  return Dismissible(
    direction: DismissDirection.horizontal,
    onDismissed: (direction) async {
      await FirebaseFirestore.instance
          .collection('Notes')
          .doc(doc.id)
          .delete()
          .then((value) => debugPrint("Notes Deleted"));
    },
    key: Key(doc.id),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(
            Random().nextInt(255),
            Random().nextInt(255),
            Random().nextInt(255),
            1,
          ).withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (doc["notes_title"] != "")
                    ? Text(
                        doc["notes_title"],
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      )
                    : Container(
                        height: 0,
                      ),
                (doc["notes_title"] != "")
                    ? const SizedBox(height: 5)
                    : Container(height: 0),
                (doc["notes_des"] != "")
                    ? Text(
                        doc["notes_des"],
                        style: const TextStyle(
                            fontSize: 16, overflow: TextOverflow.ellipsis),
                        maxLines: 5,
                      )
                    : Container(height: 0),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              doc["notes_pubDate"],
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    ),
  );
}
