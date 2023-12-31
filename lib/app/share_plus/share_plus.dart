import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_selector/file_selector.dart' hide XFile;
import 'package:image_picker/image_picker.dart' hide XFile;

class ShareInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShareInfoState();
  }
}

class _ShareInfoState extends State<ShareInfo> {
  String text = '';
  String uri = '';
  List<String> imageNames = [];
  List<String> imagePaths = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 32),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Share Text',
            hintText: 'Insira Texto ou Link para compartilhar',
          ),
          maxLines: null,
          onChanged: (String value) => setState(() {
            text = value;
          }),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Share uri',
            hintText: 'Insira uri para compartilhar',
          ),
          maxLines: null,
          onChanged: (String value) => setState(() {
            uri = value;
          }),
        ),
        const SizedBox(height: 16),
        // ImagePreviews(imagePaths, onDelete: _onDeleteImage),
        ElevatedButton.icon(
          label: const Text('Add image'),
          onPressed: () async {
            // Using `package:image_picker` to get image from gallery.

            final imagePicker = ImagePicker();
            final pickedFile = await imagePicker.pickImage(
              source: ImageSource.gallery,
            );
            if (pickedFile != null) {
              setState(() {
                imagePaths.add(pickedFile.path);
                imageNames.add(pickedFile.name);
              });
            }
          },
          icon: const Icon(Icons.add),
        ),
        Builder(builder: (BuildContext context) {
          return ElevatedButton(
            onPressed: text.isEmpty && imagePaths.isEmpty && uri.isEmpty
                ? null
                : () => _onShare(context),
            child: const Text('Compartilhar'),
          );
        }),
        const SizedBox(height: 16),
        Builder(builder: (BuildContext context) {
          return ElevatedButton(
            onPressed: text.isEmpty && imagePaths.isEmpty
                ? null
                : () => _onShareWithResult(context),
            child: const Text('Compartilhar com resultado'),
          );
        }),
        const SizedBox(height: 16),
        Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _onShareXFileFromAssets(context);
              },
              child: const Text('Share XFile from Assets'),
            );
          },
        ),
        const SizedBox(height: 16),
        Builder(builder: (BuildContext context) {
          return ElevatedButton(
            onPressed: () => _onRemoveAllImages(),
            child: const Text('remover imagens'),
          );
        }),
      ],
    );
  }

  void _onDeleteImage(int position) {
    setState(() {
      imagePaths.removeAt(position);
      imageNames.removeAt(position);
    });
  }

  void _onRemoveAllImages() {
    for (var i = imagePaths.length - 1; i >= 0; i--) {
      _onDeleteImage(i);
    }
  }

  void _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;

    if (uri.isNotEmpty) {
      await Share.shareUri(Uri.parse(uri));
    } else if (imagePaths.isNotEmpty) {
      final files = <XFile>[];
      for (var i = 0; i < imagePaths.length; i++) {
        files.add(XFile(imagePaths[i], name: imageNames[i]));
      }
      await Share.shareXFiles(files,
          text: text,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }

  void _onShareWithResult(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    ShareResult shareResult;
    if (imagePaths.isNotEmpty) {
      final files = <XFile>[];
      for (var i = 0; i < imagePaths.length; i++) {
        files.add(XFile(imagePaths[i], name: imageNames[i]));
      }
      shareResult = await Share.shareXFiles(files,
          text: text,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      shareResult = await Share.shareWithResult(text,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
    scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
  }

  void _onShareXFileFromAssets(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final data = await rootBundle.load('assets/flutter_logo.png');
    final buffer = data.buffer;
    final shareResult = await Share.shareXFiles(
      [
        XFile.fromData(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          name: 'flutter_logo.png',
          mimeType: 'image/png',
        ),
      ],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
  }

  SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }
}
