
;; -*- coding: utf-8; lexical-binding: t; -*-
;; Emacs settings plain gnu emacs only
;; 2019-11-06
;; http://ergoemacs.org/emacs/emacs_init_index.html


;;; code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("939ea070fb0141cd035608b2baabc4bd50d8ecc86af8528df9d41f4d83664c6a" default)))
 '(minibuffer-prompt-properties
   (quote
    (read-only t cursor-intangible t face minibuffer-prompt)))
 '(package-selected-packages
   (quote
    (lsp-dart company-inf-ruby company-lsp
              (evil elscreen use-package hydra bind-key)
              name lsp-java ccls magit gruvbox-theme fzf flycheck helm evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; todo esto fue copiado
;; -- ; ;; for isearch-forward, make these equivalent: space newline tab hyphen underscore
;; -- ; (setq search-whitespace-regexp "[-_ \t\n]+")
;; -- ; (setq backup-by-copying t)
;; -- ; (column-number-mode 1)
;; -- ;
;; -- ; (progn
  ;; -- ; ;; pointless to warn. There's always undo.
  ;; -- ; (put 'narrow-to-region 'disabled nil)
  ;; -- ; (put 'narrow-to-page 'disabled nil)
  ;; -- ; (put 'upcase-region 'disabled nil)
  ;; -- ; (put 'downcase-region 'disabled nil)
  ;; -- ; (put 'erase-buffer 'disabled nil)
  ;; -- ; (put 'scroll-left 'disabled nil)
  ;; -- ; (put 'dired-find-alternate-file 'disabled nil)
;; -- ; )
;; -- ; ;;; --------------------
;; -- ; (progn
  ;; -- ; (require 'dired-x)
  ;; -- ; (setq dired-dwim-target t)
  ;; -- ; (when (string-equal system-type "gnu/linux")
;; -- ; (setq dired-listing-switches "-al --time-style long-iso"))
  ;; -- ; (setq dired-recursive-copies 'always)
  ;; -- ; (setq dired-recursive-deletes 'always))
;; -- ; ;;; --------------------
;; -- ; (setq save-interprogram-paste-before-kill t)
;; -- ; ;; 2015-07-04 bug of pasting in emacs.
;; -- ; ;; http://debbugs.gnu.org/cgi/bugreport.cgi?bug=16737#17
;; -- ; ;; http://ergoemacs.org/misc/emacs_bug_cant_paste_2015.html
;; -- ; ;; (setq x-selection-timeout 300)
;; -- ;
;; -- ; (setq x-select-enable-clipboard-manager nil)
;; -- ;
;; -- ; ;;; --------------------
;; -- ;
;; -- ; (setq sentence-end-double-space nil )
;; -- ; (setq set-mark-command-repeat-pop t)
;; -- ; (setq mark-ring-max 5)
;; -- ; (setq global-mark-ring-max 5)
;; -- ;
;; -- ; ;; (electric-pair-mode 1)
;; -- ;
;; -- ; ;;; --------------------
;; -- ; (progn
  ;; -- ; ;; set a default font
  ;; -- ; (cond
   ;; -- ; ((string-equal system-type "gnu/linux")
    ;; -- ; (when (member "DejaVu Sans Mono" (font-family-list)) (set-frame-font "DejaVu Sans Mono" t t))
    ;; -- ; ;; specify font for chinese characters using default chinese font on linux
    ;; -- ; (when (member "WenQuanYi Micro Hei" (font-family-list))
      ;; -- ; (set-fontset-font t '(#x4e00 . #x9fff) "WenQuanYi Micro Hei" ))
    ;; -- ; ;;
    ;; -- ; )
   ;; -- ; ((string-equal system-type "darwin") ; Mac
    ;; -- ; (when (member "Menlo" (font-family-list)) (set-frame-font "Menlo-14" t t))
    ;; -- ; ;;
    ;; -- ; )
   ;; -- ; ((string-equal system-type "windows-nt") ; Windows
   ;; -- ; nil))
;; -- ;
  ;; -- ; ;; specify font for all unicode characters
  ;; -- ; (when (member "Symbola" (font-family-list))
    ;; -- ; (set-fontset-font t 'unicode "Symbola" nil 'prepend))
;; -- ;
  ;; -- ; ;; ;; specify font for all unicode characters
  ;; -- ; ;; (when (member "Apple Color Emoji" (font-family-list))
  ;; -- ; ;;   (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend))
  ;; -- ; )
;; -- ;
;; -- ; ;;; --------------------
;; -- ; ;;; editing related
;; -- ;
;; -- ; ;; make typing delete/overwrites selected text
;; -- ; (delete-selection-mode 1)
;; -- ;
;; -- ; (setq shift-select-mode nil)
;; -- ;
;; -- ; (progn
  ;; -- ; ;; org-mode
  ;; -- ; ;; make “org-mode” syntax color code sections
  ;; -- ; (setq org-src-fontify-natively t)
  ;; -- ; (setq org-startup-folded nil)
  ;; -- ; (setq org-return-follows-link t)
  ;; -- ; (setq org-startup-truncated nil))
;; -- ;
;; -- ; ;;; --------------------
;; -- ;
;; -- ; (eval-after-load 'gnutls
  ;; -- ; '(add-to-list 'gnutls-trustfiles "/etc/ssl/cert.pem"))
;; -- ; ;;; --------------------
;; -- ;
;; -- ; (progn
 ;; -- ; ;; Make whitespace-mode with very basic background coloring for whitespaces.
  ;; -- ; ;; http://ergoemacs.org/emacs/whitespace-mode.html
  ;; -- ; (setq whitespace-style (quote (face spaces tabs newline space-mark tab-mark newline-mark )))
;; -- ;
  ;; -- ; ;; Make whitespace-mode and whitespace-newline-mode use “¶” for end of line char and “▷” for tab.
  ;; -- ; (setq whitespace-display-mappings
        ;; -- ; ;; all numbers are unicode codepoint in decimal. e.g. (insert-char 182 1)
        ;; -- ; '(
          ;; -- ; (space-mark 32 [183] [46]) ; SPACE 32 「 」, 183 MIDDLE DOT 「·」, 46 FULL STOP 「.」
          ;; -- ; (newline-mark 10 [182 10]) ; LINE FEED,
          ;; -- ; (tab-mark 9 [9655 9] [92 9]) ; tab
          ;; -- ; )))
;; -- ;
;; -- ; ;;; --------------------
;; -- ;
;; -- ; (setq hippie-expand-try-functions-list
      ;; -- ; '(
        ;; -- ; try-expand-dabbrev
        ;; -- ; try-expand-dabbrev-all-buffers
        ;; -- ; ;; try-expand-dabbrev-from-kill
        ;; -- ; try-complete-lisp-symbol-partially
        ;; -- ; try-complete-lisp-symbol
        ;; -- ; try-complete-file-name-partially
        ;; -- ; try-complete-file-name
        ;; -- ; ;; try-expand-all-abbrevs
        ;; -- ; ;; try-expand-list
        ;; -- ; ;; try-expand-line
        ;; -- ; ))
;; -- ;
;; -- ; ;; convenient
;; -- ; (defalias 'yes-or-no-p 'y-or-n-p)
;; -- ; (defalias 'rs 'replace-string)
;; -- ;
;; -- ; (defalias 'lcd 'list-colors-display)
;; -- ; (defalias 'ds 'desktop-save)
;; -- ; (defalias 'dt 'desktop-save)
;; -- ; (defalias 'dsm 'desktop-save-mode)
;; -- ;
;; -- ; (defalias 'elm 'emacs-lisp-mode)
;; -- ; (defalias 'hm 'html-mode)
;; -- ; (defalias 'jsm 'js-mode)
;; -- ; (defalias 'fm 'fundamental-mode)
;; -- ; (defalias 'ssm 'shell-script-mode)
;; -- ; (defalias 'om 'org-mode)
;; -- ;
;; -- ; (when (fboundp 'magit-status)
  ;; -- ; (defalias 'ms 'magit-status))
;; -- ;
;; -- ; ;; no want tpu-edt
;; -- ; (defalias 'tpu-edt 'forward-char)
;; -- ; (defalias 'tpu-edt-on 'forward-char)
;; -- ;
;; -- ;
;; -- ;


;; start-up ------------------------------------------------
(setq inhibit-startup-screen t)
;; UTF-8 as default encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8-unix)

(setq auto-save-default nil)
(setq make-backup-files nil)
(setq create-lockfiles nil)

(progn
  (setq enable-recursive-minibuffers t)

  ;; Save minibuffer history
  (savehist-mode 1)

(require 'recentf)
(recentf-mode 1)
(desktop-save-mode 1)
(global-auto-revert-mode 1)

;; big minibuffer height, for ido to show choices vertically
(setq max-mini-window-height 0.5)

  ;; minibuffer, stop cursor going into prompt
  (customize-set-variable
   'minibuffer-prompt-properties
   (quote (read-only t cursor-intangible t face minibuffer-prompt))))

;; remember cursor position
(if (version< emacs-version "25.0")
    (progn
      (require 'saveplace)
      (setq-default save-place t))
  (save-place-mode 1))

(progn
  ;; minibuffer enhanced completion
  (require 'icomplete)
  (icomplete-mode 1)
  ;; show choices vertically
  (setq icomplete-separator "\n")
  (setq icomplete-hide-common-prefix nil)
  (setq icomplete-in-buffer t)
  (define-key icomplete-minibuffer-map (kbd "<right>") 'icomplete-forward-completions)
  (define-key icomplete-minibuffer-map (kbd "<left>") 'icomplete-backward-completions))

(progn
  ;; make buffer switch command do suggestions, also for find-file command
  (require 'ido)
  (ido-mode 1)

  ;; show choices vertically
  (if (version< emacs-version "25")
      (progn
        (make-local-variable 'ido-separator)
        (setq ido-separator "\n"))
    (progn
      (make-local-variable 'ido-decorations)
      (setf (nth 2 ido-decorations) "\n")))

  ;; show any name that has the chars you typed
  (setq ido-enable-flex-matching t)
  ;; use current pane for newly opened file
  (setq ido-default-file-method 'selected-window)
  ;; use current pane for newly switched buffer
  (setq ido-default-buffer-method 'selected-window)
  ;; stop ido from suggesting when naming new file
  (when (boundp 'ido-minor-mode-map-entry)
    (define-key (cdr ido-minor-mode-map-entry) [remap write-file] nil)))

;; indentation, tab
(electric-indent-mode 0)
(set-default 'tab-always-indent 'complete)

(setq-default indent-tabs-mode nil
              tab-width 4)

;; que no pregunte cuando me quiero salir
(setq use-dialog-box nil)

;; eliminar espacios al final de una linea
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; para un modo en especifico
;; (add-hook 'c-mode-hook (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

;; plugins -------------------------------------------------

(defun include (packages)
  "Check if PACKAGES are installed, if not, install them.  PACKAGES is a list."
  (mapc
   (lambda (p)
     (unless (package-installed-p p) (package-install p))
     (require p)
     )
   packages)
  )

(require 'package)
(package-initialize)

(include ( list
           'evil
           'elscreen
           'use-package
           'hydra
           'bind-key
           ;'projectile
           ))
(eval-when-compile (require 'use-package))
(eval-when-compile (require 'cl))
(setq use-package-always-ensure t)

(add-hook 'after-init-hook #'global-flycheck-mode)

;; Enable Evil
(evil-mode 1)
; (projectile-mode +1)
;;(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
;;(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(setq helm-buffers-fuzzy-matching t)
(add-hook 'java-mode-hook #'lsp)
(elscreen-start)


;; lsp -----------------------------------------------------
(require 'lsp-mode)
(require 'lsp-java)
;; (require 'lsp-ruby)
(require 'company-lsp)


(use-package lsp-mode
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (ruby-mode . lsp)
         (java-mode . lsp)
         ;; if you want which-key integration
         ;;(lsp-mode . lsp-enable-which-key-integration)
         )
  :commands lsp)

;;
;; (use-package lsp-mode
  ;; :hook ((c++-mode . lsp-deferred))
  ;; :commands (lsp lsp-deferred))
;; (use-package lsp-mode
  ;; :hook
  ;; (java-mode . lsp-deferred)
  ;; :commands (lsp lsp-deferred))
;;
;; (use-package lsp-mode
  ;; :hook (ruby-mode . lsp-deferred)
  ;; :commands (lsp lsp-deferred))

(push 'company-lsp company-backends)
(setq company-minimum-prefix-length 1
      company-idle-delay 0.0) ;; default is 0.2

(use-package lsp-ui :commands lsp-ui-mode)
(lsp-ui-mode 1)

;; -- ; ;; if you are helm user
;; -- ; (use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; -- ; ;; if you are ivy user
;; -- ; (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;; -- ; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language
;; optional if you want which-key integration
(use-package which-key
  :config
  (which-key-mode))

;; visual --------------------------------------------------
(blink-cursor-mode 0)

;; set highlighting brackets
(show-paren-mode 1)
(setq show-paren-style 'parenthesis)

;; hacer que el movimiento de la pantalla sea suave
(setq scroll-margin 10
      scroll-conservatively 0
      scroll-step 1
      ;;scroll-up-aggressively 0.01
      ;;scroll-down-aggressively 0.01
      )
(setq-default scroll-up-aggressively 0.01
              scroll-down-aggressively 0.01)

(toggle-scroll-bar -1)

(setq visible-bell nil)

(load-theme 'gruvbox-dark-soft)
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))
(setq display-line-numbers-type 'relative)

(if (display-graphic-p)
    (setq initial-frame-alist
          '(
            (tool-bar-lines . 0)
            (width . 106)
            (height . 60)
            ))
  (setq initial-frame-alist '( (tool-bar-lines . 0))))

(setq default-frame-alist
      '(
        (tool-bar-lines . 0)
        (width . 100)
		(height . 50)))
;; change mode-line color by evil state
(lexical-let ((default-color (cons (face-background 'mode-line)
                                   (face-foreground 'mode-line))))
  (add-hook 'post-command-hook
            (lambda ()
              (let ((color (cond ((minibufferp) default-color)
                                 ((evil-insert-state-p) '("#73b3e7" . "#3e4249"))
                                 ((evil-normal-state-p) '("#a1bf78" . "#3e4249"))
                                 ((evil-replace-state-p)'("#d390e7" . "#3e4249"))
                                 ((evil-visual-state-p) '("#e77171" . "#3e4249"))

                                 ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                                 ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
                                 (t default-color))))
                (set-face-background 'mode-line (car color))
                (set-face-foreground 'mode-line (cdr color))))))

(loop for (mode . state)
      in '(
           (dired-mode . normal)
           (help-mode . normal)
           (magit-mode . emacs)

           (inferior-emacs-lisp-mode . emacs)
           (nrepl-mode . insert)
           (pylookup-mode . emacs)
           (comint-mode . normal)
           (shell-mode . insert)
           (git-commit-mode . insert)
           (git-rebase-mode . emacs)
           (term-mode . emacs)
           (helm-grep-mode . emacs)
           (grep-mode . emacs)
           (bc-menu-mode . emacs)
           (magit-branch-manager-mode . emacs)
           (rdictcc-buffer-mode . emacs)
           (wdired-mode . normal)
           )
      do (evil-set-initial-state mode state))

(require 'display-line-numbers)
(defcustom display-line-numbers-exempt-modes
  '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode help-mode magit-mode )
  "Major modes on which to disable the linum mode, exempts them from global requirement."
  :group 'display-line-numbers
  :type 'list
  :version "green")

(defun display-line-numbers--turn-on ()
  "Turn on line numbers but excempting certain majore modes defined in `display-line-numbers-exempt-modes'."
  (if (and
       (not (member major-mode display-line-numbers-exempt-modes))
       (not (minibufferp)))
      (display-line-numbers-mode)))

(global-display-line-numbers-mode)
;; functions -----------------------------------------------

(defun save-all-buffers ()
  "Save all buffers."
  (interactive)
  (mapc 'save-buffer (delq (current-buffer) (buffer-list) ) ) )

(defun kill-other-buffers ()
  "Kill all other buffers, except the current buffer and Emacs' 'system' buffers."
  (interactive)
  (save-all-buffers)
  (mapc
   (lambda (x)
     (let ((name (buffer-name x) ) )
       (unless (eq ?\s (aref name 0))
         (kill-buffer x) ) ) )
   (delq (current-buffer) (buffer-list) ) ) )

(defun melpa-load-sources ()
  "LOAD melpa sources :v."
  (interactive)

  (when (>= emacs-major-version 24)
    (require 'package)
    (add-to-list
     'package-archives
     ;;'("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
     '("melpa" . "https://melpa.org/packages/") t )
    (add-to-list
     'package-archives
     '("melpa" . "http://melpa.milkbox.net/packages/") t )
    )
  )

(defun melpa-refresh ()
  "Refresh melpa contents."
  (interactive)
  (melpa-load-sources)
  (package-refresh-contents 'ASYNC)
  )

(defun save-and-exit-evil ()
  "Salir de modo de insert y guardar el archivo."
  (interactive)
  (save-buffer)
  (evil-force-normal-state)
)

(defun reload-emacs-config ()
  "Reload your init.el file without restarting Emacs."
  (interactive)
  (load-file "~/.emacs.d/init.el") )

(defun open-emacs-config ()
  "Open your init.el file."
  (interactive)
  (find-file "~/.emacs.d/init.el") )

(defun nmap (key function)
  "Define mapping in evil normal mode.  FUNCTION in KEY."
  (define-key evil-motion-state-map (kbd key) function) )

(defun imap (key function)
  "Define mapping in evil insert mode.  FUNCTION in KEY."
  (define-key evil-insert-state-map (kbd key) function) )

; (defun tmap (key function)
;
  ; ;(define-key
; )

(defun amap (key function)
  "Define mapping in evil normal/insert mode.  FUNCTION in KEY."
  (nmap key function)
  (imap key function)
)

(defun gbind (key function)
  "Map FUNCTION to KEY."
  (global-set-key (kbd key) function) )

; aun falta hacer para poder esconder la terminal :v
(defun toggle-terminal ()
  "Toggle terminal in its own buffer."
  (interactive)
  (split-window-horizontally)
  (eshell)
  )

;; hydras --------------------------------------------------

(defhydra hydra-leader (:color blue :idle 1.0 :hints "leader")
  " actuar como leader en vim "
  ( "rs" reload-emacs-config "reload init" )
  ( "re" open-emacs-config "edit init" )
  ( "l" helm-buffers-list "buffer list" )
  ( "." toggle-terminal "terminal" )
  ( "j" evil-next-buffer "next" )
  ( "k" evil-next-buffer "next" )
  ( "SPC" (evil-execute-macro 1 (evil-get-register ?q t) ) )
  ( "h" (helm-apropos) "help" )
  ( "t" (ido-dired) "file" )
)

(defhydra hydra-elscreen (:color red :idle 1.0)
  "Elscreen management: "
  ("c" elscreen-create "create" )
  ("C" elscreen-clone "clone" )
  ("q" elscreen-kill "quit" )
  ("l" elscreen-next "left" )
  ("h" elscreen-previous "right" )
  ("s" elscreen-store "store" )
  ("r" elscreen-restore "restore" )
  ("g" elscreen-goto "goto" )
  ("-" split-window-vertically "vertical" )
  ("+" split-window-horizontally "horizontal")
)

;; keybinds ------------------------------------------------

(gbind "C-SPC" 'hydra-elscreen/body)
(gbind "C-S-s" 'save-all-buffers )
(gbind "C-S-q" 'kill-other-buffers ) ; tambien esta clean-buffer-list

 ;;; esc quits
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'keyboard-escape-quit)
(define-key minibuffer-local-ns-map [escape] 'keyboard-escape-quit)
(define-key minibuffer-local-completion-map [escape] 'keyboard-escape-quit )
(define-key minibuffer-local-must-match-map [escape] 'keyboard-escape-quit )
(define-key minibuffer-local-isearch-map [escape] 'keyboard-escape-quit )

; para redefinir comandos evil-ex
; (evil-ex-define-cmd "q" 'kill-this-buffer)

;(defun close-buffer-but-not-emacs ()
;(interactive)
;)

;; redefinir mappings de evil
(with-eval-after-load 'evil-maps
  ;;(define-key evil-motion-state-map (kbd "g t") 'elscreen-next )
  ;;(define-key evil-motion-state-map (kbd "g b") 'elscreen-previous )
  ( nmap "C-s" 'evil-write )
  ( nmap "C-M-q" 'ido-kill-buffer ) ;'evil-quit )
  ( nmap "C-q" 'evil-quit )
  ( nmap "C-w q" 'delete-window ) ; 'kill-this-buffer )
  ( nmap "TAB" 'evil-window-map )
  ( nmap ","   #'hydra-leader/body )
  ( imap "C-s" 'save-and-exit-evil )
  ( imap "C-v" 'evil-paste-before )
  ( amap "C-z" 'undo-tree-undo )
)

(provide 'init);;; init.el end here

; " para mover desde la terminal
    ; tnoremap <C-h> <C-\><C-n><C-w>h
    ; tnoremap <C-j> <C-\><C-n><C-w>j
    ; tnoremap <C-k> <C-\><C-n><C-w>k
    ; tnoremap <C-l> <C-\><C-n><C-w>l
;
; " mostrar las marcas
    ; nnoremap '? :marks <cr>
;
; " para solo mostrar las marcas dentro del archivo
    ; nnoremap <Leader>' :marks abcdefghijklmnopqrstuvwxyz<cr>:'
;
    ; " ver arbol de archivos
    ; noremap <Leader>t :Lexplore <cr>
;
; " porque quiero, puedo y no tengo miedo
    ; nnoremap <Leader>c :call Compilar() <cr>
;
; " muestra errores
    ; nnoremap <Leader>m :botright lwindow 5<cr>
;
; "mover entre buffers
    ; noremap <Leader>j <esc>:bp<cr>
    ; noremap <Leader>k <esc>:bn<cr>
    ; nnoremap <Leader>s :FZFLines <cr>
;
; " cortes
    ; " <tab>t oficialmente sirve para ir a la ventana superior izquierda, pero no se si lo use mucho
    ; " me gusta mas la funcion que yo le tengo :D
    ; noremap <tab>t <esc>:tabnew %<cr>
;
; " final funciones con <Leader> -----------------------------------
;
    ; inoremap <C-a> <esc>
; " funciones generales de otros editores
; " guardar
; " deshacer
    ; inoremap <C-z> <esc> ui
     ; noremap <C-z> u

    ; vnoremap <tab> >gv
    ; vnoremap <S-tab> <gv
;
; " mover entre splits
    ; noremap <C-h> <C-w>h
    ; noremap <C-j> <C-w>j
    ; noremap <C-k> <C-w>k
    ; noremap <C-l> <C-w>l
;
    ; noremap j gj
    ; noremap k gk
    ; map gf :edit <cfile><cr>
