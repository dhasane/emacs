;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(defun c-mode-init-hook ()
  ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
  (c-set-offset 'substatement-open 0)
  ;; other customizations can go here

  (setq c++-tab-always-indent t)

  (let ((dh/indent-dep 2))
    (setq c-basic-offset dh/indent-dep)                  ;; Default is 2
    (setq c-indent-level dh/indent-dep)                  ;; Default is 2
    (setq tab-width dh/indent-dep)
    )

  ;; (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  )

(add-hook 'c-mode-common-hook 'c-mode-init-hook)

(use-package ccls
  :disabled t
  :mode (
         ("\\.h\\'"   . c-mode)
         ("\\.cpp\\'" . c++-mode)
         ("\\.ino\\'" . c++-mode)
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
