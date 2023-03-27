;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package ccls
  :mode (
         ("\\.h\\'"   . c-mode)
         ("\\.cpp\\'" . c++-mode)
  )
  :custom
  (ccls-initialization-options '(:index (:comments 2) :completion (:detailedLabel t)))
  (ccls-code-lens-mode +1)
  (ccls-code-lens-position 'end)
  (ccls-executable "~/.nix-profile/bin/ccls")
  ;; (ccls-sem-highlight-method 'font-lock)
  ;; alternatively,
  ;; (ccls-sem-highlight-method 'overlay)
  :config


  ;; For rainbow semantic highlighting
  (ccls-use-default-rainbow-sem-highlight)

  ;; (setq company-transformers nil company-lsp-async t company-lsp-cache-candidates nil)
                                        ; Use lsp-goto-implementation or lsp-ui-peek-find-implementation (textDocument/implementation) for derived types/functions
                                        ; $ccls/inheritance is more general


  ;; References whose filenames are under this project
  ;; (lsp-ui-peek-find-references nil (list :folders (vector (projectile-project-root))))
  )

(use-package clang-format)

;;; c-based.el ends here
