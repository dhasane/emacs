

;;; code:
;; quitar la pantalla inicial
;;(setq inhibit-startup-screen t)
;;(desktop-save-mode 1)
;;(defun always-use-fancy-splash-screens-p () 1)
  ;;(defalias 'use-fancy-splash-screens-p 'always-use-fancy-splash-screens-p)


(setq-default bidi-paragraph-direction 'left-to-right)
(if (version<= "27.1" emacs-version)
    (setq bidi-inhibit-bpa t))

(if (version<= "27.1" emacs-version)
    (global-so-long-mode 1))

(add-to-list 'default-frame-alist '(fullscreen . maximized)) ;; llenar toda la pantalla

;; UTF-8 as default encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(setq backward-delete-char-untabify-method 'hungry)
(setq large-file-warning-threshold nil) ;; Don’t warn me about opening large files
(setq x-select-enable-clipboard t) ;; Enable copy/past-ing from clipboard
(setq system-uses-terminfo nil) ;; Fix weird color escape sequences
(prefer-coding-system 'utf-8) ;; Prefer UTF-8 encoding
(fset 'yes-or-no-p 'y-or-n-p) ;; Answer with y and n instead of yes and no
(setq confirm-kill-emacs 'yes-or-no-p) ;; Ask for confirmation before closing emacs
(global-auto-revert-mode 1) ;; modificar el bufer, si este ha cambiado

(setq lexical-binding t)

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

(setq show-paren-delay 0
      show-paren-style 'parenthesis)
;;
;;(setq-default tab-always-indent 'complete)
;;
(setq c-default-style "linux"
      )
(setq-default c-basic-offset 4
              tab-width 4
              indent-tabs-mode nil)

;; que no pregunte cuando me quiero salir
(setq use-dialog-box nil)

;;(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq auto-save-default nil
      make-backup-files nil
      create-lockfiles nil
     )

(setq x-wait-for-event-timeout nil)

(blink-cursor-mode 0)

;; hacer que el movimiento de la pantalla sea suave
(setq scroll-margin 10
      scroll-conservatively 0
      scroll-step 1
      ;;scroll-up-aggressively 0.01
      ;;scroll-down-aggressively 0.01
      )

(setq-default scroll-up-aggressively 0.01
              scroll-down-aggressively 0.01)

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
    (linum-mode -1)
    (font-lock-mode -1)
    )
  )

(add-hook 'find-file-hook 'my-find-file-check-make-large-file-read-only-hook)

(provide 'basic)
;;; basic.el ends here
