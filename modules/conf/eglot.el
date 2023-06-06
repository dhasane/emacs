

(use-package project)

(use-package eglot
  :after (project)
  :hook ((
         js-ts-mode
         tsx-ts-mode
         typescript-ts-mode
         dh-vue-mode
         ) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs '(dh-vue-mode "vls"))
  (add-to-list 'eglot-server-programs '(typescriptreact-mode ("typescript-language-server" "--stdio")))

  ;; (cl-pushnew '(
  ;;               (js-mode typescript-mode typescriptreact-mode) . ("typescript-language-server" "--stdio")
  ;;               ((dh-vue-mode) . ("vls"))
  ;;             eglot-server-programs
  ;;             :test #'equal))
  )
