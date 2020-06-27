
;;; Code:

(load-theme 'gruvbox-dark-medium)
;; (load-theme
 ;; 'gruvbox-light-medium)
;; (load-theme 'gruvbox-dark-soft)

;; fonts ------
(progn
  ;; set a default font
  (cond
   ((string-equal system-type "gnu/linux")
    (when (member "DejaVu Sans Mono" (font-family-list))
      ;;(set-frame-font "DejaVu Sans Mono 12" t t)
      (set-frame-font "Fira Code 12" t t)
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
