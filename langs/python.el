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
              (setq-local indent-tabs-mode t)
              (setq-local tab-width 4)
              (setq-local python-indent-offset 4)))
  :custom
  (python-guess-indent nil)
  (python-indent 4)
  (python-shell-interpreter "python3")
  (py-python-command "python3")
  ;; (flycheck-add-next-checker 'python-flake8 'python-pylint)
  (python-shell-completion-native-enable nil)
  :config
  (setq-local default-tab-width 4)
  (setq-local c-basic-offset 4)
  (message "pythooon modeee")
  ;; pip install python-language-server
  ;; Use IPython when available or fall back to regular Python
  (cond
   ((executable-find "ipython")
    (progn
      (setq python-shell-buffer-name "IPython")
      (setq python-shell-interpreter "ipython")
      (setq python-shell-interpreter-args "-i --simple-prompt")))
   ((executable-find "python3")
    (setq python-shell-interpreter "python3"))
   ((executable-find "python2")
    (setq python-shell-interpreter "python2"))
   (t
    (setq python-shell-interpreter "python"))))


;; (use-package anaconda-mode)

(use-package lsp-pyright
  :config
  (when (executable-find "python3")
    (setq lsp-pyright-python-executable-cmd "python3"))
  :custom
  (lsp-pyright-auto-search-paths t)
  (lsp-pyright-extra-paths ["layers/*"])
  (lsp-clients-python-library-directories '("/usr/" "~/miniconda3/pkgs"))
  (lsp-pyright-disable-organize-imports nil)
  (lsp-pyright-auto-import-completions t)
  (lsp-pyright-use-library-code-for-types t)
  (lsp-pyright-typechecking-mode ;; TODO: eventually find why this gives so many errors because of wrong types
   "off"
   ;; "basic" ;; default
   ;; "strict"
   )
  ;; (lsp-pyright-venv-path "~/miniconda3/envs")
  )

(use-package lsp-python-ms
  :disabled
  :after (lsp-mode)
  :custom (lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                         (require 'lsp-python-ms)
                         (lsp-deferred))))  ; or lsp-deferred

(use-package yapfify
  :if (executable-find "yapf")
  :hook (python-mode)
  )

(use-package elpy
  :disabled
  :hook (python-mode . elpy-enable)
  :custom
  (elpy-shell-starting-directory 'current-directory)
  ;; (python-shell-interpreter "ipython") ;require pip install ipython
  ;; (python-shell-interpreter-args "-i --simple-prompt")
  ;; (elpy-rpc-python-command "python3")
  (elpy-shell-echo-output nil)
  ;; (elpy-rpc-backend "jedi")
  ;; (elpy-rpc-python-command)
  :config
  (let ((prevent-elpy '(elpy-module-highlight-indentation elpy-module-flymake)))
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
  ;; (pyvenv-post-activate-hooks
  ;;       (list (lambda ()
  ;;               (setq python-shell-interpreter (concat pyvenv-virtual-env "bin/python")))))
  ;; (pyvenv-post-deactivate-hooks
  ;;       (list (lambda ()
  ;;               (setq python-shell-interpreter "python3"))))
  )

(use-package pyenv-mode
  :hook (python-mode . pyenv-mode)
  :config
  ;;  ;; Setting work on to easily switch between environments
  ;;  (setenv "WORKON_HOME" (expand-file-name "~/miniconda3/envs/"))
  ;;  ;; Restart the python process when switching environments
  ;;  (add-hook 'pyvenv-post-activate-hooks (lambda ()
  ;;					                      (pyvenv-restart-python)))
  )

(use-package auto-virtualenv
  :hook (python-mode . auto-virtualenv-set-virtualenv)
  )

(use-package jupyter)

;;; python.el ends here
