
(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :config
  (setq lsp-rust-analyzer-cargo-watch-enable t)
  (setq lsp-rust-server 'rust-analyzer)
  )
