import 'package:flutter/material.dart';

class SnapshotHandler<T> extends StatelessWidget {
  final AsyncSnapshot<T> snapshot;
  final Widget Function(T data) onSuccess;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const SnapshotHandler({
    super.key,
    required this.snapshot,
    required this.onSuccess,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      // If loading, return a loading indicator (or a custom loading widget)
      return loadingWidget ?? Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      // If error, return error widget or a default error message
      return errorWidget ??
          Center(
            child: Text(
              '${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
    } else if (snapshot.hasData) {
      // If data is available, pass the data to the provided success callback
      return onSuccess(snapshot.data as T);
    } else {
      // In case snapshot has no data and no error
      return Center(child: Text('No data available'));
    }
  }
}
