;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:


(define-derived-mode arduino-mode c++-mode "Arduino"
  "A major mode derived from c++-mode, for editing arduino files with LSP support.")

(add-to-list 'auto-mode-alist '("\\.ino\\'" . arduino-mode))

;;; arduino.el ends here
