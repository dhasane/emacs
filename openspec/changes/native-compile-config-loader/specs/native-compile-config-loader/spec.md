## ADDED Requirements

### Requirement: Optional native compilation for config-loader

When enabled, config-loader should native-compile each config file it loads without altering the existing load behavior when disabled.

#### Scenario: Native compilation enabled

- **WHEN** the native compilation option is enabled
- **AND** `cl/load-file` loads a config file
- **THEN** the file is native-compiled

#### Scenario: Native compilation disabled (default)

- **WHEN** the native compilation option is disabled
- **AND** `cl/load-file` loads a config file
- **THEN** the file is loaded with existing behavior only
- **AND** no native compilation is triggered
