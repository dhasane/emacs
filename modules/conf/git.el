;;; git.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Git tooling and integrations

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

(use-package diff-hl
  :demand t
  :hook ((magit-pre-refresh  . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh)
         (dired-mode         . diff-hl-dired-mode))
  :custom
  (diff-hl-fringe-bmp-function 'diff-hl-fringe-bmp-from-type)
  :config
  (global-diff-hl-mode)
  (fringe-mode '(4 . 4))
  (unless (display-graphic-p)
    (diff-hl-margin-mode)))

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
