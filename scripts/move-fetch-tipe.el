
(defalias 'macro-delete-type
   (kmacro "x d w"))

(defun isearch-line-forward (&optional regexp-p)
  (interactive)
  (let* ((beg (line-beginning-position))
         (end (line-end-position))
         (isearch-message-prefix-add "[Line]")
         (isearch-search-fun-function
          `(lambda ()
             (lambda (string &optional bound noerror)
               (save-restriction
                 (narrow-to-region ,beg ,end)
                 (funcall (isearch-search-fun-default)
                          string bound noerror))))))
    (isearch-forward regexp-p)))

(defun macro-cleanup ()
  (interactive)

  (atomic-change-group

    ;; (save-excursion
      (while (or (re-search-forward "api.*\n?.*.post" nil t)
                 (re-search-forward "api.*\n?.*.put" nil t)
                 (re-search-forward "api.*\n?.*.patch" nil t)
                 (re-search-forward "api.*\n?.*.delete" nil t)
                 (re-search-forward "api.*\n?.*.get" nil t)
                 (re-search-forward "api.*\n?.*.fetch" nil t)
                 )

        (re-search-backward "\\." nil t)
        (macro-delete-type)
        (if (not (isearch-line-forward "\\,"))
            (progn
              (isearch-line-forward "\\)"))

              )

            )
        )
      ;; )
    )
