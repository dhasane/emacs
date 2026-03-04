;;; basic-test.el --- Tests for modules/conf/basic.el -*- lexical-binding: t; -*-

(require 'test-helper)
(load-file (dh/config-test-path "modules/conf/basic.el"))
(load-file (dh/config-test-path "modules/conf/profiling.el"))

(ert-deftest basic-large-file-hook-sets-read-only-for-large-buffers ()
  (with-temp-buffer
    (insert (make-string (+ (* 1024 1024) 1) ?a))
    (let ((buffer-read-only nil))
      (my-find-file-check-make-large-file-read-only-hook)
      (should buffer-read-only))))

(ert-deftest basic-large-file-hook-keeps-small-buffers-editable ()
  (with-temp-buffer
    (insert "small")
    (let ((buffer-read-only nil))
      (my-find-file-check-make-large-file-read-only-hook)
      (should-not buffer-read-only))))

(ert-deftest basic-file-open-record-sample-respects-max-size ()
  (let ((dh/file-open-latency-samples nil)
        (dh/file-open-latency-max-samples 2)
        (dh/file-open-latency-threshold 9999))
    (dh/file-open--record-sample "a.el" 0.1)
    (dh/file-open--record-sample "b.el" 0.2)
    (dh/file-open--record-sample "c.el" 0.3)
    (should (= 2 (length dh/file-open-latency-samples)))
    (should (equal "c.el" (plist-get (car dh/file-open-latency-samples) :file)))
    (should (equal "b.el" (plist-get (cadr dh/file-open-latency-samples) :file)))))

(provide 'basic-test)
;;; basic-test.el ends here
