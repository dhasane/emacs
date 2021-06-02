;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(defcustom lsp-ignore-modes
  '(
    emacs-lisp-mode
    ;; typescript-mode
    ;; ng2-ts-mode
    csharp-mode
    makefile-mode
    shell-script-mode
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
  ;; :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
  ;;        (prog-mode . #'dh/lsp-enable-mode)
  ;;        (lsp-mode  . lsp-enable-which-key-integration)
  ;;        (lsp-managed-mode-hook . lsp-modeline-diagnostics-mode)
  ;;        ;; (lsp-mode . #'lsp-lens-mode)
  ;;        )
  :custom
  (lsp-keymap-prefix "C-c l")

  ;; :project/:workspace/:file
  ;; (lsp-modeline-diagnostics-scope :project)
  (lsp-ui-peek-enable t)
  (lsp-semantic-tokens-enable t)
  (lsp-enable-indentation t)
  ;;;;   (lsp-file-watch-threshold 500)
  (lsp-enable-snippet nil)
  (lsp-intelephense-multi-root t)

  ;; debug
  ;; (lsp-print-io t)
  ;; (lsp-trace t)
  ;; (lsp-print-performance t)

  ;; general
  ;; (lsp-auto-guess-root nil)
  (lsp-headerline-breadcrumb-enable t)
  ;;;;   (lsp-document-sync-method 'incremental) ;; none, full, incremental, or nil
  ;;;;   (lsp-response-timeout 10)

  (read-process-output-max (* 4 1024 1024))

  ;; (lsp-auto-configure nil)
  (lsp-enable-file-watchers t)
  (lsp-eldoc-render-all nil)
  (lsp-completion-enable t)
  (lsp-keep-workspace-alive nil)

  :config
  (lsp-enable-which-key-integration t)
  (lsp-modeline-diagnostics-mode t)
  ;; lsp-log-io nil

  ;; (lsp-session-folders-blacklist "~")

  ;; (defun lsp-on-save-operation ()
  ;;   (when (or (boundp 'lsp-mode)
  ;;             (bound-p 'lsp-deferred))
  ;;     (lsp-organize-imports)
  ;;     (lsp-format-buffer)))
  ;; (add-hook 'lsp-mode-hook #'lsp-lens-mode)
  )

(use-package lsp-ui
  :ensure t
  :after (lsp-mode evil)
  :commands lsp-ui-mode
  ;; :hook (lsp-ui-mode . sideline-mode)
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

  ;; debug
  (lsp-print-io t)

  ;; ui-doc
  (lsp-ui-doc-enable nil)
  (lsp-ui-doc-delay nil)

  (lsp-ui-doc-header t)
  (lsp-ui-doc-include-signature t)
  (lsp-ui-doc-position 'top)
  (lsp-ui-doc-border (face-foreground 'default))

  ;; sideline
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-symbol t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline-update-mode 'line) ;; 'point)
  (lsp-ui-sideline-ignore-duplicate t)
  (lsp-ui-sideline-show-code-actions t)

  (lsp-ui-sideline-delay 0.7)

  ;; signature
  (lsp-signature-render-documentation nil)

  ;; modeline actions
  (lsp-auto-execute-action nil)

  ;; imenu
  (lsp-ui-imenu-window-width 30)

  (lsp-ui-sideline-diagnostic-max-lines 10)
  :custom-face
  (lsp-ui-sideline-current-symbol ((t (:foreground "black" :background "#689d6b"))))
  (lsp-ui-sideline-global
   ((t (:box (:line-width (-1 . -1) :color "grey75" :style released-button)))))
  )

(use-package lsp-treemacs
  :ensure t
  :defer t
  :commands lsp-treemacs-errors-list
  )

(use-package lsp-origami )

;;; lsp ends here
