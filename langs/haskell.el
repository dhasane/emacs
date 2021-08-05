;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package haskell-mode
  )

(use-package lsp-haskell
  :hook(
        (haskell-mode . #'lsp)
        (haskell-literate-mode . #'lsp)
        )
  )

;;; haskell.el ends here
