import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'scaled_tile.dart';
import 'search_bar_style.dart';

mixin ControllerListener<T> on State<AnimSearchBar2<T>> {
  void onListChanged(List<T> items) {}

  void onLoading() {}

  void onClear() {}

  void onError(Error error) {}
}

class SearchBarController<T> {
  final List<T> _list = [];
  final List<T> _filteredList = [];
  final List<T> _sortedList = [];
  late TextEditingController _searchQueryController;
  late String _lastSearchedText;
  late Future<List<T>> Function(String text) _lastSearchFunction;
  late ControllerListener<dynamic> _controllerListener;
  // late int? Function(T a, T b) _lastSorting;
  CancelableOperation<dynamic>? _cancelableOperation;
  late int minimumChars;

  void setTextController(
      TextEditingController searchQueryController, int minimumChars) {
    _searchQueryController = searchQueryController;
    this.minimumChars = minimumChars;
  }

  void setListener(ControllerListener<dynamic> _controllerListener) {
    this._controllerListener = _controllerListener;
  }

  void clear() {
    _controllerListener.onClear();
  }

  Future<void> _search(
      String text, Future<List<T>> Function(String text) onSearch) async {
    _controllerListener.onLoading();
    try {
      if (_cancelableOperation != null &&
          (!_cancelableOperation!.isCompleted ||
              !_cancelableOperation!.isCanceled)) {
        _cancelableOperation!.cancel();
      }
      _cancelableOperation = CancelableOperation<dynamic>.fromFuture(
        onSearch(text),
        onCancel: () => <void>{},
      );

      final List<T> items = await _cancelableOperation?.value as List<T>;
      _lastSearchFunction = onSearch;
      _lastSearchedText = text;
      _list.clear();
      _filteredList.clear();
      _sortedList.clear();
      // _lastSorting = null;
      _list.addAll(items);
      _controllerListener.onListChanged(_list);
    } catch (error) {
      // _controllerListener.onError(error);
    }
  }

  void injectSearch(
      String searchText, Future<List<T>> Function(String text) onSearch) {
    if (searchText.isNotEmpty && searchText.length >= minimumChars) {
      _searchQueryController.text = searchText;
      _search(searchText, onSearch);
    }
  }

  void replayLastSearch() {
    if (_lastSearchFunction != null && _lastSearchedText != null) {
      _search(_lastSearchedText, _lastSearchFunction);
    }
  }

  void removeFilter() {
    _filteredList.clear();
    _controllerListener.onListChanged(_list);
  }

  void removeSort() {
    _sortedList.clear();
    _controllerListener
        .onListChanged(_filteredList.isEmpty ? _list : _filteredList);
  }

  void sortList(int Function(T a, T b) sorting) {
    _sortedList.clear();
    _sortedList
        .addAll(List<T>.from(_filteredList.isEmpty ? _list : _filteredList));
    _sortedList.sort(sorting);
    _controllerListener.onListChanged(_sortedList);
  }

  void filterList(bool Function(T item) filter) {
    _filteredList.clear();
    _filteredList.addAll(_sortedList.isEmpty
        ? _list.where(filter).toList()
        : _sortedList.where(filter).toList());
    _controllerListener.onListChanged(_filteredList);
  }
}

/// Signature for a function that creates [ScaledTile] for a given index.
typedef IndexedScaledTileBuilder = ScaledTile Function(int index);

