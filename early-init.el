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
;;   ;; (when (member "DejaVu Sans Mono" (font-family-list))
;;   ;;   (set-frame-font "DejaVu Sans Mono 12" t t))
;;   (when (member "Symbola" (font-family-list))
;;     (set-fontset-font t 'unicode "Symbola" nil 'prepend))
;;   ;; specify font for chinese characters using default chinese font on linux
;;   ;; (when (member "WenQuanYi Micro Hei" (font-family-list))
;;   ;;   (set-fontset-font t '(#x4e00 . #x9fff) "WenQuanYi Micro Hei" ))
;;   )
;;
;;  ;; specify font for all unicode characters
;;  (when (member "Apple Color Emoji" (font-family-list))
;;    (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend))
;;
;;  )

;; fonts ------
(let ((font (cond
             ((string-equal system-type "gnu/linux")
              (when (member "DejaVu Sans Mono" (font-family-list)) "DejaVu Sans Mono"))

             ((string-equal system-type "darwin") ; Mac
              (when (member "Menlo" (font-family-list)) "Menlo"))

             ((string-equal system-type "windows-nt") ; Windows
              ;; esto fue necesario para que siquiera sirviera en windows
              (setq inhibit-compacting-font-caches t)))
             ))

  ;; set a default font
  (set-face-attribute
   'default nil
   :family font
   :height 130
   :weight 'normal
   :width 'normal
   ))

;; (when (fboundp 'startup-redirect-eln-cache)
;;   (startup-redirect-eln-cache
;;    (convert-standard-filename
;; 	  (expand-file-name  "var/eln-cache/" user-emacs-directory))))

(push '(foreground-color . :never) frameset-filter-alist)
(push '(background-color . :never) frameset-filter-alist)
(push '(font . :never) frameset-filter-alist)
(push '(cursor-color . :never) frameset-filter-alist)
(push '(background-mode . :never) frameset-filter-alist)
(push '(ns-appearance . :never) frameset-filter-alist)
(push '(background-mode . :never) frameset-filter-alist)

;; medir el tiempo de inico
;; Use a hook so the message doesn't get clobbered by other messages.
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;;; early-init.el ends here
