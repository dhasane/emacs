;;; package --- Summary -*- lexical-binding: t; -*-

;;; Commentary:
;;; Configuracion para la integracion entre Emacs y git

;;; code:

(use-package magit
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
   "C-p" 'magit-process-buffer
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
  (magit-display-buffer-function
   ;; #'magit-display-buffer-fullframe-status-v1

   ; #'magit-display-buffer-traditional
   ; #'magit-display-buffer-same-window-except-diff-v1
   ; #'magit-display-buffer-fullframe-status-v1
   ; #'magit-display-buffer-fullframe-status-topleft-v1
   #'magit-display-buffer-fullcolumn-most-v1
   ; #'display-buffer
   )
  (magit-bury-buffer-function #'magit-restore-window-configuration)
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

(use-package git-gutter-fringe
  :if (display-graphic-p)
  :demand t
  :after (git-gutter)
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom)
  )

(use-package git-modes
  :mode (("/\\.gitignore\\'" . gitignore-mode)
         ("/\\.gitattributes\\'" . gitattributes-mode)
         ("/\\.gitconfig\\'" . gitconfig-mode)))

(use-package magit-todos
  :disabled t
  :init
  (magit-todos-mode)
  )

(use-package forge
  :after magit
  ; :hook (magit-status-mode . forge-mode)
  )

;;; git.el ends here
