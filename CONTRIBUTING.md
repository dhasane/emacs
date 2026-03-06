# Contributing

## Configuration changes require tests

When adding or modifying configuration behavior, include or update ERT tests in `tests/config/`.

- Add a module test file if one does not exist (`<module>-test.el`)
- Update existing tests when behavior changes
- Cover observable behavior (startup effects, user-visible outcomes)

## Run tests before submitting

Use the canonical command:

```bash
./scripts/run-config-tests.sh
```

Pull requests that change config files should include matching test coverage.