class AnimSearchBar2<T> extends StatefulWidget {
  const AnimSearchBar2({
    Key? key,

    /// The width cannot be null
    required this.width,

    /// The textController cannot be null
    // this.textController,
    this.suffixIcon,
    this.prefixIcon,
    this.helpText = 'Search...',

    /// choose your custom color
    this.color = Colors.white,

    /// The onSuffixTap cannot be null
    required this.onSuffixTap,
    this.animationDurationInMilli = 375,

    /// make the search bar to open from right to left
    this.rtl = false,

    /// make the keyboard to show automatically when the searchbar is expanded
    this.autoFocus = false,

    /// TextStyle of the contents inside the searchbar
    this.style,

    /// close the search on suffix tap
    this.closeSearchOnSuffixTap = false,

    /// can add list of inputformatters to control the input
    this.inputFormatters,
    required this.onSearch,
    required this.onItemFound,
    this.searchBarController,
    this.minimumChars = 3,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.loader = const Center(child: CircularProgressIndicator()),
    this.onError,
    this.emptyWidget = const SizedBox.shrink(),
    this.header,
    this.placeHolder,
    this.icon = const Icon(Icons.search),
    this.hintText = '',
    this.hintStyle = const TextStyle(color: Color.fromRGBO(142, 142, 147, 1)),
    this.iconActiveColor = Colors.black,
    this.textStyle = const TextStyle(color: Colors.black),
    this.cancellationWidget = const Text('Cancel'),
    this.onCancelled,
    this.suggestions = const [],
    this.buildSuggestion,
    this.searchBarStyle = const SearchBarStyle(),
    this.crossAxisCount = 1,
    this.shrinkWrap = false,
    this.indexedScaledTileBuilder,
    this.scrollDirection = Axis.vertical,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.listPadding = EdgeInsets.zero,
    this.searchBarPadding = EdgeInsets.zero,
    this.headerPadding = EdgeInsets.zero,
  }) : super(key: key);

  ///  width - double ,isRequired : Yes
  ///  textController - TextEditingController  ,isRequired : Yes
  ///  onSuffixTap - Function, isRequired : Yes
  ///  rtl - Boolean, isRequired : No
  ///  autoFocus - Boolean, isRequired : No
  ///  style - TextStyle, isRequired : No
  ///  closeSearchOnSuffixTap - bool , isRequired : No
  ///  suffixIcon - Icon ,isRequired :  No
  ///  prefixIcon - Icon  ,isRequired : No
  ///  animationDurationInMilli -  int ,isRequired : No
  ///  helpText - String ,isRequired :  No
  /// inputFormatters - TextInputFormatter, Required - No

  final double width;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final String helpText;
  final int animationDurationInMilli;
  final onSuffixTap;
  final bool rtl;
  final bool autoFocus;
  final TextStyle? style;
  final bool closeSearchOnSuffixTap;
  final Color? color;
  final List<TextInputFormatter>? inputFormatters;

  /// Future returning searched items
  final Future<List<T>> Function(String text) onSearch;

  /// List of items showed by default
  final List<T> suggestions;

  /// Callback returning the widget corresponding to a Suggestion item
  final Widget? Function(T item, int index)? buildSuggestion;

  /// Minimum number of chars required for a search
  final int minimumChars;

  /// Callback returning the widget corresponding to an item found
  final Widget Function(T item, int index) onItemFound;

  /// Callback returning the widget corresponding to an Error while searching
  final Widget? Function(Error error)? onError;

  /// Cooldown between each call to avoid too many
  final Duration debounceDuration;

  /// Widget to show when loading
  final Widget loader;

  /// Widget to show when no item were found
  final Widget emptyWidget;

  /// Widget to show by default
  final Widget? placeHolder;

  /// Widget showed on left of the search bar
  final Widget icon;

  /// Widget placed between the search bar and the results
  final Widget? header;

  /// Hint text of the search bar
  final String hintText;

  /// TextStyle of the hint text
  final TextStyle hintStyle;

  /// Color of the icon when search bar is active
  final Color iconActiveColor;

  /// Text style of the text in the search bar
  final TextStyle textStyle;

  /// Widget shown for cancellation
  final Widget cancellationWidget;

  /// Callback when cancel button is triggered
  final VoidCallback? onCancelled;

  /// Controller used to be able to sort, filter or replay the search
  final SearchBarController<dynamic>? searchBarController;

  /// Enable to edit the style of the search bar
  final SearchBarStyle searchBarStyle;

  /// Number of items displayed on cross axis
  final int crossAxisCount;

  /// Weather the list should take the minimum place or not
  final bool shrinkWrap;

  /// Called to get the tile at the specified index for the
  /// [SliverGridStaggeredTileLayout].
  final IndexedScaledTileBuilder? indexedScaledTileBuilder;

  /// Set the scrollDirection
  final Axis scrollDirection;

  /// Spacing between tiles on main axis
  final double mainAxisSpacing;

  /// Spacing between tiles on cross axis
  final double crossAxisSpacing;

