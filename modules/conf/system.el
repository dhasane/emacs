;; -*- lexical-binding: t; -*-
;;; Code:

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(use-package midnight
  ;; :after
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

(use-package proced
  :custom
  (proced-auto-update-flag t)
  )

(use-package ranger
  :demand t
  :custom
  (ranger-override-dired-mode t)
  (ranger-return-to-ranger nil)
  (ranger-show-hidden t)
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

(use-package adaptive-wrap
  :custom
  (adaptive-wrap-extra-indent 4)
  :config
  ;; https://stackoverflow.com/questions/13559061/emacs-how-to-keep-the-indentation-level-of-a-very-long-wrapped-line/13561223
  (when (fboundp 'adaptive-wrap-prefix-mode)
    (defun my-activate-adaptive-wrap-prefix-mode ()
      "Toggle `visual-line-mode' and `adaptive-wrap-prefix-mode' simultaneously."
      (adaptive-wrap-prefix-mode (if visual-line-mode 1 -1)))
    (add-hook 'visual-line-mode-hook 'my-activate-adaptive-wrap-prefix-mode))
  )

(use-package logview)

(use-package eldoc
  :delight)

;;; system end here
