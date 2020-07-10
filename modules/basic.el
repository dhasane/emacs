

;;; code:
;; quitar la pantalla inicial
;;(setq inhibit-startup-screen t)
;;(desktop-save-mode 1)
;;(defun always-use-fancy-splash-screens-p () 1)
  ;;(defalias 'use-fancy-splash-screens-p 'always-use-fancy-splash-screens-p)

(use-package dashboard
  :ensure t
  :init
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  ;; (dashboard-modify-heading-icons '((recents . "file-text")
                                  ;; (bookmarks . "book")))
  (setq dashboard-set-navigator t)
  (setq show-week-agenda-p t)
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
  :config
  (dashboard-setup-startup-hook))

;; quitar las barras
(menu-bar-mode -1) ;; TODO: me gustaria activarlo para org
(tool-bar-mode -1)
(scroll-bar-mode -1)

(add-to-list 'default-frame-alist '(fullscreen . maximized)) ;; llenar toda la pantalla

;; UTF-8 as default encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(setq backward-delete-char-untabify-method 'hungry)
(global-auto-revert-mode 1) ;; modificar el bufer, si este ha cambiado
;;
;;;; mostrar los ultimos archivos modificados en menu-bar en files
;;;; pero yo no uso lo barra :v
;;;; (recentf-mode 1)
;;
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
