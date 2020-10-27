
;; lsp -----------------------------------------------------
;;; code:
(defcustom lsp-ignore-modes
  '(
    emacs-lisp-mode
    typescript-mode
    ng2-ts-mode
    csharp-mode
    )
  "Modes to prevent Emacs from loading lsp-mode."
  :type 'list
  :group 'lsp-mode-ignore
  )

(defun dh/lsp-enable-mode ()
  "Activar lsp solo si no es un modo a ignorar."
  (interactive)
  ;; (if (not (member major-mode '(emacs-lisp-mode)))
  (if (not (member major-mode lsp-ignore-modes))
      (lsp-deferred)
    ;;(message "lsp no activado")
    )
  )

(add-hook 'prog-mode-hook 'dh/lsp-enable-mode)

(use-package lsp-mode
  :ensure t
  :demand t
  ;; :init
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (prog-mode . #'dh/lsp-enable-mode)
         (lsp-mode  . lsp-enable-which-key-integration)
         (lsp-mode  . lsp-lens-mode)
         )
  ;; :general
  ;; (
  ;;  :keymap 'prog-mode
  ;;  :states 'normal
  ;;  ;; "K" #'lsp-ui-peek-find-definitions
  ;;  )
  :config
  ;; :project/:workspace/:file
  (setq read-process-output-max (* 4 1024 1024))
  (setq lsp-modeline-diagnostics-scope :project)
  (setq lsp-ui-peek-enable t
        lsp-enable-which-key-integration t
        lsp-enable-semantic-highlighting t
        lsp-diagnostics-modeline-mode t)
  (setq lsp-print-performance t)
  (add-hook 'lsp-managed-mode-hook 'lsp-diagnostics-modeline-mode)

  ;; (add-hook 'lsp-mode-hook #'lsp-lens-mode)
  :commands (lsp lsp-deferred)
  )

(use-package flycheck
  :demand t
  :ensure t
  :hook (prog-mode . flycheck-mode)

  ;; :config
  ;; (add-hook 'after-init-hook #'global-flycheck-mode)
  )

(use-package company
  ;; :disabled
  :demand t
  :ensure t
  :after (evil)
  ;;:hook (prog-mode . company-mode)
  :general
  (:states '(insert)
           ;;"TAB" 'tab-indent-or-complete
           "TAB" 'dh/complete-in-context
           )
  (company-active-map
   "TAB"  'company-complete-common-or-cycle
   "<tab>"  'company-complete-common-or-cycle

   "S-TAB"  'company-select-previous
   "<backtab>"  'company-select-previous

   "<return>"  'company-complete-selection
   "RET"  'company-complete-selection

   "ESC" 'company-abort
   "C-s" 'company-abort
   )
  ;; :bind
  ;; (
  ;;  :map
  ;;  evil-insert-state-map
  ;;  ;; ("TAB" . #'dh/complete-in-context)

  ;;  ;; ( "ESC" . company-abort)
  ;;  )
  :custom
  ;;(company-begin-commands '(self-insert-command))
  ;;(company-show-numbers t)
  (company-tooltip-align-annotations t)
  (company-minimum-prefix-length 1) ; Show suggestions after entering one character.
  (company-selection-wrap-around t)
  (company-idle-delay nil) ; Delay in showing suggestions.
  (global-company-mode t)
  ;;(setq company-tooltip-margin 4)
  :config

  ;; disable company completion of *all* remote filenames, whether
  ;; connected or not
  (defun company-files--connected-p (file)
    (not (file-remote-p file)))

  (defcustom just-complete-modes
    '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode )
    "Modes in which to just complete instead of indent or complete."
    :type 'list
    )

  (defun dh/complete-in-context ()
    (interactive)
    (if (member major-mode just-complete-modes )
        (company-complete-common-or-cycle)
      (tab-indent-or-complete)
      )
    )

  (defun company-eshell-setup ()
    (when (boundp 'company-backends)
      ;; (make-local-variable 'company-idle-delay)
      ;; (company-idle-delay 0) ; Delay in showing suggestions.
      (make-local-variable 'company-backends)
      ;; remove
      (setq company-backends nil)
      ;; add
      ;; (add-to-list 'company-backends 'company-files)
      (add-to-list 'company-backends 'company-keywords)
      (add-to-list 'company-backends 'company-capf)
      ;; (yas-minor-mode nil)
      )
    )

  (add-hook 'eshell-mode-hook 'company-eshell-setup)

  ;; (defun check-expansion ()
  ;;   (save-excursion
  ;;     (if (looking-at "\\_>") t
  ;;       (backward-char 1)
  ;;       (if (looking-at "\\.") t
  ;;         (backward-char 1)
  ;;         (if (looking-at "->") t nil)
  ;;         )
  ;;       )
  ;;     )
  ;;   )

  ;; completar siempre que no sea espacio
  (defun check-expansion ()
    (save-excursion
      (backward-char 1)
      (if (looking-at "[\n \t]")
          nil
        t
        )
      )
    )

  (defun do-yas-expand ()
    (let ((yas-fallback-behavior 'return-nil))
      (yas-expand)))

  ;; (defun tab-indent-or-complete ()
  ;;   (interactive)
  ;;   (if (minibufferp)
  ;;       (minibuffer-complete)
  ;;     (if (or (not yas-minor-mode)
  ;;             (null (do-yas-expand)))
  ;;         (if (check-expansion)
  ;;             (company-complete-common)
  ;;           ;;(indent-for-tab-command) ;; indentar correctamente
  ;;           (tab-to-tab-stop) ;; agregar tabs
  ;;           )
  ;;       )
  ;;     )
  ;;   )

  (defun tab-indent-or-complete ()
    (interactive)
    (if (minibufferp)
        (minibuffer-complete)
      (if (check-expansion)
          (company-complete-common)
        ;;(indent-for-tab-command) ;; indentar correctamente
        (tab-to-tab-stop) ;; agregar tabs
        )
      )
    )

  (defun autocomplete-show-snippets ()
    "Show snippets in autocomplete popup."
    (let ((backend (car company-backends)))
      (unless (listp backend)
        (setcar company-backends `(,backend :with company-yasnippet company-files)))))
  (add-hook 'after-change-major-mode-hook 'autocomplete-show-snippets)

  ;;(setq company-frontends (delq 'company-pseudo-tooltip-frontend company-frontends))

  ;; set default `company-backends'
  (setq company-backends
        '(
          (
           company-files          ; files & directory
           company-keywords       ; keywords
           company-capf
           company-yasnippet
           company-dabbrev-code
           ;;company-dabbrev
           ;;company-abbrev
           )
          )
        )

  (dolist (hook '(js-mode-hook
                  js2-mode-hook
                  js3-mode-hook
                  inferior-js-mode-hook
                  ))
    (add-hook hook
              (lambda ()
                (tern-mode t)
                (add-to-list
                 (make-local-variable 'company-backends)
                 'company-tern)
                )))

  (setq company-frontends
        (delq 'company-pseudo-tooltip-frontend company-frontends)
        )

    ;; (company-tng-configure-default)
    (company-tng-mode)
    (add-hook 'after-init-hook 'global-company-mode)
    ;; para probar company-box
    ;;(add-hook 'after-init-hook 'global-company-mode)

    ;; https://emacs.stackexchange.com/questions/12360/how-to-make-private-python-methods-the-last-company-mode-choices
    (defun company-transform-candidates-_-to-end (candidates)
      "mover los candidatos que inicien por _ al final"
      (let ((deleted))
        (mapcar #'(lambda (c)
                    (if (or (string-prefix-p "_" c) (string-prefix-p "._" c))
                        (progn
                          (add-to-list 'deleted c)
                          (setq candidates (delete c candidates)))))
                candidates)
        (append candidates (nreverse deleted))))

    ;; (defun my-python-yasnippet-conf()
    ;;   (setq-local company-transformers
    ;;               (append company-transformers '(company-transform-python))))

    ;; (add-hook 'python-mode-hook 'my-python-yasnippet-conf)
    (append company-transformers '(company-transform-candidates-_-to-end))

    )

;;(use-package readline-complete
	;;:ensure t
	;;)

(use-package company-quickhelp
  :ensure t
  :after (company)
  :init
  (company-quickhelp-mode)
  )

;; (use-package company-box
  ;; :ensure t
  ;; :after (company)
  ;; :hook (company-mode . company-box-mode)
  ;; :bind
  ;; (
   ;; ;;:map
   ;; ;;company-box-mode-map
   ;; ;;( "TAB" . 'company-box--next-line)
   ;; ;;( "<tab>" . 'company-box--prev-line)
   ;; )
  ;; :config
  ;; (setq company-box-doc-delay 0
        ;; company-box-doc-enable t
        ;; ;;company-box--max 10
        ;; )
  ;; )

(use-package lsp-ui
  :ensure t
  :after (lsp-mode evil)
  :commands lsp-ui-mode
  :general
  (
   :keymap 'prog-mode
   :states 'normal
   ;; "K" #'lsp-ui-peek-find-definitions
   "K" #'lsp-ui-doc-show
   )
   ;; lsp-ui-mode-map
   ;; ("S-k" . #'lsp-ui-peek-find-definitions)
   ;; ("" . #'lsp-ui-peek-find-references)
  :config
  (lsp-ui-doc-mode nil)
  (lsp-ui-doc-hide)
  :init
  (lsp-ui-mode)
  (setq lsp-ui-doc-enable nil
        lsp-ui-doc-delay nil
        )
  )

(use-package lsp-treemacs
  :ensure t
  :defer t
  :commands lsp-treemacs-errors-list
  )

(use-package yasnippet
  :demand t
  :ensure t
  :defer .1
  :hook (
         (prog-mode . yas-minor-mode)
         (org-mode . yas-minor-mode)
         )
  :general
  (yas-minor-mode-map
   "TAB" nil
   "<tab>" nil
   )
  :config
  ;; (yas-global-mode 1)

  )

(use-package ivy-yasnippet
  )

(use-package yasnippet-snippets
  :demand t
  :after yasnippet
  :config
  (yas-reload-all)
  )

;; optionally if you want to use debugger
(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-mode 1)
  (dap-auto-configure-mode)

  (dap-ui-mode 1)
  ;; enables mouse hover support
  (dap-tooltip-mode 1)
  ;; use tooltips for mouse hover
  ;; if it is not enabled `dap-mode' will use the minibuffer.
  (tooltip-mode 1)
  ;; displays floating panel with debug buttons
  ;; requies emacs 26+
  (dap-ui-controls-mode 1)
  )
;; TODO: mirar como funciona lo de dap-mode

(use-package polymode
  :disabled
  :mode ("\\.md\\'" "\\.org\\'" )
  :config
  ;; (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
  ;; (setq polymode-prefix-key (kbd "C-c n"))
  ;; (define-hostmode poly-python-hostmode :mode 'python-mode)
  )
