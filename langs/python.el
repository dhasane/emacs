;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package virtualenvwrapper)

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
  (py-python-command "python3")
  ;; (flycheck-add-next-checker 'python-flake8 'python-pylint)
  (python-shell-completion-native-enable nil)
  :config
  ;; pip install python-language-server
  (setq-default python-indent-offset 4)
  )

;; (use-package anaconda-mode)

(use-package lsp-pyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp-deferred)))  ; or lsp-deferred
  :init (when (executable-find "python3")
          (setq lsp-pyright-python-executable-cmd "python3"))
  :custom
  (lsp-pyright-auto-search-paths t)
  (lsp-pyright-extra-paths ["layers/*"])
  )

(use-package lsp-python-ms
  :after (lsp-mode company)
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp-deferred))))  ; or lsp-deferred

(use-package yapfify
  :hook
  (python-mode . yapf-mode)
  )

(use-package elpy
  :hook (python-mode . elpy-enable)
  :custom
  (elpy-shell-starting-directory 'current-directory)
  ;; (python-shell-interpreter "ipython") ;require pip install ipython
  ;; (python-shell-interpreter-args "-i --simple-prompt")
  ;; (elpy-rpc-python-command "python3")
  (elpy-shell-echo-output nil)
  (elpy-rpc-backend "jedi")
  ;; (elpy-rpc-python-command)
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

(use-package pyvenv
  ;; :init
  ;; (setenv "WORKON_HOME" "~/.venvs/")
  :hook (python-mode . pyvenv-mode)
  :config
  (pyvenv-tracking-mode 1)

  ;; :custom
  ;; ;; Set correct Python interpreter
  ;; (setq pyvenv-post-activate-hooks
  ;;       (list (lambda ()
  ;;               (setq python-shell-interpreter (concat pyvenv-virtual-env "bin/python")))))
  ;; (setq pyvenv-post-deactivate-hooks
  ;;       (list (lambda ()
  ;;               (setq python-shell-interpreter "python3"))))
  )

(use-package pyenv-mode
  :hook (python-mode . pyenv-mode)
  )

(use-package auto-virtualenv
  :hook (python-mode . auto-virtualenv-set-virtualenv)
  )


;;; python.el ends here
