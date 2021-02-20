;;; package --- Summary

;;; Commentary:

;;; code:

;; -*- lexical-binding: t; -*-

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

(use-package lsp-mode :ensure t)

(use-package lsp-mode
  :disabled
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
         (lsp-managed-mode-hook . lsp-modeline-diagnostics-mode)
         ;; (lsp-mode . #'lsp-lens-mode)
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
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-prefer-flymake nil)
  ;; (lsp-diagnostics-provider :flymake)
  (lsp-document-sync-method 'incremental) ;; none, full, incremental, or nil
  (lsp-response-timeout 10)

  (lsp-enable-which-key-integration t)
  (lsp-diagnostics-modeline-mode nil)
  (read-process-output-max (* 4 1024 1024))

  (lsp-auto-configure nil)
  (lsp-enable-file-watchers t)
  (lsp-eldoc-render-all t)
  (lsp-completion-enable t)
  (lsp-keep-workspace-alive nil)

  :config
  ;; lsp-log-io nil

  ;; (lsp-session-folders-blacklist "~")

  ;; (defun lsp-on-save-operation ()
  ;;   (when (or (boundp 'lsp-mode)
  ;;             (bound-p 'lsp-deferred))
  ;;     (lsp-organize-imports)
  ;;     (lsp-format-buffer)))
  ;; (add-hook 'lsp-mode-hook #'lsp-lens-mode)
  :commands (lsp lsp-deferred)
  )

(use-package lsp-ui
  :ensure t
  :demand t
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
  :custom
  (lsp-ui-doc-enable nil)
  (lsp-ui-doc-delay nil)

  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-symbol t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline-showcode-actions t)
  (lsp-ui-sideline-update-mode 'point)

  (lsp-ui-doc-header t)
  (lsp-ui-doc-include-signature t)
  (lsp-ui-doc-position 'top)
  (lsp-ui-doc-border (face-foreground 'default))
  (lsp-ui-sideline-enable nil)
  (lsp-ui-sideline-ignore-duplicate t)
  (lsp-ui-sideline-show-code-actions nil)
  )

(use-package lsp-treemacs
  :ensure t
  :defer t
  :commands lsp-treemacs-errors-list
  )

;;; lsp ends here
