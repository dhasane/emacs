
;; lsp -----------------------------------------------------
;;; code:
(defcustom lsp-ignore-modes
  '(
    emacs-lisp-mode
    ;; typescript-mode
    ;; ng2-ts-mode
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
  :defines
  (
   lsp-modeline-diagnostics-scope
   lsp-ui-peek-enable
   lsp-enable-which-key-integration
   lsp-enable-semantic-highlighting
   lsp-diagnostics-modeline-mode
  )
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (prog-mode . #'dh/lsp-enable-mode)
         (lsp-mode  . lsp-enable-which-key-integration)
         ;; (lsp-mode  . lsp-modeline-diagnostics-mode)
         (lsp-managed-mode-hook . lsp-modeline-diagnostics-mode)
         )
  :custom
  ;; :project/:workspace/:file
  (lsp-modeline-diagnostics-scope :project)
  (lsp-ui-peek-enable t)
  (lsp-enable-semantic-highlighting t)
  (lsp-enable-indentation t)
  (lsp-file-watch-threshold 500)
  (lsp-enable-snippet nil)

  ;; (lsp-intelephense-multi-root nil)

  ;; debug
  (lsp-print-io t)
  (lsp-trace t)
  (lsp-print-performance t)

  ;; general
  (lsp-auto-guess-root nil)
  (lsp-document-sync-method 'incremental) ;; none, full, incremental, or nil
  (lsp-response-timeout 10)

  :config
  (setq read-process-output-max (* 4 1024 1024))
  (setq lsp-enable-which-key-integration t
        ;; lsp-log-io nil
        lsp-diagnostics-modeline-mode nil
        )

  ;; (lsp-session-folders-blacklist "~")

  ;; (defun lsp-on-save-operation ()
  ;;   (when (or (boundp 'lsp-mode)
  ;;             (bound-p 'lsp-deferred))
  ;;     (lsp-organize-imports)
  ;;     (lsp-format-buffer)))
  ;; (add-hook 'lsp-mode-hook #'lsp-lens-mode)
  :commands (lsp lsp-deferred)
  )

(use-package lsp-ivy
  )

(use-package ivy-avy
  )

(use-package flycheck
  :demand t
  :ensure t
  :hook (prog-mode . flycheck-mode)

  :custom
  (flycheck-check-syntax-automatically '(save idle-change mode-enabled))
  ;; :config
  ;; (add-hook 'after-init-hook #'global-flycheck-mode)
  )

(use-package company
  ;; :disabled t
  :after (evil)
  :demand t
  :ensure t
  :defer .1
  :hook (prog-mode . company-mode)
  :general
  (
   :keymap 'prog-mode
   :states '(insert)
   "TAB" 'tab-indent-or-complete
   )
  (
   :keymaps 'company-active-map
   "TAB" 'company-complete-common-or-cycle
   "<tab>" 'company-complete-common-or-cycle

   "S-TAB" 'company-select-previous
   "<backtab>" 'company-select-previous

   "RET" 'company-complete-selection
   "<return>" 'company-complete-selection
   "<ret>" 'company-complete-selection

   [escape] 'company-abort
   )
  :functions
  (
   check-expansion
   )
  :custom
  ;;(company-begin-commands '(self-insert-command))
  ;;(company-show-numbers t)
  (company-tooltip-align-annotations t)
  (company-minimum-prefix-length 1) ; Show suggestions after entering one character.
  (company-selection-wrap-around t)
  (company-idle-delay nil) ; Delay in showing suggestions.
  (global-company-mode t)
  ;;(setq company-tooltip-margin 4)

  (company-tooltip-maximum-width 60) ;; normalizar y evitar saltos
  (company-tooltip-minimum-width 60)
  (company-tng-mode t)
  (company-tng-auto-configure nil)
  (company-require-match nil)
  :config

  (company-tng-mode)

  (evil-make-intercept-map company-active-map 'insert)

  ;; disable company completion of *all* remote filenames, whether
  ;; connected or not
  (defun company-files--connected-p (file)
    (not (file-remote-p file)))

  (defun check-expansion ()
    (save-excursion
      (if (looking-at "\\_>") t
        (backward-char 1)
        (if (looking-at "\\.") t
          (backward-char 1)
          (if (looking-at "->") t
            (if (looking-at "::") t
              nil)
            )
          )
        )
      )
    )

  ;; completar siempre que no sea espacio
  ;; (defun check-expansion ()
  ;;   (save-excursion
  ;;     (backward-char 1)
  ;;     (if (looking-at "[\n \t]")
  ;;         nil
  ;;       t
  ;;       )
  ;;     )
  ;;   )

  ;; (defun do-yas-expand ()
  ;;   (let ((yas-fallback-behavior 'return-nil))
  ;;     (yas-expand)))

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

  ;; (defun autocomplete-show-snippets ()
  ;;   "Show snippets in autocomplete popup."
  ;;   (let ((backend (car company-backends)))
  ;;     (unless (listp backend)
  ;;       (setcar company-backends `(,backend :with company-yasnippet company-files)))))
  ;; (add-hook 'after-change-major-mode-hook 'autocomplete-show-snippets)

  ;;(setq company-frontends (delq 'company-pseudo-tooltip-frontend company-frontends))

  ;; set default `company-backends'
  (setq company-backends
        '(
          (
           company-files          ; files & directory
           company-keywords       ; keywords
           company-capf
           ;; company-yasnippet
           company-dabbrev-code
           ;;company-dabbrev
           ;;company-abbrev
           )
          )
        )

  ;; (add-hook 'after-init-hook 'global-company-mode)
  (global-company-mode)

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

  (append company-transformers '(company-transform-candidates-_-to-end))

  ;; (company-tng-configure-default)
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

(use-package company-box
  :ensure t
  :after (company)
  :hook (company-mode . company-box-mode)
  :config
  (setq company-box-doc-delay 0
        company-box-doc-enable t
        ;;company-box--max 10
        )

  (setq company-box-backends-colors
        '(
          (company-yasnippet :all "lime green"
                             :selected
                             (
                              :background "lime green"
                              :foreground "black"
                              ))
          (company-elisp . (:icon "yellow"
                                  :selected (
                                             :background "orange"
                                             :foreground "black")))
        (company-dabbrev . "purple")
        ;;(company-)
        )
        )
  )

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
  :defines
  (
   yas-reload-all
  )
  :hook (
         (prog-mode . yas-minor-mode)
         (org-mode . yas-minor-mode)
         (text-mode . yas-minor-mode)
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
  :defines
  (yas-reload-all)
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

(use-package tree-sitter

  )
