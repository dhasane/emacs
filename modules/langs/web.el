

(use-package web-mode
  :ensure t
  :defer t
  :mode ("\\.html\\'" "\\.jinja\\'")
  :config (setq web-mode-markup-indent-offset 2
                web-mode-code-indent-offset 2)
  (add-to-list 'auto-mode-alist
               '("\\.erb\\'" . web-mode)
               )
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
