;;; project.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Project tooling (built-in project.el)

;;; Configuracion general para paquetes usados en varios proyectos

;;; code:

(use-package project
  :demand t
  :ensure nil
  :custom
  (project-vc-extra-root-markers '(".project" ".projectile" "package.json" "Cargo.toml" "go.mod"))
  :config
  (dolist (path '("~/dev/" "~/work"))
    (when (file-exists-p path)
      (project-remember-projects-under path)))

  (cl-defun get-project-name-except-if-remote (&key pre pos else show-external)
    "Retorna el nombre del proyecto, en caso de no ser remoto.
Se tienen varios parametros opcionales:
* PRE y POS representan las cadenas para incluir antes y despues del
nombre del proyecto. Solo se muestran en caso de estar dentro de un
proyecto.
* ELSE es la funcion a ejecutar (o cadena a retornar) en caso de estar local y fuera de un proyecto.
* SHOW-EXTERNAL es si se quiere mostrar el simbolo '' en caso de estar
conectado a una maquina externa.
"
    (interactive)
    (cond
     ((file-remote-p default-directory)
      (if show-external (concat pre "net" pos) ""))
     ((project-current nil)
      (concat pre (project-name (project-current)) pos))
     ((functionp else)
      (funcall else))
     ((null else) "")
     ((stringp else) else)
     (t (format "%s" else))))
  )

(use-package gud
  :demand t
  :ensure nil
  :custom
  (gdb-many-windows t) ;; use gdb-many-windows by default
  (gdb-show-main t)    ;; Non-nil means display source file containing the main routine at startup
  )

(use-package wgrep
  :commands (wgrep-change-to-wgrep-mode))

(use-package rg
  :commands (rg rg-menu)
  :config
  (rg-enable-menu))

;;; project.el ends here
