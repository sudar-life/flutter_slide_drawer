# flutter_slide_drawer

A Flutter package, It would help you make has slide effect drawer easy.

## Getting Started

To start using this package, add `flutter_slide_drawer` dependency to your `pubspec.yaml`

```yaml
dependencies:
    flutter_slide_drawer: '<latest_release>'
```

## Documentation

### SliderDrawerWidget

```dart
    SliderDrawerWidget(
        key: drawerKey,
        option: SliderDrawerOption(),
        drawer: CustomDrawer(),
        body: Scaffold(
          appBar: AppBar(),
          body: Container(),
        )
    )
```

| Parameters | Value                                | Required | Docs                         |
| ---------- | ------------------------------------ | :------: | ---------------------------- |
| `key`      | `GlobalKey<SliderDrawerWidgetState>` |   YES    | Required to open drawer.     |
| `drawer`   | `Widget`                             |   YES    | Custom Widget to use drawer  |
| `body`     | `Widget`                             |   YES    | Body Widget                  |
| `option`   | `SliderDrawerOption`                 |    No    | You can set several options. |

---

### SliderDrawerOption

```dart
    SliderDrawerOption(
      backgroundImage: Image.asset("assets/sample_background.jpg"),
      backgroundColor: Colors.black,
      sliderEffectType: SliderEffectType.Rounded,
      upDownScaleAmount: 50,
      radiusAmount: 50,
      direction: SliderDrawerDirection.LTR,
    )
```

| Parameters          | Value                   | Required | Docs                                                                                                         |
| ------------------- | ----------------------- | :------: | ------------------------------------------------------------------------------------------------------------ |
| `backgroundImage`   | `Image Widget`          |    No    | be covered Background Image in Drawer                                                                        |
| `backgroundColor`   | `Color`                 |    No    | background Color in Drawer (default Color is blue)                                                           |
| `sliderEffectType`  | `SliderEffectType`      |    No    | Slide push Effect Type ( Rounded , Rectangle)                                                                |
| `upDownScaleAmount` | `double`                |    No    | If you use SliderEffectType.Runded then you can use this parameters. It make margin Vertical in Scaffold     |
| `radiusAmount`      | `double`                |    No    | If you use SliderEffectType.Runded then you can use this parameters. It make as amount as radius in Scaffold |
| `direction`         | `SliderDrawerDirection` |    No    | Drawer direction option, default is SliderDrawerDirection.LTR                                                |

---

## Screens

### Using Background Image And Rounded Type

![Example App Demo2](https://user-images.githubusercontent.com/36467891/125026234-19bb1b00-e0bf-11eb-8273-dd617d9735db.gif)

### Default FlutterSliderWidget

![Example app Demo](https://user-images.githubusercontent.com/36467891/125026222-158efd80-e0bf-11eb-882c-cf1a28b3f368.gif)
