;;; package --- summary:

;; EEEEEEEEEEEEEEEEEEEEEE                                                                                ;;
;; E::::::::::::::::::::E                                                                                ;;
;; E::::::::::::::::::::E                                                                                ;;
;; EE::::::EEEEEEEEE::::E                                                                                ;;
;;   E:::::E       EEEEEE   mmmmmmm    mmmmmmm     aaaaaaaaaaaaa      cccccccccccccccc    ssssssssss     ;;
;;   E:::::E              mm:::::::m  m:::::::mm   a::::::::::::a   cc:::::::::::::::c  ss::::::::::s    ;;
;;   E::::::EEEEEEEEEE   m::::::::::mm::::::::::m  aaaaaaaaa:::::a c:::::::::::::::::css:::::::::::::s   ;;
;;   E:::::::::::::::E   m::::::::::::::::::::::m           a::::ac:::::::cccccc:::::cs::::::ssss:::::s  ;;
;;   E:::::::::::::::E   m:::::mmm::::::mmm:::::m    aaaaaaa:::::ac::::::c     ccccccc s:::::s  ssssss   ;;
;;   E::::::EEEEEEEEEE   m::::m   m::::m   m::::m  aa::::::::::::ac:::::c                s::::::s        ;;
;;   E:::::E             m::::m   m::::m   m::::m a::::aaaa::::::ac:::::c                   s::::::s     ;;
;;   E:::::E       EEEEEEm::::m   m::::m   m::::ma::::a    a:::::ac::::::c     cccccccssssss   s:::::s   ;;
;; EE::::::EEEEEEEE:::::Em::::m   m::::m   m::::ma::::a    a:::::ac:::::::cccccc:::::cs:::::ssss::::::s  ;;
;; E::::::::::::::::::::Em::::m   m::::m   m::::ma:::::aaaa::::::a c:::::::::::::::::cs::::::::::::::s   ;;
;; E::::::::::::::::::::Em::::m   m::::m   m::::m a::::::::::aa:::a cc:::::::::::::::c s:::::::::::ss    ;;
;; EEEEEEEEEEEEEEEEEEEEEEmmmmmm   mmmmmm   mmmmmm  aaaaaaaaaa  aaaa   cccccccccccccccc  sssssssssss      ;;

;;; Commentary:

;; configuracion de Emacs asi como bien pro

;;; code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
	 '("e1d09f1b2afc2fed6feb1d672be5ec6ae61f84e058cb757689edb669be926896" "aded61687237d1dff6325edb492bde536f40b048eab7246c61d5c6643c696b7f" "4cf9ed30ea575fb0ca3cff6ef34b1b87192965245776afa9e9e20c17d115f3fb" "939ea070fb0141cd035608b2baabc4bd50d8ecc86af8528df9d41f4d83664c6a" default))
 '(git-gutter:window-width 1)
 '(minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
 '(package-selected-packages
	 '(inf-ruby solargraph rust-mode company-box lsp-dart lsp-python-ms ws-butler which-key dap-java esup counsel ivy evil-collection pdf-tools evil-org evil-magit eyebrowse git-gutter company-lsp
							(evil use-package hydra bind-key)
							name lsp-java ccls magit gruvbox-theme fzf flycheck evil))
 '(tab-bar-mode t)
 '(tab-bar-show 1)
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-goggles-change-face ((t (:inherit diff-removed))))
 '(evil-goggles-delete-face ((t (:inherit diff-removed))))
 '(evil-goggles-paste-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-add-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-change-face ((t (:inherit diff-changed))))
 '(evil-goggles-undo-redo-remove-face ((t (:inherit diff-removed))))
 '(evil-goggles-yank-face ((t (:inherit diff-changed)))))

;; init ----------------------------------------------------

;; medir el tiempo de inico
;; Use a hook so the message doesn't get clobbered by other messages.
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;; Make startup faster by reducing the frequency of garbage
;; collection.  The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;;; Inicio configuracion

(server-start)

