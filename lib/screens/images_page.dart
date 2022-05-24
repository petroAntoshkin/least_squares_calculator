import 'dart:io';
import 'package:flutter/material.dart';
import 'package:least_squares/elements/subscribed_icon_button.dart';
import 'package:least_squares/mocks/my_translations.dart';
import 'package:least_squares/models/image_pare.dart';
import 'package:least_squares/providers/data_provider.dart';

// import 'package:material_dialogs/material_dialogs.dart';
// import 'package:material_dialogs/widgets/buttons/icon_button.dart';
// import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:provider/provider.dart';

class ImagesPage extends StatefulWidget {
  @override
  _ImagesPageState createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  ThemeData _themeData;
  List<ImagePair> _imageList;
  String _lang = 'en';

  // StringBuffer _bufer = StringBuffer();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<DataProvider>(context, listen: false)
        .setContextFunction(2, _deleteImages);
  }

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
      child: _imageList.length > 0
          ? ListView.builder(
              itemCount: _imageList.length,
              itemBuilder: itemBuilder,
            )
          : Center(
              child: Text(
                MyTranslations().getLocale(_lang, 'no_images'),
                style: TextStyle(
                  color: _themeData.primaryTextTheme.bodyText1.color,
                ),
              ),
            ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    var _imageFile = _imageList[index].path.split('/').last;
    return Card(
      color: _themeData.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 40.0,
            height: 40.0,
            child: Checkbox(
              activeColor: _themeData.primaryColorDark,
              checkColor: _themeData.colorScheme.secondary,
              value: _imageList[index].selected,
              onChanged: (bool value) {
                _changeCheckbox(index, value);
              },
            ),
          ),
          SizedBox(
            width: 100.0,
            height: 100.0,
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
                                          .readSavedData(fileName: _imageFile);
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
          SizedBox(
            width: 100.0,
            height: 100.0,
            // ignore: deprecated_member_use
            child: FlatButton(
              // onPressed: () => _bufer.write(_imageList[index].path),
              onPressed: () {
                _shareImage(_imageList[index].path);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Icon(
                      Icons.share,
                      color: _themeData.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeCheckbox(int index, bool value) {
    // print('tap on ckeckbox $value selectedAny=$_selectedAny');
    Provider.of<DataProvider>(context, listen: false)
        .setImageSelection(index, value);
  }

  void _deleteImages() {
    if (Provider.of<DataProvider>(context, listen: false)
        .isSomeImageSelected()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
            title: Text(
              MyTranslations().getLocale(
                  Provider.of<DataProvider>(context, listen: false)
                      .getLanguage(),
                  'reset'),
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
                            .deleteImages();
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(MyTranslations().getLocale(
                Provider.of<DataProvider>(context, listen: false).getLanguage(),
                'no_selected_images')),
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
              ),
            ],
          );
        },
      );
      // Dialogs.bottomMaterialDialog(
      //   msg: MyTranslations().getLocale(
      //       Provider.of<DataProvider>(context, listen: false).getLanguage(),
      //       'no_selected_images'),
      //   // title: MyTranslations().getLocale(
      //   //     Provider.of<DataProvider>(context, listen: false).getLanguage(),
      //   //     'delete_image'),
      //   context: context,
      //   actions: [
      //     IconsButton(
      //       onPressed: () => Navigator.pop(context),
      //       text: '',
      //       iconData: Icons.check,
      //       // textStyle: TextStyle(color: Colors.grey),
      //       iconColor: Colors.green,
      //     ),
      //   ],
      // );
    }
  }

  void _shareImage(String filePath) async {
    try {
      final bytes = await File(filePath).readAsBytes();
      // final byteData = bytes.buffer.asByteData();
      // final ByteData bytes = await  as ByteData;
      await WcFlutterShare.share(
          sharePopupTitle: 'share',
          fileName: 'share.png',
          mimeType: 'image/png',
          bytesOfFile: bytes);
    } catch (e) {
      debugPrint('error: $e');
    }
  }
}
