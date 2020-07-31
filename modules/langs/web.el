

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

(use-package emmet-mode
  :ensure t
  :config (add-hook 'web-mode-hook 'emmet-mode))
