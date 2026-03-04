## Why

Config-loader currently loads and byte-compiles config files but does not support native compilation in its load path. Adding native compilation for loaded files makes the loader align with Emacs native-comp capabilities while keeping the behavior explicit and optional.

## What Changes

- Add a user option to enable native compilation for config-loader loads.
- When enabled, native-compile each config file loaded by `cl/load-file`.
- Preserve current behavior by default.

## Capabilities

### New Capabilities
- `native-compile-config-loader`: enable native compilation for config files loaded by config-loader.

### Modified Capabilities
- `config-loader`: loaded config files may also be native-compiled when the option is enabled.

## Impact

- `config-loader.el`: add option and integrate native compilation into `cl/load-file`.
