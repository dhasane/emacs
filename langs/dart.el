;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

;; https://github.com/emacs-lsp/lsp-dart
(use-package lsp-dart
  :ensure t
  :defer t
  ;; :after (lsp-mode company)
  :hook (dart-mode . lsp-deferred))

;;; dart.el ends here
