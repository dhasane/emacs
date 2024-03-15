;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(defun js-web-mode-init-hook ()
  (setq js-indent-level 2)
  (setq-local c-basic-offset 2)
  (setq-local tab-width 2)
  (setq-local indent-tabs-mode nil)
  )

(define-derived-mode web-js-mode web-mode "JS"
  "A major mode derived from web-mode, for editing .vue files with LSP support.")
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-js-mode))

(use-package npm
  :hook ((typescript-mode js-mode web-mode))
  )

(use-package js
  :disabled t
  :elpaca nil
  :demand t
  ;; :mode ("\\.js\\'")
  ;; :hook (js-mode . js-web-mode-init-hook)
  :custom
  (js-indent-level 2)
  (tab-width 2)

  (flycheck-check-syntax-automatically  '(save idle-change mode-enabled))
  (flycheck-auto-change-delay           1.5)

  (whitespace-line-column               120)   ;; max line length
  (whitespace-style                     '(face lines-tail trailing))
  :config
  (add-hook 'js-mode-hook 'js-web-mode-init-hook)
  )

(use-package prettier-js
  :disabled t
  :hook
  (
   (typescript-mode . prettier-js-mode)
   (js-mode . prettier-js-mode)
   (js2-mode . prettier-js-mode)
   (web-mode / prettier-js-mode)
   )
  )

(use-package nvm
  :demand t
  :config

  (defun do-nvm-use (version)
    (interactive "sVersion: ")
    (nvm-use version)
    (exec-path-from-shell-copy-env "PATH"))

  (defun run-node (cwd)
    (interactive "DDirectory: ")
    (unless (executable-find "node")
      (call-interactively 'do-nvm-use))
    (let ((default-directory cwd))
      (pop-to-buffer (make-comint (format "node-repl-%s" cwd) "node" nil "--interactive"))))

   (defun nvm (version)
      (interactive (list
		    (completing-read "Node version: "
		     (mapcar #'car
			     (nvm--installed-versions)))))
      (nvm-use version))
  )

(use-package js2-mode
  :disabled t
  :mode (("\\.js\\'" . js2-mode)
         ("\\.jsx?\\'" . js2-jsx-mode))
  ;; en teoria esto es mejor como minor-mode desde emacs 27, pero como que me funciona mejor como principal
  ;; :hook ((js-mode . js2-minor-mode))
  :custom
  (tern-mode t)
  (indent-tabs-mode nil)
  :config
  ;; (push 'company-tern company-backends)
  )

;; https://github.com/magnars/js2-refactor.el
(use-package js2-refactor
  :disabled t
  :hook ((js2-mode . #'js2-refactor-mode))
  :config
  ; (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (setq-default js2-basic-offset 2)
  (setq js2-skip-preprocessor-directives t)

  (add-to-list 'interpreter-mode-alist '("node" . js2-mode))
  (add-to-list 'interpreter-mode-alist '("node" . js2-jsx-mode))
  )

(use-package tide                              ; https://github.com/ananthakumaran/tide
  :disabled
  :after (typescript-mode flycheck)
  :hook (
         ;; (typescript-mode . tide-setup)
         (typescript-mode . tide-mode)
         (typescript-mode . tide-hl-identifier-mode)
         (typescript-mode . (lambda ()
                              (tide-setup)
                              (tide-hl-identifier-mode +1)
                              (eldoc-mode +1)
                              (add-hook before-save-hook tide-format-before-save)
                              ))
         )
  :custom
  (tide-format-options
   '(
     :insertSpaceAfterFunctionKeywordForAnonymousFunctions t
     :placeOpenBraceOnNewLineForFunctions nil
     :tabSize 2
     :indentSize 2
     ))
  :config
  (flycheck-add-mode 'typescript-tide 'ng2-ts-mode)
  )

(use-package ng2-mode
  :disabled t
  :config
  (flycheck-add-mode 'typescript-tslint 'ng2-ts-mode)
  )

(use-package rjsx-mode
  :disabled t
  ;; :mode "components\\/.*\\.js\\'"
  :defer t
  )

;; Add NodeJS error format
(setq compilation-error-regexp-alist-alist
      (cons '(node "^[  ]+at \\(?:[^\(\n]+ \(\\)?\\([a-zA-Z\.0-9_/-]+\\):\\([0-9]+\\):\\([0-9]+\\)\)?$"
                         1 ;; file
                         2 ;; line
                         3 ;; column
                         )
            compilation-error-regexp-alist-alist))
(setq compilation-error-regexp-alist
      (cons 'node compilation-error-regexp-alist))

;;; javascript.el ends here
