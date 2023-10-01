import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:restart_app/restart_app.dart';

final _shorebirdCodePush = ShorebirdCodePush();

class ForceUpdate {
  ForceUpdate(this.context, this.mounted);
  BuildContext context;
  bool mounted;

  void _showRestartBanner() {
    // ScaffoldMessenger.of(context).showMaterialBanner(
    //   MaterialBanner(
    //     content: const Text('Update downloaded'),
    //     actions: [
    //       TextButton(
    //         onPressed: () async {
    //           ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    //           await Restart.restartApp();
    //         },
    //         child: const Text('Restart'),
    //       ),
    //     ],
    //   ),
    // );
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
              title: const Text('Restart'),
              content: const Text(
                  'Click on the button below to restart the app'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    await Restart.restartApp();
                    Navigator.pop(ctx);
                  
                  },
                  child: const Text('Restart'),
                ),
              ],
            ));
  }

  void checkAndForceUpdate() {
    _shorebirdCodePush.currentPatchNumber().then((currentPatchVersion) {
      if (!mounted) return;

      _checkForUpdate();
    });
  }

  Future<void> _checkForUpdate() async {
    // Ask the Shorebird servers if there is a new patch available.
    final isUpdateAvailable =
        await _shorebirdCodePush.isNewPatchAvailableForDownload();

    if (!mounted) return;

    if (isUpdateAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Update available'),
        ),
      );
      _showUpdateAvailableBanner();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No update available'),
        ),
      );
    }
  }

  void _showUpdateAvailableBanner() {
    // ScaffoldMessenger.of(context).showMaterialBanner(
    //   MaterialBanner(
    //     content: const Text('Update available'),
    //     actions: [
    //       TextButton(
    //         onPressed: () async {
    //           ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    //           await _downloadUpdate();

    //           if (!mounted) return;
    //           ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    //         },
    //         child: const Text('Download'),
    //       ),
    //     ],
    //   ),
    // );
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
              title: const Text('Update available'),
              content: const Text(
                  'Click on the button below to download the update'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await _downloadUpdate();
                  
                  },
                  child: const Text('Download'),
                ),
              ],
            ));
  }

  Future<void> _downloadUpdate() async {
    // _showDownloadingBanner();
    await _shorebirdCodePush.downloadUpdateIfAvailable();
    Fluttertoast.showToast(msg: "Update Downloaded");
    _showRestartBanner();
  }
}
