;;; evil.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Evil mode and related extensions

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
   ;; [escape] 'evil-ex-nohighlight
   ;; ","   #'hydra-leader/body
   ;; "C-_" 'comment-dwim ; cambiar esto desactiva undo-tree
   ;; "C-/" 'comment-dwim
   )
  (:states '(normal) :keymaps 'minibuffer-mode-map
   "esc"    #'abort-minibuffers
   )
  (:states '(normal motion)
     :keymaps
     '(
       minibuffer-mode-map
       minibuffer-local-map
       minibuffer-local-ns-map
       minibuffer-local-completion-map
       minibuffer-local-must-match-map
       minibuffer-local-isearch-map
       )
   "esc"    #'abort-minibuffers
   )
  (:states '(normal)
     :keymaps 'evil-ex-search-keymap
     [escape] #'abort-recursive-edit
     (kbd "ESC") #'abort-recursive-edit
     (kbd "<escape>") #'abort-recursive-edit
     )
  :general
  (
   :states '(insert visual)
   :keymaps 'override
   "C-s" 'save-buffer
   )
  :general
  (
   :states '(insert)
   :keymaps 'override
   "C-s" 'save-buffer
   "C-v" 'evil-paste-before
   "C-z" 'evil-undo
   )
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

  (evil-undo-system 'undo-fu)

  ;; (evil-ex-complete-emacs-commands nil)
  ;; (evil-shift-round nil)
  ;; (evil-want-C-u-scroll t)

  ;; para redefinir comandos evil-ex
  ;; (evil-ex-define-cmd "q" 'kill-this-buffer)

  ;; minibuffer
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
    )

  (defun close-except-last-window ()
    "Close all windows without removing them from buffer, except if only one is remaining, in which case the eyebrowse-config is closed."
    (interactive)
    (if (one-window-p)
        (when (fboundp 'close-tab-configuration)
          (close-tab-configuration))
                                        ; (message "hay un split")
      (evil-quit)
                                        ; (message "hay varios splits")
      )
    )

  ;; siempre antes de guardar ir a estado normal
  (advice-add #'save-buffer :before #'evil-force-normal-state)
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
  :demand t
  :after evil
  :custom
  (evil-goggles-duration 0.200) ;; default is 0.200
  :init
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces)
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
  (
   :states '(normal)
   :keymaps 'evil-collection-magit-mode-map
   "C-l" 'evil-window-right
   "C-h" 'evil-window-left
   "C-k" 'evil-window-up
   "C-j" 'evil-window-down
   "M-j" 'magit-section-forward-sibling
   "M-k" 'magit-section-backward-sibling
   )
  (
   :states '(normal override)
   :keymaps 'evil-collection-pdf-mode-map
   "k" 'pdf-view-previous-line-or-previous-page
   "j" 'pdf-view-next-line-or-next-page
   "l" 'image-forward-hscroll
   "h" 'image-backward-hscroll
   (kbd "C-f") 'pdf-view-scroll-up-or-next-page
   (kbd "C-b") 'pdf-view-scroll-down-or-previous-page
   "gg" 'pdf-view-first-page
   "G" 'pdf-view-last-page
   "r" 'revert-buffer
   ":" 'evil-ex
   "/" 'isearch-forward
   )
  :config
  (let ((prevent-ec '(
                      company
                      racer
                      flycheck
                      flymake
                      robe
                      eglot
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

  (with-eval-after-load 'pdf-view
    (evil-define-key 'normal pdf-view-mode-map (kbd "k") 'pdf-view-previous-line-or-previous-page)
    (evil-define-key 'normal pdf-view-mode-map (kbd "j") 'pdf-view-next-line-or-next-page))

  (evil-collection-init)


  ;; (evil-collection-define-key 'normal 'evil-ex-completion-map (kbd "k") 'previous-complete-history-element)
  ;; (evil-collection-define-key 'normal 'evil-ex-completion-map (kbd "j") 'next-complete-history-element)
  ;; (evil-collection-define-key 'normal 'evil-ex-completion-map (kbd "k") 'previous-history-element)
  ;; (evil-collection-define-key 'normal 'evil-ex-completion-map (kbd "j") 'next-history-element)

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
