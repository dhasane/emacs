;; -*- lexical-binding: t; -*-

;;; Code:

(use-package nix-mode)

;; (use-package rainbow-blocks
  ;; )

;; (use-package restart-emacs
;;   )

(use-package nhexl-mode
  :custom
  (nhexl-display-unprintables t)
  (nhexl-line-width t)
  (nhexl-obey-font-lock nil)
  (nhexl-separate-line nil)
  (nhexl-silently-convert-to-unibyte t)
  )

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

;;; general end here
