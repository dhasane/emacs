
;;; package --- Summary

;;; Commentary:

;;; code:

;; -*- lexical-binding: t; -*-

(setq-default indicate-empty-lines t)
;; (setq indicate-buffer-boundaries t)

(use-package dashboard
  :ensure t
  :demand t
  :defines
  (
   show-week-agenda-p
   )
  :custom

  (inhibit-startup-screen t)
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
  :config
  (setq dashboard-footer-messages
        '(
          "Free as free speech, free as free Beer"
          "Richard Stallman is proud of you"
          "Happy coding!"
          "I showed you my source code, pls respond"
          "Yeeeee boiii"
          "Gotta go fast"
          "Stonks"
          "Para la gente que piensa que ya no hay razon para vivir y nada mas para esperar, la cuestion es lograr que entiendan que la vida espera algo de ellos -Victor Frankel"
          )
        )

  (dashboard-setup-startup-hook))

(use-package gruvbox-theme
  ;; :disabled
  :demand t
  :config
  (load-theme
   ;; 'gruvbox-dark-medium
   ;; 'gruvbox-dark-soft
   'gruvbox-dark-hard
   )
  )

;; (use-package ample-theme
;;   ;; https://github.com/jordonbiondo/ample-theme
;;   :init
;;
;;   ;; (load-theme 'ample t t)
;;   ;;(load-theme 'ample-flat t t)
;;   ;; (load-theme 'ample-light t t) ;; no
;;   (load-theme 'ample)
;;   :defer t
;;   :ensure t)
;;(use-package kaolin-themes
  ;;;; https://github.com/ogdenwebb/emacs-kaolin-themes
  ;;:config
  ;;(load-theme 'kaolin-temple t)
  ;;(kaolin-treemacs-theme))

;; fonts ------
(progn
  ;; set a default font
  (cond
   ((string-equal system-type "gnu/linux")
    (when (member "DejaVu Sans Mono" (font-family-list))
      (set-frame-font "DejaVu Sans Mono 12" t t)
      ;;(set-frame-font "Fira Code 12" t t)
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
  :defer .1
  )

(use-package rainbow-delimiters
  :defer 1
  :delight
  :hook (prog-mode . rainbow-delimiters-mode)
  :demand t
  )

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
  :disabled
  :hook (
         (prog-mode . display-line-numbers)
         )
  :init
  (defun relative-line-numbers ()
    (interactive)
    (setq-local display-line-numbers 'visual)
    )

  (defun absolute-line-numbers ()
    (interactive)
    (setq-local display-line-numbers t)
    )

  :config
  (setq display-line-numbers-type 'relative)
  ;;(setq-default
  (setq
   display-line-numbers 'visual
   display-line-numbers-widen t
   ;; this is the default
   display-line-numbers-current-absolute t)

  (add-hook 'prog-mode-hook (lambda ()
                              (add-hook 'evil-insert-state-exit-hook #'relative-line-numbers)
                              (add-hook 'evil-insert-state-entry-hook #'absolute-line-numbers)
                              ))

  ;; example of customizing colors
  ;;(custom-set-faces '(line-number-current-line ((t :weight bold
  ;;:foreground "goldenrod"
  ;;:background "slate gray"))))


  ;; (global-display-line-numbers-mode)
  ;;(when (version<= "26.0.50" emacs-version )
  ;;  (global-display-line-numbers-mode))
  ;; :hook (prog-mode . display-line-numbers)
  )

(use-package hl-line
  :defer 1
  :hook (prog-mode . hl-line-mode)
  ;; :config
  ;; (global-hl-line-mode +1)
)

(use-package highlight-indent-guides
  :defer 1
  :delight
  :hook (
         (prog-mode . highlight-indent-guides-mode)
         )
  :custom
  (highlight-indent-guides-method 'character
                                  ;; 'column
                                  )
  (highlight-indent-guides-character ?║ ;; U+2551
                                     )
  (highlight-indent-guides-responsive ;;'top
                                      'stack
                                      )
  :config
  ;; (set-face-background 'highlight-indent-guides-odd-face "blue")
  ;; (set-face-background 'highlight-indent-guides-even-face "green")
  ;; (set-face-foreground 'highlight-indent-guides-character-face "red")

  )

(use-package tree-sitter
  :hook
  (tree-sitter-after-on-hook . tree-sitter-hl-mode)
  (rust-mode . tree-sitter-hl-mode)

  :init

  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)

  (use-package tree-sitter-langs)
  (require 'tree-sitter)
  (require 'tree-sitter-hl)
  (require 'tree-sitter-langs)
  (require 'tree-sitter-debug)
  (require 'tree-sitter-query)

  (global-tree-sitter-mode)
  )

;; (set-frame-parameter (selected-frame) 'alpha '(85 . 50))
;; (set-window-parameter (selected-window) 'alpha '(85 . 50))
;; (add-to-list 'default-frame-alist '(alpha . (85 . 50)))
