import 'package:flutter/material.dart';

class DynamicField extends StatelessWidget {
  final int index;
  final TextEditingController subHeadingController;
  final TextEditingController subHeadingContentController;
  final VoidCallback onRemove; // Added onRemove callback

  const DynamicField({
    Key? key,
    required this.index,
    required this.subHeadingController,
    required this.subHeadingContentController,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'SubHeading ${index + 1}:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: onRemove, // Call onRemove callback when the remove button is pressed
            ),
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: subHeadingController,
          decoration: InputDecoration(
            hintText: 'Enter SubHeading ${index + 1}',
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffA42FC1)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffA42FC1)),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffA42FC1)),
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'SubHeading Content ${index + 1}:',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: subHeadingContentController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Enter SubHeading Content ${index + 1}',
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xffA42FC1)),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xffA42FC1)),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xffA42FC1)),
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}