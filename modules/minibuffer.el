;;; package --- Summary

;;; Commentary:

;;; code:

;; -*- lexical-binding: t; -*-

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

;; minibuffer, stop cursor going into prompt
(customize-set-variable
 'minibuffer-prompt-properties
 (quote (read-only t cursor-intangible t face minibuffer-prompt)))
