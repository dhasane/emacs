;;; writting.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:

;;; code:

(use-package olivetti
  :hook ((org-mode . olivetti-mode)
         (fountain-mode . olivetti-mode))
  :custom
  (olivetti-body-width 0.65)
  (olivetti-minimum-body-width 120)
  (olivetti-body-width 100)
  (olivetti-style t)
  ;; :custom-face
  ;; (olivetti-fringe ((t (:background "#504945" :foreground "#fdf4c2"))))
  )

(use-package fountain-mode
  :mode ("\\.fountain\\'" . fountain-mode)
  )

(use-package darkroom
  :disabled t
  :hook (org-mode . darkroom-tentative-mode)
  :custom
  (darkroom-text-scale-increase 0)
  (darkroom-fringes-outside-margins 2)
  (darkroom-margins 'darkroom-guess-margins)

  :config
  (setq darkroom-disable-mode-line nil)

  (defun darkroom--enter (&optional just-margins)
    "Save current state and enter darkroom for the current buffer.
With optional JUST-MARGINS, just set the margins."
    (unless just-margins
      (setq darkroom--saved-state
            (mapcar #'(lambda (sym)
                        (cons sym (buffer-local-value sym (current-buffer))))
                    darkroom--saved-variables))
      (if darkroom-disable-mode-line
          (setq mode-line-format nil)
          )
      (setq header-line-format nil
            fringes-outside-margins darkroom-fringes-outside-margins)
      (text-scale-increase darkroom-text-scale-increase))
    (mapc #'(lambda (w)
              (with-selected-window w
                (darkroom--set-margins)))
          (get-buffer-window-list (current-buffer))))
  )

;;; writting.el ends here
