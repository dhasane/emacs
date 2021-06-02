;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :custom
  (rust-format-on-save t)
  (lsp-rust-analyzer-cargo-watch-enable t)
  (lsp-rust-server
   'rust-analyzer
   ;; 'rls
   )
  )

(use-package flycheck-rust
  :disabled
  :ensure t
  :demand t
  :hook (flycheck-mode . #'flycheck-rust-setup))

(use-package racer
  :disabled
  :ensure t
  :hook
  (
   (rust-mode  . #'racer-mode)
   (racer-mode .  #'eldoc-mode)
   (racer-mode .  #'company-mode)
   )
  :custom
  (racer-rust-src-path
   ;; "/YOUR/REAL/HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library"
   "~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library"
   )
  )

;;; rust.el ends here
