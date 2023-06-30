;; -*- lexical-binding: t; -*-

;;; Code:

(setq enable-recursive-minibuffers t)

(use-package prog
  :elpaca nil
  ;; :straight (:type built-in)
  :init
  (setq-default c-basic-offset 4
                tab-width 4
                indent-tabs-mode nil)
  (setq-default indent-tabs-mode nil)
  :config
  (setq-local indent-tabs-mode nil)
  :custom
  (indent-tabs-mode nil)
  )


(use-package origami
  :demand t
  :config
  (global-origami-mode)
  )

(use-package treemacs
  :disabled t
  :custom
  (treemacs-width 50)
  (treemacs-no-png-images nil)
  (treemacs-follow-mode t)
  )

(use-package rainbow-delimiters
  :delight
  :hook (prog-mode . rainbow-delimiters-mode)
  :demand t
  )

(use-package hl-line
  :elpaca nil
  :defer 1
  :hook (prog-mode . hl-line-mode)
  ;; :config
  ;; (global-hl-line-mode +1)
)

(use-package highlight-indent-guides
  :defer 1
  :delight
  :hook (
         (prog-mode . highlight-indent-guides-mode)
         )
  :custom
  (highlight-indent-guides-method 'character
                                  ;; 'column
                                  )
  (highlight-indent-guides-character ?║ ;; U+2551
  ;; (highlight-indent-guides-character "|" ;; U+2551
                                     )
  (highlight-indent-guides-responsive ;;'top
                                      'stack
                                      )
  ;; :config
  ;; (set-face-background 'highlight-indent-guides-odd-face "blue")
  ;; (set-face-background 'highlight-indent-guides-even-face "green")
  ;; (set-face-foreground 'highlight-indent-guides-character-face "red")

  )

(use-package indent-guide
  :disabled t
  :unless '(highlight-indent-guides)
  :init
  ;; (add-hook 'yaml-mode-hook 'indent-guide-mode)
  (indent-guide-global-mode)
  :custom
  (indent-guide-char "|")
  )

(use-package nhexl-mode
  :custom
  (nhexl-display-unprintables t)
  (nhexl-line-width t)
  (nhexl-obey-font-lock nil)
  (nhexl-separate-line nil)
  (nhexl-silently-convert-to-unibyte t)
  )

(use-package highlight-indentation
  :disabled t
  :delight
  :config
  ;; (set-face-background 'highlight-indentation-face "lightgray")
  ;; (set-face-background 'highlight-indentation-current-column-face "#c334b3")
  )

(use-package tree-sitter
  :demand t
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

(use-package smart-tabs-mode
  :ensure t
  :config
  (progn (smart-tabs-insinuate 'c 'c++)))

;;; code-editor.el ends here
