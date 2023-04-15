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
  :defer t
  :defines (yas-reload-all)
  :hook ((prog-mode org-mode text-mode) . yas-minor-mode)
  :general
  (yas-minor-mode-map
   "TAB" nil
   "<tab>" nil
   )
  ;; :config
  ;; (yas-global-mode 1)

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

(use-package vertico
  :init
  (vertico-mode)
  :general
  (:keymaps 'vertico-map
   "<escape>"       #'minibuffer-keyboard-quit ; Close minibuffer
   "<tab>"          #'vertico-insert  ; Insert selected candidate into text area
   "C-<return>"     #'vertico-exit
   "C-K" #'vertico-next-group
   "C-J" #'vertico-previous-group
   )
  (:states '(normal insert motion emacs) :keymaps 'vertico-map
   "C-j"      #'vertico-next
   "C-k"      #'vertico-previous
   "?" #'minibuffer-completion-help
   ;; "M-RET" #'minibuffer-force-complete-and-exit
   ;"TAB" #'minibuffer-complete
   )
  (:states '(normal) :keymaps 'vertico-map
   "j"      #'vertico-next
   "k"      #'vertico-previous
   )
  :custom
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t)

  (completion-styles '(substring orderless basic))
  ;; (completion-styles '(basic substring partial-completion flex))

  ;; modify completion-at-point
  (completion-in-region-function 'consult-completion-in-region)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (vertico-cycle t)
  )

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

(use-package consult)

(use-package consult-flycheck)

(use-package consult-lsp
  :config
  (consult-lsp-marginalia-mode)
  ;; :custom
  ;; (consult-lsp-margina-mode t)
  )

(use-package orderless
  :custom
  (completion-styles '(orderless))
  (completion-category-defaults nil)    ; I want to be in control!
  (completion-category-overrides
   '((file (styles basic-remote ; For `tramp' hostname completion with `vertico'
                   orderless))))
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
  :general
  (:keymaps 'minibuffer-local-map
   "M-A" 'marginalia-cycle)
  :custom
  (marginalia-max-relative-age 0)
  (marginalia-align 'right)
  :init
  (marginalia-mode))

(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

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

(use-package prescient
  :demand t
  )

(use-package selectrum
  :disabled t
  :init
  (selectrum-mode +1)
  )

(use-package selectrum-prescient
  :disabled t
  :demand t
  :config
  ;; to make sorting and filtering more intelligent
  (selectrum-prescient-mode t)
  ;; to save your command history on disk, so the sorting gets more
  ;; intelligent over time
  (prescient-persist-mode t)
  ;; :custom
  ;; (selectrum-prescient-enable-filtering)
  ;; (selectrum-prescient-enable-sorting)
  )

;;; completion.el ends here
