
;; status line information
(setq-default
 mode-line-format
 (list
  mode-line-misc-info ; for eyebrowse
  ;; '(eyebrowse-mode (:eval (eyebrowse-mode-line-indicator)))
  ;; (setcdr (assq 'vc-mode mode-line-format)
  ;; '((:eval (replace-regexp-in-string "^ Git" " " vc-mode))))
  '(:eval (when-let (vc vc-mode)
            (list
             " "
             (replace-regexp-in-string "^ Git:" "" vc-mode)
             " "
             ) ) )
  '(:eval (list
           ;; the buffer name; the file name as a tool tip
           (propertize
            " %b"
            'help-echo (buffer-file-name))
           (when (buffer-modified-p)
             (propertize
              " "
              ) )
           (when buffer-read-only
             (propertize
              " "
              ) ) " " ) )
  ;; spaces to align right
  '(:eval (propertize
           " " 'display
           `(
             (space :align-to (- (+ right right-fringe right-margin)
                                 ,(+
                                   3
                                   (string-width mode-name)
                                   3
                                   (string-width (projectile-project-name))
                                   )
                                 )
                    )
              ) ) )

  ;; para mostrar el nombre del proyecto en el que se esta trabajando
  '(:eval (list
           ;; the buffer name; the file name as a tool tip
           (propertize
            ;;(projectile-project-name)
            (format "[%s]" (projectile-project-name))
            )
           " " ) )

  ;; the current major mode
  (propertize " %m " )
  )
 )
