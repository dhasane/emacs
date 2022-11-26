;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package kotlin-mode
  )

(use-package lsp-intellij
  :after lsp-mode
  :custom
  (lsp-intellij--code-lens-kind-face nil)
  ;; :bind (:map kotlin-mode-map
  ;;             ("C-c k u" . 'lsp-intellij-run-project)
  ;;             ("C-c k c" . 'lsp-intellij-build-project))
  ;; :hook (kotlin-mode . 'lsp-intellij-enable)
  ) 

;;; kotlin.el ends here
