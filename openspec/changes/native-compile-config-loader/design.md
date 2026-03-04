## Context

`config-loader.el` centralizes config loading via `cl/load-file` and currently byte-compiles before loading. Emacs has native compilation available, and the project already sets native-comp variables in `modules/conf/basic.el`, but config-loader does not explicitly trigger native compilation for files it loads.

## Goals / Non-Goals

**Goals:**
- Add an explicit user option to enable native compilation for config-loader loads.
- Trigger native compilation for each file loaded by `cl/load-file` when enabled.
- Preserve current behavior by default.

**Non-Goals:**
- Changing the broader package compilation strategy.
- Managing or cleaning native-compiled artifacts beyond Emacs defaults.
- Retrofitting native compilation for previously loaded files.

## Decisions

### Decision 1: Add an opt-in variable in config-loader

Introduce a defcustom (e.g., `cl/native-compile-on-load`) that defaults to nil. `cl/load-file` will check this flag and call `native-compile` if available. This keeps behavior explicit and avoids surprises.

### Decision 2: Prefer native compilation after load

Trigger `native-compile` after `load` to minimize any potential blocking of file load. If `native-compile` is unavailable (older Emacs), the option will be ignored gracefully.