(require 'package)
(setq
 package-archives
 '(
   ("melpa"         . "https://melpa.org/packages/")
   ("melpa-milkbox" . "http://melpa.milkbox.net/packages/")
   ("melpa-stable"  . "http://stable.melpa.org/packages/")
   ("elpa"          . "https://elpa.gnu.org/packages/")
   ("gnu"           . "http://elpa.gnu.org/packages/")
   )
 package-archive-priorities
 '(
   ("melpa"         . 20)
   ("melpa-milkbox" . 15)
   ("melpa-stable"  . 10)
   ("gnu"           . 5)
   ("elpa"          . 0)
   )
 )

(package-initialize)

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))
(package-install-selected-packages)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)

(defconst config-module-dir "~/.emacs.d/modules/"
  "Directorio de modulos de configuracion.")

;; utility function to auto-load my package configurations
(defun load-config-module (filelist)
  (dolist (file filelist)
    (load (expand-file-name
           (concat config-module-dir file)))
    (message "Loaded config file:%s" file)
    ))

;; load my configuration files
;; TODO: mover todo a archivos individuales, ya que permite mejor organizacion
(load-config-module
 '(
   "basic"
	 "minibuffer"
   "completion"
   "tabs"
   "mode-line"
   "org-mode"

   ))

;; fonts ------
(progn
  ;; set a default font
  (cond
   ((string-equal system-type "gnu/linux")
    (when (member "DejaVu Sans Mono" (font-family-list))
      (set-frame-font "DejaVu Sans Mono 12" t t)
      )

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

		;; esto fue necesario para que siquiera sirviera en windows
		(setq inhibit-compacting-font-caches t)
    nil
		))
  ;; specify font for all unicode characters
  (when (member "Symbola" (font-family-list))
    (set-fontset-font t 'unicode "Symbola" nil 'prepend))
  ;; specify font for all unicode characters
  (when (member "Apple Color Emoji" (font-family-list))
    (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend))
  )

(use-package all-the-icons
	)

