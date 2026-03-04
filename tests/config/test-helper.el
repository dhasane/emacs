;;; test-helper.el --- Shared helpers for config tests -*- lexical-binding: t; -*-

(require 'ert)
(require 'cl-lib)

(defconst dh/config-test-root
  (expand-file-name "../../" (file-name-directory (or load-file-name buffer-file-name)))
  "Repository root for config tests.")

(defun dh/config-test-path (relative)
  "Build an absolute path from RELATIVE under the repository root."
  (expand-file-name relative dh/config-test-root))

(defmacro dh/with-test-state (&rest body)
  "Run BODY with config-loader global state reset."
  `(let ((cl/find-file-hook-table (make-hash-table :test 'equal))
         (cl/lazy-file-hook-table (make-hash-table :test 'equal))
         (cl/lazy-loaded-extensions (make-hash-table :test 'equal))
         (cl/lazy-extension-files (make-hash-table :test 'equal))
         (cl/lazy-mode-hook-refresh-buffers nil)
         (pre-file-load-hook nil))
     ,@body))

(provide 'test-helper)
;;; test-helper.el ends here
