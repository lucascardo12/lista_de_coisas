import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/listas/presenter/controllers/listas_controller.dart';

class ListaTexto extends StatefulWidget {
  final Global gb;
  final ListasController ct;

  const ListaTexto({super.key, required this.ct, required this.gb});

  @override
  State<ListaTexto> createState() => _ListaTextoState();
}

class _ListaTextoState extends State<ListaTexto> {
  late QuillController _quillController;
  late ScrollController _scrollController;
  late FocusNode _focusNode;
  bool _showToolbar = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _focusNode = FocusNode();

    // Initialize Quill controller with existing content or empty
    final conteudoRich = widget.ct.coisas.conteudoRich;
    if (conteudoRich != null) {
      try {
        final delta = Delta.fromJson(conteudoRich['ops'] as List);
        _quillController = QuillController(
          document: Document.fromDelta(delta),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e, s) {
        log('Erro ao carregar conteúdo rich: $e', stackTrace: s);
        // Fallback to plain text
        _initWithPlainText();
      }
    } else if (widget.ct.coisas.descricao.isNotEmpty) {
      _initWithPlainText();
    } else {
      _quillController = QuillController.basic();
    }

    // Listen for changes and update the model
    _quillController.addListener(_onTextChanged);
  }

  void _initWithPlainText() {
    final document = Document()..insert(0, widget.ct.coisas.descricao);
    _quillController = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  void _onTextChanged() {
    final delta = _quillController.document.toDelta();
    widget.ct.coisas.conteudoRich = {'ops': delta.toJson()};
    // Also update plain text for backward compatibility
    widget.ct.coisas.descricao = _quillController.document.toPlainText().trim();
  }

  @override
  void dispose() {
    _quillController.removeListener(_onTextChanged);
    _quillController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Modern Toolbar
        const Divider(height: 1, color: Colors.white24),
        // Editor
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Theme(
                data: ThemeData(
                  textTheme: const TextTheme(
                    bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  primaryTextTheme: const TextTheme(
                    bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                child: QuillEditor(
                  controller: _quillController,
                  scrollController: _scrollController,
                  focusNode: _focusNode,

                  config: QuillEditorConfig(
                    placeholder: 'Digite seu conteúdo aqui...',
                    padding: const EdgeInsets.all(16),
                    scrollable: true,
                    autoFocus:
                        widget.ct.coisas.descricao.isEmpty &&
                        (widget.ct.coisas.conteudoRich == null),
                    expands: false,
                    keyboardAppearance: Brightness.dark,
                    customStyles: const DefaultStyles(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_showToolbar) _buildToolbar(),
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _showToolbar = !_showToolbar;
                  });
                },
                icon: Icon(
                  _showToolbar
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                  color: Colors.white,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),

        // Toolbar condicional
      ],
    );
  }

  Widget _buildToolbar() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.10,
      margin: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 600),
        child: QuillSimpleToolbar(
          controller: _quillController,
          config: QuillSimpleToolbarConfig(
            color: Colors.white,
            sectionDividerColor: Colors.white38,
            decoration: const BoxDecoration(color: Colors.transparent),
            showBoldButton: true,
            showItalicButton: true,
            showUnderLineButton: true,
            showStrikeThrough: true,
            showColorButton: true,
            showBackgroundColorButton: false,
            showClearFormat: true,
            showHeaderStyle: true,
            showListNumbers: true,
            showListBullets: true,
            showListCheck: true,
            showCodeBlock: true,
            showQuote: true,
            showIndent: true,
            showLink: true,
            showUndo: true,
            showRedo: true,
            showAlignmentButtons: true,
            showDirection: false,
            showSearchButton: true,
            showSubscript: false,
            showSuperscript: false,
            showFontFamily: false,
            showFontSize: false,
            showInlineCode: false,
            multiRowsDisplay: false,
            toolbarSectionSpacing: 8,
            buttonOptions: QuillSimpleToolbarButtonOptions(
              base: QuillToolbarBaseButtonOptions(
                iconTheme: QuillIconTheme(
                  iconButtonSelectedData: IconButtonData(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white30,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  iconButtonUnselectedData: IconButtonData(
                    style: IconButton.styleFrom(foregroundColor: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
