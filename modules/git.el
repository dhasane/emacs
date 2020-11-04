
;; magit ------------------------------------------------------
;;; Code:

(use-package magit
  :ensure t
  :demand t
  :defer .1
  )

(use-package git-gutter
  :ensure t
  :demand t
  :custom
  (git-gutter:window-width 1)
  :config
  (git-gutter)
  )

;; TODO: verificar el funcionamiento de esto, que hay varios binds que
;; me gustaria cambiar, por ejemplo el de 'h', que sirve para mover a
;; la izquierda, pero no tiene sentido siendo que 'l' no sirve para
;; mover a la derecha
(use-package evil-magit
  :after (magit evil)
  :demand t
  :general
  (
   :states '(normal insert)
   "C-l" 'evil-window-right
   "C-h" 'evil-window-left
   "C-k" 'evil-window-up
   "C-j" 'evil-window-down
   )
  :config
  ;; (setq magit-completing-read-function 'magit-ido-completing-read)
  ;; open magit status in same window as current buffer
  (setq magit-status-buffer-switch-function 'switch-to-buffer)
  ;; highlight word/letter changes in hunk diffs
  (setq magit-diff-refine-hunk t)

  (global-git-gutter-mode +1)
  )
