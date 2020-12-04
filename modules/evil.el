

;; Todo lo relacionado a vim
;;; Code:

(require 'cl-lib)

(use-package evil
  :ensure t
  :demand t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil) ;; para collection debe ser nil
  (setq
   evil-search-module 'evil-search
   evil-vsplit-window-right t ;; like vim's 'splitright'
   evil-split-window-below t ;; like vim's 'splitbelow'
   evil-move-beyond-eol t
   evil-want-Y-yank-to-eol t
   evil-auto-indent t
   evil-move-cursor-back nil
   evil-symbol-word-search t
   evil-indent-convert-tabs t
   indent-tabs-mode t
   )

  ;; (setq evil-ex-complete-emacs-commands nil)
  ;; (setq evil-shift-round nil)
  ;; (setq evil-want-C-u-scroll t)

  ;; para redefinir comandos evil-ex
  ;; (evil-ex-define-cmd "q" 'kill-this-buffer)

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
   ","   #'hydra-leader/body
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
  (evil-undo-system 'undo-tree)

  :config
  ;; para redefinir comandos evil-ex
  ;; (evil-ex-define-cmd "q" 'kill-this-buffer)

  (evil-mode 1)

  (cl-loop for (mode . state) in
           '(
             ;; insert
             (shell-mode . insert)
             (dashboard-mode . insert)
             (git-commit-mode . insert)
             (nrepl-mode . insert)

             ;; normal
             (debugger-mode . normal)
             (pylookup-mode . normal)
             (inferior-python-mode . normal)
             (comint-mode . normal)
             (dired-mode . normal)
             (wdired-mode . normal)
             (nrepl-mode . normal)

             ;; emacs
             (term-mode . emacs)
             (rdictcc-buffer-mode . emacs)

             ;; motion
             ;; (debugger-mode . motion)
             ;; (inferior-emacs-lisp-mode . motion)
             ;; (package-menu-mode . motion)
             ;; (help-mode . motion)
             ;; (grep-mode . motion)
             ;; (special-mode . motion)
             ;; (bc-menu-mode . motion)
             ;; (Custom-mode . motion)
             )
           do (evil-set-initial-state mode state))

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
  :demand t
  :config
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
  :ensure t
  :after (evil)
  :config
  (global-evil-surround-mode 1))

;; visual hints while editing
(use-package evil-goggles
  :ensure t
  :after (evil)
  :functions evil-googles-use-diff-faces
  :config
  (setq evil-goggles-duration 0.250) ;; default is 0.200
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
  (evil-goggles-yank-face ((t (:inherit 'isearch-fail))))
  )

(use-package evil-collection
  :demand t
  :after evil
  :ensure t
  :init
  (setq warning-suppress-types '((evil-collection)))
  :config
  ;; (evil-collection-init)

  (let ((prevent-ec '(company)))
    (seq-difference evil-collection-mode-list prevent-ec)
    )
  (evil-collection-init)
  )
