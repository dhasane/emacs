;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package nxml
  :elpaca nil
  :hook (
         (nxml-mode . visual-line-mode)
         (nxml-mode . adaptive-wrap-prefix-mode)
         )
  )

;;; xml.el ends here
