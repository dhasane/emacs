;; -*- lexical-binding: t; -*-
;;; Code:

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(use-package midnight
  :ensure nil
  :demand t
  :config
  (midnight-delay-set 'midnight-delay "5:30am")
  :custom
  (clean-buffer-list-delay-general 3)
  (clean-buffer-list-delay-special (* 2 3600)) ;; cada 2 horas
  ;; adicionales para cerrar

  (clean-buffer-list-kill-never-regexps
   '(
     "\\` \\*Minibuf-.*\\*\\'"
     "\\*eshell\\*.*"
     ))


  ;; (clean-buffer-list-kill-buffer-names
  ;;  (nconc clean-buffer-list-kill-buffer-names
  ;;         '("*buffer-selection*"
  ;;           "*Finder*"
  ;;           "*Finder Category*"
  ;;           "*Finder-package*"
  ;;           "*RE-Builder*"
  ;;           "*vc-change-log*")))
  ;; ;; no cerrar estos buffers
  ;; (clean-buffer-list-kill-never-buffer-names
  ;;  (nconc clean-buffer-list-kill-never-buffer-names
  ;;         '("*eshell*"
  ;;           "*ielm*"
  ;;           "*mail*"
  ;;           "*w3m*"
  ;;           "*w3m-cache*")))
  ;; (clean-buffer-list-kill-regexps
  ;;  (nconc clean-buffer-list-kill-regexps
  ;;         '(
  ;;           "\\`\\*Customize .*\\*\\'"
  ;;           "\\`\\*\\(Wo\\)?Man .*\\*\\'"
  ;;           )))
  )

(use-package helpful
  :demand t
  :general
  (
   :keymaps 'override
   "C-S-h" 'help-command
   "C-S-h f" #'helpful-callable
   "C-S-h v" #'helpful-variable
   "C-S-h k" #'helpful-key
   "C-S-h x" #'helpful-command
   )
  )

(use-package proced
  :ensure nil
  :custom
  (proced-auto-update-flag t)
  )

(use-package dirvish
  :init
  (dirvish-override-dired-mode)
  ;; :custom
  ;; (dirvish-quick-access-entries ; It's a custom option, `setq' won't work
  ;;  '(("h" "~/"                          "Home")
  ;;    ("d" "~/Downloads/"                "Downloads")
  ;;    ("m" "/mnt/"                       "Drives")
  ;;    ("t" "~/.local/share/Trash/files/" "TrashCan")))
  :config
  ;; (dirvish-peek-mode) ; Preview files in minibuffer
  (dirvish-side-follow-mode) ; similar to `treemacs-follow-mode'

  :custom
  (dirvish-mode-line-format
   '(:left (sort symlink) :right (omit yank index)))
  (dirvish-attributes
   '(all-the-icons file-time file-size collapse subtree-state vc-state git-msg))
  (delete-by-moving-to-trash t)

  (dirvish-peek-mode t)
  (dirvish-side-auto-close t)

  ;; uno de estos me estaba dando problemas
  ;; (setq dirvish-preview-dispatchers (remove 'epub dirvish-preview-dispatchers))
  ;; (setq dirvish-preview-dispatchers (remove 'image dirvish-preview-dispatchers))
  (dirvish-preview-dispatchers '())

  ;; (setq dirvish-preview-dispatchers (remove 'image dirvish-preview-dispatchers))

  (dirvish-mode-line-height 15)
  (dirvish-header-line-height 15)

  ;; (setq dired-listing-switches
  ;;       "-l --almost-all --human-readable --group-directories-first --no-group")
  :general ; Bind `dirvish|dirvish-side|dirvish-dwim' as you see fit
  (
   ;;("C-c f" . dirvish-fd)
   :keymaps 'dirvish-mode-map ; Dirvish inherits `dired-mode-map'
   :states '(normal motion override)
   "a"    'dirvish-quick-access
   "f"    'dirvish-file-info-menu
   "y"    'dirvish-yank-menu
   "N"    'dirvish-narrow
   "^"    'dirvish-history-last
   "h"    'dirvish-history-jump ; remapped `describe-mode'
   "s"    'dirvish-quicksort    ; remapped `dired-sort-toggle-or-edit'
   "v"    'dirvish-vc-menu      ; remapped `dired-view-file'
   "TAB"  'dirvish-subtree-toggle
   "M-f"  'dirvish-history-go-forward
   "M-b"  'dirvish-history-go-backward
   "M-l"  'dirvish-ls-switches-menu
   "M-m"  'dirvish-mark-menu
   "M-t"  'dirvish-layout-toggle
   "M-s"  'dirvish-setup-menu
   "M-e"  'dirvish-emerge-menu
   "M-j"  'dirvish-fd-jump
   ))

(use-package ranger
  :disabled t
  :demand t
  :custom
  (ranger-override-dired-mode t)
  (ranger-return-to-ranger nil)
  (rangershow-hidden t)
  (ranger-cleanup-on-disable t)

  ;; headers
  (ranger-header-func 'ranger-header-line)
  (ranger-parent-header-func 'ranger-parent-header-line)
  (ranger-preview-header-func 'ranger-preview-header-line)

  ;; organizacion de ventanas
  (ranger-width-parents 0.12)
  (ranger-max-parent-width 0.12)
  (ranger-preview-file t)
  (ranger-show-literal t)
  (ranger-width-preview 0.55)

  ;; excluir preview
  (ranger-excluded-extensions
   '("mkv" "iso" "mp4"))
  ;; en MB
  (ranger-max-preview-size 10)
  (ranger-dont-show-binary t)
  :config
  (ranger-show-file-details)
  )

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  ;; :if (or
  ;;      (memq window-system '(mac ns))
  ;;      (daemonp)
  ;;      )
  ;; :init
  ;; (when (memq window-system '(mac ns x))
  ;;   (exec-path-from-shell-initialize))
  ;; (when (daemonp)
  ;;   (exec-path-from-shell-initialize))
  ;; )
  :config
  (exec-path-from-shell-initialize))

(use-package direnv
  :disabled
  :init
  (direnv-mode))

(use-package logview)

;;; system end here
