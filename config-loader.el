;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; funciones para cargar archivos de elisp

;;; code:

(require 'cl-lib)

(defvar cl/find-file-hook-table (make-hash-table :test 'equal)
  "Internal storage mapping extensions to their find-file hook functions.")
(defvar cl/lazy-file-hook-table (make-hash-table :test 'equal)
  "Internal storage for cl/lazy-load-file-once hooks.")
(defvar cl/lazy-loaded-extensions (make-hash-table :test 'equal)
  "Extensions already loaded via cl/lazy-load-file-once.")
(defvar cl/lazy-extension-files (make-hash-table :test 'equal)
  "Extensions mapped to config files pending lazy load.")
(defvar cl/loaded-config-files nil
  "List of config files loaded via `cl/load`.")
(defvar pre-file-load-hook nil
  "Hook run before Emacs selects a major mode for a file buffer.")
(defvar cl/lazy-mode-hook-refresh-buffers nil
  "Buffers that should have their mode hooks re-run after lazy config loads.")

(defun cl/expand-name (file)
  "Expand FILE relative to `user-emacs-directory`."
  (expand-file-name file user-emacs-directory))

(defun remove-nth (n list)
  "Remove the Nth element from LIST."
  (if (> n (length list))
      list
    (append (cl-subseq list 0 n)
            (cl-subseq list (1+ n)))))

(defun cl/build-ignore-list (dir-name ignore lazy alt)
  "Build ignore list for DIR-NAME using IGNORE, LAZY, and ALT."
  (let* ((dir (cl/expand-name (concat dir-name "/")))
         (lazy-to-ignore (if lazy (cl/lazy-load dir-name lazy)))
         (alt-to-ignore (flatten-tree
                         (mapcar #'(lambda (x) (remove-nth (car x) (cdr x)))
                                 alt)))
         (all-to-ignore (flatten-tree (list ignore lazy-to-ignore alt-to-ignore))))
    (message "ignored: %s" all-to-ignore)
    (list dir (mapcar #'(lambda (x) (concat dir x)) all-to-ignore))))

(defun cl/dir-files (dir)
  "Return all non-dot files in DIR without extensions."
  (mapcar #'file-name-sans-extension
          (directory-files dir t "^\\([^.]\\|\\.[^.]\\|\\.\\..\\)")))

(cl-defun cl/dir (dir-name &key alt ignore lazy)
  "Return config file basenames for DIR-NAME using IGNORE, ALT, and LAZY."

  (let* ((data (cl/build-ignore-list dir-name ignore lazy alt))
         (dir (car data))
         (ignore-exp (cadr data)))
    (seq-uniq ;; if a file has been compiled, it will appear 2 times
     (cl-remove-if (lambda (r) (member r ignore-exp))
                   (cl/dir-files dir))))
  )

(defun cl/file (filename)
  "Return a list containing FILENAME expanded under `user-emacs-directory`."
  (let ((file (cl/expand-name filename)))
    (list file)))

(defun cl/load (&rest filelist)
  "Load FILELIST, a list (or list of lists) of full file paths."
  (let ((files (flatten-tree filelist)))
    (dolist (f files)
      (condition-case err
	  (cl/load-file f)
        (error (message "Error loading %s: \"%s\"" f
                        (error-message-string err))
               nil)))))

(defun cl/show-loaded-config-files ()
  "Display config files loaded via `cl/load`."
  (interactive)
  (if cl/loaded-config-files
      (with-help-window "*Loaded Config Files*"
        (princ (mapconcat #'identity cl/loaded-config-files "\n")))
    (message "No config files loaded yet.")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;        lazy loading of files        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun cl/lazy-load (dir-name lazy)
  "Register lazy config files in DIR-NAME based on LAZY entries."
  (flatten-tree
   (mapcar (lambda (elem)
            (let ((exts (flatten-tree (car elem)))
                  (to-load (flatten-tree (cdr elem))))
              (dolist (ext exts)
                (dolist (file to-load)
                  (cl/lazy-load-file-once ext (concat dir-name "/" file))))
              to-load))
          lazy)))

(defun cl/load-lazy-file (extension)
  "Load lazy config files for EXTENSION on first visit."
  (when (and (stringp buffer-file-name)
	     (string-match (concat "\\." (regexp-quote extension) "\\'")
			   buffer-file-name)
	     (not (gethash extension cl/lazy-loaded-extensions)))
    (puthash extension t cl/lazy-loaded-extensions)
    (remove-hook 'pre-file-load-hook
                 (gethash extension cl/lazy-file-hook-table))
    (remhash extension cl/lazy-file-hook-table)
    (cl-pushnew (current-buffer) cl/lazy-mode-hook-refresh-buffers)
    (let ((to-load (gethash extension cl/lazy-extension-files)))
      (remhash extension cl/lazy-extension-files)
      (dolist (lazy-file (reverse to-load))
        (cl/load-file lazy-file)
	(cl/load-packages-from-package-manager)
	)))
  )

(defun cl/lazy-load-file-once (ext config-file)
  "Load CONFIG-FILE the first time a file with extension EXT is visited."
  (let* ((extension (cl/normalize-extension ext))
         (file (expand-file-name config-file user-emacs-directory))
         (existing (gethash extension cl/lazy-file-hook-table)))
    (unless (gethash extension cl/lazy-loaded-extensions)
      (let* ((files (gethash extension cl/lazy-extension-files))
             (updated-files (seq-uniq (cons file files))))
        (puthash extension updated-files cl/lazy-extension-files)
        (unless existing
          (let ((hook (lambda () (cl/load-lazy-file extension))))
            (puthash extension hook cl/lazy-file-hook-table)
            (add-hook 'pre-file-load-hook hook)))))))

(defun cl/run-pre-file-load-hook ()
  "Run `pre-file-load-hook' before selecting a major mode for a file buffer."
  (when (and (stringp buffer-file-name)
             (not (minibufferp)))
    (run-hooks 'pre-file-load-hook)))

(advice-add 'set-auto-mode :before #'cl/run-pre-file-load-hook)

(defun cl/refresh-mode-hooks-after-lazy-load ()
  "Re-run the major mode hook after lazy loading for the current buffer."
  ;; (message "calling refresh: %s" cl/lazy-mode-hook-refresh-buffers)
  (when (memq (current-buffer) cl/lazy-mode-hook-refresh-buffers)
    (message "Reloading after lazy")
    (setq cl/lazy-mode-hook-refresh-buffers
          (delq (current-buffer) cl/lazy-mode-hook-refresh-buffers))
    (let* ((mode (assoc-default buffer-file-name auto-mode-alist #'string-match-p))
           (hook (intern (concat mode "-hook"))))
      (print (format "Loading: %s" hook))
      (when (boundp hook)
        (run-hooks hook)))))

(add-hook 'find-file-hook #'cl/refresh-mode-hooks-after-lazy-load)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                   helper                                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun cl/load-packages-from-package-manager ()
  "Trigger package manager processing after loading a config file."
  (if (featurep 'elpaca)
      (dh/elpaca-wait-maybe))
  )

(defun cl/load-file (file)
  "Byte-compile and load FILE, then record it in `cl/loaded-config-files`."
  (byte-compile file)
  (load file)
  (add-to-list 'cl/loaded-config-files file)
  (cl/load-packages-from-package-manager)
  )

(defun cl/normalize-extension (ext)
  "Normalize extension EXT by removing any leading dot."
  (if (string-prefix-p "." ext) (substring ext 1) ext))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;        compile / maybe remove       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; TODO: arreglar para native-compile
;; https://stackoverflow.com/questions/20952894/what-emacs-lisp-function-is-to-require-as-autoload-is-to-load

(defun cl/comp-dir (dir-name compile)
  "Compile files listed in COMPILE within DIR-NAME.
Remove compiled files not present in COMPILE."
  (mapc #'(lambda (x) (cl/clean-compile (file-name-sans-extension x)))
        (cl-remove-if (lambda (r) (member (file-name-base r) compile))
                      (directory-files dir-name t ".elc$")))

  (mapc #'(lambda (x)
            (cl/compile-file
             (concat dir-name x)))
        compile)
  )

(defun cl/comp-file (file compile)
  "Compile FILE when COMPILE is non-nil."
  (if compile
      (cl/compile-file file)
    (cl/clean-compile file))
  )

(defun cl/clean-compile (filename)
  "Remove compiled version of FILENAME."
  (let ((file (concat filename ".elc")))
    (if (file-exists-p file)
        (progn
          (print (format "deleting: %s" file))
          (delete-file file)
          ))))

(defun cl/compile-file (filename)
  "Compile FILENAME if the compiled file is missing or stale."
  (print (format ";;; %s" filename))
  (let ((file (concat filename ".el"))
        (compfile (concat filename ".elc")))
    (if (or (not (file-exists-p compfile))
            (file-newer-than-file-p file compfile))
        (progn
          (message (concat "compiling: " file))
          (byte-compile-file file))
      ;; (message "all is gud")
      )))


(provide 'config-loader)
;;; config-loader.el ends here
