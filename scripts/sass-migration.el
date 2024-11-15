
;; created this to help migrate sass
(defalias 'macro-import-to-use
   (kmacro "0 f . h v b y A SPC a s SPC C-v <escape> I <right> C-<kp-delete> u s e <escape>"))

(defalias 'macro-delete
   (kmacro "h x"))

(defalias 'macro-add-variables
   (kmacro "b i v a r i a b l e s . <escape>"))

(defun macro-cleanup ()
  (interactive)

  (atomic-change-group
    (while (re-search-forward "@import" nil t)
      (macro-import-to-use)
      )

    (save-excursion
      (while (re-search-forward ";" nil t)
        (macro-delete)
        ;; (message "delete at %s" (line-number-at-pos))
        )
      (while (or
              (re-search-forward ":.*[[:space:]]\\$" nil t)
              (re-search-forward ":.*\(\\$" nil t)
              ;; (re-search-forward ":.*\{\\$" nil t)
              )
        (macro-add-variables)
        ;; (message "delete at %s" (line-number-at-pos))
        )
      )
    )
  )
