
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
  :after lsp-mode company
  :hook (
         (c-mode c++-mode objc-mode cuda-mode cc-mode c++//l) .
         (lambda ()
           (require 'ccls)
           (lsp-deferred)))
  :config
  ;;(setq ccls-executable "/snap/bin/ccls")
  ;; (setq ccls-executable "/usr/bin/ccls")
  (setq ccls-executable "~/.nix-profile/bin/ccls")
  )

(use-package irony
	:ensure t
    :hook ((c-mode c++-mode objc-mode cuda-mode cc-mode c++//l) .
         (lambda ()
           (irony-mode)))
	:hook (irony-mode . irony-cdb-autosetup-compile-options)
    :config
    (unless (irony--find-server-executable)
      (call-interactively #'irony-install-server))
    )

(use-package company-irony
	:ensure t
	:after irony company
	:config
	(add-to-list 'company-backends 'company-irony)
	)

;;(require 'flycheck-kotlin)
;;(add-hook 'kotlin-mode-hook 'flycheck-mode)
;;(lsp-register-client
 ;;(make-lsp-client
	;;:new-connection (lsp-stdio-connection '("path to what you want to use"))
	;;:major-modes '(kotlin-mode)
	;;:priority -1
	;;:server-id 'kotlin-ls))

(setq ruby-indent-tabs-mode nil)

(use-package inf-ruby
  :ensure t
  :bind
  (:map
   ruby-mode-map
   ("C-c C-c" . inf-ruby)
   ("C-M-x" . ruby-send-block)
   )
  :hook
  (ruby-mode . 'inf-ruby-keys)
  ;;:config

  ;(define-key ruby-mode-map [S-f7] 'ruby-compilation-this-buffer)
  ;;(eval-after-load 'ruby-mode
  ;;'(add-hook 'ruby-mode-hook 'inf-ruby-keys))

  ;; (define-key ruby-mode-map (kbd "C-c C-c") 'inf-ruby)
  ;; :hook (ruby-mode . inf-ruby)

  )
;;(use-package solargraph
	;;:ensure t
	;;:config
	;;(define-key ruby-mode-map (kbd "M-i") 'solargraph:complete)
	;;)

(use-package lsp-python-ms
  :ensure t
  :after lsp-mode company
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp-deferred))))  ; or lsp-deferred

(use-package elpy
  :ensure t
  :hook (python-mode . elpy-enable)
  ;;(elpy-enable)
  )

(setq python-shell-interpreter "python3")

;; https://github.com/emacs-lsp/lsp-dart
(use-package lsp-dart
  :ensure t
  :defer t
  :after lsp-mode company
  :hook (dart-mode . lsp-deferred))

(use-package lsp-java
  :ensure t
  :after lsp-mode company
  :config
  (add-hook 'java-mode-hook #'lsp-deferred)
  (add-hook 'java-mode-hook 'flycheck-mode)
  (add-hook 'java-mode-hook 'company-mode)
  )

(use-package flycheck
    :ensure t
    :config
    (add-hook 'after-init-hook #'global-flycheck-mode)
    )

(use-package company
  :ensure t
  :after evil
  :bind
  (
   :map
   evil-insert-state-map
   ("TAB" . #'tab-indent-or-complete)

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
	(setq company-tooltip-margin 4)
  :config

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
           company-dabbrev
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
	:after company
	:init
	(company-quickhelp-mode)
	)

(use-package robe
	:ensure t
	:after company
	:hook (ruby-mode . robe-mode)
	:config
	(eval-after-load 'company
  '(push 'company-robe company-backends))
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
  :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t))
;; TODO: mirar como funciona lo de dap-mode
;; (use-package dap-java :after (lsp-java))
