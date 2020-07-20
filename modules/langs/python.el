
(use-package lsp-python-ms
  :ensure t
  :after lsp-mode company
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp-deferred))))  ; or lsp-deferred

(use-package elpy
  :ensure t
  :hook (python-mode . elpy-enable)
  ;;(elpy-enable)
  )

(setq python-shell-interpreter "python3")
