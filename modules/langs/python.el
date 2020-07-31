
(use-package lsp-python-ms
  :ensure t
  :after (lsp-mode company)
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp-deferred))))  ; or lsp-deferred

(use-package virtualenvwrapper
  :ensure t)

(use-package elpy
  :ensure t
  :hook (python-mode . elpy-enable)
  :config
  ;;(elpy-enable)
  ;; (setq elpy-shell-use-project-root nil)
  (setq elpy-shell-starting-directory 'current-directory)
  )

(setq python-shell-interpreter "python3")
