;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuracion de eglot para conexion con lsp

;;; code:

(use-package eglot
  ;; :ensure nil
  :after (project)
  :hook
  ((js-mode
    tsx-mode
    typescript-mode
    web-vue-mode
    python-mode
    python-ts-mode
    )
   . eglot-ensure)
  :general
  (
   :keymap 'eglot-mode
   :states 'normal
   "K" #'eldoc-box-help-at-point ; eldoc-box-eglot-help-at-point
   "M-K" #'eldoc-doc-buffer
   ;; "=" #'eglot-format
   )
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
  (eldoc-echo-area-use-multiline-p nil)
  (eglot-send-changes-idle-time 0.5)
  (flymake-no-changes-timeout 0.5)
  (eglot-confirm-server-initiated-edits nil)
  (eglot-sync-connect 0)
  (eglot-extend-to-xref t)
  :config
  ;; (add-to-list 'eglot-server-programs '(web-vue-mode "vue-language-server"))
  ;; (add-to-list 'eglot-server-programs '(web-vue-mode . ("npm" "vue-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs `(web-vue-mode . ("vue-language-server" "--stdio" :initializationOptions ,(vue-eglot-init-options))))
  (add-to-list 'eglot-server-programs '(typescript-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '(web-js-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '(python-mode . ("pylsp")))
  (add-to-list 'eglot-server-programs '(arduino-mode . ("arduino-language-server")))
  (add-to-list 'eglot-server-programs '(javascript-mode . ("javascript-typescript-langserver")))
  (add-to-list 'eglot-server-programs '((rust-ts-mode rust-mode) . ("rustup" "run" "stable" "rust-analyzer")))

  (fset #'jsonrpc--log-event #'ignore)

  ;; (cl-pushnew '(
  ;;               (js-mode typescript-mode typescriptreact-mode) . ("typescript-language-server" "--stdio")
  ;;               ((web-vue-mode) . ("vls"))
  ;;             eglot-server-programs
  ;;             :test #'equal))
  )

;;; eglot.el ends here
