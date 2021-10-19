;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package flycheck
  :demand t
  ;; :hook (prog-mode . flycheck-mode)
  :init (global-flycheck-mode)

  :custom
  (flycheck-check-syntax-automatically
   '(
	 ;; save
	 idle-change
	 idle-buffer-switch
	 mode-enabled
	 ))
  (flycheck-idle-change-delay 2)
  (flycheck-idle-buffer-switch-delay 2)
  ;; :config
  ;; (add-hook 'after-init-hook #'global-flycheck-mode)
  )

(use-package yasnippet
  :demand t
  :defer .1
  :defines
  (
   yas-reload-all
  )
  :hook (
         (prog-mode . yas-minor-mode)
         (org-mode . yas-minor-mode)
         (text-mode . yas-minor-mode)
         )
  :general
  (yas-minor-mode-map
   "TAB" nil
   "<tab>" nil
   )
  :config
  ;; (yas-global-mode 1)

  )

(use-package yasnippet-snippets
  :demand t
  :after yasnippet
  :defines
  (yas-reload-all)
  :config
  (yas-reload-all)
  )

;; optionally if you want to use debugger
(use-package dap-mode
  :after lsp-mode :demand t
  :config
  (dap-mode 1)
  (dap-auto-configure-mode)

  (dap-ui-mode t)
  ;; enables mouse hover support
  (dap-tooltip-mode 1)
  ;; use tooltips for mouse hover
  ;; if it is not enabled `dap-mode' will use the minibuffer.
  (tooltip-mode 1)
  ;; displays floating panel with debug buttons
  ;; requies emacs 26+
  (dap-ui-controls-mode 1)
  )
;; TODO: mirar como funciona lo de dap-mode

(use-package polymode
  :disabled
  :mode ("\\.md\\'" "\\.org\\'" )
  :config
  ;; (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
  ;; (setq polymode-prefix-key (kbd "C-c n"))
  ;; (define-hostmode poly-python-hostmode :mode 'python-mode)
  )

(use-package tree-sitter

  )
