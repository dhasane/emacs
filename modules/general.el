;; -*- lexical-binding: t; -*-


;;; Code:

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(use-package whitespace
  :disabled ;; TODO: fix this
  :custom
  (whitespace-line-column 1000)   ;; max line length
  (whitespace-style
   '(
     face
     tabs
     lines-tail
     trailing
     ))
  :hook ((prog-mode . whitespace-mode))
  )

(use-package nix-mode)

(use-package which-key
  :delight
  :demand t
  :defer .1
  :custom
  ;; (which-key-max-description-length 27)
  (which-key-unicode-correction 3)
  (which-key-show-prefix 'left)
  (which-key-side-window-max-width 0.33)
  ;; (which-key-popup-type 'side-window)
  ;; (which-key-popup-type 'frame)
  ;; ;; max width of which-key frame: number of columns (an integer)
  ;; (which-key-frame-max-width 60)
  ;;
  ;; ;; max height of which-key frame: number of lines (an integer)
  ;; (which-key-frame-max-height 20)
  :config
  (which-key-setup-side-window-right-bottom)
  (which-key-mode)
  )

;; eliminar espacios al final de una linea
;; (add-hook 'before-save-hook 'delete-trailing-whitespace)
(use-package ws-butler
  :delight
  :demand t
  :defer .1
  :hook (
         (prog-mode . ws-butler-mode)
         (org-mode . ws-butler-mode)
         )
  )

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


(use-package indent-guide
  :init (add-hook 'yaml-mode-hook 'indent-guide-mode))

(use-package highlight-indentation
  :delight
  :config
  ;; (set-face-background 'highlight-indentation-face "lightgray")
  ;; (set-face-background 'highlight-indentation-current-column-face "#c334b3")
  )

;; (use-package rainbow-blocks
  ;; )

(use-package proced
  :custom
  (proced-auto-update-flag t)
  )

;; (use-package restart-emacs
;;   )

(use-package nhexl-mode
  :custom
  (nhexl-display-unprintables t)
  (nhexl-line-width t)
  (nhexl-obey-font-lock nil)
  (nhexl-separate-line nil)
  (nhexl-silently-convert-to-unibyte t)
  )

(use-package origami
  :demand t
  :config
  (global-origami-mode)
  )

(defvar dh/history-directory (expand-file-name "undo_history" user-emacs-directory))
(unless (file-directory-p dh/history-directory) (make-directory dh/history-directory))

(use-package undo-tree
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

(use-package bufler
  :disabled
  :delight
  :config
  ;; (bufler-workspace-mode t)
  )

(setq visual-line-fringe-indicators
      '(
        nil ;; left-curly-arrow
        nil ;; right-curly-arrow
        ))

(use-package eldoc
  :delight
  )

(use-package exec-path-from-shell
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
  (when (daemonp)
    (exec-path-from-shell-initialize))
  )

(use-package direnv
  :init
  (direnv-mode))

(use-package treemacs
  :custom
  (treemacs-width 50)
  (treemacs-no-png-images t)
  )

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

(use-package logview
  )

(use-package polymode
  :disabled
  :mode ("\\.md\\'" "\\.org\\'" )
  :config
  ;; (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
  ;; (setq polymode-prefix-key (kbd "C-c n"))
  ;; (define-hostmode poly-python-hostmode :mode 'python-mode)
  )

(use-package tree-sitter

  )

(use-package no-littering
  :demand
  :config
  (require 'recentf)
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)
  :custom
  (auto-save-file-name-transforms
   `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  )

;;; general end here
