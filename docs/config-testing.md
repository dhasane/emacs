# Config Testing

This repository uses ERT for configuration regression tests.

## Phase-one critical config modules

- `config-loader.el`
- `modules/conf/basic.el`
- `modules/pack.el`

These modules cover startup/config loading behavior and core setup helpers.

## Test layout and naming convention

- Config tests live in `tests/config/`
- One test file per config module, named `<module>-test.el`
- Shared fixtures/helpers live in `tests/config/test-helper.el`
- Batch entry point is `tests/config/run-config-tests.el`

## Local command

Run the config test suite with:

```bash
./scripts/run-config-tests.sh
```

This command is the canonical local and CI entry point.

## Coverage expansion plan

1. Add tests for additional files under `modules/conf/`
2. Add tests for language modules under `modules/langs/`
3. Add tests for startup/package modules where behavior can be isolated
4. Keep new config changes test-first for touched modules
