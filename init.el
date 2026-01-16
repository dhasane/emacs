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
                        (1 . ("lsp" "eglot"))
                        ))
         (cl/dir "modules/langs"
                 :lazy '((( "ino" "pde" )          "arduino" "c-based")
                         (( "c" "h" "cpp" "hpp" )  "c-based")
                         (( "cs" )                 "c-sharp")
                         (( "dart" )               "dart")
                         (( "gd" )                 "godot")
                         (( "hs" )                 "haskell")
                         (( "java" )               "java")
                         (( "js" "jsx" )           "javascript" "web")
                         (( "kt" "kts" )           "kotlin")
                         (( "tex" )                "latex")
                         (( "lisp" )               "lisp")
                         (( "lua" )                "lua")
                         (( "md" "markdown" )      "markdown")
                         (( "nix" )                "nix")
                         (( "php" )                "php")
                         (( "py" )                 "python")
                         (( "rb" )                 "ruby")
                         (( "rs" )                 "rust")
                         (( "sql" )                "sql")
                         (( "tf" "tfvars" )        "terraform")
                         (( "ts" "tsx" )           "typescript")
                         (( "vue" )                "vue")
                         (( "html" "css" )         "web")
                         (( "xml" )                "xml")
                         (( "yml" "yaml" )         "yaml"))
                 )
         (cl/dir "modules/extra"
                 :ignore '("email" "epub" "games" "telegram" "org-papers" "pdf")
                 )
         (cl/file "modules/keybinds"))

;;; init.el ends here
