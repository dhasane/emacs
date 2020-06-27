
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

;; TODO: agregar rust-analyzer y poner esto a funcionar
(use-package rust-mode
  :ensure t
  :hook (rust-mode . lsp-deferred)
  :config
  (setq lsp-rust-analyzer-cargo-watch-enable t)
  (setq lsp-rust-server 'rust-analyzer)
  )

(use-package ccls
  :ensure t
  :defer t
  :after lsp-mode
  :hook (
         (c-mode c++-mode objc-mode cuda-mode) .
         (lambda ()
           (require 'ccls)
           (lsp-deferred)))
  :config
  ;;(setq ccls-executable "/snap/bin/ccls")
  (setq ccls-executable "/usr/bin/ccls")
  )

;; (use-package inf-ruby
	;; :ensure t
	;; :bind
	;; (:map ruby-mode
	 ;; ("C-M-x" . inf-ruby)
	 ;; )
	;; ;; :hook (ruby-mode . inf-ruby)
;;
	;; )
;;(use-package solargraph
	;;:ensure t
	;;:config
	;;(define-key ruby-mode-map (kbd "M-i") 'solargraph:complete)
	;;)

(use-package lsp-python-ms
  :ensure t
  :after lsp-mode
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp-deferred))))  ; or lsp-deferred

;; https://github.com/emacs-lsp/lsp-dart
(use-package lsp-dart
  :ensure t
  :defer t
  :after lsp-mode
  :hook (dart-mode . lsp-deferred))

(use-package lsp-java
  :ensure t
  :defer t
  :after lsp-mode
  :config
  (add-hook 'java-mode-hook #'lsp-deferred)
  (add-hook 'java-mode-hook 'flycheck-mode)
  (add-hook 'java-mode-hook 'company-mode)
  )

;; show

(use-package company
  :ensure t
  :after evil
  :bind
  (
   :map
   evil-insert-state-map
   ;;("TAB" . #'indent-or-complete)
   ("TAB" . #'tab-indent-or-complete)
   ;;("TAB" . #'complete-or-indent)
   ;;("TAB" . #'company-indent-or-complete-common)

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
  (company-idle-delay 10) ; Delay in showing suggestions.
  (global-company-mode t)
  :config

  (defun check-expansion ()
    (save-excursion
      (if (looking-at "\\_>") t
        (backward-char 1)
        (if (looking-at "\\.") t
          (backward-char 1)
          (if (looking-at "->") t nil)
          )
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
           )
          (
           company-abbrev company-dabbrev)
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

  ;; para probar company-box
  ;;(add-hook 'after-init-hook 'global-company-mode)
  )

;; (use-package company-box
  ;; :ensure t
  ;; :after company
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
  :after lsp-mode evil
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
  ;; (lsp-ui-doc-mode nil)
  ;; (lsp-ui-doc-hide)
  ;; (remove-hook 'lsp-on-hover-hook 'lsp-ui-doc--on-hover)
  :init
  (lsp-ui-mode)
  (setq lsp-ui-doc-enable nil
        ;;lsp-ui-flycheck-enable t
        )
  ;;(setq lsp-ui-sideline-enable nil
        ;;lsp-ui-sideline-show-symbol nil
        ;;lsp-ui-sideline-show-hover nil
        ;;lsp-ui-sideline-show-code-actions nil
        ;;lsp-ui-sideline-update-mode 'point)
  )

(use-package lsp-ivy
  :ensure t
  :defer t
  :commands lsp-ivy-workspace-symbol
  )

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
  :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t))
;; TODO: mirar como funciona lo de dap-mode
;; (use-package dap-java :after (lsp-java))
