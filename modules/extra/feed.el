;;; feed.el --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package elfeed
  :demand t
  :commands (elfeed)
  :hook (elfeed-show-mode . olivetti-mode)
  :custom
  (elfeed-search-filter "@6-months-ago +unread")
  (elfeed-search-separator-date-format "%A, %B %d %Y")
  :hook (elfeed-show-mode . (lambda ()
                             (setq-local browse-url-browser-function #'eww-browse-url)))
  :config
  (defun dh/elfeed-update-and-open ()
    "Reload elfeed-org tags, open the search buffer, and refresh all feeds."
    (interactive)
    (elfeed-org)
    (elfeed-tree)
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
      ;; Remove entries from the database
      (elfeed-delete-feed url)
      ;; Remove the line from the org file
      (with-current-buffer (find-file-noselect org-file)
        (goto-char (point-min))
        (when (re-search-forward (regexp-quote url) nil t)
          (beginning-of-line)
          (let ((beg (point)))
            (forward-line 1)
            (delete-region beg (point)))
          (save-buffer)))
      (elfeed-org)
      (when (buffer-live-p (get-buffer "*elfeed-search*"))
        (with-current-buffer "*elfeed-search*"
          (elfeed-search-update--force)))
      (message "Removed feed: %s" selection)))
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
  ;; Eagerly process the org file so tags are available immediately,
  ;; not just when `elfeed' command is first invoked.
  (rmh-elfeed-org-process rmh-elfeed-org-files rmh-elfeed-org-tree-id)
  )

(use-package elfeed-score
  :after elfeed
  :demand t
  :custom
  (elfeed-score-serde-score-file
   (expand-file-name "settings/elfeed-score.el" user-emacs-directory))
  :config
  (elfeed-score-enable)
  (define-key elfeed-search-mode-map "=" elfeed-score-map)

  ;; Sort by day first (newest on top), then by score within each day
  (defun dh/elfeed-score-sort-by-day (a b)
    "Sort by day first (newest day on top), then by score within each day."
    (let ((day-a (format-time-string "%Y-%m-%d" (elfeed-entry-date a)))
          (day-b (format-time-string "%Y-%m-%d" (elfeed-entry-date b))))
      (if (string= day-a day-b)
          (> (or (elfeed-meta a elfeed-score-scoring-meta-keyword) 0)
             (or (elfeed-meta b elfeed-score-scoring-meta-keyword) 0))
        (string> day-a day-b))))
  (setq elfeed-search-sort-function #'dh/elfeed-score-sort-by-day)

  )

;;; feed.el ends here
