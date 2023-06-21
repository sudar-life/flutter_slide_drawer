import 'package:flutter/material.dart';

enum SliderEffectType { Rounded, Rectangle }

enum SliderDrawerDirection { LTR, RTL }

class SliderDrawerOption {
  final Color backgroundColor;
  final Image? backgroundImage;
  final SliderEffectType sliderEffectType;
  final double radiusAmount;
  final double upDownScaleAmount;
  final SliderDrawerDirection direction;
  SliderDrawerOption({
    this.backgroundColor = Colors.blue,
    this.sliderEffectType = SliderEffectType.Rectangle,
    this.backgroundImage,
    this.radiusAmount = 0,
    this.upDownScaleAmount = 0,
    this.direction = SliderDrawerDirection.LTR,
  });
}

class SliderDrawerWidget extends StatefulWidget {
  final Widget drawer;
  final Widget body;
  final SliderDrawerOption? option;
  SliderDrawerWidget({
    Key? key,
    required this.drawer,
    required this.body,
    this.option,
  }) : super(key: key);

  @override
  SliderDrawerWidgetState createState() => SliderDrawerWidgetState();
}

class SliderDrawerWidgetState extends State<SliderDrawerWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Size size;
  double limitPercent = 0.85;
  double upDownScaleAmount = 0;
  double radiusAmount = 0;
  double drawerRate = 0.0;
  bool isOpened = false;
  bool dragPossible = false;
  late SliderDrawerDirection _direction;
  late SliderDrawerOption option;
  late EdgeInsetsGeometry drawerPadding;
  late Alignment backgroundDecorationAlignment;
  late Alignment backgroundDrawerAlignment;

  @override
  void initState() {
    super.initState();
    _initOption();
    _animationSetup();
  }

  void _setDrawerPadding() {
    switch (_direction) {
      case SliderDrawerDirection.LTR:
        drawerPadding =
            EdgeInsets.only(left: size.width - (size.width * limitPercent));
        backgroundDecorationAlignment = Alignment.centerLeft;
        backgroundDrawerAlignment = Alignment.topLeft;
        break;
      case SliderDrawerDirection.RTL:
        drawerPadding =
            EdgeInsets.only(right: size.width - (size.width * limitPercent));
        backgroundDecorationAlignment = Alignment.centerRight;
        backgroundDrawerAlignment = Alignment.topRight;
        break;
    }
  }

  void _initOption() {
    option = widget.option ?? SliderDrawerOption();
    _direction = option.direction;
    switch (option.sliderEffectType) {
      case SliderEffectType.Rounded:
        upDownScaleAmount = option.upDownScaleAmount;
        radiusAmount = option.radiusAmount;
        break;
      case SliderEffectType.Rectangle:
        upDownScaleAmount = 0;
        radiusAmount = 0;
        break;
    }
  }

  void _animationSetup() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    animationController.addListener(() {
      updateDrawerRate(animationController.value);
    });
  }

  @override
  void didUpdateWidget(covariant SliderDrawerWidget oldWidget) {
    if (oldWidget.option != widget.option) {
      _initOption();
      _setDrawerPadding();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    _setDrawerPadding();
  }

  double get drawerPosition => (size.width * drawerRate);

  void updateDrawerRate(double rate) {
    if (rate > limitPercent) {
      rate = limitPercent;
    }
    drawerRate = rate;
    update();
  }

  void toggleDrawer() {
    if (isOpened) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
    isOpened = !isOpened;
  }

  void closeDrawer() {
    animationController.reverse(from: drawerRate);
    isOpened = false;
  }

  void openDrawer() {
    animationController.forward(from: drawerRate);
    isOpened = true;
  }

  void update() {
    setState(() {});
  }

  _onDragStart(DragStartDetails details) {
    if (isOpened &&
        (_direction == SliderDrawerDirection.LTR
            ? details.globalPosition.dx > size.width * 0.8
            : details.globalPosition.dx < size.width * 0.2)) {
      dragPossible = true;
    }

    if (!isOpened &&
        (_direction == SliderDrawerDirection.LTR
            ? details.globalPosition.dx < size.width * 0.2
            : details.globalPosition.dx > size.width * 0.8)) {
      dragPossible = true;
    }
  }

  _onDragUpdate(DragUpdateDetails details) {
    if (dragPossible) {
      var rate = _direction == SliderDrawerDirection.LTR
          ? details.globalPosition.dx / size.width
          : (size.width - details.globalPosition.dx) / size.width;
      updateDrawerRate(rate);
    }
  }

  _onDragEnd(DragEndDetails details) {
    if (!dragPossible) return;
    if (details.velocity.pixelsPerSecond.dx == 0) {
      if (drawerRate >= 0.5) {
        openDrawer();
      } else {
        closeDrawer();
      }
    } else {
      if (details.velocity.pixelsPerSecond.dx > 100) {
        openDrawer();
      }
      if (details.velocity.pixelsPerSecond.dx < -100) {
        closeDrawer();
      }
    }
    dragPossible = false;
  }

  BoxDecoration loadBackgroundDecoration() {
    if (option.backgroundImage != null) {
      return BoxDecoration(
        image: DecorationImage(
          image: option.backgroundImage!.image,
          fit: BoxFit.cover,
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.4), BlendMode.dstATop),
          alignment: backgroundDecorationAlignment,
        ),
        color: option.backgroundColor,
      );
    } else {
      return BoxDecoration(
        color: option.backgroundColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Positioned(
              left: _direction == SliderDrawerDirection.LTR
                  ? -size.width + drawerPosition
                  : 0,
              right: _direction == SliderDrawerDirection.RTL
                  ? -size.width + drawerPosition
                  : 0,
              bottom: 0,
              top: 0,
              child: Container(
                width: size.width * 2,
                decoration: loadBackgroundDecoration(),
                child: Align(
                  alignment: backgroundDrawerAlignment,
                  child: Container(
                    width: size.width,
                    padding: drawerPadding,
                    child: widget.drawer,
                  ),
                ),
              ),
            ),
            Positioned(
              left: drawerPosition *
                  (_direction == SliderDrawerDirection.LTR ? 1 : -1),
              right: drawerPosition *
                  (_direction == SliderDrawerDirection.RTL ? 1 : -1),
              bottom: upDownScaleAmount * drawerRate,
              top: upDownScaleAmount * drawerRate,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radiusAmount * drawerRate),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragStart: _onDragStart,
                  onHorizontalDragUpdate: _onDragUpdate,
                  onHorizontalDragEnd: _onDragEnd,
                  child: widget.body,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
