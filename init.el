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

(cl/load (cl/file "startup")
         (cl/dir "modules/conf" :ignore '("ivy"))
         (cl/dir "modules/langs" :ignore
                 '("dart" "haskell" "kotlin" "latex" "lisp" "lua" "markdown" "ruby"))
         (cl/file "keybinds"))

;;; init.el ends here
