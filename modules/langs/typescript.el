;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package typescript-mode
  :demand t
  :mode (("\\.ts\\'" . typescript-mode)
         ("\\.tsx\\'" . typescript-mode))
  :custom
  (typescript-indent-level       2)
  (typescript-expr-indent-offset 2)
  (indent-tabs-mode nil)
  )

;;; typescript.el ends here
