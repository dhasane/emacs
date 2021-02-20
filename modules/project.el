;;; package --- Summary

;;; Commentary:
;;; Configuracion general para paquetes usados en varios proyectos

;;; code:

;; -*- lexical-binding: t; -*-

(use-package projectile
  :demand t
  :ensure t
  :defer .1
  :bind
  (
   :map
   projectile-mode-map
   ("M-p" . 'projectile-command-map)
   )
  :custom
  (projectile-require-project-root nil)
  ;; (projectile-project-search-path '("~/projects/" "~/work/"))
  (projectile-project-search-path '("~/dev/"))
  (projectile-sort-order 'recently-active)
  (projectile-completion-system 'ivy)
  :config
  (projectile-mode +1)
  )

(use-package compile
  :hook
  ;; Add color formatting to *compilation* buffer
  (compilation-filter . (lambda () (ansi-color-apply-on-region (point-min) (point-max))))
  :general
  ("<f5>" (lambda ()
            (interactive)
            (setq-local compilation-read-command nil)
            (call-interactively 'compile))
   )
  )

(use-package gud
  :custom
  (gdb-many-windows t) ;; use gdb-many-windows by default
  (gdb-show-main t)    ;; Non-nil means display source file containing the main routine at startup
  )

(use-package skeletor
  :after (projectile)
  :demand t
  :bind
  (
   :map
   projectile-mode-map
   ("M-p n" . 'skeletor-create-project)
   )
  :config
  (setq skeletor-project-directory "~/dev")
  )
