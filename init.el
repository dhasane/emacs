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

;; TODO: temp solution
(defvar native-comp-deferred-compilation-deny-list nil)

(load (expand-file-name "config-loader.el" user-emacs-directory))

(cl/load (cl/file "startup")
         (cl/dir "modules/conf" :ignore '("ivy"))
         (cl/dir "modules/langs"
                 :ignore '("lisp")
                 :lazy
                 '(
                   (".dart" . "dart")
                   (".lua" . "lua")
                   (".java" . "java")
                   (".rs" . "rust")
                   (".rb" . "ruby")
                   (".py" . "python")
                   (".gd" . "godot")
                   (".js" . "web")
                   (".html" . "web")
                   (".sql" . "sql")
                   (".xml" . "xml")
                   (".yaml" . "yaml")
                   (".c" . "c-based")
                   (".cxx" . "c-based")
                   (".cpp" . "c-based")
                   (".cs" . "c-based")
                   (".hs" . "haskell")
                   (".kt" . "kotlin")
                   (".md" . "markdown")
                   (".tex" . "latex")
                   ;; docker.el
                   ;; lisp.el
                   )

                 )
         (cl/file "keybinds"))

;;; init.el ends here
