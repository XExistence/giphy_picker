import 'package:flutter/material.dart';
import 'package:giphy_picker/src/model/giphy_repository.dart';
import 'package:giphy_picker/src/widgets/giphy_context.dart';
import 'package:giphy_picker/src/widgets/giphy_preview_page.dart';
import 'package:giphy_picker/src/widgets/giphy_thumbnail.dart';

/// A selectable grid view of gif thumbnails.
class GiphyThumbnailGrid extends StatelessWidget {
  final GiphyRepository repo;
  final ScrollController? scrollController;
  final Color backgroundColor;
  final Brightness brightness;
  final Color color;

  const GiphyThumbnailGrid(
      {Key? key, @required required this.repo, this.scrollController, required this.backgroundColor, required this.brightness,required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.all(1),
        controller: scrollController,
        itemCount: repo.totalCount,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
            child: GiphyThumbnail(key: Key('$index'), repo: repo, index: index,color: color,backgroundColor: backgroundColor,),
            onTap: () async {
              // display preview page
              final giphy = GiphyContext.of(context);
              final gif = await repo.get(index);
              if (giphy.showPreviewPage) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => GiphyPreviewPage(
                      title: Text(""),
                      gif: gif,
                      onSelected: giphy.onSelected,
                      backgroundColor: backgroundColor,
                      color: color,
                      brightness: brightness,
                    ),
                  ),
                );
              } else {
                giphy.onSelected?.call(gif);
              }
            }),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 2
                    : 3,
            childAspectRatio: 1,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1));
  }
}