(use-package which-key
  :ensure t
  :config
  (which-key-setup-side-window-right-bottom)
  ;; (setq which-key-max-description-length 27)
  (setq which-key-unicode-correction 3)
  (setq which-key-show-prefix 'left)
  (setq which-key-side-window-max-width 0.33)
  ;; (setq which-key-popup-type 'side-window)
  ;; (setq which-key-popup-type 'frame)
  ;; ;; max width of which-key frame: number of columns (an integer)
  ;; (setq which-key-frame-max-width 60)
  ;;
  ;; ;; max height of which-key frame: number of lines (an integer)
  ;; (setq which-key-frame-max-height 20)
  (which-key-mode)
  )

(use-package recentf
  :ensure t
  :config
  (recentf-mode 1)
  )

;;  (eval-after-load "evil"
  ;;  ;; "This cotrols the state in which each mode will be opened in."
  ;;  ;; "States: normal/insert/emacs."
  ;;  (loop for (mode . state)
        ;;  in '(
             ;;  (dired-mode . normal)
             ;;  (help-mode . normal)
             ;;  (magit-mode . normal)
             ;;  (package-menu-mode . normal)
                                        ;;  ;           (emacs-lisp-mode . normal)
;;
             ;;  (inferior-emacs-lisp-mode . emacs)
             ;;  (nrepl-mode . insert)
             ;;  (pylookup-mode . emacs)
             ;;  (comint-mode . normal)
             ;;  (shell-mode . insert)
             ;;  (git-commit-mode . insert)
             ;;  (git-rebase-mode . emacs)
             ;;  (term-mode . emacs)
             ;;  ;;(helm-grep-mode . emacs)
             ;;  (grep-mode . emacs)
             ;;  (bc-menu-mode . emacs)
             ;;  (magit-branch-manager-mode . emacs)
             ;;  (rdictcc-buffer-mode . emacs)
             ;;  (wdired-mode . normal)
             ;;  )
        ;;  do (evil-set-initial-state mode state))
;;
    ;;  )

(use-package hydra
  )
(use-package bind-key
  )

(use-package evil
  :ensure t
  ;;:defer
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-search-module 'evil-search)
  (setq evil-vsplit-window-right t) ;; like vim's 'splitright'
  (setq evil-split-window-below t) ;; like vim's 'splitbelow'
  (setq evil-move-beyond-eol t)
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
   ("Y"   . #'evil-yank-to-end-of-line )
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
   ("C-z" . undo-tree-undo )
   (","   .  #'hydra-leader/body )
   :map
   evil-insert-state-map
   ("C-s" . #'save-and-exit-evil )
   ("C-v" . 'evil-paste-before )
   ("C-z" . 'undo-tree-undo )
   )

  :config
  (evil-mode 1)

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
  (defun evil-yank-to-end-of-line ()
    "Yanks content from point until end of line."
    (interactive)
    (evil-yank (point) (line-end-position) )
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

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init)
  )

;; Projectile
(use-package projectile
  :ensure t
  :bind
  (
   :map
   projectile-mode-map
   ("M-p" . 'projectile-command-map)
   )
  :init
  (setq projectile-require-project-root nil)
  :config
  (projectile-mode +1)
  ;; (setq projectile-project-search-path '("~/projects/" "~/work/"))
  (setq projectile-project-search-path '("~/dev/"))
  (setq projectile-sort-order 'recently-active)
  (setq projectile-completion-system 'ivy)
  )

(use-package flycheck
	:ensure t
	:config
	(add-hook 'after-init-hook #'global-flycheck-mode)
	)

(pdf-tools-install)
(pdf-loader-install)

(setq x-wait-for-event-timeout nil)

;; eliminar espacios al final de una linea
;; (add-hook 'before-save-hook 'delete-trailing-whitespace)
(use-package ws-butler
  :ensure t
  :defer .1
  :hook (
         (prog-mode . ws-butler-mode)
         )
  )

;; tramp ---------------------------------------------------

(use-package tramp
  :config
  (setq tramp-default-method "ssh")
  )

;; magit ------------------------------------------------------

; use ido to switch branches
; https://github.com/bradleywright/emacs-d/blob/master/packages/init-magit.el
(use-package magit
  :ensure t
  :defer .1
  )

(use-package git-gutter
	:ensure t
	:after magit
	)

;; TODO: verificar el funcionamiento de esto, que hay varios binds que me gustaria cambiar,
;; por ejemplo el de 'h', que sirve para mover a la izquierda, pero no tiene sentido siendo
;; que 'l' no sirve para mover a la derecha
(use-package evil-magit
  :after magit evil
  :config
  ;; (setq magit-completing-read-function 'magit-ido-completing-read)
  ;; open magit status in same window as current buffer
  (setq magit-status-buffer-switch-function 'switch-to-buffer)
  ;; highlight word/letter changes in hunk diffs
  (setq magit-diff-refine-hunk t)

  (global-git-gutter-mode +1)
  )

(use-package ivy
  :ensure t
  :diminish (ivy-mode . "")
  :bind
  (:map ivy-mode-map
        ("C-'" . ivy-avy))
  :config
  (ivy-mode 1)
  (setq enable-recursive-minibuffers t)
  ;; add ‘recentf-mode’ and bookmarks to ‘ivy-switch-buffer’.
  (setq ivy-use-virtual-buffers t)
  ;; number of result lines to display
  (setq ivy-height 10)
  ;; does not count candidates
  (setq ivy-count-format "")
  ;; no regexp by default
  (setq ivy-initial-inputs-alist nil)
  ;; configure regexp engine.
  (setq ivy-re-builders-alist
	;; allow input not in order
        '((t   . ivy--regex-ignore-order))))

(use-package counsel
  :ensure t
  :after ivy
	:bind ("M-m" . 'counsel-find-file)
  )

;; optionally if you want to use debugger
(use-package dap-mode
  :ensure t :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t))

;; TODO: mirar como funciona lo de dap-mode
;; (use-package dap-java :after (lsp-java))

;; visual --------------------------------------------------

(blink-cursor-mode 0)

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

;; quitar todo tipo de 'alarma'
(setq visible-bell nil
      ring-bell-function 'ignore)


;; esto me parece que esta lento
;;(use-package indent-guide
  ;;:ensure t
  ;;:defer .1
  ;;:hook (
         ;;(prog-mode-hook . indent-guide-mode)
         ;;)
  ;;:config
  ;;;; (indent-guide-global-mode)
  ;;(setq indent-guide-recursive t)
  ;;)

(load-theme 'gruvbox-dark-medium)
;; (load-theme
 ;; 'gruvbox-light-medium)
;; (load-theme 'gruvbox-dark-soft)

(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))
(setq display-line-numbers-type 'relative)

(use-package display-line-numbers
  :ensure t
  :config
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
  )

;; (set-frame-parameter (selected-frame) 'alpha '(85 . 50))
;; (set-window-parameter (selected-window) 'alpha '(85 . 50))
;; (add-to-list 'default-frame-alist '(alpha . (85 . 50)))

;; functions -----------------------------------------------

(defun gbind (key function)
  "Map FUNCTION to KEY globally."
  (global-set-key (kbd key) function) )

(gbind "C-M-h" 'help-menu )
(gbind "C-S-h" 'help-command )
(gbind "C-_" 'comment-dwim) ;; TODO: poner esto a funcionar

(defun save-all-buffers ()
  "Save all buffers."
  (interactive)
  (mapc 'save-buffer (buffer-list) )
  (message "se han guardado todos los buffers") )
(gbind "C-S-s" 'save-all-buffers )

(defun kill-other-buffers ()
  "Kill all other buffers, except the current buffer and Emacs' 'system' buffers."
  (interactive)
  (save-all-buffers)
  (mapc
   (lambda (x)
     (let ((name (buffer-name x) ) )
       (unless (eq ?\s (aref name 0) )
         (kill-buffer x) ) ) )
   (delq (current-buffer) (buffer-list) ) )
  (message "se han cerrado los demas buffers")
  )
(gbind "C-S-q" 'kill-other-buffers ) ; tambien esta clean-buffer-list

(defun melpa-refresh ()
  "Refresh melpa contents."
  (interactive)
  (package-refresh-contents 'ASYNC) )

(defun reload-emacs-config ()
  "Reload your init.el file without restarting Emacs."
  (interactive)
  (load-file "~/.emacs.d/init.el") )

(defun open-emacs-config ()
  "Open your init.el file."
  (interactive)
  (find-file "~/.emacs.d/init.el") )

(defun prelude-google ()
  "Googles a query or region if any."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (if mark-active
        (buffer-substring (region-beginning) (region-end))
      (read-string "Google: ")))))
(global-set-key (kbd "C-c g") 'prelude-google)

(defun nmap (key function)
  "Define mapping in evil normal mode.  FUNCTION in KEY."
  (define-key evil-motion-state-map (kbd key) function) )

(defun imap (key function)
  "Define mapping in evil insert mode.  FUNCTION in KEY."
  (define-key evil-insert-state-map (kbd key) function) )

(defun amap (key function)
  "Define mapping in evil normal and insert mode.  FUNCTION in KEY."
  (nmap key function)
  (imap key function) )

(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

; TODO: aun falta hacer para poder esconder la terminal >:v
(defun toggle-terminal ()
  "Toggle terminal in its own buffer."
  (interactive)
  ;; (split-window-horizontally)
  (eshell)
  (message
   (buffer-file-name (current-buffer) ) )

   ;;(if (eshell-mode)
       ;;(message "kiubito")
     ;;(evil-quit)
     ;;)

  ;; (if (eq "eshell" (buffer-file-name (current-buffer) ) )
      ;; (kill-this-buffer)
    ;; (split-window-horizontally)
    ;; (eshell)
    ;; )
  )

;; Set transparency of emacs
(defun transparency (value)
  "Set the transparency of the frame window to VALUE.  0=transparent/100=opaque."
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value)
  )

(defun toggle-transparency ()
  "Toggle between frame transparency of 95 and 100."
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
		 ;; el segundo valor es para cuando no esta enfocado
         '(95 . 95) '(100 . 100)))))
(global-set-key (kbd "C-c t") 'toggle-transparency)

;; hydras --------------------------------------------------

;; colores
;; |----------+-----------+-----------------------+-----------------|
;; | Body     | Head      | Executing NON-HEADS   | Executing HEADS |
;; | Color    | Inherited |                       |                 |
;; |          | Color     |                       |                 |
;; |----------+-----------+-----------------------+-----------------|
;; | amaranth | red       | Disallow and Continue | Continue        |
;; | teal     | blue      | Disallow and Continue | Quit            |
;; | pink     | red       | Allow and Continue    | Continue        |
;; | red      | red       | Allow and Quit        | Continue        |
;; | blue     | blue      | Allow and Quit        | Quit            |
;; |----------+-----------+-----------------------+-----------------|

(defhydra hydra-leader (:color blue :idle 1.0 :hint nill)
  "
actuar como leader en vim :

^Config^       |    ^Buffers^       |  ^Edit^
^^^^^^^^-------------------------------------------------
_rs_: reload   |   _l_: jet-pack    |   _m_: magit
_re_: edit     |   _j_: previous    |   _o_: org
^ ^            |   _k_: next        |   _e_: errores
^ ^            |   _._: terminal    |   _SPC_: execute macro
^ ^            |   _b_: all buffers |   _t_: tree
^ ^            |   _?_: marks       |   _rn_: rename
^ ^            |   ^ ^              |   _s_: search text

"
  ( "rs" reload-emacs-config "reload init" )
  ( "re" open-emacs-config "edit init" )
  ( "l" (lambda () ;; evitar mostrar todos los archivos, en caso de estar fuera de un proyecto
					(interactive)
					(if (projectile-project-p)
							(projectile-find-file)
						(ivy-switch-buffer)
						)
					)  "jet pack" )

	( "b" ivy-switch-buffer "buffer list" )
  ( "s" swiper "swiper" )
  ( "." toggle-terminal "terminal" )
  ( "e" counsel-flycheck "errores" )

  ;;( "j" previous-buffer "next" )
  ;;( "k" next-buffer "next" )
  ( "j" projectile-next-project-buffer "next" )
  ( "k" projectile-previous-project-buffer "next" )

  ( "SPC" (evil-execute-macro 1 (evil-get-register ?q t) ) "execute macro" )
  ( "m" (magit) "magit" )
  ( "o" (hydra-org/body) "org" )
  ( "t" #'treemacs "tree" )
  ( "rn" lsp-rename "rename")
  ( "?" evil-show-marks "marks")
  )

;; TODO: cuadrar esto bien y aprender un poco, que por el momento solo he usado 'a'
(defhydra hydra-org (:color red :columns 3)
  "Org Mode Movements"
  ("a" org-agenda "agenda")
  ("l" org-store-link "store link")
  ("n" outline-next-visible-heading "next heading")
  ("p" outline-previous-visible-heading "prev heading")
  ("N" org-forward-heading-same-level "next heading at same level")
  ("P" org-backward-heading-same-level "prev heading at same level")
  ("u" outline-up-heading "up heading")
  ("g" org-goto "goto" :exit t) ;; y esto como que no sirve :v
  )

;; la encontre de ejemplo y creo que podria ser util
(defhydra hydra-zoom ()
  "zoom"
  ("+" text-scale-increase "in")
  ("-" text-scale-decrease "out")
  ("0" (text-scale-adjust 0) "reset")
  ("q" nil "quit" :color blue))

;; otros/mover ------------------------------------------------

; para redefinir comandos evil-ex
; (evil-ex-define-cmd "q" 'kill-this-buffer)

(setq custom-tab-width 2)

(defun disable-tabs () (setq indent-tabs-mode nil))
(defun enable-tabs  ()
  (interactive)
  (local-set-key (kbd "TAB") 'tab-to-tab-stop)
  (setq indent-tabs-mode t)
  (setq tab-width custom-tab-width))
(enable-tabs)

;;(local-set-key (kbd "TAB") 'tab-to-tab-stop)
;;(setq indent-tabs-mode t)
;;(setq tab-width custom-tab-width))

;; redefinir mappings de evil
;; (with-eval-after-load 'evil-maps
;; )


;; final ------------------------------------------------------

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))

(provide 'init)
;;; init.el ends here
