# AGENTS.md

## Cursor Cloud specific instructions

### Overview

Flutter/Dart monorepo with 8 independent Flutter apps under `apps/` and a shared package `packages/core_state`. The primary app is `pulse_app` (state-observation tracker). See `README.md` for the full list and structure.

### Prerequisites

- **Flutter SDK**: Installed at `/opt/flutter` (add `/opt/flutter/bin` to `PATH`).
- **Linux desktop build tools**: `ninja-build`, `cmake`, `clang`, `pkg-config`, `libgtk-3-dev`, `lld`, `llvm`, `g++-14`, `libstdc++-13-dev`, `xdg-user-dirs`.
- Run `xdg-user-dirs-update` before launching apps that use `path_provider` (e.g., `pulse_app`) — without this, `getApplicationDocumentsDirectory()` throws `MissingPlatformDirectoryException`.

### Running apps

Standard commands per `README.md`:

```
cd apps/<app_name>
flutter pub get
flutter run -d linux
```

#### Cloud environment caveats

- **GPU rendering**: This cloud VM has no GPU. Set `LIBGL_ALWAYS_SOFTWARE=1` and `GALLIUM_DRIVER=llvmpipe` before running desktop apps. Canvas-based apps (e.g., `particle_app`, `snow_blackhole`) may not render painted content despite launching successfully. Material UI apps (e.g., `pulse_app`) render correctly with software rendering.
- **`--enable-software-rendering`**: Pass this flag to `flutter run` for desktop targets.
- **`pulse_app` web build fails**: Isar uses `dart:ffi` and generates 64-bit integer literals incompatible with JavaScript. Only build `pulse_app` for Linux desktop, not web.
- **`after_app`**: Contains a vendored Flutter framework fork. Skip dependency resolution for `after_app` unless specifically needed.

### Lint / Test / Build

| Task | Command |
|------|---------|
| Lint (core_state) | `cd packages/core_state && dart analyze` |
| Lint (app) | `cd apps/<app> && flutter analyze` |
| Test (core_state) | `cd packages/core_state && dart test` |
| Test (app) | `cd apps/<app> && flutter test` |
| Build web | `cd apps/<app> && flutter build web` (only for apps without Isar/ffi) |
| Build Linux debug | `cd apps/<app> && flutter build linux --debug` |
