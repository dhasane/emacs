;; -*- lexical-binding: t; -*-

;;; Code:

(use-package origami
  :demand t
  :config
  (global-origami-mode)
  )

(use-package treemacs
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
                                     )
  (highlight-indent-guides-responsive ;;'top
                                      'stack
                                      )
  :config
  ;; (set-face-background 'highlight-indent-guides-odd-face "blue")
  ;; (set-face-background 'highlight-indent-guides-even-face "green")
  ;; (set-face-foreground 'highlight-indent-guides-character-face "red")

  )

(use-package indent-guide
  :disabled t
  :init (add-hook 'yaml-mode-hook 'indent-guide-mode))

(use-package highlight-indentation
  :disabled t
  :delight
  :config
  ;; (set-face-background 'highlight-indentation-face "lightgray")
  ;; (set-face-background 'highlight-indentation-current-column-face "#c334b3")
  )

(use-package tree-sitter
  :hook
  (tree-sitter-after-on-hook . tree-sitter-hl-mode)
  (tree-sitter-after-on-hook . (lambda () (font-lock-mode -1)))

  :init
  (use-package tree-sitter-langs)
  (require 'tree-sitter)
  (require 'tree-sitter-hl)
  (require 'tree-sitter-langs)
  (require 'tree-sitter-debug)
  (require 'tree-sitter-query)

  (global-tree-sitter-mode)
  )

;;; code-editor end here
