
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
 '(package-selected-packages (quote (ccls magit gruvbox-theme fzf flycheck helm evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; --------------------
;; initial window and default window
(setq inhibit-startup-screen t)

;;; --------------------

;; UTF-8 as default encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8-unix)

;;; --------------------

;; for isearch-forward, make these equivalent: space newline tab hyphen underscore
(setq search-whitespace-regexp "[-_ \t\n]+")
(setq make-backup-files nil)
(setq backup-by-copying t)

(setq create-lockfiles nil)

(setq auto-save-default nil)

(column-number-mode 1)

(progn
  ;; pointless to warn. There's always undo.
  (put 'narrow-to-region 'disabled nil)
  (put 'narrow-to-page 'disabled nil)
  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  (put 'erase-buffer 'disabled nil)
  (put 'scroll-left 'disabled nil)
  (put 'dired-find-alternate-file 'disabled nil)
)

;;; --------------------

(progn
  (require 'dired-x)
  (setq dired-dwim-target t)
  (when (string-equal system-type "gnu/linux") (setq dired-listing-switches "-al --time-style long-iso"))
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always))

;;; --------------------

(setq save-interprogram-paste-before-kill t)
;; 2015-07-04 bug of pasting in emacs.
;; http://debbugs.gnu.org/cgi/bugreport.cgi?bug=16737#17
;; http://ergoemacs.org/misc/emacs_bug_cant_paste_2015.html
;; (setq x-selection-timeout 300)

(setq x-select-enable-clipboard-manager nil)

;;; --------------------

