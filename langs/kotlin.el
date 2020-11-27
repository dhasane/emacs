
(use-package kotlin-mode
  :ensure t
  :hook (kotlin-mode . company-mode))

(use-package lsp-intellij
  :ensure t
  :after lsp-mode
  :config
  (setq lsp-intellij--code-lens-kind-face nil)
  :bind (:map kotlin-mode-map
              ("C-c k u" . lsp-intellij-run-project)
              ("C-c k c" . lsp-intellij-build-project))
  :hook (kotlin-mode . lsp-intellij-enable))
