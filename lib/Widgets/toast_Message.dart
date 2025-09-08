import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

showToast(String error) {
  BotToast.showText(
    text: error,
    contentColor: Color(0xff098EDD),
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    align: const Alignment(0, 0.1),
    backButtonBehavior: BackButtonBehavior.none,
    backgroundColor: Colors.transparent,
    textStyle: const TextStyle(fontSize: 18, color: Colors.white),
  );
}

showToastNew(String error) {
  BotToast.showText(
    text: error,
    contentColor: Colors.grey.shade600,
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    align: const Alignment(0, 0.1),
    backButtonBehavior: BackButtonBehavior.none,
    backgroundColor: Colors.transparent,
    textStyle: const TextStyle(fontSize: 18, color: Colors.white),
  );
}
