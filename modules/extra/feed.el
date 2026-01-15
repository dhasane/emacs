;;; feed.el --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package elfeed
  :demand t
  :commands (elfeed)
  :custom
  (elfeed-search-filter "@6-months-ago +unread")
  :config
  (defun dh/elfeed-update-and-open ()
    "Reload elfeed-org tags and refresh elfeed feeds."
    (interactive)
    (when (fboundp 'elfeed-org)
      (elfeed-org))
    (elfeed-update)
    (elfeed)
    )
  )

(use-package elfeed-org
  :after elfeed
  :demand t
  :custom
  (rmh-elfeed-org-files (list "~/.emacs.d/elfeed.org"))
  :config
  (elfeed-org)
  )

;;; feed.el ends here
