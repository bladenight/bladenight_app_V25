import 'dart:convert';

import 'package:archive/archive_io.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_io/io.dart';

import '../generated/l10n.dart';
import '../models/friend.dart';
import '../models/user_trackpoint.dart';
import '../pages/friends/widgets/edit_friend_dialog.dart';
import '../pages/friends/widgets/friends_action_sheet.dart';
import '../providers/friends_provider.dart';
import 'device_info_helper.dart';
import 'deviceid_helper.dart';
import 'logger.dart';
import 'notification/toast_notification.dart';
import 'preferences_helper.dart';

void exportData(BuildContext context) async {
  try {
    var res = await FlutterPlatformAlert.showCustomAlert(
        windowTitle: Localize.of(context).exportWarningTitle,
        text: Localize.of(context).exportWarning,
        positiveButtonTitle: Localize.of(context).export,
        negativeButtonTitle: Localize.of(context).cancel);
    if (res == CustomButton.negativeButton) {
      return;
    }
    var deviceID = await DeviceId.getId;
    var friends = await PreferencesHelper.getFriendsFromPrefs();
    String exportdata =
        'id=$deviceID&fri=${MapperContainer.globals.toJson(friends)}';
    var bytes = utf8.encode(exportdata);
    var text = 'bna://bladenight.app?data=${base64.encode(bytes)}';
    await Share.share(text);
    Fluttertoast.showToast(
        msg: '${Localize.current.export} ${Localize.current.ok}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.activeGreen,
        textColor: CupertinoColors.black);
  } catch (e) {
    Fluttertoast.showToast(
        msg: '${Localize.current.export} ${Localize.current.failed}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.systemRed,
        textColor: CupertinoColors.black);
    BnLog.error(methodName: 'exportData', text: 'failed to export $e');
  }
}

void importData(String dataString) async {
  try {
    var res = await FlutterPlatformAlert.showCustomAlert(
        windowTitle: Localize.current.importWarningTitle,
        text: Localize.current.importWarning,
        positiveButtonTitle: Localize.current.import,
        negativeButtonTitle: Localize.current.cancel);
    if (res == CustomButton.negativeButton) {
      return;
    }

    const String dataId = 'data=';
    var dataPartIdx = dataString.indexOf(dataId);
    if (dataPartIdx == -1) return;
    var base64dataString =
        dataString.substring(dataPartIdx + dataId.length, dataString.length);
    var base64Decoded = utf8.decode(base64.decode(base64dataString));
    var dataParts = base64Decoded.split('&');
    var id = dataParts[0].substring(3);
    DeviceId.saveDeviceIdToPrefs(id);
    var friendJson = dataParts[1].substring(4);
    var friends = MapperContainer.globals.fromJson<List<Friend>>(friendJson);
    await PreferencesHelper.saveFriendsToPrefsAsync(friends);
    ProviderContainer().refresh(friendsProvider);
    ProviderContainer().read(friendsLogicProvider).reloadFriends();
    showToast(
        message:
            '${Localize.current.import} ${Localize.current.ok} ${Localize.current.restartRequired}',
        backgroundColor: CupertinoColors.activeGreen,
        textColor: CupertinoColors.black);
  } catch (e) {
    BnLog.error(methodName: 'importData', text: 'failed to import $e');
    showToast(
        message: '${Localize.current.import} ${Localize.current.failed}',
        backgroundColor: CupertinoColors.systemRed,
        textColor: CupertinoColors.black);
  }
}

Future<bool> _checkFileExists(String path) {
  return File(path).exists();
}

Future<void> _deleteFile(String path) async {
  try {
    await File(path).delete();
  } catch (e) {
    BnLog.error(text: 'Error deleting file $path', exception: e);
  }
}

Future<Directory> _getTempDirectory() async {
  Directory appDocDir = await getApplicationCacheDirectory();
  Directory tempPath = Directory('${appDocDir.path}/logTempData');
  if (await tempPath.exists() == false) {
    await tempPath.create(recursive: true);
  }
  var list = tempPath.listSync();
  for (var item in list) {
    if (await FileSystemEntity.isFile(item.path)) {
      await _deleteFile(item.path);
    }
  }
  return tempPath;
}

Future<File> _createLogFile(String fileName) async {
  var tempDir = await _getTempDirectory();
  File file = File('${tempDir.path}/$fileName.txt');
  return await file.create();
}

