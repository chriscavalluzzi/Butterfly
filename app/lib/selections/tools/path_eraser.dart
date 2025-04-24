part of '../selection.dart';

class _ShapeEraseModeView extends StatefulWidget {
  final List<PathEraserTool> selected; // TODO
  final Function(BuildContext, List<PathEraserTool>) update; // TODO

  const _ShapeEraseModeView({required this.selected, required this.update});

  @override
  _ShapeEraseModeViewState createState() => _ShapeEraseModeViewState();
}

class _ShapeEraseModeViewState extends State<_ShapeEraseModeView> {
  void _updateEraseShapesMode(EraseShapesMode? value) {
    if (value != null) {
      setState(() {
        widget.update(
          context,
          [widget.selected.first.copyWith(eraseShapesMode: value)],
        );
      });
    }
  }

  String getModeDescription(EraseShapesMode mode) {
    switch (mode) {
      case EraseShapesMode.anywhere:
        return 'Erase when touching anywhere'; // TODO
      case EraseShapesMode.edgesOnly:
        return 'Erase when touching edges'; // TODO
      case EraseShapesMode.disabled:
        return 'Do not erase'; // TODO
    }
  }

  @override
  void didUpdateWidget(covariant _ShapeEraseModeView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Control if PenTool is changed
    if (oldWidget.selected != widget.selected) {
      // if change force update
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Delete shapes'), // TODO
      subtitle: Text(
        getModeDescription(widget.selected.first.eraseShapesMode),
        style: TextStyle(
          color: ColorScheme.of(context).secondary,
        ),
      ),
      tilePadding: EdgeInsets.fromLTRB(16, 0, 20.0, 0),
      leading: const Icon(PhosphorIconsLight.shapes),
      children: [
        InkWell(
          onTap: () => _updateEraseShapesMode(EraseShapesMode.disabled),
          child: ListTile(
            title: Text(getModeDescription(EraseShapesMode.disabled)), // TODO
            leading: Radio<EraseShapesMode>(
              value: EraseShapesMode.disabled,
              groupValue: widget.selected.first.eraseShapesMode,
              onChanged: _updateEraseShapesMode,
            ),
          ),
        ),
        InkWell(
          onTap: () => _updateEraseShapesMode(EraseShapesMode.edgesOnly),
          child: ListTile(
            title: Text(getModeDescription(EraseShapesMode.edgesOnly)),
            leading: Radio<EraseShapesMode>(
              value: EraseShapesMode.edgesOnly,
              groupValue: widget.selected.first.eraseShapesMode,
              onChanged: _updateEraseShapesMode,
            ),
            // enabled: widget.selected.first.eraseShapes,
          ),
        ),
        InkWell(
          onTap: () => _updateEraseShapesMode(EraseShapesMode.anywhere),
          child: ListTile(
            title: Text(getModeDescription(EraseShapesMode.anywhere)),
            leading: Radio<EraseShapesMode>(
              value: EraseShapesMode.anywhere,
              groupValue: widget.selected.first.eraseShapesMode,
              onChanged: _updateEraseShapesMode,
            ),
            // enabled: widget.selected.first.eraseShapes,
          ),
        ),
      ],
    );
  }
}

class PathEraserToolSelection extends ToolSelection<PathEraserTool> {
  PathEraserToolSelection(super.selected);

  @override
  List<Widget> buildProperties(BuildContext context) {
    final tool = selected.first;
    return [
      ...super.buildProperties(context),
      ExactSlider(
          header: Text(AppLocalizations.of(context).strokeWidth),
          value: tool.strokeWidth,
          min: 0,
          max: 70,
          defaultValue: 5,
          onChangeEnd: (value) => update(context,
              selected.map((e) => e.copyWith(strokeWidth: value)).toList())),
      _ShapeEraseModeView(selected: selected, update: update),
      CheckboxListTile(
        value: selected.first.eraseElements,
        title: Text(AppLocalizations.of(context).deleteElements),
        subtitle: Text('Erase imported elements, text, etc.'), // TODO
        secondary: const PhosphorIcon(PhosphorIconsLight.image),
        onChanged: (value) => update(
            context,
            selected
                .map((e) => e.copyWith(eraseElements: value ?? false))
                .toList()),
      ),
    ];
  }

  @override
  Selection insert(dynamic element) {
    if (element is PathEraserTool) {
      return PathEraserToolSelection([...selected, element]);
    }
    return super.insert(element);
  }
}
