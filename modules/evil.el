

;; Todo lo relacionado a vim
;;; Code:

(require 'cl-lib)

(use-package evil
  :ensure t
  :demand t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq
	 evil-want-keybinding t ;; para collection debe ser nil
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

  :bind
  (:map
   evil-normal-state-map
   ("C-S-k" . evil-lookup)
   ;("ESC" . evil-ex-nohighlight)
   ("j" . evil-next-visual-line)
   ("k" . evil-previous-visual-line)
  ;;("g t" . 'tab-next )
  ;;("g b" . 'tab-previous )
   ("C-s" . evil-write )
   ("TAB" . evil-window-map )
   ("TAB q" . #'close-except-last-window )
   ;; ("C-w q" . 'evil-quit ) ; 'kill-this-buffer )
   ("C-l" . evil-window-right )
   ("C-h" . evil-window-left )
   ("C-k" . evil-window-up )
   ("C-j" . evil-window-down )
   ("C-M-q" . ido-kill-buffer ) ;'evil-quit )
   ("C-q" . #'close-except-last-window )
   ;;("C-z" . undo-tree-undo )
   (","   .  #'hydra-leader/body )
   :map
   evil-insert-state-map
   ("C-s" . #'save-and-exit-evil )
   ("C-v" . 'evil-paste-before )
   ("C-z" . 'undo-tree-undo )
   )

  :config
  ;; para redefinir comandos evil-ex
  ;; (evil-ex-define-cmd "q" 'kill-this-buffer)
  (cl-loop for (mode . state) in
		'(
		  (inferior-emacs-lisp-mode . emacs)
		  (nrepl-mode . insert)
          (debugger-mode . normal)
		  (dashboard-mode . insert)
		  (pylookup-mode . normal)
          (inferior-python-mode . normal)
		  (comint-mode . normal)
		  (shell-mode . insert)
		  (git-commit-mode . insert)
		  (term-mode . emacs)
		  (help-mode . normal)
		  (grep-mode . normal)
		  (bc-menu-mode . emacs)
		  (rdictcc-buffer-mode . emacs)
		  (dired-mode . normal)
		  (wdired-mode . normal)
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
    (save-buffer)
    (evil-force-normal-state) )

 ;;; esc quits
  (define-key evil-normal-state-map [escape] 'keyboard-quit)
  (define-key evil-visual-state-map [escape] 'keyboard-quit)
  (define-key minibuffer-local-map [escape] 'keyboard-escape-quit)
  (define-key minibuffer-local-ns-map [escape] 'keyboard-escape-quit)
  (define-key minibuffer-local-completion-map [escape] 'keyboard-escape-quit )
  (define-key minibuffer-local-must-match-map [escape] 'keyboard-escape-quit )
  (define-key minibuffer-local-isearch-map [escape] 'keyboard-escape-quit )
  )

;; visual hints while editing
(use-package evil-goggles
  :ensure t
  :after evil
  :config
  (setq evil-goggles-duration 0.250) ;; default is 0.200
  (evil-goggles-use-diff-faces)
  (evil-goggles-mode)
  (custom-set-faces
   '(evil-goggles-yank-face ((t (:inherit 'isearch-fail)))))
  )

;;(use-package evil-collection
  ;;:after evil
  ;;:ensure t
  ;;:config
  ;;(evil-collection-init)
  ;;)

;;(eval-after-load "evil"
  ;;;; "This cotrols the state in which each mode will be opened in."
  ;;;; "States: normal/insert/emacs."
  ;;(loop for (mode . state)
        ;;in '(
             ;;(dired-mode . normal)
             ;;(help-mode . normal)
             ;;(magit-mode . normal)
             ;;(package-menu-mode . normal)
                                        ;;;           (emacs-lisp-mode . normal)
;;
             ;;(inferior-emacs-lisp-mode . emacs)
             ;;(nrepl-mode . insert)
             ;;(pylookup-mode . emacs)
             ;;(comint-mode . normal)
             ;;(shell-mode . insert)
             ;;(git-commit-mode . insert)
             ;;(git-rebase-mode . emacs)
             ;;(term-mode . emacs)
             ;;;;(helm-grep-mode . emacs)
             ;;(grep-mode . emacs)
             ;;(bc-menu-mode . emacs)
             ;;(magit-branch-manager-mode . emacs)
             ;;(rdictcc-buffer-mode . emacs)
             ;;(wdired-mode . normal)
             ;;)
        ;;do (evil-set-initial-state mode state))
;;
  ;;)
