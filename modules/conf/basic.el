;;; package --- Summary -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(desktop-save-mode -1)
(setq desktop-restore-eager nil)

;;(defun always-use-fancy-splash-screens-p () 1)
  ;;(defalias 'use-fancy-splash-screens-p 'always-use-fancy-splash-screens-p)

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
(setq large-file-warning-threshold nil) ;; Don’t warn me about opening large files
(setq select-enable-clipboard t) ;; Enable copy/past-ing from clipboard
(setq system-uses-terminfo nil) ;; Fix weird color escape sequences
(prefer-coding-system 'utf-8) ;; Prefer UTF-8 encoding
(fset 'yes-or-no-p 'y-or-n-p) ;; Answer with y and n instead of yes and no
(setq confirm-kill-emacs 'yes-or-no-p) ;; Ask for confirmation before closing emacs
(global-auto-revert-mode 1) ;; modificar el bufer, si este ha cambiado

(setq lexical-binding t)

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
;; (setq electric-pair-delete-adjacent-pairs nil)

(setq show-paren-delay 0
      show-paren-style 'parenthesis)
;;
;;(setq-default tab-always-indent 'complete)
;;
(setq c-default-style "linux")

;; que no pregunte cuando me quiero salir
(setq use-dialog-box nil)

(setq auto-save-default nil
      make-backup-files nil
      create-lockfiles nil
     )

;; (defvar dh/backup-directory (expand-file-name ".cache/backup" user-emacs-directory))
;; (unless (file-directory-p dh/backup-directory)
;;   (make-directory dh/backup-directory))
;; (setq backup-directory-alist `(("." . ,dh/backup-directory ))
;;       backup-by-copying t    ; Don't delink hardlinks
;;       version-control t      ; Use version numbers on backups
;;       delete-old-versions t  ; Automatically delete excess backups
;;       kept-new-versions 20   ; how many of the newest versions to keep
;;       kept-old-versions 5    ; and how many of the old
;;       )

;; quitar el mouse del lugar donde uno esta editando
;; (mouse-avoidance-mode 'cat-and-mouse)

(setq x-wait-for-event-timeout nil)

(blink-cursor-mode 0)

;; scrolling

(pixel-scroll-precision-mode 1)

;; (setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq pixel-scroll-precision-large-scroll-height 40.0)
(setq mouse-wheel-follow-mouse t)
(setq scroll-step 1)

;; quitar todo tipo de 'alarma'
(setq visible-bell nil
      ring-bell-function 'ignore)

(savehist-mode 1)

(defun my-find-file-check-make-large-file-read-only-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (> (buffer-size) (* 1024 1024))
    (setq buffer-read-only t)
    (buffer-disable-undo)
    (fundamental-mode)
    ;; (linum-mode -1)
    (font-lock-mode -1)
    )
  )

(add-hook 'find-file-hook 'my-find-file-check-make-large-file-read-only-hook)
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(setq debug-on-error nil)

(setq native-comp-async-report-warnings-errors nil)
(setq native-compile-prune-cache t)
(setq native-comp-deferred-compilation t)

;; (advice-add 'windmove-left  :before 'save-buffer)
;; (advice-add 'windmove-right :before 'save-buffer)
;; (advice-add 'windmove-up    :before 'save-buffer)
;; (advice-add 'windmove-down  :before 'save-buffer)

;; (advice-add 'split-window   :after 'save-buffer)

(setq read-extended-command-predicate #'command-completion-default-include-p)

                                        ; extra settings ;;;;;;;;;;;;;;;;;;;;;
(put 'narrow-to-region 'disabled nil)

;; (add-hook 'emacs-startup-hook
;;           (lambda ()
;;             (when (get-buffer-window "*scratch*")
;;               (bury-buffer "*scratch*"))))

;;; basic.el ends here
