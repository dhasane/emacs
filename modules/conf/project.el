;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; Configuracion general para paquetes usados en varios proyectos

;;; code:

(use-package project
  :ensure nil
  )

(use-package projectile
  :delight '(:eval (format "[%s]" (projectile-project-name)))
  :demand t
  :defer 1
  :bind
  (
   :map
   projectile-mode-map
   ("M-p" . 'projectile-command-map)
   )
  :custom
  (projectile-require-project-root nil)
  ;; (projectile-project-search-path '("~/dev/" "~/work"))
  (projectile-sort-order 'recently-active)
  ;; (projectile-completion-system 'ivy)
  (projectile-globally-ignored-files
   '(
     "TAGS"
     ;; "*.svg"
     ))
  :config

  ;; (add-to-list 'projectile-project-root-files-bottom-up ".project")

  ;; evitar cargar rutas que no existen
  (dolist (path '("~/dev/" "~/work"))
    (if (file-exists-p path)
        (add-to-list 'projectile-project-search-path path)))

  (projectile-mode +1)

  :init
  ;; (projectile-register-project-type 'lrn '(".project")
  ;;                                   :project-file ".project"
  ;;                                   :test-suffix ".spec")

  (cl-defun get-project-name-except-if-remote (&key pre pos else show-external)
    "Retorna el nombre del proyecto, en caso de no ser remoto.
Se tienen varios parametros opcionales:
* PRE y POS representan las cadenas para incluir antes y despues del
nombre del proyecto. Solo se muestran en caso de estar dentro de un
proyecto.
* ELSE es la funcion a ejecutar (o cadena a retornar) en caso de estar local y fuera de un proyecto.
* SHOW-EXTERNAL es si se quiere mostrar el simbolo '' en caso de estar
conectado a una maquina externa.
"
    (interactive)
    (cond
     ((file-remote-p default-directory)
      (if show-external (concat pre "" pos) ""))
     ((projectile-project-p)
      (concat pre (projectile-project-name) pos))
     ((functionp else)
      (funcall else))
     ((null else) "")
     ((stringp else) else)
     (t (format "%s" else))))
  )

;; (use-package code-compass
;;   :demand
;;   :init
;;   (use-package async)
;;   (use-package dash)
;;   (use-package f)
;;   (use-package s)
;;   (use-package simple-httpd)
;;   :load-path "~/.emacs.d/elisp/code-compass/" )

(use-package gud
  :ensure nil
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

(use-package wgrep)

(use-package rg
  :config
  (rg-enable-menu))

;;; project.el ends here
