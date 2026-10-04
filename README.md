# Shortest Path Finder

A Flutter app that loads grid tasks from an API, finds the shortest path for
each of them, sends the results back and shows the paths on the grid.

## Screens

1. **Home** – enter the API URL (GET parameters are supported). An invalid URL
   shows an error; a valid one is saved and reused on the next launch.
2. **Process** – loads the tasks, solves them while the percent grows, then
   offers to send the results. The button is locked while sending; a failure
   shows the error text and unlocks the button.
3. **Result list** – every result as a path, e.g. `(0,3)->(1,2)->(2,1)->(3,0)`.
4. **Preview** – the grid of the tapped result: start `#64FFDA`, end `#009688`,
   blocked `#000000`, path `#4CAF50`, empty `#FFFFFF`, coordinates in each cell.
   Large grids (up to 99x99) scroll in both directions.

## Run

Built with Flutter 3.41.0.

```
flutter pub get
flutter run
```

API URL used by the task: `https://flutter.webspark.dev/flutter/api`

## Test

```
flutter analyze
flutter test
```

## Algorithm

`BfsPathFinder` is a breadth-first search written from scratch. A piece moves
one cell per step in any of the eight directions and cannot enter blocked
cells. The search spreads from the start one step at a time, so the first
time it reaches the end cell the path is the shortest. It remembers where
each cell was reached from and walks back from the end to restore the path.
Every cell is visited once, so a 99x99 grid takes a few milliseconds.

`x` is the column and `y` is the row, counted from the top-left cell `(0,0)`.

## Architecture

Clean architecture, one feature, `flutter_bloc` cubits, `get_it` for
dependency injection.

```
lib/
  app/                      MaterialApp, dependency injection
  core/
    constants/              strings, sizes, colours, durations
    error/                  application exceptions
    network/                HTTP client, API response
    utils/                  URL validation
  features/path_finder/
    domain/
      entities/             Cell, Grid, PathTask, PathResult
      repositories/         repository contracts
      services/             PathFinder and its BFS implementation
      usecases/             TaskSolver
    data/
      models/               JSON models (json_serializable)
      datasources/          remote API, local URL storage
      repositories/         repository implementations
    presentation/
      cubit/                HomeCubit, ProcessCubit and their states
      pages/                the four screens
      widgets/              shared widgets
```

The presentation layer depends only on the domain; the data layer implements
the domain contracts and converts API models to entities.

After changing a model, regenerate the JSON code:

```
dart run build_runner build --delete-conflicting-outputs
```
