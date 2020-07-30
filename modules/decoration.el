
;;; Code:

(use-package dashboard
  :ensure t
  :init
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  ;; (dashboard-modify-heading-icons '((recents . "file-text")
                                  ;; (bookmarks . "book")))
  (setq dashboard-set-navigator t)
  (setq show-week-agenda-p t)
  (setq dashboard-center-content t)
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
  (setq dashboard-items
        '(
          (recents  . 5)
          (bookmarks . 5)
          (projects . 5)
          (agenda . 5)
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
          )
        )

  (dashboard-setup-startup-hook))

(load-theme 'gruvbox-dark-medium)

;;(use-package ample-theme
  ;;;; https://github.com/jordonbiondo/ample-theme
  ;;:init (progn
          ;;(load-theme 'ample t t)
          ;;;;(load-theme 'ample-flat t t)
          ;;;;(load-theme 'ample-light t t)
          ;;(enable-theme 'ample)
               ;;)
  ;;:defer t
  ;;:ensure t)
;;(use-package kaolin-themes
  ;;;; https://github.com/ogdenwebb/emacs-kaolin-themes
  ;;:config
  ;;(load-theme 'kaolin-temple t)
  ;;(kaolin-treemacs-theme))
;; (load-theme
 ;; 'gruvbox-light-medium)
;; (load-theme 'gruvbox-dark-soft)

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
  :hook (prog-mode . rainbow-delimiters-mode)
  )


(setq display-line-numbers-type 'relative)
(setq-default display-line-numbers 'visual
              display-line-numbers-widen t
              ;; this is the default
              display-line-numbers-current-absolute t)

(defun noct:relative ()
  (setq-local display-line-numbers 'visual))

(defun noct:absolute ()
  (setq-local display-line-numbers t))

;;(add-hook 'evil-insert-state-entry-hook #'noct:absolute)
;;(add-hook 'evil-insert-state-exit-hook #'noct:relative)

;; example of customizing colors
;;(custom-set-faces '(line-number-current-line ((t :weight bold
                                                 ;;:foreground "goldenrod"
                                                 ;;:background "slate gray"))))
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

  ;; (global-display-line-numbers-mode)
  ;;(when (version<= "26.0.50" emacs-version )
    ;;(global-display-line-numbers-mode))
  :hook (prog-mode . display-line-numbers)
  )

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

;; (set-frame-parameter (selected-frame) 'alpha '(85 . 50))
;; (set-window-parameter (selected-window) 'alpha '(85 . 50))
;; (add-to-list 'default-frame-alist '(alpha . (85 . 50)))
