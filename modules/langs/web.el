

(use-package web-mode
  :ensure t
  :defer t
  :mode ("\\.html?\\'"
         "\\.phtml\\'"
         "\\.php\\'"
         "\\.inc\\'"
         "\\.tpl\\'"
         "\\.jsp\\'"
         "\\.as[cp]x\\'"
         "\\.erb\\'"
         "\\.mustache\\'"
         "\\.djhtml\\'"
         "\\.jsx\\'"
         "\\.tsx\\'")
  :config (setq web-mode-markup-indent-offset 2
                web-mode-code-indent-offset 2)
  (add-to-list 'auto-mode-alist
               '("\\.erb\\'" . web-mode)
               )
  ;; configure jsx-tide checker to run after your default jsx checker
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (flycheck-add-mode 'typescript-tslint 'web-mode)
)

(use-package js2-mode
  :mode "\\.js\\'"
  )

;; https://github.com/magnars/js2-refactor.el
(use-package js2-refactor
  :hook ((js2-mode . #'js2-refactor-mode))
  :config
  ; (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (setq js2-skip-preprocessor-directives t)
  )

(use-package php-mode
  )

(use-package tide                       ; https://github.com/ananthakumaran/tide
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save))
  :init
  (defun setup-tide-mode ()
    (interactive)
    (tide-setup)
    (flycheck-mode +1)
    ;; (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (eldoc-mode +1)
    (tide-hl-identifier-mode +1)
    (company-mode +1))

  (defun my/setup-tsx-mode ()
    (when (string-equal "tsx" (file-name-extension buffer-file-name))
      (setup-tide-mode)))

  (defun my/setup-jsx-mode ()
    (when (string-equal "jsx" (file-name-extension buffer-file-name))
      (setup-tide-mode)))

  (add-hook 'typescript-mode-hook #'setup-tide-mode)
  (add-hook 'js2-mode-hook #'setup-tide-mode)
  (add-hook 'web-mode-hook #'my/setup-tsx-mode)
  (add-hook 'rjsx-mode-hook #'my/setup-jsx-mode)
  :requires flycheck
  :config
  (add-to-list 'company-backends 'company-tide)
  ;; aligns annotation to the right hand side
  ;; (setq company-tooltip-align-annotations t)

  ;; formats the buffer before saving
  ;; (add-hook 'before-save-hook 'tide-format-before-save)

  (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)
  (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append))

(use-package rjsx-mode
  :defer t)
