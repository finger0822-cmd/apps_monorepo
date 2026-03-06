# AGENTS.md

## Cursor Cloud specific instructions

### Overview

Flutter/Dart monorepo containing multiple personal productivity/journaling apps. All apps are client-side Flutter applications with no backend servers. See individual `pubspec.yaml` files for each app's dependencies.

### Key apps (under `apps/`)

| App | Description | Linux desktop | Notes |
|-----|-------------|:---:|-------|
| `pulse_app` | Daily state/mood tracker | Yes | Uses Isar DB + `core_state` package |
| `particle_app` | Particle animation demo | Yes | Simplest app, no DB |
| `one_sentence_app` | One-sentence daily journal | Yes | Uses SharedPreferences |
| `boundary_app` | Task boundary organizer | Yes | Uses Isar DB + Riverpod |
| `one_minute_diary` | 1-min diary (dark) | Yes | Uses Isar DB + Riverpod |
| `one_minute_diary_app` | 1-min diary (light) | Yes | Uses Isar DB + Riverpod |

The `packages/core_state` shared package is a pure-Dart library used by `pulse_app`.

### Flutter SDK

Flutter SDK is installed at `/opt/flutter/bin/flutter`. It is added to PATH via `~/.bashrc`. The apps require Dart SDK `^3.10.8` (Flutter 3.38+).

### Running apps on Linux desktop

```bash
cd apps/<app_name>
flutter run -d linux
```

The `libEGL warning: DRI3 error` messages on startup are expected in environments without GPU acceleration and do not affect functionality.

### Lint / Analyze

```bash
# Per-app
cd apps/<app_name> && flutter analyze

# Pure Dart package
cd packages/core_state && dart analyze
```

Pre-existing warnings from Isar-generated `.g.dart` files (`experimental_member_use`) are expected and should not be fixed. `pulse_app` has WIP code in `lib/ui/next_screen.dart` that references an uninstalled `fl_chart` package.

### Tests

```bash
# core_state (pure Dart)
cd packages/core_state && dart test

# Flutter app tests
cd apps/<app_name> && flutter test
```

### Build gotcha (Linux desktop)

Clang on this VM needs `libstdc++-14-dev` for C++ standard library headers. This is installed as a system dependency. If `flutter build linux` fails with `'type_traits' file not found`, run: `sudo apt-get install -y libstdc++-14-dev`.

Also, `libstdc++.so` symlink must exist at `/usr/lib/x86_64-linux-gnu/libstdc++.so` for the linker. If missing: `sudo ln -sf /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so`.
