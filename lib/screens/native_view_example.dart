
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeViewExample extends StatefulWidget {

  @override
  _NativeViewExampleState createState() => _NativeViewExampleState();
}

class _NativeViewExampleState extends State<NativeViewExample>  with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    final String viewType = '<platform-view-type>';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }



}
