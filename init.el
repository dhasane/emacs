;;; package --- Summary  -*- lexical-binding: t; -*-

;; ███████╗███╗   ███╗ █████╗  ██████╗███████╗
;; ██╔════╝████╗ ████║██╔══██╗██╔════╝██╔════╝
;; █████╗  ██╔████╔██║███████║██║     ███████╗
;; ██╔══╝  ██║╚██╔╝██║██╔══██║██║     ╚════██║
;; ███████╗██║ ╚═╝ ██║██║  ██║╚██████╗███████║
;; ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝

;;; Commentary:

;; configuracion de Emacs asi como bien pro

;;; code:

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file)

(load (expand-file-name "config-loader.el" user-emacs-directory))
(cl/load (cl/dir "modules/package"
                 :alt '((1 . ("straight" "elpaca"))))
         (cl/file "modules/startup")
         (cl/file "modules/startup-keybinds")
         (cl/file "modules/pack")
         (cl/dir "modules/conf"
                 :alt '((1 . ("company" "corfu"))
                        (0 . ("completion" "ivy"))
                        (1 . ("lsp" "eglot"))))
         (cl/dir "modules/langs"
                 :ignore '("lisp")
                 )
         (cl/dir "modules/extra"
                 :ignore '("email" "epub" "fira-code" "games" "telegram" "org-papers" "pdf")
                 )
         (cl/file "keybinds"))

;;; init.el ends here
