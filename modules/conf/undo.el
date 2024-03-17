;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(defvar dh/history-directory (expand-file-name "undo_history" user-emacs-directory))
(unless (file-directory-p dh/history-directory) (make-directory dh/history-directory))

(use-package undo-tree
  :disabled t
  :delight
  :defer 5
  :demand t
  :commands (undo-tree-undo undo-tree-redo)
  :init
  (global-undo-tree-mode)
  :custom
  (global-undo-tree-mode t)
  ;; guardar el historial
  (undo-tree-auto-save-history t)
  (undo-tree-history-directory-alist `(("." . ,dh/history-directory)))
  ;; hacer cabios en areas particulares
  (undo-tree-enable-undo-in-region t)
  ;; desactivar undo-tree en modos especificos
  (undo-tree-incompatible-major-modes '(term-mode eshell-mode shell-mode))

  (undo-tree-visualizer-timestamps t)
  (undo-tree-visualizer-diff t)
  :custom-face
  (undo-tree-visualizer-register-face ((t (:background "red" :foreground "#fabd2f"))))
  (undo-tree-visualizer-current-face ((t (:background "medium blue" :foreground "#fb4933"))))
  )

(use-package undo-fu
  :custom
  (undo-in-region t)
  )

(use-package undo-fu-session
  :demand t
  :custom
  (undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  :config
  (global-undo-fu-session-mode)
  )

(use-package vundo
  :ensure (vundo :type git :host github :repo "casouri/vundo")
  :general
  (
   :states '(motion override)
   :keymaps 'vundo-mode-map
  ;; Use `HJKL` VIM-like motion, also Home/End to jump around.
   "l"       'vundo-forward
   "<right>" 'vundo-forward

   "h"       'vundo-backward
   "<left>"  'vundo-backward

   "j"       'vundo-next
   "<down>"  'vundo-next

   "k"       'vundo-previous
   "<up>"    'vundo-previous

   "<home>"  'vundo-stem-root
   "<end>"   'vundo-stem-end

   "q"       'vundo-quit
   "C-g"     'vundo-quit

   "RET"     'vundo-confirm
   "ESC"     'vundo-confirm
   )

  :custom
  ;; Take less on-screen space.
  (vundo-compact-display t)

  ;; Better contrasting highlight.
  ;; (custom-set-faces
  ;;   '(vundo-node ((t (:foreground "#808080"))))
  ;;   '(vundo-stem ((t (:foreground "#808080"))))
  ;;   '(vundo-highlight ((t (:foreground "#FFFF00")))))
  )

;;; undo.el ends here
