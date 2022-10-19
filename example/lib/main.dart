import 'package:flutter/material.dart';
import 'package:flutter_slide_drawer/flutter_slide_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<SliderDrawerWidgetState> drawerKey = GlobalKey();

  bool toggleBackgroundState = false;

  void toggleBackgroundImage() {
    setState(() {
      toggleBackgroundState = !toggleBackgroundState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliderDrawerWidget(
        key: drawerKey,
        option: SliderDrawerOption(
          backgroundImage: toggleBackgroundState
              ? Image.asset("assets/sample_background.jpg")
              : Image.asset("assets/sample_background2.jpg"),
          backgroundColor: Colors.black,
          sliderEffectType: SliderEffectType.Rounded,
          upDownScaleAmount: 50,
          radiusAmount: 50,
          direction: SliderDrawerDirection.LTR,
        ),
        drawer: CustomDrawer(),
        body: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                drawerKey.currentState!.toggleDrawer();
              },
              child: Icon(Icons.menu),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  drawerKey.currentState!.toggleDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Icon(Icons.menu),
                ),
              ),
            ],
          ),
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: toggleBackgroundImage,
                      child: Text('Change Drawer Background')),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(
                      100,
                      (index) => Container(
                        padding: const EdgeInsets.all(15),
                        child: Text("$index Contents "),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ));
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  Widget _thumbnailPart() {
    return Row(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: CircleAvatar(
            backgroundImage:
                Image.asset("assets/default_user.png", fit: BoxFit.contain)
                    .image,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Sudarlife",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                Text(
                  "Boys, be ambitious",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget get _line => Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      height: 1,
      color: Colors.white.withOpacity(0.2));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _thumbnailPart(),
            SizedBox(height: 20),
            _line,
            MenuBox(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              icon: Icon(
                Icons.add_chart,
                color: Colors.white,
              ),
              menu: Text(
                "Chart",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            MenuBox(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              icon: Icon(
                Icons.add_to_photos_outlined,
                color: Colors.white,
              ),
              menu: Text(
                "Photos",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            MenuBox(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              icon: Icon(
                Icons.announcement_rounded,
                color: Colors.white,
              ),
              menu: Text(
                "Service center",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            MenuBox(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              menu: Text(
                "Setting",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuBox extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final Widget menu;
  final Function()? onTap;
  const MenuBox({
    Key? key,
    required this.menu,
    this.padding = const EdgeInsets.all(10),
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          this.onTap!();
        }
      },
      child: Container(
        padding: padding,
        child: Row(
          children: [
            icon != null ? icon! : Container(),
            SizedBox(width: 15),
            menu,
          ],
        ),
      ),
    );
  }
}
