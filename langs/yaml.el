;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package indent-guide
  :ensure t
  :init (add-hook 'yaml-mode-hook 'indent-guide-mode))

(use-package yaml-mode
  :ensure t
  :defer t
  :mode ("\\.yml\\'" "\\.sls\\'" "\\.yml.j2\\'")
  :init
  (add-hook 'yaml-mode-hook 'turn-off-auto-fill))

;;; yaml.el ends here