  /// Set a padding on the search bar
  final EdgeInsetsGeometry searchBarPadding;

  /// Set a padding on the header
  final EdgeInsetsGeometry headerPadding;

  /// Set a padding on the list
  final EdgeInsetsGeometry listPadding;

  @override
  State<AnimSearchBar2<T>> createState() => _AnimSearchBar2State<T>();
}

///toggle - 0 => false or closed
///toggle 1 => true or open
int toggle = 0;

class _AnimSearchBar2State<T> extends State<AnimSearchBar2<T>>
    with SingleTickerProviderStateMixin, ControllerListener<T> {
  ///initializing the AnimationController
  late AnimationController _con;
  FocusNode focusNode = FocusNode();
  bool _loading = false;
  Widget? _error;
  final TextEditingController _searchQueryController = TextEditingController();
  Timer? _debounce;
  bool _animate = false;
  List<T> _list = <T>[];
  SearchBarController<dynamic>? searchBarController;

  @override
  void initState() {
    super.initState();
    searchBarController =
        widget.searchBarController ?? SearchBarController<T>();
    searchBarController?.setListener(this);
    searchBarController?.setTextController(
        _searchQueryController, widget.minimumChars);

    ///Initializing the animationController which is responsible for the expanding and shrinking of the search bar
    _con = AnimationController(
      vsync: this,

      /// animationDurationInMilli is optional, the default value is 375
      duration: Duration(milliseconds: widget.animationDurationInMilli),
    );
  }

  @override
  void onListChanged(List<T> items) {
    setState(() {
      _loading = false;
      _list = items;
    });
  }

  @override
  void onLoading() {
    setState(() {
      _loading = true;
      _error = null;
      _animate = true;
    });
  }

  @override
  void onClear() {
    _cancel();
  }

  @override
  void onError(Error error) {
    setState(() {
      _loading = false;
      _error =
          widget.onError != null ? widget.onError!(error) : const Text('error');
    });
  }

  Future<void> _onTextChanged(String newText) async {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(widget.debounceDuration, () async {
      if (newText.length >= widget.minimumChars) {
        searchBarController!._search(newText, widget.onSearch);
      } else {
        setState(() {
          _list.clear();
          _error = null;
          _loading = false;
          _animate = false;
        });
      }
    });
  }

  void _cancel() {
    if (widget.onCancelled != null) {
      widget.onCancelled!();
    }

    setState(() {
      _searchQueryController.clear();
      _list.clear();
      _error = null;
      _loading = false;
      _animate = false;
    });
  }

  void unFocusKeyboard() {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Widget _buildListView(
      List<T> items, Widget Function(T item, int index) builder) {
    return Padding(
      padding: widget.listPadding,
      child: StaggeredGridView.countBuilder(
        crossAxisCount: widget.crossAxisCount,
        itemCount: items.length > 5 ? 5 : items.length,
        shrinkWrap: widget.shrinkWrap,
        staggeredTileBuilder:
            widget.indexedScaledTileBuilder ?? (int index) => ScaledTile.fit(1),
        scrollDirection: widget.scrollDirection,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        itemBuilder: (BuildContext context, int index) {
          return builder(items[index], index);
        },
      ),
    );
  }

  Widget? _buildContent(BuildContext context) {
    if (_error != null) {
      return _error!;
    } else if (_loading) {
      return widget.loader;
    } else if (_searchQueryController.text.length < widget.minimumChars) {
      if (widget.placeHolder != null) {
        return widget.placeHolder!;
      }
      return _buildListView(widget.suggestions, widget.onItemFound);
    } else if (_list.isNotEmpty) {
      return _buildListView(_list, widget.onItemFound);
    } else {
      return widget.emptyWidget;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,

      ///if the rtl is true, search bar will be from right to left
      alignment: widget.rtl ? Alignment.centerRight : Alignment.centerLeft,

      ///Using Animated container to expand and shrink the widget
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: widget.animationDurationInMilli),
            height: 48.0,
            width: (toggle == 0) ? 48.0 : widget.width,
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              /// can add custom color or the color will be white
              color: widget.color,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: -10.0,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Stack(
              children: <Widget>[
                ///Using Animated Positioned widget to expand and shrink the widget
                AnimatedPositioned(
                  duration:
                      Duration(milliseconds: widget.animationDurationInMilli),
                  top: 6.0,
                  right: 7.0,
                  curve: Curves.easeOut,
                  child: AnimatedOpacity(
                    opacity: (toggle == 0) ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        /// can add custom color or the color will be white
                        color: widget.color,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: AnimatedBuilder(
                        builder: (BuildContext context, Widget? widget) {
                          ///Using Transform.rotate to rotate the suffix icon when it gets expanded
                          return Transform.rotate(
                            angle: _con.value * 2.0 * pi,
                            child: widget,
                          );
                        },
                        animation: _con,
                        child: GestureDetector(
                          onTap: () {
                            try {
                              ///trying to execute the onSuffixTap function
                              widget.onSuffixTap();
                              _cancel();

                              ///closeSearchOnSuffixTap will execute if it's true
                              if (widget.closeSearchOnSuffixTap) {
                                unFocusKeyboard();
                                setState(() {
                                  toggle = 0;
                                });
                              }
                            } catch (e) {
                              ///print the error if the try block fails
                              if (kDebugMode) {
                                print(e);
                              }
                            }
                          },

                          ///suffixIcon is of type Icon
                          child: widget.suffixIcon ??
                              const Icon(
                                Icons.close,
                                size: 20.0,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration:
                      Duration(milliseconds: widget.animationDurationInMilli),
                  left: (toggle == 0) ? 20.0 : 40.0,
                  curve: Curves.easeOut,
                  top: 11.0,

                  ///Using Animated opacity to change the opacity of th textField while expanding
                  child: AnimatedOpacity(
                    opacity: (toggle == 0) ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      alignment: Alignment.topCenter,
                      width: widget.width / 1.7,
                      child: TextField(
                        ///Text Controller. you can manipulate the text inside this textField by calling this controller.
                        controller: _searchQueryController,
                        onChanged: _onTextChanged,
                        inputFormatters: widget.inputFormatters,
                        focusNode: focusNode,
                        cursorRadius: const Radius.circular(10.0),
                        onEditingComplete: () {
                          /// on editing complete the keyboard will be closed and the search bar will be closed
                          unFocusKeyboard();
                          setState(() {
                            toggle = 0;
                          });
                        },

                        ///style is of type TextStyle, the default is just a color black
                        style: widget.style ??
                            const TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(bottom: 5),
                          isDense: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: widget.helpText,
                          labelStyle: const TextStyle(
                            color: Color(0xff5B5B5B),
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                          ),
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                ///Using material widget here to get the ripple effect on the prefix icon
                Material(
                  /// can add custom color or the color will be white
                  color: widget.color,
                  borderRadius: BorderRadius.circular(30.0),
                  child: IconButton(
                    splashRadius: 19.0,

                    ///if toggle is 1, which means it's open. so show the back icon, which will close it.
                    ///if the toggle is 0, which means it's closed, so tapping on it will expand the widget.
                    ///prefixIcon is of type Icon
                    icon: widget.prefixIcon != null
                        ? toggle == 1
                            ? const Icon(Icons.arrow_back_ios)
                            : widget.prefixIcon!
                        : Icon(
                            toggle == 1 ? Icons.arrow_back_ios : Icons.search,
                            size: 20.0,
                          ),
                    onPressed: () {
                      setState(
                        () {
                          ///if the search bar is closed
                          if (toggle == 0) {
                            toggle = 1;
                            setState(() {
                              ///if the autoFocus is true, the keyboard will pop open, automatically
                              if (widget.autoFocus) {
                                FocusScope.of(context).requestFocus(focusNode);
                              }
                            });

                            ///forward == expand
                            _con.forward();
                          } else {
                            ///if the search bar is expanded
                            toggle = 0;

                            ///if the autoFocus is true, the keyboard will close, automatically
                            setState(() {
                              if (widget.autoFocus) {
                                unFocusKeyboard();
                              }
                            });

                            ///reverse == close
                            _con.reverse();
                          }
                        },
                      );
                      onClear();
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: widget.headerPadding,
            child: widget.header ?? Container(),
          ),
          Expanded(
            // flex: 3,
            child: _buildContent(context)!,
          ),
        ],
      ),
    );
  }
}
