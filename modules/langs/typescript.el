;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(define-derived-mode typescriptreact-mode web-mode "TypescriptReact"
  "A major mode for tsx.")

(use-package typescript-mode
  :demand t
  :mode (("\\.ts\\'" . typescript-mode)
         ("\\.tsx\\'" . typescriptreact-mode))
  :custom
  (typescript-indent-level       2)
  (typescript-expr-indent-offset 2)
  )

;;; typescript.el ends here
