
;; lsp -----------------------------------------------------
;;; code:

(use-package lsp-mode
  :defer t
  :ensure t
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (ruby-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration)
         )
  :config
  (with-eval-after-load 'lsp-mode
    ;; :project/:workspace/:file
    (setq lsp-diagnostics-modeline-scope :project)
    (add-hook 'lsp-managed-mode-hook 'lsp-diagnostics-modeline-mode))
  (lsp-diagnostics-modeline-mode t)

  (add-hook 'lsp-mode-hook #'lsp-lens-mode)
  ;;:commands lsp
  :commands (lsp lsp-deferred)
  )

(use-package flycheck
    :ensure t
    :config
    (add-hook 'after-init-hook #'global-flycheck-mode)
    )

(use-package company
  :ensure t
  :after (evil)
  ;;:hook (prog-mode . company-mode)
  :bind
  (
   :map
   evil-insert-state-map
   ("TAB" . #'dh/complete-in-context)

   :map
   company-active-map
   ( "TAB" . 'company-complete-common-or-cycle)
   ( "<tab>" . 'company-complete-common-or-cycle)

   ( "S-TAB" . 'company-select-previous)
   ( "<backtab>" . 'company-select-previous)

   ( "<return>" . 'company-complete-selection)
   ( "RET" . 'company-complete-selection)
   )
  :custom
  ;;(company-begin-commands '(self-insert-command))
  ;;(company-show-numbers t)
  (company-tooltip-align-annotations 't)
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
      (make-local-variable 'company-backends)
      ;; remove
      (setq company-backends nil)
      ;; add
      ;; (add-to-list 'company-backends 'company-files)
      (add-to-list 'company-backends 'company-keywords)
      (add-to-list 'company-backends 'company-capf)
      )
    )

  (add-hook 'eshell-mode-hook 'company-eshell-setup)

  ;;(defun check-expansion ()
    ;;(save-excursion
      ;;(if (looking-at "\\_>") t
        ;;(backward-char 1)
        ;;(if (looking-at "\\.") t
          ;;(backward-char 1)
          ;;(if (looking-at "->") t nil)
          ;;)
        ;;)
      ;;)
    ;;)

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

	(defun tab-indent-or-complete ()
		(interactive)
		(if (minibufferp)
				(minibuffer-complete)
			(if (or (not yas-minor-mode)
							(null (do-yas-expand)))
					(if (check-expansion)
							(company-complete-common)
						;;(indent-for-tab-command) ;; indentar correctamente
						(tab-to-tab-stop) ;; agregar tabs
						)
				)
			)
		)

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

	(company-tng-configure-default)
  ;; para probar company-box
  ;;(add-hook 'after-init-hook 'global-company-mode)
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
  :bind
  (:map
   evil-normal-state-map
   ("K" . 'lsp-ui-doc-show )
   ;; lsp-ui-mode-map
   ;; ("S-k" . #'lsp-ui-peek-find-definitions)
   ;; ("" . #'lsp-ui-peek-find-references)
   )
  :config
  (lsp-ui-doc-mode nil)
  (lsp-ui-doc-hide)
  :init
  (lsp-ui-mode)
  (setq lsp-ui-doc-enable nil
				lsp-ui-doc-delay nil
        )
  )

;;(use-package lsp-ivy
  ;;:ensure t
  ;;:defer t
  ;;:commands lsp-ivy-workspace-symbol
  ;;)

(use-package lsp-treemacs
  :ensure t
  :defer t
  :commands lsp-treemacs-errors-list
  )

(use-package yasnippet
  :ensure t
  :defer .1
  :hook (prog-mode-hook-hook . yas-minor-mode)
  ;;:config (yas-global-mode)
  )

;; optionally if you want to use debugger
(use-package dap-mode
  :ensure t
  :after (lsp-mode)
  :config
  (dap-mode t)
  (dap-ui-mode t))
;; TODO: mirar como funciona lo de dap-mode
;; (use-package dap-java :after (lsp-java))

(defconst config-lang-dir (expand-file-name "modules/langs/" user-emacs-directory)
  "Directorio de modulos de configuracion.")

(load-config-module
 config-lang-dir
 '(
   "c-based"
   "dart"
   "java"
   "python"
   "ruby"
   "rust"
   "markdown.el"
   "web.el"
   "dart.el"
   "lua.el"
   "yaml.el"
   )
 )

(use-package polymode
  :config
  (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
  (setq polymode-prefix-key (kbd "C-c n"))
  (define-hostmode poly-python-hostmode :mode 'python-mode)
  )
