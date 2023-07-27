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
         (cl/file "modules/pack")
         (cl/dir "modules/conf"
                 :alt '((1 . ("company" "corfu"))
                        (0 . ("completion" "ivy"))))
         (cl/dir "modules/langs"
                 :ignore '("lisp")
                 :lazy
                 '(
                   ("rs" . "rust")
                   ("rb" . "ruby")
                   ("py" . "python")
                   ("java" . "java")
                   ("sql" . "sql")
                   (("c" "cxx" "cpp" "hpp" "hxx") . "c-based")
                   ("cs" . "c-sharp")
                   ("lua" . "lua")
                   ("gd" . "godot")
                   (("sass" "html") . "web")
                   (("js" "jsx") . "javascript")
                   (("ts" "tsx") . ("typescript" "javascript"))
                   ("vue" . ("vue" "javascript"))
                   ("php" . "php")
                   ("xml" . "xml")
                   ("yaml" . "yaml")
                   ("hs" . "haskell")
                   ("kt" . "kotlin")
                   ("md" . "markdown")
                   ("tex" . "latex")
                   ("nix" . "nix")
                   ("dart" . "dart")
                   ("tf" . "terraform")
                   ("ino" . ("c-based" "arduino"))
                   ;; docker.el
                   ;; lisp.el
                   )
                 )
         (cl/dir "modules/extra"
                 :ignore '("email" "epub" "fira-code" "games" "telegram" "org-papers")
                 :lazy
                 '(("pdf" . "pdf"))
                 )
         (cl/file "keybinds"))

;;; init.el ends here
