
;; magit ------------------------------------------------------
;;; Code:

(use-package magit
  :ensure t
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
  )

(use-package evil-magit
  :after (magit evil)
  :demand t
  :config
  ;; (setq magit-completing-read-function 'magit-ido-completing-read)
  ;; open magit status in same window as current buffer
  (setq magit-status-buffer-switch-function 'switch-to-buffer)
  ;; highlight word/letter changes in hunk diffs
  (setq magit-diff-refine-hunk t)
  )

(use-package git-gutter
  :ensure t
  :demand t
  :custom
  (git-gutter:window-width 1)
  :config
  (git-gutter)
  (global-git-gutter-mode +1)
  )
