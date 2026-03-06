;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package go-mode
  :custom
  (go-ts-mode-indent-offset 4) ; use spaces only if nil
  )

(use-package go-ts-mode
  :disabled t
  :mode "\\.go\\'")

;;; go.el ends here
