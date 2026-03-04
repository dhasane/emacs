;;; file-open-performance-test.el --- Measure file-open latency -*- lexical-binding: t; -*-

(require 'test-helper)

(defun dh/measure-open-file-seconds (file)
  "Return seconds required to open FILE in a buffer."
  (let ((start (float-time)))
    (with-current-buffer (find-file-noselect file t)
      (set-buffer-modified-p nil)
      (kill-buffer (current-buffer)))
    (- (float-time) start)))

(defconst dh/file-open-language-samples
  '(("el" . "(defun hello ()\n  (message \"hi\"))\n")
    ("py" . "def hello():\n    return 'hi'\n")
    ("js" . "function hello() { return 'hi'; }\n")
    ("go" . "package main\nfunc main() {}\n")
    ("rs" . "fn main() { println!(\"hi\"); }\n")
    ("ts" . "const hello = (): string => 'hi'\n"))
  "Language extension/content pairs for open-file latency tests.")

(ert-deftest config-open-file-in-buffer-measures-latency ()
  (let* ((temp-file (make-temp-file "dh-open-file-latency-" nil ".txt"))
         (content (concat (make-string 1024 ?a) "\n" (make-string 1024 ?b) "\n"))
         (elapsed nil))
    (unwind-protect
        (progn
          (with-temp-file temp-file
            (insert content))
          (setq elapsed (dh/measure-open-file-seconds temp-file))
          (message "config benchmark: open file in buffer = %.6fs" elapsed)
          (should (numberp elapsed))
          (should (>= elapsed 0.0)))
      (when (file-exists-p temp-file)
        (delete-file temp-file)))))

(ert-deftest config-open-file-by-language-measures-latency ()
  (let (results)
    (dolist (sample dh/file-open-language-samples)
      (let* ((ext (car sample))
             (content (cdr sample))
             (temp-file (make-temp-file "dh-open-file-lang-" nil (concat "." ext)))
             (elapsed nil))
        (unwind-protect
            (progn
              (with-temp-file temp-file
                (insert content))
              (setq elapsed (dh/measure-open-file-seconds temp-file))
              (push (cons ext elapsed) results)
              (should (numberp elapsed))
              (should (>= elapsed 0.0)))
          (when (file-exists-p temp-file)
            (delete-file temp-file)))))
    (setq results (nreverse results))
    (message "config benchmark: open by language = %s"
             (mapconcat (lambda (entry)
                          (format "%s=%.6fs" (car entry) (cdr entry)))
                        results
                        ", "))
    (should (= (length results) (length dh/file-open-language-samples)))))

(provide 'file-open-performance-test)
;;; file-open-performance-test.el ends here
