import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:giphy_picker/src/model/giphy_repository.dart';
import 'package:giphy_picker/src/utils/debouncer.dart';
import 'package:giphy_picker/src/widgets/giphy_context.dart';
import 'package:giphy_picker/src/widgets/giphy_thumbnail_grid.dart';
import 'package:giphy_picker/src/widgets/logo.dart';

/// Provides the UI for searching Giphy gif images.
class GiphySearchView extends StatefulWidget {

  Color color;
  Color backgroundColor;
  Brightness brightness;

  GiphySearchView({this.color,this.brightness,this.backgroundColor});

  @override
  _GiphySearchViewState createState() => _GiphySearchViewState();
}

class _GiphySearchViewState extends State<GiphySearchView> {

  bool isSearchIcon = true;
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _repoController = StreamController<GiphyRepository>();
  var giphy;
  FocusNode myFocusNode;

  @override
  void initState() {
    // initiate search on next frame (we need context)
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final giphy = GiphyContext.of(context);
      _debouncer = Debouncer(
        delay: giphy.searchDelay,
      );
      _search(giphy);
    });
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _repoController.close();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    giphy = GiphyContext.of(context);

    return Scaffold(
        appBar: buildBar(context,widget.brightness,widget.backgroundColor),
        body: SafeArea(child: Column(children: <Widget>[
          Expanded(
              child: StreamBuilder(
                  stream: _repoController.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<GiphyRepository> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data.totalCount > 0
                          ? NotificationListener(
                        child: RefreshIndicator(
                            child: GiphyThumbnailGrid(
                              brightness: widget.brightness,
                                backgroundColor: widget.backgroundColor,
                                key: Key('${snapshot.data.hashCode}'),
                                repo: snapshot.data,
                                scrollController: _scrollController),
                            onRefresh: () =>
                                _search(giphy, term: _textController.text)),
                        onNotification: (n) {
                          // hide keyboard when scrolling
                          if (n is UserScrollNotification) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            return true;
                          }
                          return false;
                        },
                      )
                          : Center(child: Text('No results'));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('An error occurred'));
                    }
                    return Center(child: CircularProgressIndicator());
                  }))
        ]), bottom: false));

  }

  void _delayedSearch(GiphyContext giphy, String term) =>
      _debouncer.call(() => _search(giphy, term: term));

  Future _search(GiphyContext giphy, {String term = ''}) async {
    // skip search if term does not match current search text
    if (term != _textController.text) {
      return;
    }

    try {
      // search, or trending when term is empty
      final repo = await (term.isEmpty
          ? GiphyRepository.trending(
              apiKey: giphy.apiKey,
              rating: giphy.rating,
              sticker: giphy.sticker,
              previewType: giphy.previewType,
              onError: giphy.onError)
          : GiphyRepository.search(
              apiKey: giphy.apiKey,
              query: term,
              rating: giphy.rating,
              lang: giphy.language,
              sticker: giphy.sticker,
              previewType: giphy.previewType,
              onError: giphy.onError,
            ));

      // scroll up
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      if (mounted) {
        _repoController.add(repo);
      }
    } catch (error) {
      if (mounted) {
        _repoController.addError(error);
      }
      giphy.onError?.call(error);
    }
  }

  Widget buildBar(BuildContext context, Brightness brightness, Color color) {

    giphy = GiphyContext.of(context);
    return new AppBar(
      brightness: brightness,
      backgroundColor: widget.backgroundColor,
      leading: !Platform.isIOS
          ? IconButton(
        onPressed: () => Navigator.pop(context, false),
        icon: Icon(
          const IconData(
            0xe900,
            fontFamily: 'backarrow',
          ),
          size: 20.0,
        ),
        color: brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
      )
          : RotatedBox(
        quarterTurns: 2,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          onTap: () => Navigator.pop(context, false),
          child: Padding(
            padding: EdgeInsets.all(17),
            child: SvgPicture.asset(
              "assets/svg/next.svg",
              color: brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
      centerTitle: true,
      title: isSearchIcon
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Logo(width: 40,height: 40,padding: 0,color: widget.color,brightness: widget.brightness,)
        ],
      )
          : TextField(
        focusNode: myFocusNode,
        onChanged: (value) => _delayedSearch(giphy, value),
        controller: _textController,
        decoration:
        InputDecoration(border: InputBorder.none, hintText: "Search Gify"),
        autofocus: true,
        style: new TextStyle(fontSize: 18),
      ),
      actions: <Widget>[
        new IconButton(
          icon: isSearchIcon
              ? Icon(
            const IconData(0xe900, fontFamily: 'internationalsvg'),
            size: 20,
            color: brightness == Brightness.dark ? Colors.white : Colors.black,
          )
              : Icon(
            const IconData(
              0xe900,
              fontFamily: 'close',
            ),
            color: brightness == Brightness.dark ? Colors.white : Colors.black,
            size: 18,
          ),
          onPressed: () {
            _displayTextField();
          },
        ),
        // new IconButton(icon: new Icon(Icons.more), onPressed: _IsSearching ? _showDialog(context, _buildSearchList()) : _showDialog(context,_buildList()))
      ],
    );
  }

  void _displayTextField() {
    setState(() {
      if (isSearchIcon == true) {
        isSearchIcon = false;
        myFocusNode.requestFocus();
        //_handleSearchStart();
      } else {
        _handleSearchEnd();

      }
    });
  }

  void _handleSearchEnd() {
    setState(() {
      isSearchIcon = true;
      searchTextChange('');
    });
  }

  void searchTextChange(text) async {
        _textController.text = text;
        _delayedSearch(giphy, text);
  }
}
