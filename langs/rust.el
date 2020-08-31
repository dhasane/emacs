
;; TODO: agregar rust-analyzer y poner esto a funcionar
(use-package rust-mode
  :ensure t
  :config
  (setq lsp-rust-analyzer-cargo-watch-enable t)
  (setq lsp-rust-server 'rust-analyzer)
  )
