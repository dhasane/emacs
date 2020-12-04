
(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :config
  :custom
  (lsp-rust-analyzer-cargo-watch-enable t)
  (lsp-rust-server 'rust-analyzer)
  )

(use-package flycheck-rust
  :ensure t
  :demand t
  :config (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package racer
  :ensure t
  :demand t
  :config
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'racer-mode-hook #'company-mode)
  ;; :bind (:map rust-mode-map
  ;;             ("TAB" . company-indent-or-complete-common)
  ;;             )
  )
