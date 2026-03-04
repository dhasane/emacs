## 1. Config-loader option

- [x] 1.1 Add a `defcustom` toggle for native compilation in `config-loader.el`.
- [x] 1.2 Ensure it defaults to disabled and is documented.

## 2. Native compilation hook-up

- [x] 2.1 Update `cl/load-file` to invoke `native-compile` when the toggle is on and the function is available.
- [x] 2.2 Guard the call so older Emacs versions don’t error.

## 3. Verify

- [ ] 3.1 Manually load a config file and confirm no errors when the toggle is off and on.
