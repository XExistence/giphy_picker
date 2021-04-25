import 'package:flutter/material.dart';
import 'package:giphy_picker/src/model/giphy_repository.dart';
import 'package:giphy_picker/src/widgets/giphy_context.dart';
import 'package:giphy_picker/src/widgets/giphy_preview_page.dart';
import 'package:giphy_picker/src/widgets/giphy_thumbnail.dart';

/// A selectable grid view of gif thumbnails.
class GiphyThumbnailGrid extends StatelessWidget {
  final GiphyRepository repo;
  final ScrollController scrollController;
  final Color backgroundColor;
  final Brightness brightness;

  const GiphyThumbnailGrid(
      {Key key, @required this.repo, this.scrollController,this.backgroundColor,this.brightness})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.all(1),
        controller: scrollController,
        itemCount: repo.totalCount,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
            child: GiphyThumbnail(key: Key('$index'), repo: repo, index: index),
            onTap: () async {
              // display preview page
              final giphy = GiphyContext.of(context);
              final gif = await repo.get(index);
              if (giphy.showPreviewPage) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => GiphyPreviewPage(
                      gif: gif,
                      onSelected: giphy.onSelected,
                      color: backgroundColor,
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
