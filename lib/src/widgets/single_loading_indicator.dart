import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SingleLoadingIndicator extends StatelessWidget {

  EdgeInsets padding ;
  Color color;
  SingleLoadingIndicator({required this.padding,required this.color });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Container(
          margin: EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: padding,
                child: SizedBox(
                  height: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      color: color,
                      backgroundColor: Colors.black12,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
