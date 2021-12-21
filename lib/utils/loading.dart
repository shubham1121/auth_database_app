import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  bool showStatus = false;
  Loading(this.showStatus);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: showStatus
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SpinKitWave(
                  color: Colors.indigo,
                  size: 50.0,
                ),
                Text('Upload In Progress!'),
              ],
            )
          : const Center(
              child: SpinKitWave(
                color: Colors.indigo,
                size: 50.0,
              ),
            ),
    );
  }
}
