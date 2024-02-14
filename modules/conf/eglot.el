;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;; Paquetes adicionales para org

;;; code:

(use-package eglot
  :elpaca nil
  :after (project)
  :hook ((
         js-ts-mode
         tsx-ts-mode
         typescript-ts-mode
         web-vue-mode
         python-mode
         ) . eglot-ensure)
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
  :config
  (add-to-list 'eglot-server-programs '(web-vue-mode "vls"))
  (add-to-list 'eglot-server-programs '(typescriptreact-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs '(python-mode . ("pylsp")))
  (add-to-list 'eglot-server-programs '(arduino-mode . ("arduino-language-server")))


  ;; (cl-pushnew '(
  ;;               (js-mode typescript-mode typescriptreact-mode) . ("typescript-language-server" "--stdio")
  ;;               ((web-vue-mode) . ("vls"))
  ;;             eglot-server-programs
  ;;             :test #'equal))
  :config

  (setq eldoc-echo-area-use-multiline-p nil)
  )

;;; eglot.el ends here
