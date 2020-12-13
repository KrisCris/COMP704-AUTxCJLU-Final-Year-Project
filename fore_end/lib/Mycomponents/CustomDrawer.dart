import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  final double elevation;
  final Widget child;
  final String semanticLabel;
  final double widthPercent;
  final Function onOpen;
  final Function onClose;
  const CustomDrawer({
    Key key,
    this.elevation = 16.0,
    this.child,
    this.semanticLabel,
    this.widthPercent,
    this.onOpen,
    this.onClose
  })  : assert(widthPercent < 1.0 && widthPercent > 0.0),
        super(key: key);
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  @override
  void initState() {
    ///add start
    if(widget.onOpen!=null){
      widget.onOpen();
    }
    ///add end
    super.initState();
  }
  @override
  void dispose() {
    ///add start
    if(widget.onClose!=null){
      widget.onClose();
    }
    ///add end
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    String label = widget.semanticLabel;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        label = widget.semanticLabel;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        label = widget.semanticLabel ?? MaterialLocalizations.of(context)?.drawerLabel;
    }
    final double _width = MediaQuery.of(context).size.width * widget.widthPercent;
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: label,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(width: _width),
        child: Material(
          elevation: widget.elevation,
          child: widget.child,
        ),
      ),
    );
  }
}