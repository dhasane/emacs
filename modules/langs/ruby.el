;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package ruby-mode
  :ensure nil
  :hook ((ruby-mode . ruby-ts-mode))
  :custom
  (ruby-insert-encoding-magic-comment nil)
  )

(use-package rbenv)

(use-package robe
  :disabled t
  :after '(ruby-mode)
  )

(use-package inf-ruby)

(use-package ruby-electric
  :hook ((ruby-mode . ruby-electric-mode)))

(use-package rake
  :general
  (:keymaps '(ruby-mode-map)
            "C-!" 'rake))

(use-package slim-mode)

;;; ruby.el ends here
