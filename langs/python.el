
(use-package lsp-python-ms
  :ensure t
  :after (lsp-mode company)
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp-deferred))))  ; or lsp-deferred

(use-package virtualenvwrapper
  :ensure t)

(use-package python
  :demand t
  :mode ("\\.py\\'" . python-mode)
  :hook
  (python-mode .
               (lambda ()
                 (setq python-indent-offset 4
                       tab-width 4
                       ))
               )
  :custom
  (python-guess-indent nil)
  (python-indent-offset 4)
  (python-indent 4)
  (python-shell-interpreter "python3")
  :config
  ;; pip install python-language-server
  (setq-default python-indent-offset 4)
  )

(use-package elpy
  :ensure t
  :hook (python-mode . elpy-enable)
  :custom
  (elpy-shell-starting-directory 'current-directory)
  :config
  (let ((prevent-elpy '(elpy-module-highlight-indentation)))
    (dolist (pe prevent-elpy)
      (setq elpy-modules (delete pe elpy-modules))
      )
    )
  ;; (elpy-modules
  ;;  'elpy-module-sane-defaults
  ;;  'elpy-module-company
  ;;  'elpy-module-eldoc
  ;;  'elpy-module-flymake
  ;;  ;; ' ;; la indentacion la muestro con otro paquete
  ;;  'elpy-module-pyvenv
  ;;  'elpy-module-yasnippet
  ;;  'elpy-module-django
  ;;  )
  ;; (elpy-enable)
  ;; (setq elpy-shell-use-project-root nil)
  )

