import 'package:flutter/material.dart';
import 'package:simple_markdown_editor/src/emoji_input_formatter.dart';

class MarkdownField extends StatelessWidget {
  const MarkdownField({
    super.key,
    required this.fieldKey,
    this.expands = false,
    this.minLines,
    this.maxLines,
    this.controller,
    this.scrollController,
    this.onChanged,
    this.decoration,
    this.style,
    this.emojiConvert = false,
    this.onTap,
    this.textCapitalization = TextCapitalization.sentences,
    this.readOnly = false,
    this.cursorColor,
    this.focusNode,
    this.padding = const EdgeInsets.all(10),
  });

  final GlobalKey fieldKey;

  // Exposing TextFormField options
  final bool expands;
  final int? minLines;
  final int? maxLines;

  final InputDecoration? decoration;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  final ScrollController? scrollController;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  ///
  /// Only supports text keyboards, other keyboard types will ignore this configuration. Capitalization is locale-aware.
  ///
  /// Defaults to [TextCapitalization.none]. Must not be null.
  ///
  /// See also:
  /// * [TextCapitalization], for a description of each capitalization behavior.
  final TextCapitalization textCapitalization;

  /// See also:
  ///
  /// * [inputFormatters], which are called before [onChanged] runs and can validate and change
  /// ("format") the input value.
  /// * [onEditingComplete], [onSubmitted]: which are more specialized input change notifications.
  final ValueChanged<String>? onChanged;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the subtitle1 text style from the current [Theme].
  final TextStyle? style;

  /// to enable auto convert emoji
  ///
  /// if true, the string will be automatically converted to emoji
  ///
  /// example: :smiley: => 😃
  final bool emojiConvert;

  /// Called for each distinct tap except for every second tap of a double tap.
  ///
  /// The text field builds a [GestureDetector] to handle input events like tap, to trigger focus
  /// requests, to move the caret, adjust the selection, etc. Handling some of those events by wrapping
  /// the text field with a competing GestureDetector is problematic.
  ///
  /// To unconditionally handle taps, without interfering with the text field's internal gesture
  /// detector, provide this callback.
  ///
  /// If the text field is created with [enabled] false, taps will not be recognized.
  /// To be notified when the text field gains or loses the focus, provide a [focusNode] and add a
  /// listener to that.
  ///
  /// To listen to arbitrary pointer events without competing with the text field's internal gesture
  /// detector, use a [Listener].
  final VoidCallback? onTap;

  /// Whether the text can be changed.
  ///
  /// When this is set to true, the text cannot be modified by any shortcut or keyboard operation. The text is still selectable.
  ///
  /// Defaults to false. Must not be null.
  final bool readOnly;

  /// The color of the cursor.
  ///
  /// The cursor indicates the current location of text insertion point in the field.
  ///
  /// If this is null it will default to the ambient [TextSelectionThemeData.cursorColor]. If that is
  /// null, and the [ThemeData.platform] is [TargetPlatform.iOS] or [TargetPlatform.macOS] it will use
  /// [CupertinoThemeData.primaryColor]. Otherwise it will use the value of [ColorScheme.primary] of
  /// [ThemeData.colorScheme].
  final Color? cursorColor;

  /// Defines the keyboard focus for this widget.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a [StatefulWidget] parent. See
  /// [FocusNode] for more information.
  ///
  /// To give the keyboard focus to this widget, provide a [focusNode] and then use the current
  /// [FocusScope] to request the focus:
  ///
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// This happens automatically when the widget is tapped.
  final FocusNode? focusNode;

  /// The amount of space by which to inset the child.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final inputDecoration = decoration ??
        const InputDecoration(
          contentPadding: EdgeInsets.only(
            top: 60,
            bottom: 8,
          ),
        );

    return TextFormField(
      key: fieldKey,
      expands: expands,
      minLines: minLines,
      maxLines: maxLines,
      focusNode: focusNode,
      controller: controller,
      scrollController: scrollController,
      onChanged: _onEditorChange,
      onTap: onTap,
      autocorrect: false,
      keyboardType: TextInputType.multiline,
      textCapitalization: textCapitalization,
      readOnly: readOnly,
      cursorColor: cursorColor,
      style: style,
      decoration: inputDecoration,
      inputFormatters: [
        if (emojiConvert) EmojiInputFormatter(),
      ],
      contextMenuBuilder: (context, editableTextState) {
        final List<ContextMenuButtonItem> buttonItems =
            editableTextState.contextMenuButtonItems;

        buttonItems.insert(
          0,
          ContextMenuButtonItem(
            label: 'Send email',
            onPressed: () {
              ContextMenuController.removeAny();
            },
          ),
        );

        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: editableTextState.contextMenuAnchors,
          buttonItems: buttonItems,
        );
      },
    );
  }

  // on field change
  void _onEditorChange(String value) {
    onChanged?.call(value);
  }
}
