;;; profiling.el --- File-open profiling utilities -*- lexical-binding: t; -*-
;;; Commentary:
;;; Latency tracking and profiling commands for opening files.

;;; Code:

(defcustom dh/file-open-latency-threshold 1.0
  "Seconds before file-open latency is reported in the echo area."
  :type 'number
  :group 'files)

(defcustom dh/file-open-latency-max-samples 200
  "Maximum number of file-open latency samples to retain."
  :type 'integer
  :group 'files)

(defvar dh/file-open-latency-samples nil
  "Recent file-open latency samples.")

(defun dh/file-open--record-sample (file seconds &optional hooks)
  "Record FILE open duration SECONDS and optional HOOKS breakdown."
  (let ((sample (list :file file :seconds seconds :time (current-time-string) :hooks hooks)))
    (push sample dh/file-open-latency-samples)
    (when (> (length dh/file-open-latency-samples) dh/file-open-latency-max-samples)
      (setcdr (nthcdr (1- dh/file-open-latency-max-samples) dh/file-open-latency-samples) nil))
    (when (> seconds dh/file-open-latency-threshold)
      (message "slow file open: %.3fs %s" seconds file))))

(defun dh/file-open-latency-clear ()
  "Clear collected file-open latency samples."
  (interactive)
  (setq dh/file-open-latency-samples nil)
  (message "Cleared file-open latency samples."))

(defun dh/file-open-latency-report ()
  "Show recorded file-open latency samples, slowest first."
  (interactive)
  (if dh/file-open-latency-samples
      (with-help-window "*File Open Latency*"
        (princ "seconds\twhen\t\t\tfile\n")
        (dolist (sample (sort (copy-sequence dh/file-open-latency-samples)
                              (lambda (a b) (> (plist-get a :seconds)
                                               (plist-get b :seconds)))))
          (princ (format "%.3f\t%s\t%s\n"
                         (plist-get sample :seconds)
                         (plist-get sample :time)
                         (plist-get sample :file)))))
    (message "No file-open latency samples recorded yet.")))

(defun dh/file-open-latency-report-detailed ()
  "Show latency samples with per-hook timings when captured."
  (interactive)
  (if dh/file-open-latency-samples
      (with-help-window "*File Open Latency Detailed*"
        (dolist (sample (sort (copy-sequence dh/file-open-latency-samples)
                              (lambda (a b) (> (plist-get a :seconds)
                                               (plist-get b :seconds)))))
          (princ (format "%.3fs  %s  %s\n"
                         (plist-get sample :seconds)
                         (plist-get sample :time)
                         (plist-get sample :file)))
          (let ((hooks (plist-get sample :hooks)))
            (if hooks
                (dolist (hook hooks)
                  (princ (format "  - %s: %.3fs\n" (car hook) (cdr hook))))
              (princ "  - hook timing: n/a\n")))
          (princ "\n")))
    (message "No file-open latency samples recorded yet.")))

(defun dh/profile-open-file (file)
  "Profile opening FILE and show a CPU profile report."
  (interactive "fProfile open file: ")
  (require 'profiler)
  (profiler-start 'cpu)
  (let ((start (float-time)))
    (unwind-protect
        (with-current-buffer (find-file-noselect file t)
          (set-buffer-modified-p nil))
      (profiler-stop)
      (profiler-report)
      (message "profiled open: %.3fs %s" (- (float-time) start) file))))

(defun dh/file-open-latency--advice (orig filename &rest args)
  "Measure latency for ORIG file open with FILENAME and ARGS."
  (let ((start (float-time)))
    (prog1
        (apply orig filename args)
      (when (stringp filename)
        (dh/file-open--record-sample filename (- (float-time) start))))))

(advice-add 'find-file-noselect :around #'dh/file-open-latency--advice)

(provide 'profiling)
;;; profiling.el ends here
