import 'package:flutter/material.dart';
import 'package:xinlake_platform/xinlake_platform.dart';
import 'package:xinlake_qrcode/xinlake_qrcode.dart';

class DecodeImageDemo extends StatefulWidget {
  const DecodeImageDemo({Key? key}) : super(key: key);

  @override
  State<DecodeImageDemo> createState() => _DecodeImageState();
}

class _DecodeImageState extends State<DecodeImageDemo> {
  List<String>? _imageList;

  // result
  List<String>? _codeList;

  void _pickImages() async {
    final images = await XinlakePlatform.pickFiles(
      multiSelection: true,
      mimeType: "image/*",
      cacheDir: AndroidAppDir.externalFiles,
      filterName: "JPEG, PNG Images",
      filterPattern: "*.jpg; *.jpeg; *.png",
    );

    if (images != null && images.isNotEmpty) {
      // valid selection
      setState(() {
        _imageList = images;
      });
    }
  }

  void _readImage() async {
    final codeList = await XinlakeQrcode.fromImage(_imageList);
    setState(() => _codeList = codeList);
  }

  Widget _buildFromImage() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _pickImages,
              child: const Text("Pick Images"),
            ),
            _imageList != null
                ? _imageList!.isNotEmpty
                    ? Column(
                        children: List<Widget>.generate(
                          _imageList!.length,
                          (index) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${index + 1}"),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(_imageList![index]),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const Text("EMPTY", textAlign: TextAlign.center)
                : const Text("NULL", textAlign: TextAlign.center),
            const Divider(height: 10),
            ElevatedButton(
              onPressed: _imageList != null ? _readImage : null,
              child: const Text("Read Images"),
            ),
            _codeList != null
                ? _codeList!.isNotEmpty
                    ? Column(
                        children: List<Widget>.generate(
                          _codeList!.length,
                          (index) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${index + 1}"),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(_codeList![index]),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const Text("EMPTY", textAlign: TextAlign.center)
                : const Text("NULL", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: _buildFromImage(),
    );
  }
}
