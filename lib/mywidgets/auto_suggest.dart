import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EasyAutocomplete extends StatefulWidget {
  /// The list of suggestions to be displayed
  final List<String>? suggestions;

  /// Fetches list of suggestions from a Future
  final Future<List<String>> Function(String searchValue)? asyncSuggestions;

  /// Text editing controller
  final TextEditingController? controller;

  /// Can be used to decorate the input
  final InputDecoration decoration;

  /// Function that handles the changes to the input
  final Function(String)? onChanged;

  /// Function that handles the submission of the input
  final Function(String)? onSubmitted;

  /// Can be used to set custom inputFormatters to field
  final List<TextInputFormatter> inputFormatter;

  /// Can be used to set the textfield initial value
  final String? initialValue;

  /// Can be used to set the text capitalization type
  final TextCapitalization textCapitalization;

  /// Determines if should gain focus on screen open
  final bool autofocus;

  /// Can be used to set different keyboardTypes to your field
  final TextInputType keyboardType;

  /// Can be used to manage TextField focus
  final FocusNode? focusNode;

  /// Can be used to set a custom color to the input cursor
  final Color? cursorColor;

  /// Can be used to set custom style to the suggestions textfield
  final TextStyle inputTextStyle;

  /// Can be used to set custom style to the suggestions list text
  final TextStyle suggestionTextStyle;

  /// Can be used to set custom background color to suggestions list
  final Color? suggestionBackgroundColor;

  /// Used to set the debounce time for async data fetch
  final Duration debounceDuration;

  /// Can be used to customize suggestion items
  final Widget Function(String data)? suggestionBuilder;

  /// Can be used to display custom progress idnicator
  final Widget? progressIndicatorBuilder;

  /// Can be used to validate field value
  final String? Function(String?)? validator;

  final int? maxLength;

  /// Creates a autocomplete widget to help you manage your suggestions
  const EasyAutocomplete(
      {this.suggestions,
      this.asyncSuggestions,
      this.suggestionBuilder,
      this.progressIndicatorBuilder,
      this.controller,
      this.decoration = const InputDecoration(),
      this.onChanged,
      this.onSubmitted,
      this.inputFormatter = const [],
      this.initialValue,
      this.autofocus = false,
      this.textCapitalization = TextCapitalization.sentences,
      this.keyboardType = TextInputType.text,
      this.focusNode,
      this.cursorColor,
      this.inputTextStyle = const TextStyle(),
      this.suggestionTextStyle = const TextStyle(),
      this.suggestionBackgroundColor,
      this.debounceDuration = const Duration(milliseconds: 400),
      this.validator,
      this.maxLength})
      : assert(onChanged != null || controller != null,
            'onChanged and controller parameters cannot be both null at the same time'),
        assert(!(controller != null && initialValue != null),
            'controller and initialValue cannot be used at the same time'),
        assert(
            suggestions != null && asyncSuggestions == null ||
                suggestions == null && asyncSuggestions != null,
            'suggestions and asyncSuggestions cannot be both null or have values at the same time');

  @override
  State<EasyAutocomplete> createState() => _EasyAutocompleteState();
}

