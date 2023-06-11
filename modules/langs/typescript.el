;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package typescript-mode
  :demand t
  :mode ("\\.ts\\'" "\\.tsx\\'")
  :custom
  (typescript-indent-level       2)
  (typescript-expr-indent-offset 2)
  )

;;; typescript.el ends here
