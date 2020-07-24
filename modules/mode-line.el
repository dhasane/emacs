

;;; code:

(eval-when-compile (require 'cl-lib))
;; change mode-line color by evil state
(lexical-let ((default-color (cons (face-background 'mode-line)
                                   (face-foreground 'mode-line))))
  (add-hook 'post-command-hook
            (lambda ()
              (let ((color (cond ((minibufferp) default-color)
                                 ((evil-insert-state-p) '("#73b3e7" . "#3e4249"))
                                 ((evil-normal-state-p) '("#a1bf78" . "#3e4249"))
                                 ((evil-replace-state-p)'("#d390e7" . "#3e4249"))
                                 ((evil-visual-state-p) '("#e77171" . "#3e4249"))

                                 ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                                 ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
                                 (t default-color))))
                (set-face-background 'mode-line (car color))
                (set-face-foreground 'mode-line (cdr color))))))


(defun get-project-name-except-if-remote ()
  (interactive)
  (if (file-remote-p default-directory)
      ""
    (projectile-project-name)
    )
  )

;; status line information
(setq-default mode-line-format
 (list
  mode-line-misc-info ; for eyebrowse
  ;; '(eyebrowse-mode (:eval (eyebrowse-mode-line-indicator)))
  ;; (setcdr (assq 'vc-mode mode-line-format)
  ;; '((:eval (replace-regexp-in-string "^ Git" " " vc-mode))))
  '(:eval (when-let (vc vc-mode)
            (list
             " "
             (replace-regexp-in-string "^ Git:" "" vc-mode)
             " "
             ) ) )
  '(:eval (list
           " "
                                        ; en caso de ser archivo remoto
           (when (file-remote-p default-directory) ":")
                                        ; nombre del archivo
           (propertize "%b" 'help-echo (buffer-file-name) )
                                        ; archivo modificado
           (when (buffer-modified-p) " " );;" "
                                        ; read only
           (when buffer-read-only " " )
           " "
           ) )
  '(:eval (propertize
           " " 'display
           `(
             (space :align-to
                    (- (+ right right-fringe right-margin)
                       ,(+
                         3
                         (string-width mode-name)
                         3
                         (string-width (get-project-name-except-if-remote))
                         )
                       )
                    ) ) ) )

  ;; para mostrar el nombre del proyecto en el que se esta trabajando
  '(:eval (propertize
           (format "[%s] " (get-project-name-except-if-remote) ) ) )

  ;; the current major mode
  (propertize " %m " )
  )
 )

