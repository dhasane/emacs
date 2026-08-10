;;; feed.el --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package elfeed
  :demand t
  :commands (elfeed)
  :hook (elfeed-show-mode . olivetti-mode)
  :custom
  (elfeed-search-filter "@6-months-ago +unread")
  :config
  (defun dh/elfeed-update-and-open ()
    "Reload elfeed-org tags, open the search buffer, and refresh all feeds."
    (interactive)
    (elfeed-org)
    (elfeed)
    (elfeed-update))
  )

(use-package elfeed-org
  :after elfeed
  :demand t
  :custom
  (rmh-elfeed-org-files
   (mapcar #'(lambda (x) (expand-file-name x user-emacs-directory))
	   (list "settings/elfeed.org")))
  :config
  (elfeed-org)
  )

;;; feed.el ends here
