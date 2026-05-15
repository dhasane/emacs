;;; basic.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Core Emacs defaults and performance settings

;;; code:

(desktop-save-mode -1)
(setq desktop-restore-eager nil)

(setq-default bidi-paragraph-direction 'left-to-right)
(if (version<= "27.1" emacs-version)
    (progn
      (setq bidi-inhibit-bpa t)
      (global-so-long-mode 1)
      )
  )

(xterm-mouse-mode 1)

;; UTF-8 as default encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(setq backward-delete-char-untabify-method 'hungry)
(setq large-file-warning-threshold (* 100 1024 1024)) ;; Warn for files over 100MB
(setq select-enable-clipboard t) ;; Enable copy/past-ing from clipboard
(setq system-uses-terminfo nil) ;; Fix weird color escape sequences
(prefer-coding-system 'utf-8) ;; Prefer UTF-8 encoding
(setq use-short-answers t) ;; Answer with y and n instead of yes and no
(setq confirm-kill-emacs 'y-or-n-p) ;; Ask for confirmation before closing emacs
(global-auto-revert-mode 1) ;; modificar el bufer, si este ha cambiado

(setq save-interprogram-paste-before-kill t
      mouse-yank-at-point t
      require-final-newline t
      load-prefer-newer t
      )

;; mostrar los ultimos archivos modificados
(recentf-mode 1)

;; remember cursor position
(if (version< emacs-version "25.0")
    (progn
      (require 'saveplace)
      (setq-default save-place t))
  (save-place-mode 1))
;; indentation, tab
(electric-indent-mode 1)

;; set highlighting brackets
(show-paren-mode 1)
(electric-pair-mode 1)
(setq-default
 electric-pair-skip-whitespace-chars '(9 32)
 )
(setq show-paren-delay 0
      show-paren-style 'parenthesis)

(setq c-default-style "linux")

;; que no pregunte cuando me quiero salir
(setq use-dialog-box nil)

(setq auto-save-default nil
      make-backup-files nil
      create-lockfiles nil
     )

(setq x-wait-for-event-timeout nil)

(blink-cursor-mode 0)

;; scrolling

(pixel-scroll-precision-mode 1)
(setq pixel-scroll-precision-large-scroll-height 40.0)
(setq mouse-wheel-follow-mouse t)
(setq scroll-step 1)

;; quitar todo tipo de 'alarma'
(setq visible-bell nil
      ring-bell-function 'ignore)

(savehist-mode 1)

(defun dh/large-file-read-only-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (> (buffer-size) (* 1024 1024))
    (when (boundp 'treesit-font-lock-level)
      (setq-local treesit-font-lock-level 1))
    (setq buffer-read-only t)
    (buffer-disable-undo)
    (fundamental-mode)
    (font-lock-mode -1)))

(add-hook 'find-file-hook 'dh/large-file-read-only-hook)
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(setq debug-on-error nil)

(setq native-comp-async-report-warnings-errors nil)
(setq native-compile-prune-cache t)
(setq native-comp-deferred-compilation t)

(setq read-extended-command-predicate #'command-completion-default-include-p)

(put 'narrow-to-region 'disabled nil)

;;; basic.el ends here
