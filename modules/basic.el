

;; quitar la pantalla inicial
(setq inhibit-startup-screen t)
;; quitar las barras
(menu-bar-mode -1) ;; TODO: me gustaria activarlo para org
(tool-bar-mode -1)

;; UTF-8 as default encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8-unix)

(setq backward-delete-char-untabify-method 'hungry)

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
