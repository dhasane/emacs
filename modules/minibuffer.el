
;;; code:

;; TODO: encontrar algo para hacer que el minibuffer funcione de forma mas interesante

(progn
  (setq enable-recursive-minibuffers t)

  ;; Save minibuffer history
  (savehist-mode 1)
  (desktop-save-mode 1)
  (global-auto-revert-mode 1)

  (setq max-mini-window-height 0.5)

  ;; minibuffer, stop cursor going into prompt
  (customize-set-variable
   'minibuffer-prompt-properties
   (quote (read-only t cursor-intangible t face minibuffer-prompt))))
