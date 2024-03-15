;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;; Paquetes adicionales para org

;;; code:

(use-package eglot
  :elpaca nil
  :after (project)
  :hook (prog-mode . eglot-ensure)
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
   "fd" '(eglot-find-typeDefinition  :which-key "definitions")
   "fr" '(eglot-find-declaration     :which-key "references")
   "a" 'eglot-code-actions
   )
  :custom
  (eglot-events-buffer-size 0)
  (eglot-autoshutdown t)
  (eldoc-echo-area-use-multiline-p nil)
  (eglot-send-changes-idle-time 0.5)
  (flymake-no-changes-timeout 0.5)
  :config
  (add-to-list 'eglot-server-programs '(web-vue-mode "vls"))
  (add-to-list 'eglot-server-programs '(typescript-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '(web-js-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '(python-mode . ("pylsp")))
  (add-to-list 'eglot-server-programs '(arduino-mode . ("arduino-language-server")))
  (add-to-list 'eglot-server-programs '(javascript-mode . ("javascript-typescript-langserver")))

  (fset #'jsonrpc--log-event #'ignore)

  ;; (cl-pushnew '(
  ;;               (js-mode typescript-mode typescriptreact-mode) . ("typescript-language-server" "--stdio")
  ;;               ((web-vue-mode) . ("vls"))
  ;;             eglot-server-programs
  ;;             :test #'equal))
  )

(use-package breadcrumb
  :config
  (breadcrumb-mode)
  )

;;; eglot.el ends here
