import 'package:cloud_bucket/viewmodels/intent_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final IntentModelProvider _viewModel = IntentModelProvider();

  UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('Upload Activity')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _viewModel.textController,
              onChanged: (val) {
                _viewModel.textController.text = val.toString();
              },
              decoration: const InputDecoration(labelText: 'Text for Upload'),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final permissionStatus = await Permission.storage.status;
                      if (permissionStatus.isDenied) {
                        // Here just ask for the permission for the first time
                        await Permission.storage.request();
                        // I noticed that sometimes popup won't show after user press deny
                        // so I do the check once again but now go straight to appSettings
                        if (permissionStatus.isDenied) {
                          await openAppSettings();
                        }
                      } else if (permissionStatus.isPermanentlyDenied) {
                        // Here open app settings for user to manually enable permission in case
                        // where permission was permanently denied
                        await openAppSettings();
                      } else {
                        await _viewModel.openFiles();
                        // print("files selection: $filesList");
                      }
                    },
                    child: const Text('Add Files'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      // _viewModel.uploadActivity();
                      _viewModel.uploadFiles();
                    },
                    child: const Text('Upload'),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            ListenableBuilder(
              listenable: _viewModel,
              builder: (innerContext, child) {
                if (!_viewModel.isTextOrFileFilled) {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _showToast(context));
                }
                return _viewModel.isLoading
                    ? _viewModel.isFileUpLoading
                        ? Expanded(
                            child: Column(
                              children: [
                                Text(
                                    'Uploading ${(_viewModel.progress).toStringAsFixed(2)} %'),
                                SizedBox(
                                  width: 100.0,
                                  height: 2.0,
                                  child: LinearProgressIndicator(
                                    value: _viewModel.progress,
                                    minHeight: 2.0,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Text('Uploading...')
                    : const Spacer();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext innerContext) {
    final scaffold = ScaffoldMessenger.of(innerContext);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Please add atleat 1 field.'),
        action: SnackBarAction(
            label: 'ok', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
