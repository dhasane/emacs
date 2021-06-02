;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; Todo lo relacionado a vim

;;; code:

(require 'cl-lib)

(use-package evil
  :defer nil
  :demand t
  :general
  (
   :states '(normal motion override)
   "C-S-k" 'evil-lookup
   "j" 'evil-next-visual-line
   "k" 'evil-previous-visual-line
   "C-s" 'evil-write
   "C-l" 'evil-window-right
   "C-h" 'evil-window-left
   "C-k" 'evil-window-up
   "C-j" 'evil-window-down
   "C-M-q" 'ido-kill-buffer ;'evil-quit
   "C-q" #'close-except-last-window
   ;; ","   #'hydra-leader/body
   ;; "u" 'undo-tree-undo
   ;; "C-_" 'comment-dwim ; cambiar esto desactiva undo-tree
   ;; "C-/" 'comment-dwim
   )
  (
   :states '(visual)
   "C-s" 'save-and-exit-evil
   )
  (
   :states '(insert)
   "C-s" #'save-and-exit-evil
   "C-v" 'evil-paste-before
   "C-z" 'undo-tree-undo
   )

  ;; :bind
  ;; (:map
  ;;  evil-normal-state-map
  ;;  ;("ESC" . evil-ex-nohighlight)
  ;; ;;("g t" . 'tab-next )
  ;; ;;("g b" . 'tab-previous )
  ;;  ;; ("TAB" . evil-window-map )
  ;;  ;; ("TAB q" . #'close-except-last-window )
  ;;  ;; ("C-w q" . 'evil-quit ) ; 'kill-this-buffer )
  ;;  ;;("C-z" . undo-tree-undo )
  ;;  :map
  ;;  evil-motion-state-map
  ;;  ;; ("TAB" . evil-window-map )
  ;;  ;; ("TAB q" . #'close-except-last-window )
  ;;  ;; ("C-w q" . 'evil-quit ) ; 'kill-this-buffer )
  ;; :map

  ;; :functions

  :custom
  (evil-want-integration t) ;; This is optional since it's already set to t by default.
  (evil-want-keybinding nil) ;; para collection debe ser nil
  (evil-search-module 'evil-search)
  (evil-vsplit-window-right t) ;; like vim's 'splitright'
  (evil-split-window-below t) ;; like vim's 'splitbelow'
  (evil-move-beyond-eol t)
  (evil-want-Y-yank-to-eol t)
  (evil-auto-indent t)
  (evil-move-cursor-back nil)
  (evil-symbol-word-search t)
  (evil-indent-convert-tabs t)
  (indent-tabs-mode t)

  (evil-undo-system 'undo-tree)

  ;; (evil-ex-complete-emacs-commands nil)
  ;; (evil-shift-round nil)
  ;; (evil-want-C-u-scroll t)

  ;; para redefinir comandos evil-ex
  ;; (evil-ex-define-cmd "q" 'kill-this-buffer)

  :config
  ;; para redefinir comandos evil-ex
  ;; (evil-ex-define-cmd "q" 'kill-this-buffer)

  (evil-mode 1)

  ;; Esto en teoria ya es manejado por evil-collection
  ;; (cl-loop for (mode . state) in
  ;;          '(
  ;;            ;; insert
  ;;            (shell-mode . insert)
  ;;            ;; (dashboard-mode . insert)
  ;;            (git-commit-mode . insert)
  ;;            (nrepl-mode . insert)

  ;;            ;; normal
  ;;            (debugger-mode . normal)
  ;;            (pylookup-mode . normal)
  ;;            (inferior-python-mode . normal)
  ;;            (comint-mode . normal)
  ;;            (dired-mode . normal)
  ;;            (wdired-mode . normal)
  ;;            (nrepl-mode . normal)

  ;;            ;; emacs
  ;;            (term-mode . emacs)
  ;;            (rdictcc-buffer-mode . emacs)

  ;;            ;; motion
  ;;            ;; (debugger-mode . motion)
  ;;            ;; (inferior-emacs-lisp-mode . motion)
  ;;            ;; (package-menu-mode . motion)
  ;;            ;; (help-mode . motion)
  ;;            ;; (grep-mode . motion)
  ;;            ;; (special-mode . motion)
  ;;            ;; (bc-menu-mode . motion)
  ;;            ;; (Custom-mode . motion)
  ;;            )
  ;;          do (evil-set-initial-state mode state))

  (defun close-except-last-window ()
    "Close all windows without removing them from buffer, except if only one is remaining, in which case the eyebrowse-config is closed."
    (interactive)
    (if (one-window-p)
        (close-tab-configuration)
                                        ; (message "hay un split")
      (evil-quit)
                                        ; (message "hay varios splits")
      )
    )

  (defun save-and-exit-evil ()
    "Salir de modo de insert y guardar el archivo."
    (interactive)
    (evil-force-normal-state)
    (save-buffer)
    )

  (evil-make-intercept-map company-active-map 'insert)

 ;;; esc quits
  (define-key evil-normal-state-map [escape] 'keyboard-quit)
  (define-key evil-visual-state-map [escape] 'keyboard-quit)
  (define-key minibuffer-local-map [escape] 'keyboard-escape-quit)
  (define-key minibuffer-local-ns-map [escape] 'keyboard-escape-quit)
  (define-key minibuffer-local-completion-map [escape] 'keyboard-escape-quit )
  (define-key minibuffer-local-must-match-map [escape] 'keyboard-escape-quit )
  (define-key minibuffer-local-isearch-map [escape] 'keyboard-escape-quit )
  )

(use-package evil-leader
  :defer 1
  :demand t
  ;; :config
  ;; (global-evil-leader-mode)
  ;; (evil-leader/set-leader "<SPC>")
  ;; (evil-leader/set-key
  ;;   "e" 'find-file
  ;;   "b" 'switch-to-buffer
  ;;   "k" 'kill-buffer
  ;;   "w" 'evil-window-map
  ;;   "t" 'hydra-tabs/body
  ;;   )
  )


(use-package evil-surround
  :defer 1
  :ensure t
  :after (evil)
  :config
  (global-evil-surround-mode 1))

;; visual hints while editing
(use-package evil-goggles
  :delight
  :defer 1
  :ensure t
  :after (evil)
  :functions evil-googles-use-diff-faces
  :custom
  ;; (evil-goggles-duration 0.250) ;; default is 0.200
  (evil-goggles-duration 0.250) ;; default is 0.200
  :config
  (evil-goggles-use-diff-faces)
  (evil-goggles-mode)
  :custom-face
  (evil-goggles-change-face ((t (:inherit diff-removed))))
  (evil-goggles-delete-face ((t (:inherit diff-removed))))
  (evil-goggles-paste-face ((t (:inherit diff-added))))
  (evil-goggles-undo-redo-add-face ((t (:inherit diff-added))))
  (evil-goggles-undo-redo-change-face ((t (:inherit diff-changed))))
  (evil-goggles-undo-redo-remove-face ((t (:inherit diff-removed))))
  ;; (evil-goggles-yank-face ((t (:inherit diff-changed))))
  (evil-goggles-yank-face ((t (:inherit 'evil-goggles-record-macro-face))))
  ;; (evil-goggles-yank-face ((t (:inherit 'isearch-fail))))
  )

(use-package evil-owl
  :defer 1
  :delight
  :custom
  (evil-owl-max-string-length 500)
  :config
  (add-to-list 'display-buffer-alist
               '("*evil-owl*"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window-height . 0.3)))
  :init
  (evil-owl-mode))

(use-package evil-collection
  :delight
  :demand t
  :after evil
  :ensure t
  :custom
  (warning-suppress-types '((evil-collection)))
  ;; (evil-collection-unimpaired-mode -1)
  :general
  (
   :states '(normal motion override)
   "C-l" 'evil-window-right
   "C-h" 'evil-window-left
   "C-k" 'evil-window-up
   "C-j" 'evil-window-down
   )
  :config
  ;; (evil-collection-init)

  (let ((prevent-ec '(
                      company
                      racer
                      flycheck
                      flymake
                      ;; compile
                      )))
    (dolist (pe prevent-ec)
      (setq evil-collection-mode-list (delete pe evil-collection-mode-list))
      )
    )

  ;; (dolist (dd evil-collection-mode-list)
  ;;   ;; (message "%s" evil-collection-mode-list)
  ;;   (message "%s" dd)
  ;;   )

  (evil-collection-init)

  (general-define-key
   :states '(normal)
   :keymaps 'evil-collection-magit-mode-map
   "C-l" 'evil-window-right
   "C-h" 'evil-window-left
   "C-k" 'evil-window-up
   "C-j" 'evil-window-down
   "M-j" 'magit-section-forward-sibling
   "M-k" 'magit-section-backward-sibling
   )
  ;; (general-define-key
  ;;  :state '(evil-collection-magit-state normal)
  ;;  :mode 'magit-mode-map
  ;;  "?" 'evil-search-backward
  ;;  "C-l" 'evil-window-right
  ;;  "C-h" 'evil-window-left
  ;;  "C-k" 'evil-window-up
  ;;  "C-j" 'evil-window-down
  ;;  "M-j" 'magit-section-forward-sibling
  ;;  "M-k" 'magit-section-backward-sibling)

  ;; (evil-define-key evil-collection-magit-mode-map magit-mode-map
  ;;   "?" 'evil-search-backward)
  ;; (evil-define-key evil-collection-magit-mode-map magit-mode-map
  ;;   "C-l" 'evil-window-right)
  ;; (evil-define-key evil-collection-magit-mode-map magit-mode-map
  ;;   "C-h" 'evil-window-left)
  ;; (evil-define-key evil-collection-magit-mode-map magit-mode-map
  ;;   "C-k" 'evil-window-up)
  ;; (evil-define-key evil-collection-magit-mode-map magit-mode-map
  ;;   "C-j" 'evil-window-down)
  ;; (evil-define-key evil-collection-magit-mode-map magit-mode-map
  ;;   "M-j" 'magit-section-forward-sibling)
  ;; (evil-define-key evil-collection-magit-mode-map magit-mode-map
  ;;   "M-k" 'magit-section-backward-sibling)
  )
