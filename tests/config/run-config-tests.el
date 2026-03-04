;;; run-config-tests.el --- Batch runner for config ERT tests -*- lexical-binding: t; -*-

(let* ((root (expand-file-name "../../" (file-name-directory (or load-file-name buffer-file-name))))
       (tests-dir (expand-file-name "tests/config" root)))
  (add-to-list 'load-path tests-dir)
  (load-file (expand-file-name "test-helper.el" tests-dir))
  (load-file (expand-file-name "config-loader-test.el" tests-dir))
  (load-file (expand-file-name "basic-test.el" tests-dir))
  (load-file (expand-file-name "pack-test.el" tests-dir))
  (load-file (expand-file-name "file-open-performance-test.el" tests-dir)))

(ert-run-tests-batch-and-exit t)

;;; run-config-tests.el ends here
