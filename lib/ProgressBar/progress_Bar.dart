import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProgressBarHUD extends StatelessWidget {
  final Color? backGroundColor;

  const ProgressBarHUD({Key? key, this.backGroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: ModalBarrier(
              dismissible: false,
              color: backGroundColor ?? Colors.grey,
            ),
          ),
          Center(
            child: SpinKitThreeBounce(color: const Color(0xff098EDD), size: 50),
          ),
        ],
      ),
    );
  }
}