Future<void> exportLogs() async {
  try {
    var fileContent =
        await BnLog.exportLogs().timeout(const Duration(seconds: 30));
    if (kIsWeb) {
      print(fileContent);
      showToast(message: 'siehe Console');
      return;
    }
    var fileName = '${DateTime.now().year}_'
        '${DateTime.now().month}_'
        '${DateTime.now().day}_'
        '${DateTime.now().hour}_'
        '${DateTime.now().minute}_'
        '${DateTime.now().second}_Bladenight';
    var logfile = await _createLogFile(fileName);
    var zipFilePath = '${logfile.path}.zip';
    var logfilePath = await logfile.writeAsString(fileContent, flush: true);

    var encoder = ZipFileEncoder();
    encoder.create(zipFilePath);
    await encoder.addFile(logfilePath);
    encoder.close();
    showToast(message: '${Localize.current.ok})');
    var aV = await DeviceHelper.getAppVersionsData();

    final Email email = Email(
      subject:
          'Supportanfrage Bladenight München App V${aV.version} build${aV.buildNumber} ',
      body: 'Folgendes Problem ist aufgetreten:\n'
          'Folgenden Vorschlag habe ich:\n\n'
          'Bitte löschen falls nicht gewünscht !\n\n'
          'Anbei auch die Logdaten der App (maximal 8 Tage alt). Diese können persönliche Standortdaten und Nutzerverhalten enthalten. Ich bin damit einverstanden die Daten für die Supportanfrage zu nutzen.',
      recipients: ['it@huth.app'],
      //cc: ['cc@example.com'],
      //bcc: ['bcc@example.com'],
      attachmentPaths: [zipFilePath],
      isHTML: true,
    );

    await FlutterEmailSender.send(email);

    /*Share.shareXFiles(
      [XFile(logfile.path)],
      subject:
          'Supportanfrage: an it@huth.app Bladenight München App ,V${aV.version} ,${aV.buildNumber} ',
      text: 'Folgendes Problem ist aufgetreten: ....',
    );*/
    //print('All logs exported to: \nPath: ${fileContent.toString()}');
  } catch (e) {
    showToast(message: 'Log export fail $e');
  }
}

String exportUserTracking(List<UserTrackPoint> userTrackPoints) {
  if (kIsWeb) return '';
  var trkPts =
      UserTrackPoints(userTrackPoints).toXML(); // jsonEncode(userTrackPoints);
  return trkPts;
}

Future<void> shareExportedTrackingData(String trkPts) async {
  try {
    var tempDir = await getTemporaryDirectory();
    final file = File(
        '${tempDir.path}/BladeNight${DateTime.now().millisecondsSinceEpoch}.gpx');
    var tempFile = await file.writeAsString(trkPts, flush: true);
    showToast(message: Localize.current.ok);
    Share.shareXFiles([XFile(tempFile.path)],
        subject: Localize.current.trackingPoints,
        text: Localize.current.trackPointsExporting);
    BnLog.info(
        text: 'TrackPoints exported to: \nPath: ${file.path.toString()}');
  } catch (e) {
    showToast(message: 'GPX export failed $e');
  }
}

void exportBgLocationLogs() async {
  bg.Logger.emailLog('it@huth.app').then((bool success) {
    showToast(message: Localize.current.ok);
  }).catchError((e) {
    showToast(message: 'Log export failed $e');
  });
}

Future<bool> addFriendWithCodeFromUrl(
    BuildContext context, String uriString) async {
  var dataStartIdx = uriString.indexOf('?');
  var datas = uriString.substring(dataStartIdx+1);
  if (datas.length<5) return false;
  var content = datas.split('&');
  //import code
  const String codeId = 'code=';
  var code = '';

  const String nameId = 'name=';
  var name = '';

  for (var part in content){
      if (part.contains(nameId)&& part.length>nameId.length)  {
        name= part.split('=')[1].trim();
      }
      if (part.contains(codeId)&& part.length>codeId.length)  {
        code= part.split('=')[1].trim();
      }
  }

  if (code.length < 6) {
    return false;
  }

  var intCode = int.tryParse(code);
  if (intCode == null) {
    showToast(
        message:
            '${Localize.of(context).invalidcode} $intCode ${Localize.of(context).received}',
        backgroundColor: Colors.redAccent,
        textColor: Colors.black);
    return false;
  }

  showToast(
      message: '${Localize.of(context).friend} $name Code $intCode ${Localize.of(context).received}',
      backgroundColor: Colors.green,
      textColor: Colors.black);

  EditFriendResult? result;
  if (context.mounted) {
    result = await EditFriendDialog.show(context,
        friend: Friend(
            name: name,
            friendId: await PreferencesHelper.getNewFriendId(),
            requestId: intCode,
            isActive: true),
        friendDialogAction: FriendsAction.addWithCode);
  }
  if (result != null) {
    ProviderContainer()
        .read(friendsLogicProvider)
        .addFriendWithCode(result.name, result.color, code);
  }
  return true;
}
