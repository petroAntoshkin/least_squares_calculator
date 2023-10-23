import 'dart:io';
import 'package:flutter/material.dart';
import 'package:least_squares_calculator/elements/subscribed_icon_button.dart';
import 'package:least_squares_calculator/mocks/my_translations.dart';
import 'package:least_squares_calculator/models/image_pare.dart';
import 'package:least_squares_calculator/providers/data_provider.dart';
import 'package:least_squares_calculator/styles_and_presets.dart';

// import 'package:wc_flutter_share/wc_flutter_share.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';

class ImagesPage extends StatefulWidget {
  @override
  _ImagesPageState createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  late ThemeData _themeData;
  late List<ImagePair> _imageList;
  String _lang = 'en';
  final imageSize = 100.0;

  // StringBuffer _bufer = StringBuffer();

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   Provider.of<DataProvider>(context, listen: false)
  //       .setContextFunction(2, _deleteImage);
  // }

  @override
  Widget build(BuildContext context) {
    _imageList = [];
    _themeData = Provider.of<DataProvider>(context).theme;
    _lang = Provider.of<DataProvider>(context).getLanguage();
    for (int i = 0;
        i < Provider.of<DataProvider>(context).getImagesLength();
        i++) {
      _imageList.add(Provider.of<DataProvider>(context).getImage(i));
    }
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: _imageList.length > 0
          ? ListView.separated(
              itemCount: _imageList.length,
              itemBuilder: itemBuilder,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
            )
          : Center(
              child: Text(
                MyTranslations().getLocale(_lang, 'no_images'),
                style: TextStyle(
                  color: _themeData.indicatorColor,
                ),
              ),
            ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    var _imageFile = _imageList[index].path.split('/').last;
    return Card(
      color: _themeData.primaryColorLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            graphButton(
              iconData: Icons.delete_outline,
              function: () => _deleteImage(index),
            ),
            SizedBox(
              width: imageSize,
              height: imageSize,
              child: GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.file(File(_imageList[index].path)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(_imageFile.split('.png')[0]),
                              ),
                              _imageList[index].haveData
                                  ? OutlinedButton(
                                      onPressed: () {
                                        Provider.of<DataProvider>(context,
                                                listen: false)
                                            .readSavedData(
                                                fileName: _imageFile);
                                        Navigator.pop(context);
                                      },
                                      child: Text(MyTranslations().getLocale(
                                          Provider.of<DataProvider>(context,
                                                  listen: false)
                                              .getLanguage(),
                                          'load')),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  },
                ),
                child: Image.file(File(_imageList[index].path)),
              ),
            ),
            graphButton(
              iconData: Icons.share,
              function: () => _shareImage(_imageList[index].path),
            ),
          ],
        ),
      ),
    );
  }

  Widget graphButton({required IconData iconData, required void Function()? function}) {
    const buttonSize = 48.0;
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: GestureDetector(
        onTap: function,
        child: Container(
          decoration: BoxDecoration(
            color: _themeData.primaryColor,
            borderRadius: Presets.defaultBorderRadius,
          ),
          child: Icon(
            iconData,
          ),
        ),
      ),
    );
  }

  void _deleteImage(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
          title: Text(
            MyTranslations().getLocale(
                Provider.of<DataProvider>(context, listen: false).getLanguage(),
                'delete_image'),
            textAlign: TextAlign.center,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                MyTranslations().getLocale(
                    Provider.of<DataProvider>(context, listen: false)
                        .getLanguage(),
                    'del_approve'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context),
                    child: SubscribedIconButton(
                      text: MyTranslations().getLocale(
                          Provider.of<DataProvider>(context, listen: false)
                              .getLanguage(),
                          'cancel'),
                      iconData: Icons.cancel_outlined,
                      iconColor: Colors.grey,
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Provider.of<DataProvider>(context, listen: false)
                          .deleteImage(index);
                      Navigator.pop(context);
                    },
                    child: SubscribedIconButton(
                      text: MyTranslations().getLocale(
                          Provider.of<DataProvider>(context, listen: false)
                              .getLanguage(),
                          'delete'),
                      iconData: Icons.delete,
                      iconColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _shareImage(String filePath) async {
    try {
      // final bytes = await File(filePath).readAsBytes();
      // final files = <XFile>[];
      // await WcFlutterShare.share(
      //     sharePopupTitle: 'share',
      //     fileName: 'share.png',
      //     mimeType: 'image/png',
      //     bytesOfFile: bytes,
      // );
      await Share.shareFiles([filePath]);
    } catch (e) {
      debugPrint('error: $e');
    }
  }
}
