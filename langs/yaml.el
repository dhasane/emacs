;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package yaml-mode
  :defer t
  :mode ("\\.yml\\'" "\\.sls\\'" "\\.yml.j2\\'")
  :init
  (add-hook 'yaml-mode-hook 'turn-off-auto-fill))

;;; yaml.el ends here
