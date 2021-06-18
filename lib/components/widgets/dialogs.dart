import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> customDialogs(context, title, content, navText, logout) {
  if (Platform.isIOS) {
    return showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                if (logout != false)
                  CupertinoDialogAction(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('cancel')),
                CupertinoDialogAction(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(navText))
                // ignore: deprecated_member_use
              ]);
        });
  }
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              if (logout != false)
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('cancel')),

              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(navText))
              // ignore: deprecated_member_use
            ]);
      });
}
