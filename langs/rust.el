;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package rust-mode
  :mode "\\.rs\\'"
  :custom
  (rust-format-on-save t)
  (lsp-rust-analyzer-cargo-watch-enable t)
  (lsp-rust-server
   'rust-analyzer
   ;; 'rls
   )
  )

;; (use-package flycheck-rust
;;   :disabled
;;   :demand t
;;   :hook (rust-mode . flycheck-rust-setup))

;; (use-package racer
;;   :disabled
;;   :hook
;;   (
;;    (rust-mode)
;;    (racer-mode . eldoc-mode)
;;    )
;;   :custom
;;   (racer-rust-src-path
;;    ;; "/YOUR/REAL/HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library"
;;    "~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library"
;;    )
;;   )

;;; rust.el ends here
