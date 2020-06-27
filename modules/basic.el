

;;; code:
;; quitar la pantalla inicial
(setq inhibit-startup-screen t)
;; quitar las barras
(menu-bar-mode -1) ;; TODO: me gustaria activarlo para org
(tool-bar-mode -1)

;; UTF-8 as default encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(setq backward-delete-char-untabify-method 'hungry)

(desktop-save-mode 1)
(global-auto-revert-mode 1) ;; modificar el bufer, si este ha cambiado

;; mostrar los ultimos archivos modificados en menu-bar en files
;; pero yo no uso lo barra :v
;; (recentf-mode 1)

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
(set-default 'tab-always-indent 'complete)

(setq-default indent-tabs-mode nil
              tab-width 4)

;; que no pregunte cuando me quiero salir
(setq use-dialog-box nil)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

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

(toggle-scroll-bar -1)

;; quitar todo tipo de 'alarma'
(setq visible-bell nil
      ring-bell-function 'ignore)

(savehist-mode 1)
