import 'package:flutter/material.dart';

class ImageScrollView extends StatelessWidget {
  final List<String> imageUrls = [ '', '', '', '', ''];

  // void add(String url) {
  //   imageUrls.insert(0, element)
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 400,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for(var imageUrl in imageUrls)...{
                Expanded(
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: Colors.grey.shade400, width: 2),
                    ),
                    child: imageUrl != '' ? Image
                        .network(imageUrl, fit: BoxFit.fill,) : Center(
                      child: Icon(Icons.insert_photo_outlined),),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
              }

          ],
        ),
      ),
    );
  }
}
