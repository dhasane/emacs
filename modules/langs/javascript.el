;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(defun js-web-mode-init-hook ()
  (setq js-indent-level 2)
  (setq-local c-basic-offset 2)
  (setq-local tab-width 2)
  (setq-local indent-tabs-mode nil)
  (tree-sitter-mode)
  )

(use-package js
  ;; :mode ("\\.js\\'")
  ;; :hook (js-mode . js-web-mode-init-hook)
  :custom
  (js-indent-level 2)
  (indent-tabs-mode nil)

  (flycheck-check-syntax-automatically  '(save idle-change mode-enabled))
  (flycheck-auto-change-delay           1.5)

  (whitespace-line-column               120)   ;; max line length
  (whitespace-style                     '(face lines-tail trailing))
  :config
  (add-hook 'js-mode-hook 'js-web-mode-init-hook)
  )

(use-package nvm)

(use-package js2-mode
  :disabled t
  :mode (("\\.js\\'" . js2-mode)
         ("\\.jsx?\\'" . js2-jsx-mode)
         )
  ;; en teoria esto es mejor como minor-mode desde emacs 27, pero como que me funciona mejor como principal
  ;; :hook ((js-mode . js2-minor-mode))
  :custom
  (tern-mode t)
  (indent-tabs-mode nil)
  :config
  ;; (push 'company-tern company-backends)
  )

;; https://github.com/magnars/js2-refactor.el
(use-package js2-refactor
  :disabled t
  :hook ((js2-mode . #'js2-refactor-mode))
  :config
  ; (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (setq-default js2-basic-offset 2)
  (setq js2-skip-preprocessor-directives t)

  (add-to-list 'interpreter-mode-alist '("node" . js2-mode))
  (add-to-list 'interpreter-mode-alist '("node" . js2-jsx-mode))
  )

(use-package typescript-mode
  :mode "\\.ts\\'"
  :custom
  (typescript-indent-level       2)
  (typescript-expr-indent-offset 2)
  :config
  ;; (push 'company-tern company-backends)
  )

(use-package tide                              ; https://github.com/ananthakumaran/tide
  :disabled
  :after (typescript-mode company flycheck)
  :hook (
         ;; (typescript-mode . tide-setup)
         (typescript-mode . tide-mode)
         (typescript-mode . tide-hl-identifier-mode)
         (typescript-mode . (lambda ()
                              (tide-setup)
                              (tide-hl-identifier-mode +1)
                              (eldoc-mode +1)
                              (add-to-list 'company-backends 'company-tide)
                              (add-hook before-save-hook tide-format-before-save)
                              ))
         )
  :custom
  (tide-format-options
   '(
     :insertSpaceAfterFunctionKeywordForAnonymousFunctions t
     :placeOpenBraceOnNewLineForFunctions nil
     :tabSize 2
     :indentSize 2
     ))
  :config
  (flycheck-add-mode 'typescript-tide 'ng2-ts-mode)
  )

(use-package ng2-mode
  :disabled t
  :config
  (flycheck-add-mode 'typescript-tslint 'ng2-ts-mode)
  (with-eval-after-load 'typescript-mode
    (add-hook 'typescript-mode-hook #'lsp)))

(use-package rjsx-mode
  :disabled t
  ;; :mode "components\\/.*\\.js\\'"
  :defer t
  )


;;; javascript.el ends here