(require 'recentf)
(recentf-mode 1)
(desktop-save-mode 1)
(blink-cursor-mode 0)
(global-auto-revert-mode 1)

(setq sentence-end-double-space nil )
(setq set-mark-command-repeat-pop t)
(setq mark-ring-max 5)
(setq global-mark-ring-max 5)

;; (electric-pair-mode 1)


;;; --------------------
(progn
  ;; set a default font
  (cond
   ((string-equal system-type "gnu/linux")
    (when (member "DejaVu Sans Mono" (font-family-list)) (set-frame-font "DejaVu Sans Mono" t t))
    ;; specify font for chinese characters using default chinese font on linux
    (when (member "WenQuanYi Micro Hei" (font-family-list))
      (set-fontset-font t '(#x4e00 . #x9fff) "WenQuanYi Micro Hei" ))
    ;;
    )
   ((string-equal system-type "darwin") ; Mac
    (when (member "Menlo" (font-family-list)) (set-frame-font "Menlo-14" t t))
    ;;
    )
   ((string-equal system-type "windows-nt") ; Windows
   nil))

  ;; specify font for all unicode characters
  (when (member "Symbola" (font-family-list))
    (set-fontset-font t 'unicode "Symbola" nil 'prepend))

  ;; ;; specify font for all unicode characters
  ;; (when (member "Apple Color Emoji" (font-family-list))
  ;;   (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend))

  ;;
  )

(progn
  (setq enable-recursive-minibuffers t)

  ;; Save minibuffer history
  (savehist-mode 1)

;; big minibuffer height, for ido to show choices vertically
(setq max-mini-window-height 0.5)

  ;; minibuffer, stop cursor going into prompt
  (customize-set-variable
   'minibuffer-prompt-properties
   (quote (read-only t cursor-intangible t face minibuffer-prompt))))

;;; --------------------

;; remember cursor position
(if (version< emacs-version "25.0")
    (progn
      (require 'saveplace)
      (setq-default save-place t))
  (save-place-mode 1))

;;; --------------------
;;; editing related

;; make typing delete/overwrites selected text
(delete-selection-mode 1)

(setq shift-select-mode nil)

;; set highlighting brackets
(show-paren-mode 1)
(setq show-paren-style 'parenthesis)

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

;;; --------------------
;; indentation, tab

(electric-indent-mode 0)

(set-default 'tab-always-indent 'complete)

;; no mixed tab space
(setq-default indent-tabs-mode nil)
 ; gnu emacs 23.1, 24.4.1 default is t

;; 4 is more popular than 8.
(setq-default tab-width 4)

;;; --------------------

(progn
  ;; org-mode
  ;; make “org-mode” syntax color code sections
  (setq org-src-fontify-natively t)
  (setq org-startup-folded nil)
  (setq org-return-follows-link t)
  (setq org-startup-truncated nil))

;;; --------------------

(package-initialize)

(eval-after-load 'gnutls
  '(add-to-list 'gnutls-trustfiles "/etc/ssl/cert.pem"))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(require 'bind-key)
(setq use-package-always-ensure t)
;;; --------------------

(progn
 ;; Make whitespace-mode with very basic background coloring for whitespaces.
  ;; http://ergoemacs.org/emacs/whitespace-mode.html
  (setq whitespace-style (quote (face spaces tabs newline space-mark tab-mark newline-mark )))

  ;; Make whitespace-mode and whitespace-newline-mode use “¶” for end of line char and “▷” for tab.
  (setq whitespace-display-mappings
        ;; all numbers are unicode codepoint in decimal. e.g. (insert-char 182 1)
        '(
          (space-mark 32 [183] [46]) ; SPACE 32 「 」, 183 MIDDLE DOT 「·」, 46 FULL STOP 「.」
          (newline-mark 10 [182 10]) ; LINE FEED,
          (tab-mark 9 [9655 9] [92 9]) ; tab
          )))

;;; --------------------

(setq hippie-expand-try-functions-list
      '(
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        ;; try-expand-dabbrev-from-kill
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol
        try-complete-file-name-partially
        try-complete-file-name
        ;; try-expand-all-abbrevs
        ;; try-expand-list
        ;; try-expand-line
        ))

;;; --------------------

(setq use-dialog-box nil)

;;; --------------------

;; convenient
(defalias 'yes-or-no-p 'y-or-n-p)
(defalias 'rs 'replace-string)

(defalias 'lcd 'list-colors-display)
(defalias 'ds 'desktop-save)
(defalias 'dt 'desktop-save)
(defalias 'dsm 'desktop-save-mode)

(defalias 'elm 'emacs-lisp-mode)
(defalias 'hm 'html-mode)
(defalias 'jsm 'js-mode)
(defalias 'fm 'fundamental-mode)
(defalias 'ssm 'shell-script-mode)
(defalias 'om 'org-mode)

(when (fboundp 'magit-status)
  (defalias 'ms 'magit-status))

;; no want tpu-edt
(defalias 'tpu-edt 'forward-char)
(defalias 'tpu-edt-on 'forward-char)

;;; --------------------


;; Set up package.el to work with MELPA
(require 'package)
(package-initialize)
(package-refresh-contents)

;; Download Evil
(unless (package-installed-p 'evil) (package-install 'evil))
;; Enable Evil
(require 'evil) (evil-mode 1)

(add-hook 'after-init-hook #'global-flycheck-mode)

(setq scroll-margin 10
      scroll-conservatively 0
      scroll-step 1
      ;;scroll-up-aggressively 0.01
      ;;scroll-down-aggressively 0.01
      )
(setq-default scroll-up-aggressively 0.01
              scroll-down-aggressively 0.01)
;;(add-to-list 'load-path "~/.emacs.d/repos/emacs-solargraph")
;;(require 'solargraph)
;;(define-key ruby-mode-map (kbd "M-i") 'solargraph:complete)

(require 'elscreen)
(require 'use-package)
(require 'lsp-mode)
(require 'hydra)

(elscreen-start)
;;(require 'elscreen-tab)
;;(elscreen-tab-mode)  ; Enable `elscreen-tab'.
;;(elscreen-tab-set-position 'top) ; Show at the top.
;;(elscreen-tab-mode 1)  ; Disable `elscreen-tab'.


(toggle-scroll-bar -1)

(setq visible-bell nil)

(use-package lsp-mode
  :hook (XXX-mode . lsp-deferred)
  :commands (lsp lsp-deferred))

;; optionally

(lsp-ui-mode 1)
(setq helm-buffers-fuzzy-matching t)

(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
  :config
  (which-key-mode))

;; visual --------------------------------------------------

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


;; functions -----------------------------------------------

;; load emacs 24's package system. Add MELPA repository.
(defun melpa-load ()
  "Cargar melpa."
  (interactive)
  (when (>= emacs-major-version 24)
    (require 'package)
    (add-to-list
     'package-archives
     ;;'("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
     '("melpa" . "http://melpa.milkbox.net/packages/")
     '("melpa" . "https://melpa.org/packages/")
     t))
  )

(defun save-and-exit-evil ()
  "Salir de modo de insert y guardar el archivo."
  (interactive)
  (funcall 'save-buffer )
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
  "Definir un mapping en modo normal evil. FUNCTION en KEY."
  (define-key evil-motion-state-map (kbd key) function))

(defun imap (key function)
  "Definir un mapping en modo normal evil. FUNCTION en KEY."
  (define-key evil-insert-state-map (kbd key) function))

(defun gbind (key function)
  "Map FUNCTION to KEY."
  (global-set-key (kbd key) function) )

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
  ;;("-" split-window-vertically "vertical" ) ; no se si lo prefiero como lo tengo en tmux o como en vim
  ;;("+" split-window-horizontally "horizontal")
)

;; keybinds ------------------------------------------------

(gbind "C-SPC" 'hydra-elscreen/body)

 ;;; esc quits
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

;; redefinir mappings de evil
(with-eval-after-load 'evil-maps
  ;;(define-key evil-motion-state-map (kbd "g t") 'elscreen-next )
  ;;(define-key evil-motion-state-map (kbd "g b") 'elscreen-previous )
  (nmap "C-s" 'evil-write )
  (nmap "C-q" 'evil-quit )
  (nmap "TAB" 'evil-window-map )
  (nmap ","   #'hydra-leader/body)
  (imap "C-s" 'evil-write )
  ; (imap "C-s" 'evil-esc-mode )
  ;(setq-default evil-escape-key-sequence "C-s")
  ;(key-chord-define evil-insert-state-map "C-s" 'evil-normal-state)
  (imap "C-v" 'evil-paste-before )
)

(provide 'init);;; init.el end here

; " #########################
; " mappings
; " #########################
; 
; 
; " secuencia de escape de la terminal de vim
    ; tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
; " para mover desde la terminal
    ; tnoremap <C-h> <C-\><C-n><C-w>h
    ; tnoremap <C-j> <C-\><C-n><C-w>j
    ; tnoremap <C-k> <C-\><C-n><C-w>k
    ; tnoremap <C-l> <C-\><C-n><C-w>l
; 
    ; " dejemos esto por el momento como prueba
    ; inoremap <Leader><Leader> <esc>
; 
; " correr la macro en q, que aveces sin querer la sobreescribo
    ; nnoremap <Leader><Space> @q
; 
; " mostrar las marcas
    ; nnoremap '? :marks <cr>
; 
; " para solo mostrar las marcas dentro del archivo
    ; nnoremap <Leader>' :marks abcdefghijklmnopqrstuvwxyz<cr>:'
; 
; " abrir terminal
    ; noremap <Leader>. <esc> :vsp <cr> :term <cr>
    ; " noremap <Leader>. :call TermToggle(25) <cr>
; 
    ; " ver arbol de archivos
    ; noremap <Leader>t :Lexplore <cr>
; 
; " porque quiero, puedo y no tengo miedo
    ; nnoremap <Leader>c :call Compilar() <cr>
; 
; " para termdebug
    ; " da el valor de la variable
    ; nnoremap <RightMouse> :Evaluate<CR>
    ; " pone un break
    ; nnoremap <RightMouse> :Break<CR>
; 
; " compilar con make y mostrar salida
    ; nnoremap <Leader><C-m> :copen <cr>
    ; " nnoremap <Leader>m :lopen 5 <cr>
; 
; " muestra errores
    ; nnoremap <Leader>m :botright lwindow 5<cr>
; 
; "mover entre buffers
    ; noremap <Leader>j <esc>:bp<cr>
    ; noremap <Leader>k <esc>:bn<cr>
    ; " jetpack
    ; " noremap <Leader>l :ls<CR>:b<space>
    ; noremap <Leader>l :FZFBuffer <cr>
    ; nnoremap <Leader>s :FZFLines <cr>
; 
        ; noremap <Leader>; :FZF <cr>
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
    ; inoremap <C-s> <esc><esc>:w<cr>
    ; vnoremap <C-s> <esc><esc>:w<cr>
; " deshacer
    ; inoremap <C-z> <esc> ui
     ; noremap <C-z> u
; " salir
; 
    ; vnoremap <tab> >gv
    ; vnoremap <S-tab> <gv
; 
; " copiar y pegar
    ; vnoremap <C-c> "*y :let @+=@* <cr>
    ; nnoremap <C-c> "*yy:let @+=@*<cr>
    ; inoremap <C-c> <esc>"*yy:let @+=@*<cr>a
    ; "nnoremap <C-p> "+P
; " pegar en insert
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
