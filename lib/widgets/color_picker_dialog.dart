import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color tempColor;

  const ColorPickerDialog({super.key, required this.tempColor});

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color tempColor;

  @override
  void initState() {
    tempColor = widget.tempColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: const Text('Choose Color'),
      content: SingleChildScrollView(
        child: ColorPicker(
          color: tempColor,
          enableShadesSelection: false,
          enableOpacity: false,
          width: 44,
          height: 44,
          borderRadius: 22,
          showRecentColors: true,
          recentColors: const [
            Colors.black,
            Colors.white,
          ],
          maxRecentColors: 8,
          borderColor: Colors.black,
          hasBorder: true,
          onColorChanged: (Color color) {
            tempColor = color;
          },
          heading: Text(
            'Select color',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          subheading: Text(
            'Select color shade',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('ok'),
          onPressed: () {
            Get.back(result: tempColor);
          },
        ),
      ],
    );
  }
}
