;;; feed.el --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package elfeed
  :demand t
  :commands (elfeed)
  :hook (elfeed-show-mode . olivetti-mode)
  :custom
  (elfeed-search-filter "@6-months-ago +unread")
  :hook (elfeed-show-mode . (lambda ()
                             (setq-local browse-url-browser-function #'eww-browse-url)))
  :config
  (defun dh/elfeed-update-and-open ()
    "Reload elfeed-org tags, open the search buffer, and refresh all feeds."
    (interactive)
    (elfeed-org)
    (elfeed)
    (elfeed-update))

  (defun dh/elfeed-remove-feed ()
    "Select a feed from `elfeed-feeds' and remove it from the elfeed org file."
    (interactive)
    (let* ((feeds (mapcar (lambda (f)
                            (let ((url (if (listp f) (car f) f)))
                              (cons (or (elfeed-meta (elfeed-db-get-feed url) :title) url)
                                    url)))
                          elfeed-feeds))
           (selection (completing-read "Remove feed: " feeds nil t))
           (url (cdr (assoc selection feeds)))
           (org-file (car rmh-elfeed-org-files)))
      (with-current-buffer (find-file-noselect org-file)
        (goto-char (point-min))
        (when (re-search-forward (regexp-quote url) nil t)
          (beginning-of-line)
          (let ((beg (point)))
            (forward-line 1)
            (delete-region beg (point)))
          (save-buffer)
          (delete-directory elfeed-db-directory t)
          (elfeed-db-load)
          (elfeed-org)
          (when (buffer-live-p (get-buffer "*elfeed-search*"))
            (with-current-buffer "*elfeed-search*"
              (elfeed-search-update--force)))
          (message "Removed feed: %s" selection)))))
  )

(use-package eww
  :defer t
  :ensure nil
  :hook (eww-after-render . eww-readable))

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
