
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(use-package ccls
  :ensure t
  :after (company)
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp-deferred)))
  :config
  (setq ccls-code-lens-position 'end)
  (setq ccls-executable "~/.nix-profile/bin/ccls")
  (setq ccls-sem-highlight-method 'font-lock)
  ;; alternatively, (setq ccls-sem-highlight-method 'overlay)

  ;; For rainbow semantic highlighting
  (ccls-use-default-rainbow-sem-highlight)

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
	;; :after (irony company)
	;; :config
	;; (add-to-list 'company-backends 'company-irony)
	;; )

(use-package csharp-mode
  )

(use-package omnisharp
  :after company
  :config
  ;; (omnisharp-start-omnisharp-server)

  (shell-command
   "export DOTNET_CLI_TELEMETRY_OPTOUT=1")

  (add-hook 'csharp-mode-hook 'omnisharp-mode)
  (add-hook 'csharp-mode-hook 'flycheck-mode)
  (add-to-list 'company-backends 'company-omnisharp))
