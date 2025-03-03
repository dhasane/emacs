;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package lsp-mode
  :demand t
  :hook
  (
   (
  ;;   rust-mode
  ;;   ;; ruby-mode
  ;;   java-mode
    js-mode
    typescript-mode
    tsx-mode
    python-mode
    python-ts-mode
  ;;   dart-mode
  ;;   c-mode
  ;;   c++-mode
  ;;   objc-mode
  ;;   cuda-mode
  ;;   haskell-mode
  ;;   haskell-literate-mode
  ;;   gdscript-mode
    )
   . lsp-deferred
   )
  (lsp-mode . sideline-mode)
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
  (indent-tabs-mode nil)

  (lsp-keymap-prefix "C-c l")

  (lsp-enable-on-type-formatting nil)
  (lsp-enable-file-watchers nil)
  (lsp-enable-xref t)
  (lsp-enable-completion-at-point t)

  (lsp-headerline-breadcrumb-mode nil)

  ;; :project/:workspace/:file
  ;; (lsp-modeline-diagnostics-scope :project)
  (lsp-ui-peek-enable t)
  (lsp-semantic-tokens-enable t)
  (lsp-enable-indentation t)
  ;;;;   (lsp-file-watch-threshold 500)

  (lsp-idle-delay 0.500)
  ;; debug
  ;; (lsp-print-io t)
  ;; (lsp-trace t)
  ;; (lsp-print-performance t)

  (lsp-lens-enable t)
  ;; general
  (lsp-log-io nil)
  (lsp-enable-snippet nil)
  (lsp-enable-completion-at-point t)
  ;; (lsp-auto-guess-root nil)
  (lsp-headerline-breadcrumb-enable nil)
  ;;;;   (lsp-document-sync-method 'incremental) ;; none, full, incremental, or nil
  ;;;;   (lsp-response-timeout 10)

  (read-process-output-max (* 4 1024 1024))

  ;; (lsp-auto-configure nil)

  (lsp-eldoc-render-all nil)
  (lsp-completion-enable t)
  (lsp-keep-workspace-alive nil)
  ;; (lsp-file-watch-ignored
  ;;  '(".idea" ".ensime_cache" ".eunit" "node_modules"
  ;;    ".git" ".hg" ".fslckout" "_FOSSIL_"
  ;;    ".bzr" "_darcs" ".tox" ".svn" ".stack-work"
  ;;    "build"))

  (lsp-completion-provider ;; :capf
			   :none) ;; we use Corfu!

  :config
  (lsp-enable-which-key-integration t)
  (lsp-modeline-diagnostics-mode t)

  :general
  (dahas-lsp-map
   "r" '(lsp-rename               :wk "rename") ;; :column "actions")
   "a" '(lsp-execute-code-action  :wk "code action")
   )
  )

(use-package lsp-ui
  ; :unless (eq system-type 'windows-nt)
  :after (lsp-mode)
  ;; :general
  ;; (
  ;;  :keymap 'lsp-mode
  ;;  :states 'normal
  ;;  ;; "K" #'lsp-ui-peek-find-definitions
  ;;  "K" #'lsp-ui-doc-show
  ;;  )
   ;; lsp-ui-mode-map
   ;; ("S-k" . #'lsp-ui-peek-find-definitions)
   ;; ("" . #'lsp-ui-peek-find-references)
  :config
  (lsp-ui-doc-mode nil)
  (lsp-ui-doc-hide)

  (with-eval-after-load 'lsp-mode
    (defun my/lsp-execute-code-action ()
      (interactive)
      (->> (lsp-code-actions-at-point)
           (seq-filter (-lambda ((&CodeAction :kind?))
                         (or (not kind?)
                             (s-match "quickfix.*\\|refactor.*" kind?))))
           (lsp--select-action)
           (lsp-execute-code-action))))

  ;; (defhydra+ hydra-lsp ()
  ;;   ("fd" lsp-ui-peek-find-definitions "definitions"      :column "find")
  ;;   ("fr" lsp-ui-peek-find-references "references"        :column "find")
  ;;   ("lm" lsp-ui-imenu "imenu"                            :column "menu")
  ;;   )
  :general
  ;; (:keymaps 'dahas-lsp-map
  ;;  "f"  '(:ignore t :which-key "find")
  ;;  "fd" '(lsp-ui-peek-find-definitions  :which-key "definitions")
  ;;  "fr" '(lsp-ui-peek-find-references   :which-key "references")
  ;;  "m"  '(lsp-ui-imenu :which-key "imenu")                  ;; "imenu"                            :column "menu")
   )

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
  (lsp-ui-sideline-enable nil)
  (lsp-ui-sideline-show-symbol nil)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-sideline-update-mode 'line) ;; 'point)
  (lsp-ui-sideline-ignore-duplicate t)
  (lsp-ui-sideline-show-code-actions t)

  (lsp-ui-sideline-delay 1.5) ;;0.7)
  (lsp-ui-sideline-diagnostic-max-lines 10)

  ;; signature
  (lsp-signature-render-documentation nil)

  ;; modeline actions
  (lsp-auto-execute-action nil)

  ;; imenu
  (lsp-ui-imenu-window-width 0)

  :custom-face
  (lsp-ui-sideline-current-symbol ((t (:foreground "black" :background "#689d6b"))))
  (lsp-ui-sideline-global
   ((t
     (:box (:line-width (-1 . -1) :color "grey75" :style released-button))
     ;; (:line-width (-1 . -1) :color "grey75" :style released-button)
     )))
  )

(use-package lsp-treemacs
  :disabled t
  :after 'treemacs
  :defer t
  :commands lsp-treemacs-errors-list
  :config
  (defhydra+ hydra-lsp ()
    ("fh" lsp-treemacs-call-hierarchy "call hierarchy"    :column "find")
    )
  )

(use-package lsp-origami)

;; optionally if you want to use debugger
(use-package dap-mode
  :after lsp-mode
  :config
  (dap-mode 1)
  (dap-auto-configure-mode)

  (dap-ui-mode t)
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

;;; lsp.el ends here
