;;; package --- Summary -*- lexical-binding: t; -*-

;;; Commentary:
;;; COnfiguracion para la integracion entre Emacs y git

;;; code:


(use-package magit
  :demand t
  :defer .1
  :general
  (
   :states '(normal insert)
   :keymaps 'magit-mode-map
   ;; "[ [" 'magit-section-backward
   ;; "] ]" 'magit-section-forward
   "C-l" 'evil-window-right
   "C-h" 'evil-window-left
   "C-k" 'evil-window-up
   "C-j" 'evil-window-down
   "M-j" 'magit-section-forward-sibling
   "M-k" 'magit-section-backward-sibling
   )
  ;; :hook (evil-collection-setup-hook
  ;;        .
  ;;        (lambda()
  ;;          (general-define-key
  ;;           :state '(evil-collection-magit-state normal)
  ;;           :mode 'magit-mode-map
  ;;           "?" 'evil-search-backward
  ;;           "C-l" 'evil-window-right
  ;;           "C-h" 'evil-window-left
  ;;           "C-k" 'evil-window-up
  ;;           "C-j" 'evil-window-down
  ;;           "M-j" 'magit-section-forward-sibling
  ;;           "M-k" 'magit-section-backward-sibling)

  ;;          ))
  :custom
  ;; highlight word/letter changes in hunk diffs
  (magit-diff-refine-hunk t)
  ;; (magit-status-buffer-switch-function 'switch-to-buffer)
  ;; (magit-display-buffer-function 'switch-to-buffer)
  )

(use-package git-gutter
  :delight
  :demand t
  :custom
  (git-gutter:window-width 1)
  :config
  (git-gutter)
  (global-git-gutter-mode +1)
  )

(use-package magit-todos
  :disabled
  :init
  (magit-todos-mode)
  )

;;; git.el ends here
