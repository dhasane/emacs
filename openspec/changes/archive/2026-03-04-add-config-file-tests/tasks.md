## 1. Test Framework Setup

- [x] 1.1 Create test directory and naming convention for per-config ERT test files
- [x] 1.2 Add shared ERT helpers/fixtures for consistent config test bootstrapping
- [x] 1.3 Document the canonical command to run config ERT tests locally

## 2. Baseline Config Test Coverage

- [x] 2.1 Identify phase-one critical configuration modules to cover first
- [x] 2.2 Add ERT test files for each selected module with startup and behavior assertions
- [x] 2.3 Update existing module tests when config behavior changes to prevent regressions

## 3. CI Integration and Enforcement

- [x] 3.1 Wire config ERT command into CI validation workflow
- [x] 3.2 Fail CI on config ERT failures and verify failure reporting is actionable
- [x] 3.3 Add contributor guidance requiring tests for new or modified config modules

## 4. Validation and Rollout

- [x] 4.1 Run full config ERT suite locally and fix flaky/state-dependent tests
- [x] 4.2 Run CI with config ERT enabled and confirm stable pass/fail behavior
- [x] 4.3 Plan incremental expansion from phase-one modules to full config coverage
