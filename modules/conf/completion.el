;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

;; Add extensions
(use-package cape
  ;; Bind dedicated completion commands
  ;; Alternative prefix keys: C-c p, M-p, M-+, ...
  :bind (("C-c p p" . completion-at-point) ;; capf
         ("C-c p t" . complete-tag)        ;; etags
         ("C-c p d" . cape-dabbrev)        ;; or dabbrev-completion
         ("C-c p h" . cape-history)
         ("C-c p f" . cape-file)
         ("C-c p k" . cape-keyword)
         ("C-c p s" . cape-symbol)
         ("C-c p a" . cape-abbrev)
         ("C-c p l" . cape-line)
         ("C-c p w" . cape-dict)
         ("C-c p \\" . cape-tex)
         ("C-c p _" . cape-tex)
         ("C-c p ^" . cape-tex)
         ("C-c p &" . cape-sgml)
         ("C-c p r" . cape-rfc1345))
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  ;; NOTE: The order matters!
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  ;;(add-to-list 'completion-at-point-functions #'cape-history)
  ;;(add-to-list 'completion-at-point-functions #'cape-keyword)
  ;;(add-to-list 'completion-at-point-functions #'cape-tex)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;;(add-to-list 'completion-at-point-functions #'cape-dict)
  ;;(add-to-list 'completion-at-point-functions #'cape-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)

  ;; (setq-local completion-at-point-functions
  ;;             (mapcar #'cape-company-to-capf
  ;;                     (list #'company-files #'company-ispell #'company-dabbrev)))

  ;;(defun my/ignore-elisp-keywords (cand)
  ;;  (or (not (keywordp cand))
  ;;      (eq (char-after (car completion-in-region--data)) ?:)))

  ;;(defun my/setup-elisp ()
  ;;  (setq-local completion-at-point-functions
  ;;              `(,(cape-super-capf
  ;;                  (cape-capf-predicate
  ;;                   #'elisp-completion-at-point
  ;;                   #'my/ignore-elisp-keywords)
  ;;                  #'cape-dabbrev)
  ;;                cape-file)
  ;;              cape-dabbrev-min-length 5))
  ;;(add-hook 'emacs-lisp-mode-hook #'my/setup-elisp)
)

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

(use-package consult
  :init
  (defhydra+ hydra-search ()
    ("s" consult-line       "line")
    ("g" consult-git-grep   "git grep")
    ("i" consult-imenu      "imenu")
    ("r" consult-ripgrep    "ripgrep")
    )
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

(use-package consult-lsp
  :after (consult lsp-mode)
  :requires lsp-mode
  :general
  (dahas-lsp-map
   "s" 'consult-lsp-file-symbols
   "d" 'consult-lsp-diagnostics
   )
  ;; :init
  ;; (defhydra+ hydra-lsp ()
  ;;   ("s" consult-lsp-file-symbols "find"        :column "errors")
  ;;   ("d" consult-lsp-diagnostics  "diagnostics" :column "errors")
  ;;   )
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