class _EasyAutocompleteState extends State<EasyAutocomplete> {
  final LayerLink _layerLink = LayerLink();
  late TextEditingController _controller;
  bool _hasOpenedOverlay = false;
  bool _isLoading = false;
  OverlayEntry? _overlayEntry;
  List<String> _suggestions = [];
  Timer? _debounce;
  String _previousAsyncSearchText = '';
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ??
        TextEditingController(text: widget.initialValue ?? '');
    _controller.addListener(() => updateSuggestions(_controller.text));
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        if (_controller.text.isNotEmpty) openOverlay();
      } else
        closeOverlay();
    });
  }

  void openOverlay() {
    if (_overlayEntry == null) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      var size = renderBox.size;
      var offset = renderBox.localToGlobal(Offset.zero);

      _overlayEntry ??= OverlayEntry(
          builder: (context) => Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 5.0,
              width: size.width,
              child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0.0, size.height + 5.0),
                  child: FilterableList(
                      loading: _isLoading,
                      suggestionBuilder: widget.suggestionBuilder,
                      progressIndicatorBuilder: widget.progressIndicatorBuilder,
                      items: _suggestions,
                      suggestionTextStyle: widget.suggestionTextStyle,
                      suggestionBackgroundColor:
                          widget.suggestionBackgroundColor,
                      onItemTapped: (value) {
                        _controller
                          ..value = TextEditingValue(
                              text: value,
                              selection: TextSelection.collapsed(
                                  offset: value.length));
                        widget.onChanged?.call(value);
                        widget.onSubmitted?.call(value);
                        closeOverlay();
                        _focusNode.unfocus();
                      }))));
    }
    if (!_hasOpenedOverlay) {
      Overlay.of(context)!.insert(_overlayEntry!);
      setState(() => _hasOpenedOverlay = true);
    }
  }

  void closeOverlay() {
    if (_hasOpenedOverlay) {
      _overlayEntry!.remove();
      setState(() {
        _previousAsyncSearchText = '';
        _hasOpenedOverlay = false;
      });
    }
  }

  Future<void> updateSuggestions(String input) async {
    // rebuildOverlay();
    if (widget.suggestions != null) {
      _suggestions = widget.suggestions!.where((element) {
        if (element == '') {
          return false;
        }
        return element.startsWith(input);
      }).toList();
      rebuildOverlay();
    } else if (widget.asyncSuggestions != null) {
      setState(() => _isLoading = true);
      if (_debounce != null && _debounce!.isActive) _debounce!.cancel();
      _debounce = Timer(widget.debounceDuration, () async {
        if (_previousAsyncSearchText != input ||
            _previousAsyncSearchText.isEmpty ||
            input.isEmpty) {
          _suggestions = await widget.asyncSuggestions!(input);
          setState(() {
            _isLoading = false;
            _previousAsyncSearchText = input;
          });
          rebuildOverlay();
        }
      });
    }
  }

  void rebuildOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
        link: _layerLink,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                  maxLength: widget.maxLength ?? 3,
                  decoration: widget.decoration,
                  controller: _controller,
                  inputFormatters: widget.inputFormatter,
                  autofocus: widget.autofocus,
                  focusNode: _focusNode,
                  textCapitalization: widget.textCapitalization,
                  keyboardType: widget.keyboardType,
                  cursorColor: widget.cursorColor ?? Colors.blue,
                  style: widget.inputTextStyle,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      closeOverlay();
                    } else {
                      openOverlay();
                    }
                    widget.onChanged?.call(value);
                  },
                  onFieldSubmitted: (value) {
                    widget.onSubmitted?.call(value);
                    closeOverlay();
                    _focusNode.unfocus();
                  },
                  onEditingComplete: () => closeOverlay(),
                  validator: widget.validator != null
                      ? (value) => widget.validator!(value)
                      : null // (value) {}
                  )
            ]));
  }

  @override
  void dispose() {
    if (_overlayEntry != null) _overlayEntry!.dispose();
    if (widget.controller == null) {
      _controller.removeListener(() => updateSuggestions(_controller.text));
      _controller.dispose();
    }
    if (_debounce != null) _debounce?.cancel();
    if (widget.focusNode == null) {
      _focusNode.removeListener(() {
        if (_focusNode.hasFocus)
          openOverlay();
        else
          closeOverlay();
      });
      _focusNode.dispose();
    }
    super.dispose();
  }
}

class FilterableList extends StatelessWidget {
  final List<String> items;
  final Function(String) onItemTapped;
  final double elevation;
  final double maxListHeight;
  final TextStyle suggestionTextStyle;
  final Color? suggestionBackgroundColor;
  final bool loading;
  final Widget Function(String data)? suggestionBuilder;
  final Widget? progressIndicatorBuilder;

  const FilterableList(
      {required this.items,
      required this.onItemTapped,
      this.suggestionBuilder,
      this.elevation = 5,
      this.maxListHeight = 150,
      this.suggestionTextStyle = const TextStyle(),
      this.suggestionBackgroundColor,
      this.loading = false,
      this.progressIndicatorBuilder});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);

    Color _suggestionBackgroundColor = suggestionBackgroundColor ??
        scaffold?.widget.backgroundColor ??
        theme.scaffoldBackgroundColor;

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      color: _suggestionBackgroundColor,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxListHeight),
        child: Visibility(
          visible: items.isNotEmpty || loading,
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(5),
            itemCount: loading ? 1 : items.length,
            itemBuilder: (context, index) {
              if (loading) {
                return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Visibility(
                        visible: progressIndicatorBuilder != null,
                        child: progressIndicatorBuilder!,
                        replacement: CircularProgressIndicator()));
              }

              if (suggestionBuilder != null) {
                return InkWell(
                    child: suggestionBuilder!(items[index]),
                    onTap: () => onItemTapped(items[index]));
              }

              return Material(
                  color: Colors.transparent,
                  child: InkWell(
                      child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(5),
                          child:
                              Text(items[index], style: suggestionTextStyle)),
                      onTap: () => onItemTapped(items[index])));
            },
          ),
        ),
      ),
    );
  }
}
