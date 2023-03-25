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
                   ("rs" . "rust")
                   ("rb" . "ruby")
                   ("py" . "python")
                   ("java" . "java")
                   ("sql" . "sql")
                   (("c" "cxx" "cpp" "cs") . "c-based")
                   ("lua" . "lua")
                   ("gd" . "godot")
                   (("js" "html") . "web")
                   ("xml" . "xml")
                   ("yaml" . "yaml")
                   ("hs" . "haskell")
                   ("kt" . "kotlin")
                   ("md" . "markdown")
                   ("tex" . "latex")
                   ("nix" . "nix")
                   ("dart" . "dart")
                   ;; docker.el
                   ;; lisp.el
                   )
                 )
         (cl/dir "modules/extra"
                 :ignore '("email" "epub" "fira-code" "games" "telegram")
                 :lazy
                 '(("pdf" . "pdf"))
                 )
         (cl/file "keybinds"))

;;; init.el ends here
