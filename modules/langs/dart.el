
;; https://github.com/emacs-lsp/lsp-dart
(use-package lsp-dart
  :ensure t
  :defer t
  :after lsp-mode company
  :hook (dart-mode . lsp-deferred))
