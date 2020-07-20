
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

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(use-package ccls
  :ensure t
  :after company
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp-deferred)))
  :config
  (setq ccls-code-lens-position 'end)
  (setq lsp-prefer-flymake nil)
  (setq ccls-executable "~/.nix-profile/bin/ccls")
  (setq ccls-sem-highlight-method 'font-lock)
  ;; alternatively, (setq ccls-sem-highlight-method 'overlay)

  ;; For rainbow semantic highlighting
  ;;(ccls-use-default-rainbow-sem-highlight)

  (setq company-transformers nil company-lsp-async t company-lsp-cache-candidates nil)
                                        ; Use lsp-goto-implementation or lsp-ui-peek-find-implementation (textDocument/implementation) for derived types/functions
                                        ; $ccls/inheritance is more general


  ;; References whose filenames are under this project
  ;; (lsp-ui-peek-find-references nil (list :folders (vector (projectile-project-root))))
  )

;;(eval-after-load 'ccls
;;
  ;;;;(lsp-ui-peek-find-custom "$ccls/call")
  ;;;; direct callers
  ;;(lsp-find-custom "$ccls/call")
  ;;;; callers up to 2 levels
  ;;(lsp-find-custom "$ccls/call" '(:levels 2))
  ;;;; direct callees
  ;;(lsp-find-custom "$ccls/call" '(:callee t))
;;
  ;;(lsp-find-custom "$ccls/vars")
  ;;;; Alternatively, use lsp-ui-peek interface
  ;;(lsp-ui-peek-find-custom "$ccls/call")
  ;;(lsp-ui-peek-find-custom "$ccls/call" '(:callee t))
;;
  ;;(defun ccls/callee ()
    ;;(interactive) (lsp-ui-peek-find-custom "$ccls/call" '(:callee t)))
  ;;(defun ccls/caller ()
    ;;(interactive) (lsp-ui-peek-find-custom "$ccls/call"))
;;
  ;;(defun ccls/vars (kind)
    ;;(lsp-ui-peek-find-custom "$ccls/vars" `(:kind ,kind)))
  ;;(defun ccls/base (levels)
    ;;(lsp-ui-peek-find-custom "$ccls/inheritance" `(:levels ,levels)))
  ;;(defun ccls/derived (levels)
    ;;(lsp-ui-peek-find-custom "$ccls/inheritance" `(:levels ,levels :derived t)))
  ;;(defun ccls/member (kind)
    ;;(interactive) (lsp-ui-peek-find-custom "$ccls/member" `(:kind ,kind)))
;;
  ;;;; References w/ Role::Role
  ;;(defun ccls/references-read ()
    ;;(interactive)
    ;;(lsp-ui-peek-find-custom
     ;;"textDocument/references"
     ;;(plist-put (lsp--text-document-position-params) :role 8)))
;;
  ;;;; References w/ Role::Write
  ;;(defun ccls/references-write ()
    ;;(interactive)
    ;;(lsp-ui-peek-find-custom
     ;;"textDocument/references"
     ;;(plist-put (lsp--text-document-position-params) :role 16)))
;;
  ;;;; References w/ Role::Dynamic bit (macro expansions)
  ;;(defun ccls/references-macro ()
    ;;(interactive)
    ;;(lsp-ui-peek-find-custom
     ;;"textDocument/references"
     ;;(plist-put (lsp--text-document-position-params) :role 64)))
;;
  ;;;; References w/o Role::Call bit (e.g. where functions are taken addresses)
  ;;(defun ccls/references-not-call ()
    ;;(interactive)
    ;;(lsp-ui-peek-find-custom
     ;;"textDocument/references"
     ;;(plist-put (lsp--text-document-position-params) :excludeRole 32)))
;;
;;
;;
  ;;)

  ;; ccls/vars ccls/base ccls/derived ccls/members have a parameter while others are interactive.
  ;; (ccls/base 1) direct bases
  ;; (ccls/derived 1) direct derived
  ;; (ccls/member 2) => 2 (Type) => nested classes / types in a namespace
  ;; (ccls/member 3) => 3 (Func) => member functions / functions in a namespace
  ;; (ccls/member 0) => member variables / variables in a namespace
  ;; (ccls/vars 1) => field
  ;; (ccls/vars 2) => local variable
  ;; (ccls/vars 3) => field or local variable. 3 = 1 | 2
  ;; (ccls/vars 4) => parameter


;; (use-package irony
	;; :ensure t
    ;; :hook ((c-mode c++-mode objc-mode cuda-mode cc-mode c++//l) .
         ;; (lambda ()
           ;; (irony-mode)))
	;; :hook (irony-mode . irony-cdb-autosetup-compile-options)
    ;; :config
    ;; (unless (irony--find-server-executable)
      ;; (call-interactively #'irony-install-server))
    ;; )
;;
;; (use-package company-irony
	;; :ensure t
	;; :after irony company
	;; :config
	;; (add-to-list 'company-backends 'company-irony)
	;; )

;;(require 'flycheck-kotlin)
;;(add-hook 'kotlin-mode-hook 'flycheck-mode)
;;(lsp-register-client
 ;;(make-lsp-client
	;;:new-connection (lsp-stdio-connection '("path to what you want to use"))
	;;:major-modes '(kotlin-mode)
	;;:priority -1
	;;:server-id 'kotlin-ls))

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
  ;;:hook (prog-mode . company-mode)
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
  ;;(global-company-mode t)
  ;;(setq company-tooltip-margin 4)
  :config

  ;;(setq company-global-modes '(not eshell-mode))

  ;; disable company completion of *all* remote filenames, whether
  ;; connected or not
  (defun company-files--connected-p (file)
    (not (file-remote-p file)))

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

(use-package robe
	:ensure t
	:after company
	:hook (ruby-mode . robe-mode)
	:config
    '(push 'company-robe company-backends)
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
