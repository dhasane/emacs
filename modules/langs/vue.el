;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

;; (use-package vue-mode
;;   :disabled t
;;   )

(define-derived-mode dh-vue-mode web-mode "Vue"
  "A major mode derived from web-mode, for editing .vue files with LSP support.")
(add-to-list 'auto-mode-alist '("\\.vue\\'" . dh-vue-mode))

;;; vue.el ends here
