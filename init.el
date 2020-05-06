
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

;; doh

;;; code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("aded61687237d1dff6325edb492bde536f40b048eab7246c61d5c6643c696b7f" "4cf9ed30ea575fb0ca3cff6ef34b1b87192965245776afa9e9e20c17d115f3fb" "939ea070fb0141cd035608b2baabc4bd50d8ecc86af8528df9d41f4d83664c6a" default)))
 '(git-gutter:window-width 1)
 '(minibuffer-prompt-properties
   (quote
    (read-only t cursor-intangible t face minibuffer-prompt)))
 '(package-selected-packages
   (quote
    (counsel ivy evil-collection pdf-tools evil-org evil-magit eyebrowse git-gutter lsp-dart company-lsp
             (evil use-package hydra bind-key)
             name lsp-java ccls magit gruvbox-theme fzf flycheck helm evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; todo esto fue copiado
;; -- ; ;; http://ergoemacs.org/emacs/emacs_init_index.html
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
;; -- ; (setq sentence-end-double-space nil )
;; -- ; (setq set-mark-command-repeat-pop t)
;; -- ; (setq mark-ring-max 5)
;; -- ; (setq global-mark-ring-max 5)
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
;; -- ; (progn
 ;; -- ; ;; Make whitespace-mode with very basic background coloring for whitespaces.
  ;; -- ; ;; http://ergoemacs.org/emacs/whitespace-mode.html
  ;; -- ; (setq whitespace-style (quote (face spaces tabs newline space-mark tab-mark newline-mark )))
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
  ;; (setq max-mini-window-height 0.5)

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

(savehist-mode 1)

;;(progn
  ;;;; make buffer switch command do suggestions, also for find-file command
  ;;(require 'ido)
  ;;(ido-mode 1)
;;
  ;;;; show choices vertically
  ;;(if (version< emacs-version "25")
      ;;(progn
        ;;(make-local-variable 'ido-separator)
        ;;(setq ido-separator "\n"))
    ;;(progn
      ;;(make-local-variable 'ido-decorations)
      ;;(setf (nth 2 ido-decorations) "\n")))
;;
  ;;;; show any name that has the chars you typed
  ;;(setq ido-enable-flex-matching t)
  ;;;; use current pane for newly opened file
  ;;(setq ido-default-file-method 'selected-window)
  ;;;; use current pane for newly switched buffer
  ;;(setq ido-default-buffer-method 'selected-window)
  ;;;; stop ido from suggesting when naming new file
  ;;(when (boundp 'ido-minor-mode-map-entry)
    ;;(define-key (cdr ido-minor-mode-map-entry) [remap write-file] nil)))

;; indentation, tab
(electric-indent-mode 0)

;; set highlighting brackets
(show-paren-mode 1)
(setq show-paren-delay 0)
(electric-pair-mode 1)
(setq show-paren-style 'parenthesis)
(set-default 'tab-always-indent 'complete)

(setq-default indent-tabs-mode nil
              tab-width 4)

;; que no pregunte cuando me quiero salir
(setq use-dialog-box nil)

;; eliminar espacios al final de una linea
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; para un modo en especifico (serviria para ignorar en markdown)
;; (add-hook 'c-mode-hook (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

;; TODO: mirar como relacionar esto a una 'caja' de recomendaciones
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

;; plugins -------------------------------------------------

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

;; esto fue necesario para que siquiera sirviera en windows
(setq inhibit-compacting-font-caches t)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))
(package-install-selected-packages)

(eval-when-compile (require 'use-package))

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  )

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init)
  )

(require 'hydra )
(require 'bind-key )

;; Projectile
(use-package projectile
  :ensure t
  :init
  (setq projectile-require-project-root nil)
  :config
  (projectile-mode 1))

(eval-when-compile (require 'cl))
(setq use-package-always-ensure t)

(add-hook 'after-init-hook #'global-flycheck-mode)
(evil-collection-init)

;; (pdf-tools-install)
(pdf-loader-install)

(setq x-wait-for-event-timeout nil)

;; Helm
;; (use-package helm
  ;; :ensure t
  ;; :init
  ;; (setq helm-M-x-fuzzy-match t
        ;; helm-mode-fuzzy-match t
        ;; helm-recentf-fuzzy-match t
        ;; helm-locate-fuzzy-match t
        ;; helm-semantic-fuzzy-match t
        ;; helm-imenu-fuzzy-match t
        ;; helm-completion-in-region-fuzzy-match t
        ;; helm-candidate-number-list 150
        ;; helm-split-window-inside-p t
        ;; helm-move-to-line-cycle-in-source t
        ;; helm-echo-input-in-header-line t
        ;; helm-autoresize-max-height 0
        ;; helm-autoresize-min-height 20
        ;; helm-buffers-fuzzy-matching t
        ;; )
  ;; :config
  ;; (helm-mode 1))


;; git ------------------------------------------------------

; use ido to switch branches
; https://github.com/bradleywright/emacs-d/blob/master/packages/init-magit.el
(require 'evil-magit)
(setq magit-completing-read-function 'magit-ido-completing-read)
;; open magit status in same window as current buffer
(setq magit-status-buffer-switch-function 'switch-to-buffer)
;; highlight word/letter changes in hunk diffs
(setq magit-diff-refine-hunk t)

(global-git-gutter-mode +1)

;; org mode ------------------------------------------------

(require 'org)
(setq org-log-done t)

(setq org-agenda-files
      '(
        "~/org/work.org"
        "~/org/school.org"
        "~/org/home.org"
        )
      )

(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(evil-org-set-key-theme '(textobjects insert navigation additional shift todo heading))

;; (setf evil-org-key-theme '(navigation insert textobjects additional))
(setf org-special-ctrl-a/e t)
(evil-org-agenda-set-keys)

(add-hook 'org-mode-hook
          (lambda ()
            (evil-org-mode)

            ;; Custom mappings
            (evil-define-key 'normal evil-org-mode-map
              (kbd "-") 'org-ctrl-c-minus
              (kbd "|") 'org-table-goto-column
              (kbd "M-o") (evil-org-define-eol-command org-insert-heading)
              (kbd "M-t") (evil-org-define-eol-command org-insert-todo))

            ;; Configure leader key
            (evil-leader/set-key-for-mode 'org-mode
                                          "." 'hydra-org-state/body
                                          "t" 'org-todo
                                          "T" 'org-show-todo-tree
                                          "v" 'org-mark-element
                                          "a" 'org-agenda
                                          "c" 'org-archive-subtree
                                          "l" 'evil-org-open-links
                                          "C" 'org-resolve-clocks)

            ;; Define a transient state for quick navigation
            (defhydra hydra-org-state ()
              ;; basic navigation
              ("i" org-cycle)
              ("I" org-shifttab)
              ("h" org-up-element)
              ("l" org-down-element)
              ("j" org-forward-element)
              ("k" org-backward-element)
              ;; navigating links
              ("n" org-next-link)
              ("p" org-previous-link)
              ("o" org-open-at-point)
              ;; navigation blocks
              ("N" org-next-block)
              ("P" org-previous-block)
              ;; updates
              ("." org-ctrl-c-ctrl-c)
              ("*" org-ctrl-c-star)
              ("-" org-ctrl-c-minus)
              ;; change todo state
              ("H" org-shiftleft)
              ("L" org-shiftright)
              ("J" org-shiftdown)
              ("K" org-shiftup)
              ("t" org-todo))))

;; lsp -----------------------------------------------------

(use-package lsp-mode
  :defer t
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (ruby-mode . lsp)
         (java-mode . lsp)
         (python-mode . lsp)
         ;; if you want which-key integration
         ;;(lsp-mode . lsp-enable-which-key-integration)
         )
  :config
  (with-eval-after-load 'lsp-mode
    ;; :project/:workspace/:file
    (setq lsp-diagnostics-modeline-scope :project)
    (add-hook 'lsp-managed-mode-hook 'lsp-diagnostics-modeline-mode))

  ;;:commands lsp
  :commands (lsp lsp-deferred)
  )
(require 'lsp-java)

(use-package ivy :ensure t
  :diminish (ivy-mode . "")
  :bind
  (:map ivy-mode-map
   ("C-'" . ivy-avy))
  :config
  (ivy-mode 1)
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

;;
;;    (setq helm-split-window-inside-p t ;; open helm buffer inside current window, not occupy whole other window
      ;;    helm-echo-input-in-header-line t) ;; input close to where I type
;;
;;    (defun spacemacs//helm-hide-minibuffer-maybe ()
  ;;    "Hide minibuffer in Helm session if we use the header line as input field."
  ;;    (when (with-helm-buffer helm-echo-input-in-header-line)
    ;;    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      ;;    (overlay-put ov 'window (selected-window))
      ;;    (overlay-put ov 'face
                   ;;    (let ((bg-color (face-background 'default nil)))
                     ;;    `(:background ,bg-color :foreground ,bg-color)))
      ;;    (setq-local cursor-type nil))))
;;
;;    (add-hook 'helm-minibuffer-set-up-hook
	  ;;    'spacemacs//helm-hide-minibuffer-maybe)
;;
;;    (setq helm-autoresize-max-height 0)
;;    (setq helm-autoresize-min-height 20)
;;    (helm-autoresize-mode 1)
;;    ;; final de lo que estoy probando de helm


(defun my-company-active-return ()
  "Function to autocomplete a company recomendation, or act as enter, depending on mode."
  (interactive)
  (if (company-explicit-action-p)
      (company-complete)
    (call-interactively
     (or (key-binding (this-command-keys))
         (key-binding (kbd "RET")))
     )))

(use-package company
  :defer t
  :config
  ;; (setq company-frontends nil)

  ; No delay in showing suggestions.
  (setq company-idle-delay 10)
  ; Show suggestions after entering one character.
  (setq company-minimum-prefix-length 1)
  (setq company-selection-wrap-around t)

  (eval-after-load 'company
    '(progn
       (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
       (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)))
  (eval-after-load 'company
    '(progn
       (define-key company-active-map (kbd "S-TAB") 'company-select-previous)
       (define-key company-active-map (kbd "<backtab>") 'company-select-previous)))

  (defun my-company-visible-and-explicit-action-p ()
    (and (company-tooltip-visible-p)
         (company-explicit-action-p)))

  (defun company-ac-setup ()
    "Sets up `company-mode' to behave similarly to `auto-complete-mode'."
    (setq company-require-match nil)
    ;;(setq company-auto-complete #'my-company-visible-and-explicit-action-p)
    (setq company-frontends '(company-echo-metadata-frontend
                              company-pseudo-tooltip-unless-just-one-frontend-with-delay
                              company-preview-frontend))
    (define-key company-active-map [tab]
      'company-select-next-if-tooltip-visible-or-complete-selection)
    (define-key company-active-map (kbd "TAB")
      'company-select-next-if-tooltip-visible-or-complete-selection))

  (company-ac-setup)
  (add-hook 'after-init-hook 'global-company-mode)

  ;; para poder usar enter para autocompletar
  (define-key company-active-map (kbd "<return>") #'my-company-active-return)
  (define-key company-active-map (kbd "RET") #'my-company-active-return)
  )

(use-package lsp-ui :commands lsp-ui-mode)
(lsp-ui-mode 1)
(add-hook 'java-mode-hook #'lsp)
(require 'company-lsp)
(push 'company-lsp company-backends)

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language
;; optional if you want which-key integration
;; (use-package which-key
  ;; :config
  ;; (which-key-mode))

;; visual --------------------------------------------------


;; Fancy titlebar
;; (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
;; (add-to-list 'default-frame-alist '(ns-appearance . dark))
;; (setq ns-use-proxy-icon  nil)
;; (setq frame-title-format nil)

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

(setq visible-bell nil)
(setq ring-bell-function 'ignore)

;; lo mas cercano a los tabs de vim que encontre
(eyebrowse-mode t)

;; (load-theme 'gruvbox-dark-soft)
(load-theme 'gruvbox-dark-medium)

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

;; this cotrols the state in which each mode will be opened in
(loop for (mode . state)
      in '(
           (dired-mode . normal)
           (help-mode . normal)
           (magit-mode . normal)
           (package-menu-mode . normal)
;           (emacs-lisp-mode . normal)

           (inferior-emacs-lisp-mode . emacs)
           (nrepl-mode . insert)
           (pylookup-mode . emacs)
           (comint-mode . normal)
           (shell-mode . insert)
           (git-commit-mode . insert)
           (git-rebase-mode . emacs)
           (term-mode . emacs)
           ;;(helm-grep-mode . emacs)
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

;; status line information
(setq-default
 mode-line-format
 (list
  ;; mode-line-misc-info ; for eyebrowse
  '(eyebrowse-mode (:eval (eyebrowse-mode-line-indicator)))
  '(:eval (when-let (vc vc-mode)
            (list
             " "
             (propertize (substring vc 5) )
             " "
             ) ) )
  '(:eval (list
           ;; the buffer name; the file name as a tool tip
           (propertize
            " %b"
            'help-echo (buffer-file-name))
           (when (buffer-modified-p)
             (propertize
              " "
              ) )
           (when buffer-read-only
             (propertize
              " "
              ) ) " " ) )
  ;; spaces to align right
  '(:eval (propertize
           " " 'display
           `(
             (space :align-to (- (+ right right-fringe right-margin)
                                 ,(+ 3 (string-width mode-name) ) )
                    )
              ) ) )
  ;; the current major mode
  (propertize " %m " )
  )
 )
;; functions -----------------------------------------------

(defun save-all-buffers ()
  "Save all buffers."
  (interactive)
  (mapc 'save-buffer (buffer-list) )
  (message "se han guardado todos los buffers") )

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

(defun melpa-refresh ()
  "Refresh melpa contents."
  (interactive)
  (package-refresh-contents 'ASYNC) )

(defun save-and-exit-evil ()
  "Salir de modo de insert y guardar el archivo."
  (interactive)
  (save-buffer)
  (evil-force-normal-state) )

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

(defun amap (key function)
  "Define mapping in evil normal/insert mode.  FUNCTION in KEY."
  (nmap key function)
  (imap key function) )

(defun gbind (key function)
  "Map FUNCTION to KEY."
  (global-set-key (kbd key) function) )

(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

; TODO: aun falta hacer para poder esconder la terminal >:v
(defun toggle-terminal ()
  "Toggle terminal in its own buffer."
  (interactive)
  (split-window-horizontally)
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

; TODO estas funciones suenan interesantes
;; ; A function that behaves like Vim's ':tabe' commnad for creating a new tab and
;; ; buffer (the name "[No Name]" is also taken from Vim).
;; (defun vimlike-:tabe ()
  ;; "Vimlike ':tabe' behavior for creating a new tab and buffer."
  ;; (interactive)
  ;; (let ((buffer (generate-new-buffer "[No Name]")))
      ;; ; create new tab
      ;; (elscreen-create)
      ;; ; set window's buffer to the newly-created buffer
      ;; (set-window-buffer (selected-window) buffer)
      ;; ; set state to normal state
      ;; (with-current-buffer buffer
        ;; (evil-normal-state))
    ;; )
  ;; )
;;
;; (defun vimlike-quit ()
  ;; "Vimlike ':q' behavior: close current window if there are split windows;
;; otherwise, close current tab (elscreen)."
  ;; (interactive)
  ;; (let ((one-elscreen (elscreen-one-screen-p))
        ;; (one-window (one-window-p))
        ;; )
    ;; (cond
     ;; ; if current tab has split windows in it, close the current live window
     ;; ((not one-window)
      ;; (delete-window) ; delete the current window
      ;; (balance-windows) ; balance remaining windows
      ;; nil)
     ;; ; if there are multiple elscreens (tabs), close the current elscreen
     ;; ((not one-elscreen)
      ;; (elscreen-kill)
      ;; nil)
     ;; ; if there is only one elscreen, just try to quit (calling elscreen-kill
     ;; ; will not work, because elscreen-kill fails if there is only one
     ;; ; elscreen)
     ;; (one-elscreen
      ;; (evil-quit)
      ;; nil)
     ;; )))

(defun close-except-last-window ()
  "Close all windows without removing them from buffer, except if only one is remaining, in which case the eyebrowse-config is closed."
  (interactive)
  (if (one-window-p)
      (eyebrowse-close-window-config)
    (evil-quit)
    )
  )

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

(defhydra hydra-leader (:color blue :idle 1.0 :hints "leader")
  " actuar como leader en vim "
  ( "rs" reload-emacs-config "reload init" )
  ( "re" open-emacs-config "edit init" )
  ( "l" ivy-switch-buffer "buffer list" )
  ( "." toggle-terminal "terminal" )
  ;; en cualquier caso no los he usado mucho, entonces probemos no tenerlos del todo, a ver si hacen falta
  ;; ( "j" evil-previous-buffer "next" ) ;; este no sirve
  ;; ( "k" evil-next-buffer "next" )
  ( "SPC" (evil-execute-macro 1 (evil-get-register ?q t) ) )
  ( "m" (magit) "magit" )
  ( "o" (hydra-org/body) "org" )
  ( ";" #'counsel-locate "locate" )
  )

(defhydra hydra-tabs (:color blue :idle 1.0)
  "Tab management: "
  ("c" eyebrowse-create-window-config "create" )
  ("$" eyebrowse-rename-window-config "rename" )
  ("q" eyebrowse-close-window-config "quit" )
  ("l" eyebrowse-next-window-config "left" :color red)
  ("h" eyebrowse-prev-window-config "right" :color red)
  ("-" split-window-vertically "vertical" )
  ("+" split-window-horizontally "horizontal")
  ("1" eyebrowse-switch-to-window-config-1)
  ("2" eyebrowse-switch-to-window-config-2)
  ("3" eyebrowse-switch-to-window-config-3)
  ("4" eyebrowse-switch-to-window-config-4)
  ("5" eyebrowse-switch-to-window-config-5)
  ("6" eyebrowse-switch-to-window-config-6)
  ("7" eyebrowse-switch-to-window-config-7)
  ("8" eyebrowse-switch-to-window-config-8)
  ("9" eyebrowse-switch-to-window-config-9)
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
  ("g" org-goto "goto" :exit t)
  )

;; keybinds ------------------------------------------------

(gbind "C-M-h" 'help-menu )
(gbind "M-m" 'counsel-find-file )
(gbind "C-SPC" 'hydra-tabs/body )
(gbind "C-S-h" 'help-command )
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

;; redefinir mappings de evil
(with-eval-after-load 'evil-maps
  ;;( nmap "g t" 'tab-next )
  ;;( nmap "g b" 'tab-previous )
  ( nmap "C-l" 'evil-window-right )
  ( nmap "C-h" 'evil-window-left )
  ( nmap "C-k" 'evil-window-up )
  ( nmap "C-j" 'evil-window-down )

  ( nmap "C-s" 'evil-write )
  ( nmap "C-M-q" 'ido-kill-buffer ) ;'evil-quit )
  ( nmap "C-q" #'close-except-last-window )
  ;; ( nmap "C-w q" 'delete-window ) ; 'kill-this-buffer )
  ( nmap "C-w q" 'evil-quit ) ; 'kill-this-buffer )
  ( nmap "C-w t" 'eyebrowse-create-window-config )
  ( nmap "TAB" 'evil-window-map )
  ( nmap ","   #'hydra-leader/body )
  ( imap "C-s" 'save-and-exit-evil )
  ( imap "C-v" 'evil-paste-before )
  ( amap "C-z" 'undo-tree-undo )
  ( imap "TAB" #'company-indent-or-complete-common)
)

(provide 'init);;; init.el end here

;; ya solo falta buscar como organizar un para de bobadas :D
; " mostrar las marcas
    ; nnoremap '? :marks <cr>
;
; " para solo mostrar las marcas dentro del archivo
    ; nnoremap <Leader>' :marks abcdefghijklmnopqrstuvwxyz<cr>:'
;
; " muestra errores
    ; nnoremap <Leader>m :botright lwindow 5<cr>
;
; "mover entre buffers
    ; noremap j gj
    ; noremap k gk
    ; map gf :edit <cfile><cr>
