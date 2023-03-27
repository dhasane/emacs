;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package csharp-mode)

(use-package omnisharp
  :hook (
         (csharp-mode . dh/.net-shut-up)
         (csharp-mode . omnisharp-mode)
         (csharp-mode . flycheck-mode)
         )
  :init
  (defun dh/.net-shut-up ()
    (interactive)
    (shell-command "export DOTNET_CLI_TELEMETRY_OPTOUT=1"))

  :config
  ;; (omnisharp-start-omnisharp-server)
  (add-to-list 'company-backends 'company-omnisharp))

;;; c-sharp.el ends here
