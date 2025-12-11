;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuracion de eglot para conexion con lsp

;;; code:

(use-package eglot
  :ensure nil
  :after (project)
  :hook
  ((js-mode
    js-ts-mode
    tsx-mode
    tsx-ts-mode
    typescript-mode
    typescript-ts-mode
    javascript-mode
    javascript-ts-mode
    web-vue-mode
    python-mode
    python-ts-mode
    rust-mode
    rust-ts-mode)
   . eglot-ensure)
  :general
  (dahas-lsp-map
   "r" 'eglot-rename ;; "rename"                             :column "actions")                     ; "rename"
   "f"  '(:ignore t :which-key "find")
   ;; "fd" '(eglot-find-typeDefinition  :which-key "definitions")
   ;; "fr" '(eglot-find-declaration     :which-key "references")
   "a" 'eglot-code-actions
   )
  :custom
  (eglot-events-buffer-size 0)
  (eglot-autoshutdown t)
  (eglot-send-changes-idle-time 0.5)
  (flymake-no-changes-timeout 0.5)
  (eglot-confirm-server-initiated-edits nil)
  (eglot-sync-connect 0)
  (eglot-extend-to-xref t)
  :config
  ;; Prefer a single, modern TSServer backend for JS/TS/TSX.
  (add-to-list 'eglot-server-programs
               '((js-mode js-ts-mode tsx-mode tsx-ts-mode
                  typescript-mode typescript-ts-mode web-js-mode)
                 . ("typescript-language-server" "--stdio")))

  ;; Ensure tree-sitter modes share the same backends.
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("pylsp")))
  (add-to-list 'eglot-server-programs
               '((rust-ts-mode rust-mode) . ("rustup" "run" "stable" "rust-analyzer")))
  (add-to-list 'eglot-server-programs
               '((vue-mode web-vue-mode) . ("vue-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(arduino-mode . ("arduino-language-server")))

  (fset #'jsonrpc--log-event #'ignore)

  ;; (cl-pushnew '(
  ;;               (js-mode typescript-mode typescriptreact-mode) . ("typescript-language-server" "--stdio")
  ;;               ((web-vue-mode) . ("vls"))
  ;;             eglot-server-programs
  ;;             :test #'equal))
  )

;;; eglot.el ends here
