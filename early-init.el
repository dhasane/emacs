;;; package --- Summary -*- lexical-binding: t; -*-
;;; early-init.el

;;; Commentary:

;;; Code:


;; Make startup faster by reducing the frequency of garbage
;; collection.  The default is 800 kilobytes.  Measured in bytes.

;;; speedup blub
(let ((default-gc-threshold gc-cons-threshold)
      (default-gc-percentage gc-cons-percentage))
  (setq gc-cons-threshold most-positive-fixnum
        default-gc-percentage 0.8)
  (add-hook 'after-init-hook
            (lambda ()
              (setq gc-cons-percentage default-gc-percentage
                    gc-cons-threshold default-gc-threshold))))

(setq load-prefer-newer t)

(setq ns-use-thin-smoothing t
      ns-use-proxy-icon nil
      tab-bar-show nil
      frame-title-format "%b - Emacs"
      frame-resize-pixelwise t
      default-frame-alist '( ;; (ns-transparent-titlebar . t)
                            (width . 170)
                            (height . 50)
                            (fullscreen . maximized)))

;; (cond
;;  ((string-equal system-type "gnu/linux")
;;   ;; llenar toda la pantalla
;;   (add-to-list 'default-frame-alist '(fullscreen . maximized))
;;   )
;;  )

(scroll-bar-mode -1) ; Turn off native OS scroll bars
(tool-bar-mode   -1) ; Turn off tool bar
(menu-bar-mode   -1) ; Turn off menu bars            ; TODO: me gustaria activarlo para org
(tooltip-mode    -1) ; Turn off pop-ups

(unless (and (display-graphic-p) (eq system-type 'darwin))
  (push '(menu-bar-lines . 0) default-frame-alist))
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

(advice-add #'x-apply-session-resources :override #'ignore)

(setq package-enable-at-startup nil)


;; (cond
;;  ((string-equal system-type "gnu/linux")
;;   (when (member "DejaVu Sans Mono" (font-family-list))
;;     (set-frame-font "DejaVu Sans Mono 12" t t))
;;   ;; specify font for chinese characters using default chinese font on linux
;;   (when (member "WenQuanYi Micro Hei" (font-family-list))
;;     (set-fontset-font t '(#x4e00 . #x9fff) "WenQuanYi Micro Hei" )))
;;  ((string-equal system-type "darwin") ; Mac
;;   (when (member "Menlo" (font-family-list))
;;     (set-frame-font "Menlo-12" t t)))
;;  ((string-equal system-type "windows-nt") ; Windows
;;   ;; esto fue necesario para que siquiera sirviera en windows
;;   (setq inhibit-compacting-font-caches t)))
;; specify font for all unicode characters

(when (member "Symbola" (font-family-list))
  (set-fontset-font t 'unicode "Symbola" nil 'prepend))
;; specify font for all unicode characters
(when (member "Apple Color Emoji" (font-family-list))
  (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend))

;; fonts ------
(let ((font (cond
             ((string-equal system-type "gnu/linux")
              (when (member "DejaVu Sans Mono" (font-family-list)) "DejaVu Sans Mono"))
             ((string-equal system-type "darwin") ; Mac
              (when (member "Menlo" (font-family-list)) "Menlo"))
             ))
      )
  ;; set a default font
  (set-face-attribute
   'default nil
   :family font
   :height 120
   :weight 'normal
   :width 'normal)

  ;; (let ((font-and-size (format "%s %s" font size)))
  ;;   ;; (message font-and-size)
  ;;   (set-frame-font font-and-size))
  )

;;; early-init.el ends here
