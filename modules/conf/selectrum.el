;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

;; (use-package selectrum
;;   :init
;;   (selectrum-mode +1)
;;   )

;; Enable vertico
(use-package vertico
  :init
  (vertico-mode)
  :custom
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t)

  (completion-styles '(basic substring partial-completion flex))

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
  ;; (completion-styles '(basic substring partial-completion flex))
  (orderless-component-separator "[ &]")
  )

;; Enable richer annotations using the Marginalia package
(use-package marginalia
  ;; Either bind `marginalia-cycle` globally or only in the minibuffer
  ;; :bind (("M-A" . marginalia-cycle)
  ;;        :map minibuffer-local-map
  ;;        ("M-A" . marginalia-cycle))

  ;; The :init configuration is always executed (Not lazy!)
  :init

  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))

(use-package embark
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-S-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

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

(use-package company-prescient
  :demand t
  :config
  (company-prescient-mode t)
  ;; :custom
  ;; (company-prescient-sort-length-enable)
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

;;; selectrum.el ends here
