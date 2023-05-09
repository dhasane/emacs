;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; Config for straight package manager

;;; code:

;; tambien funciona con emacs-ng
;; (unless (fboundp 'ng-bootstrap-straight)
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage)) ;; )

(straight-use-package 'el-patch)
(straight-use-package 'use-package)

(setq straight-use-package-by-default t)

;;; straight.el ends here
