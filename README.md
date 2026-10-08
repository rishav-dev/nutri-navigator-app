# NutriNavigator (Flutter client)

Flutter client for NutriNavigator, a nutrition app concept for university dining: meal recommendations built around a student's class schedule and the dining locations on campus. NutriNavigator is one of the ventures at [Kinnovation](https://kinnovationgroup.com), a venture studio I co-founded.

## Status

This is a front-end prototype. The screens, navigation, and layouts are implemented, and the data behind them is sample data defined in the app. There is no backend connected, and the API keys listed in `env.example.json` are not used by any code in `lib/` yet.

## How it was built

The initial scaffold was generated with [Rocket.new](https://rocket.new), a prompt-based Flutter generator, and then committed here. The repository history is short: the initial commit and the commit that added the generated app. I am not presenting the generated screens as hand-written code.

## Screens

| Screen | What it shows |
|---|---|
| Main dashboard | Greeting, quick stats, meal recommendation cards, and a timeline of the day's schedule |
| Meal recommendations | Recommendation list with filters |
| Dining location details | Menu, hours, wait-time chart, photos, and reviews |
| Meal history | Timeline of past meals, date-range selector, and summary charts |
| Schedule integration | Calendar connection, meal timing preferences, and notification settings |

## Stack

Flutter and Dart, with `sizer` for responsive layout, `fl_chart` for charts, `google_fonts`, `dio`, `shared_preferences`, and `cached_network_image`.

## Run it

Requires the Flutter SDK (Dart 3.6 or later).

```bash
flutter pub get
flutter run
```

To supply configuration later, copy `env.example.json` to `env.json` and fill in your own values. `env.json` is ignored by git.

## Structure

```
lib/
  main.dart
  core/            shared exports
  presentation/    one folder per screen, each with its own widgets/
  routes/          named routes
  theme/           app theme
  widgets/         shared components
```
