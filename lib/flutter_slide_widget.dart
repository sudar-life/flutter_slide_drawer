import 'package:flutter/material.dart';

enum SliderEffectType { Rounded, Rectangle }

class SliderDrawerOption {
  final Color backgroundColor;
  final Image? backgroundImage;
  final SliderEffectType sliderEffectType;
  final double radiusAmount;
  final double upDownScaleAmount;
  SliderDrawerOption({
    this.backgroundColor = Colors.blue,
    this.sliderEffectType = SliderEffectType.Rectangle,
    this.backgroundImage,
    this.radiusAmount = 0,
    this.upDownScaleAmount = 0,
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
  late SliderDrawerOption option;

  @override
  void initState() {
    super.initState();
    _initOption();
    _animationSetup();
  }

  void _initOption() {
    option = widget.option ?? SliderDrawerOption();
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
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
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
    if (isOpened && details.globalPosition.dx > size.width * 0.8) {
      dragPossible = true;
    }

    if (!isOpened && details.globalPosition.dx < 40) {
      dragPossible = true;
    }
  }

  _onDragUpdate(DragUpdateDetails details) {
    if (dragPossible) {
      updateDrawerRate(details.globalPosition.dx / size.width);
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
          alignment: Alignment.centerLeft,
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
              left: -size.width + drawerPosition,
              right: 0,
              bottom: 0,
              top: 0,
              child: Container(
                width: size.width * 2,
                decoration: loadBackgroundDecoration(),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: size.width,
                    padding: EdgeInsets.only(
                        left: size.width - (size.width * limitPercent)),
                    child: widget.drawer,
                  ),
                ),
              ),
            ),
            Positioned(
              left: drawerPosition,
              right: -drawerPosition,
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
