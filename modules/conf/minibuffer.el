;;; minibuffer.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Minibuffer behavior and keybindings

;;; code:

(setq enable-recursive-minibuffers t)

;; Save minibuffer history
(savehist-mode 1)

(setq max-mini-window-height 0.5)

(defun switch-to-minibuffer ()
  "Switch to minibuffer window."
  (interactive)
  (if (active-minibuffer-window)
      (select-window (active-minibuffer-window))
    (error "Minibuffer is not active")))

(global-set-key "\C-co" 'switch-to-minibuffer) ;; Bind to `C-c o'

(define-key minibuffer-local-map (kbd "<S-up>" )
  'previous-history-element)
(define-key minibuffer-local-map (kbd "<S-up>" )
  'previous-history-element)
(define-key minibuffer-local-map (kbd "<S-down>" )
  'next-history-element)
(define-key minibuffer-local-map (kbd "<S-down>" )
  'next-history-element)

;; minibuffer, stop cursor going into prompt
(customize-set-variable
 'minibuffer-prompt-properties
 (quote (read-only t cursor-intangible t face minibuffer-prompt)))

;;; minibuffer.el ends here
