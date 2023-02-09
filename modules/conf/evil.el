;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; Todo lo relacionado a vim

;;; code:

(use-package evil
  :demand t
  :general
  (
   :states '(normal motion override)
   :keymaps 'override
   "C-S-k" 'evil-lookup
   "j"     'evil-next-visual-line
   "k"     'evil-previous-visual-line
   "C-s"   'evil-write
   "C-l"   'evil-window-right
   "C-h"   'evil-window-left
   "C-k"   'evil-window-up
   "C-j"   'evil-window-down
   "C-M-q" 'ido-kill-buffer ;'evil-quit
   "C-q"   'close-except-last-window
   ;; ","   #'hydra-leader/body
   ;; "u" 'undo-tree-undo
   ;; "C-_" 'comment-dwim ; cambiar esto desactiva undo-tree
   ;; "C-/" 'comment-dwim
   )
  (
   :states '(visual)
   :keymaps 'override
   "C-s" 'save-and-exit-evil
   )
  (
   :states '(insert)
   :keymaps 'override
   "C-s" 'save-and-exit-evil
   "C-v" 'evil-paste-before
   "C-z" 'undo-tree-undo
   )
  (
   :states '(normal motion override)
   :keymaps 'minibuffer-local-map
            "k" 'vertico-next
            "j" 'vertico-previous
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
  :init
  ;; por alguna razon estas variables no funcionaban en caso de ser
  ;; definidas en custom
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-search-module 'evil-search)
  :custom
  (evil-want-integration t) ;; This is optional since it's already set to t by default.
  (evil-want-keybinding nil) ;; para collection debe ser nil
  (evil-vsplit-window-right t) ;; like vim's 'splitright'
  (evil-split-window-below t) ;; like vim's 'splitbelow'
  (evil-move-beyond-eol t)
  (evil-auto-indent t)
  (evil-move-cursor-back nil)
  (evil-symbol-word-search t)
  (evil-indent-convert-tabs t)

  (evil-undo-system 'undo-tree)

  ;; (evil-ex-complete-emacs-commands nil)
  ;; (evil-shift-round nil)
  ;; (evil-want-C-u-scroll t)

  ;; para redefinir comandos evil-ex
  ;; (evil-ex-define-cmd "q" 'kill-this-buffer)

  (evil-want-minibuffer t)

  :config
  ;; para redefinir comandos evil-ex
  ;; (evil-ex-define-cmd "q" 'kill-this-buffer)

  (evil-mode 1)

  (let ((after-fn (lambda (&rest _) (recenter nil))))
    (advice-add 'evil-goto-line :after after-fn)
    (advice-add 'evil-goto-mark :after after-fn)
    (advice-add 'evil-goto-mark-line :after after-fn)
    (advice-add 'evil-window-vsplit :before after-fn)
    (advice-add 'evil-window-vsplit :after after-fn)
    (advice-add 'evil-window-split :before after-fn)
    (advice-add 'evil-window-split :after after-fn)
    ;; etc...
    )

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

(use-package evil-terminal-cursor-changer
  :unless window-system
  :init
  (evil-terminal-cursor-changer-activate) ; or (etcc-on)
  :custom
  (evil-motion-state-cursor 'box)  ; █
  (evil-visual-state-cursor 'box)  ; █
  (evil-normal-state-cursor 'box)  ; █
  (evil-insert-state-cursor 'bar)  ; ⎸
  (evil-emacs-state-cursor  'hbar) ; _

  ;; (setq evil-default-cursor (quote (t "#750000"))
  ;;       evil-visual-state-cursor '("#880000" box)
  ;;       evil-normal-state-cursor '("#750000" box)
  ;;       evil-insert-state-cursor '("#e2e222" bar)
  ;;       )
  )

(use-package evil-leader
  :after evil
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

(use-package evil-nerd-commenter
  :after evil
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package evil-surround
  :after evil
  :defer 1
  :after (evil)
  :config
  (global-evil-surround-mode 1))

;; visual hints while editing
(use-package evil-goggles
  :after evil
  :delight
  :defer 1
  :after (evil)
  :functions evil-googles-use-diff-faces
  :custom
  (evil-goggles-duration 0.250) ;; default is 0.200
  :config
  ;; (evil-goggles-use-diff-faces)
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
  :after evil
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
  :after evil
  :delight
  :demand t
  :custom
  (warning-suppress-types '((evil-collection)))
  (evil-collection-setup-minibuffer t)
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

  ;; (evil-collection-define-key 'normal 'evil-ex-completion-map (kbd "k") 'previous-complete-history-element)
  ;; (evil-collection-define-key 'normal 'evil-ex-completion-map (kbd "j") 'next-complete-history-element)
  ;; (evil-collection-define-key 'normal 'evil-ex-completion-map (kbd "k") 'previous-history-element)
  ;; (evil-collection-define-key 'normal 'evil-ex-completion-map (kbd "j") 'next-history-element)
  ;; (evil-collection-define-key 'normal 'evil-ex-completion-map (kbd "j") 'vertico-next)
  ;; (evil-collection-define-key 'normal 'evil-ex-completion-map (kbd "k") 'vertico-previous)
  ;; (general-define-key
  ;;  :states '(normal override)
  ;;  :keymaps 'evil-ex-map
  ;;  "j" 'vertico-next
  ;;  "k" 'vertico-previous
  ;;  )


  ;; (dolist (map '(minibuffer-local-map
  ;;                minibuffer-local-ns-map
  ;;                minibuffer-local-completion-map
  ;;                minibuffer-local-must-match-map
  ;;                minibuffer-local-isearch-map))
  ;;   (evil-collection-define-key 'normal map (kbd "<escape>") 'abort-recursive-edit)
  ;;   (evil-collection-define-key 'normal map (kbd "RET") 'exit-minibuffer)
  ;;   (evil-collection-define-key 'normal map (kbd "j") 'vertico-next)
  ;;   (evil-collection-define-key 'normal map (kbd "k") 'vertico-previous)
  ;;   )

  ;; (add-hook 'minibuffer-setup-hook 'evil-collection-minibuffer-insert)
  ;; ;; Because of the above minibuffer-setup-hook, some evil-ex bindings need be reset.
  ;; (evil-collection-define-key 'normal 'evil-ex-completion-map (kbd "<escape>") 'abort-recursive-edit)
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

;;; evil.el ends here
