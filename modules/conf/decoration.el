;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(setq-default indicate-empty-lines t)

(use-package fira-code-mode
  :if (display-graphic-p)
  :custom (fira-code-mode-disabled-ligatures '(":" "x" "+")) ;; List of ligatures to turn off
  :hook prog-mode) ;; Enables fira-code-mode automatically for programming major modes

(defun disable-all-themes ()
  "disable all active themes."
  (dolist (i custom-enabled-themes)
    (disable-theme i)))

(defadvice load-theme (before disable-themes-first activate)
  (disable-all-themes))

(use-package adaptive-wrap
  :hook ((prog-mode . adaptive-wrap-prefix-mode))
  :custom
  (adaptive-wrap-extra-indent 4)
  ;; :config
  ;; https://stackoverflow.com/questions/13559061/emacs-how-to-keep-the-indentation-level-of-a-very-long-wrapped-line/13561223
  ;; (when (fboundp 'adaptive-wrap-prefix-mode)
  ;;   (defun my-activate-adaptive-wrap-prefix-mode ()
  ;;     "Toggle `visual-line-mode' and `adaptive-wrap-prefix-mode' simultaneously."
  ;;     (adaptive-wrap-prefix-mode (if visual-line-mode 1 -1)))
  ;;   (add-hook 'visual-line-mode-hook 'my-activate-adaptive-wrap-prefix-mode))
  )

(use-package visual-line-mode
  :elpaca nil
  :custom
  (
   (global-visual-line-mode t)
   (visual-line-fringe-indicators
    '(
      nil ;; left-curly-arrow
      right-curly-arrow
      ))
   )
  :hook ((prog-mode . visual-line-mode)
	 (org-mode . visual-line-mode))
  ;; (add-hook 'visual-line-mode-hook #'adaptive-wrap-prefix-mode)
  ;; :init
  ;; (setq-default global-visual-line-mode t)
  )

;; (setq indicate-buffer-boundaries t)

(setq inhibit-startup-screen t
      initial-buffer-choice nil
      initial-scratch-message nil
      )

(use-package dashboard
  :demand t
  :defines
  (
   show-week-agenda-p
   )
  :custom

  (inhibit-startup-screen t)
  (initial-buffer-choice nil)

  ;; (initial-buffer-choice "~/.emacs")
  ;; (initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
  ;; (setq dashboard-startup-banner 'logo)
  ;; Value can be
  ;; 'official which displays the official emacs logo
  ;; 'logo which displays an alternative emacs logo
  ;; 1, 2 or 3 which displays one of the text banners
  ;; "path/to/your/image.png" which displays whatever image you would prefer

  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  ;; (dashboard-modify-heading-icons '((recents . "file-text")
                                  ;; (bookmarks . "book")))
  (dashboard-set-navigator t)
  (show-week-agenda-p t)
  (dashboard-center-content t)
  (dashboard-items
   '(
     (recents   . 5)
     (projects  . 5)
     (agenda    . 5)
     (bookmarks . 5)
     (registers . 5)
     )
   )
  (dashboard-footer-messages '())
  :config

  (dashboard-setup-startup-hook))

(use-package gruvbox-theme
  :disabled t
  :demand t
  :config
  (load-theme
   ;; 'gruvbox-dark-medium
   'gruvbox-dark-soft
   ;; 'gruvbox-dark-hard
   )
  )

(use-package doom-themes
  ;; :disabled t
  :demand t
  :custom
  (doom-themes-enable-bold t)    ; if nil, bold is universally disabled
  (doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; (doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-gruvbox-padded-modeline t)

  (doom-gruvbox-brighter-comments nil)
  (doom-gruvbox-dark-variant
   "soft"
   )
  :config
  ;; Global settings (defaults)
  (load-theme
   ;; dark
   'doom-gruvbox
   ;; 'doom-material
   ;; 'doom-dracula

   ;; light
   ;; 'doom-tomorrow-day
   ;; 'doom-one-light
   t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package solaire-mode
  :demand t
  :after (doom-themes)
  :config
  (solaire-global-mode +1)
  ;; (dolist (face '(mode-line mode-line-inactive))
  ;;   (setf (alist-get face solaire-mode-remap-modeline) nil))
  )

(use-package all-the-icons
  :if (display-graphic-p)
  :demand t
  )

(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

(use-package kind-icon
  :after (corfu)
  :custom
  (kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
  :init
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package rainbow-mode
  :defer 1
  :delight
  :demand t
  :hook (org-mode
         emacs-lisp-mode
         web-mode
         typescript-mode
         js2-mode
         css-mode
         )
  )

(use-package display-line-numbers
  :elpaca nil
  :hook ((prog-mode . #'display-line-numbers))
  :custom
  ; (display-line-numbers-type 'relative)
  (display-line-numbers-type t)
  (display-line-numbers 'visual)
  (display-line-numbers nil)
  (display-line-numbers-widen t)
  (display-line-numbers-current-absolute t)

  :config
  (defun relative-line-numbers ()
    ;; (interactive)
    (setq-local display-line-numbers 'visual)
    )

  (defun absolute-line-numbers ()
    ;; (interactive)
    (setq-local display-line-numbers t)
    )

  ;; (add-hook 'prog-mode-hook
  ;;           (lambda ()
  ;;             (add-hook 'evil-insert-state-exit-hook #'relative-line-numbers)
  ;;             (add-hook 'evil-insert-state-entry-hook #'absolute-line-numbers)
  ;;             ))

  ;; example of customizing colors
  ;;(custom-set-faces '(line-number-current-line ((t :weight bold
  ;;:foreground "goldenrod"
  ;;:background "slate gray"))))


  ;; (global-display-line-numbers-mode)
  ;;(when (version<= "26.0.50" emacs-version )
  ;;  (global-display-line-numbers-mode))
  ;; :hook (prog-mode . display-line-numbers)
  )

;; (set-frame-parameter (selected-frame) 'alpha '(85 . 50))
;; (set-window-parameter (selected-window) 'alpha '(85 . 50))
;; (add-to-list 'default-frame-alist '(alpha . (85 . 50)))

;;; decoration.el ends here
