;;; treesitter.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Tree-sitter and treesit integration

;;; Code:


(use-package tree-sitter
  :disabled t
  :hook
  (tree-sitter-after-on-hook . tree-sitter-hl-mode)
  (tree-sitter-after-on-hook . (lambda () (font-lock-mode -1)))

  :init
  (require 'tree-sitter)
  (require 'tree-sitter-hl)
  (require 'tree-sitter-debug)
  (require 'tree-sitter-query)

  ;; (require 'tree-sitter-langs)
  ;; (use-package tree-sitter-langs
  ;;   :after tree-sitter)

  (global-tree-sitter-mode)
  )

(use-package treesit
  :demand t
  :ensure nil
  :custom
  (treesit-font-lock-level 4)
  (treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")
     (php "https://github.com/tree-sitter/tree-sitter-php")

     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (tsx        "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     ))
  )

(use-package treesit-auto
  :demand t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (defconst dh/treesit-major-mode-remaps
    '((python-mode python-ts-mode python)
      (go-mode go-ts-mode go)
      (rust-mode rust-ts-mode rust)
      (js-mode js-ts-mode javascript)
      (typescript-mode typescript-ts-mode typescript)
      (css-mode css-ts-mode css)
      (json-mode json-ts-mode json)
      (yaml-mode yaml-ts-mode yaml)
      (bash-mode bash-ts-mode bash))
    "Mode remaps to tree-sitter variants when grammars exist.")

  (defun dh/treesit-apply-major-mode-remaps ()
    "Apply stable tree-sitter remaps once, avoiding per-file remap rebuilds."
    (when (treesit-available-p)
      (dolist (pair dh/treesit-major-mode-remaps)
        (let ((from (nth 0 pair))
              (to (nth 1 pair))
              (lang-sym (nth 2 pair)))
          (when (and (fboundp to)
                     (treesit-language-available-p lang-sym))
            (add-to-list 'major-mode-remap-alist (cons from to)))))))

  (dh/treesit-apply-major-mode-remaps))

(use-package combobulate
  :disabled t
  :ensure (combobulate :type git :host github :repo "mickeynp/combobulate")
  :preface
  ;; You can customize Combobulate's key prefix here.
  ;; Note that you may have to restart Emacs for this to take effect!
  (setq combobulate-key-prefix "C-c o")

  ;; Optional, but recommended.
  ;;
  ;; You can manually enable Combobulate with `M-x
  ;; combobulate-mode'.
  :hook ((python-ts-mode . combobulate-mode)
         (js-ts-mode . combobulate-mode)
         (css-ts-mode . combobulate-mode)
         (yaml-ts-mode . combobulate-mode)
         (typescript-ts-mode . combobulate-mode)
         (tsx-ts-mode . combobulate-mode))
  )

;;; treesitter.el ends here
