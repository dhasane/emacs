;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package bufler
  :disabled
  :delight
  :config
  ;; (bufler-workspace-mode t)
  )

(use-package polymode
  :disabled
  :mode ("\\.md\\'" "\\.org\\'" )
  :config
  ;; (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
  ;; (setq polymode-prefix-key (kbd "C-c n"))
  ;; (define-hostmode poly-python-hostmode :mode 'python-mode)
  )

;;; general.el ends here
