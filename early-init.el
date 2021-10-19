;;; early-init.el -*- lexical-binding: t; -*-

;; quitar las barras
(menu-bar-mode -1) ;; TODO: me gustaria activarlo para org
;; (tool-bar-mode -1)
;; (scroll-bar-mode -1)

(unless (and (display-graphic-p) (eq system-type 'darwin))
  (push '(menu-bar-lines . 0) default-frame-alist))
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)


(advice-add #'x-apply-session-resources :override #'ignore)

;; Make startup faster by reducing the frequency of garbage
;; collection.  The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold most-positive-fixnum)
(setq package-enable-at-startup nil)

;;; early-init.el ends here
