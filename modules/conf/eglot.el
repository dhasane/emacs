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
  )

;;; eglot.el ends here
