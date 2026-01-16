;;; completion.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Completion stack configuration (cape, orderless, consult)

;;; code:

;; Add extensions
(use-package cape
  :demand t
  :config
  ;; Add common CAPFs in mode hooks so local lists are respected.
  (defun dh/cape-common-capfs ()
    "Add common CAPFs for general use."
    (add-to-list 'completion-at-point-functions #'cape-file t)
    (add-to-list 'completion-at-point-functions #'cape-dabbrev t))
  (add-hook 'prog-mode-hook #'dh/cape-common-capfs)
  (add-hook 'text-mode-hook #'dh/cape-common-capfs)

  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions #'cape-elisp-block t)))
  )

(use-package flycheck
  :demand t
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

(use-package flymake
  :demand t
  :ensure nil
  :custom
  (flymake-no-changes-timeout 1)
  (flymake-mode-line-format
	;; the default mode line lighter takes up an unnecessary amount of
	;; space, so make it shorter
	'(" " flymake-mode-line-exception flymake-mode-line-counters))
  )

(use-package flycheck-eglot
  :demand t
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

(use-package yasnippet
  :defer t
  :defines (yas-reload-all)
  :hook (after-init . yas-reload-all)
  :hook ((prog-mode org-mode text-mode) . yas-minor-mode)
  :general
  (yas-minor-mode-map
   "TAB" nil
   "<tab>" nil
   )
  )

(use-package yasnippet-snippets
  :delight
  :demand t
  :after yasnippet
  :defines
  (yas-reload-all)
  :config
  (yas-reload-all)
  )

(use-package consult
  :demand t
  :after hydra
  :init
  (defhydra+ hydra-search ()
    ("s" consult-line       "line")
    ("g" consult-git-grep   "git grep")
    ("i" consult-imenu      "imenu")
    ("r" consult-ripgrep    "ripgrep")
    )
  :config
  (add-to-list 'consult-preview-variables '(treesit-auto-langs nil))
  )

(use-package consult-flycheck
  :after (consult)
  :general
  (dahas-lsp-map
   "e" 'consult-flycheck
   )
  ;; :init
  ;; (defhydra+ hydra-lsp ()
  ;;   ("e" consult-flycheck         "errors" :column "errors")        ; "errores"
  ;;   )
  )

(use-package orderless
  :demand t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)    ; I want to be in control!
  (completion-category-overrides
   '((file (styles ;; basic-remote ; For `tramp' hostname completion with `vertico'
            orderless))
     (eglot (styles orderless))
     (eglot-capf (styles orderless))))
  ;; (completion-styles '(basic substring partial-completion flex))
  (orderless-component-separator "[ &]")
  (orderless-matching-styles
   '(orderless-literal
     orderless-prefixes
     orderless-initialism
     orderless-regexp
     ;; orderless-flex                       ; Basically fuzzy finding
     ;; orderless-strict-leading-initialism
     ;; orderless-strict-initialism
     ;; orderless-strict-full-initialism
     ;; orderless-without-literal          ; Recommended for dispatches instead
     )
   )
  )

(use-package marginalia
  :demand t
  :general
  (:keymaps 'minibuffer-local-map
   "M-A" 'marginalia-cycle)
  :custom
  (marginalia-max-relative-age 0)
  (marginalia-align 'right)
  :init
  (marginalia-mode))

(use-package embark
  ;; :bind
  ;; (("C-." . embark-act)         ;; pick some comfortable binding
  ;;  ("C-;" . embark-dwim)        ;; good alternative: M-.
  ;;  ("C-S-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  :custom

  ;; Optionally replace the key help with a completing-read interface
  (prefix-help-command #'embark-prefix-help-command)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; (use-package prescient :demand t)

;;; completion.el ends here
