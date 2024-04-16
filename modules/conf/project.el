;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; Configuracion general para paquetes usados en varios proyectos

;;; code:

(use-package project
  :ensure nil
  )

(use-package tab-bar-groups
  :demand t
  :hook (tab-bar-groups-tab-post-change-group-functions . #'tab-bar-groups-regroup-tabs)
  :config
  ; (add-hook 'tab-bar-groups-tab-post-change-group-functions #'tab-bar-groups-regroup-tabs)
  (add-hook 'tab-bar-tab-post-open-functions #'tab-bar-groups-regroup-tabs)
  (add-hook 'tab-bar-tab-post-change-group-functions #'tab-bar-groups-regroup-tabs)
  ;; (add-to-list 'tab-bar-tab-post-open-functions #'tab-bar-groups-regroup-tabs)
  )

(use-package project-tab-groups
  :demand t
  :config
  (project-tab-groups-mode 1)
  :custom-face
  (tab-bar-tab-group-current
   ((t (:inherit tab-bar-tab
	:underline nil
        ;; :foreground region
        :box (:line-width -1 :style nil)
        ))))
  (tab-bar-tab-group-inactive
   ((t (:inherit tab-bar-tab-inactive
	:underline nil
	:background "#504945"
        :box (:line-width -1 :style nil)
	; :strike-through t
	;; :inverse-video t
        ))))
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
* ELSE es la funcion a ejecutar en caso de estar local y fuera de un proyecto.
* SHOW-EXTERNAL es si se quiere mostrar el simbolo '' en caso de estar
conectado a una maquina externa.
"
    (interactive)
    (if (file-remote-p default-directory)
        (if show-external (concat pre "" pos) "")
      (if (projectile-project-p)
          (concat pre (projectile-project-name) pos)
        (if else
            #'else
          ""))))
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

(use-package compile
  :ensure nil
  :hook
  (
   ;; Add color formatting to *compilation* buffer
   (compilation-filter . (lambda () (ansi-color-apply-on-region (point-min) (point-max))))
   (compilation-filter . comint-truncate-buffer)
   )
  :custom
  (compilation-scroll-output t)
  ;; (compilation-scroll-output 'first-error)
  :general
  ;; ("<f5>" (lambda ()
  ;;           (interactive)
  ;;           ;; (setq-local compilation-read-command nil)
  ;;           (call-interactively 'compile))
  ;;  )
  (dahas-comp-map
   "s" '(deets/side-window-toggle :wk "side window")
   "c" '((lambda ()
            (interactive)
            ;; (setq-local compilation-read-command nil)
            (call-interactively 'compile))
         :wk "compile")
   )
  :config
  (setq switch-to-buffer-obey-display-actions t)
  ;; Introduce a bottom side window that catches
  ;; compilations, deadgreps etc.
  (add-to-list 'display-buffer-alist
               '("\\*deadgrep.*\\|\\*Compilation\\*"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (slot . 0)
                 (window-parameters
                  (no-delete-other-windows . t))))

  (defun deets/side-window-resize (enlarge)
    (let ((bottom-windows (window-at-side-list (window-normalize-frame nil) 'bottom)))
      (dolist (window bottom-windows)
        (when (symbolp (window-parameter window 'window-side))
          (if enlarge
              (window-resize window (window-height window))
            (window-resize window (- (/ (window-height window) 2))))))))

  (defun deets/side-window-toggle (arg)
    (interactive "P")
    (cond ((null arg) (window-toggle-side-windows))
          ((listp arg) (deets/side-window-resize t))
          ((symbolp arg) (deets/side-window-resize nil))))

  ;; Remove our side-windows
  ;; (global-set-key (read-kbd-macro "C-x w") 'deets/side-window-toggle)
  )

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

(use-package prodigy
  :general
  (dahas-manage-map
   "p" '(prodigy :wk "prodigy"))

  :config
  (prodigy-define-status :id 'working :face 'prodigy-yellow-face)
  (defvar my-prodigy-service-counts nil "Map of status ID to number of Prodigy processes with that status")
  (advice-add
   'prodigy-set-status
   :before
   (lambda (service new-status)
     (let* ((old-status (plist-get service :status))
            (old-status-count (or 0 (alist-get old-status my-prodigy-service-counts)))
            (new-status-count (or 0 (alist-get new-status my-prodigy-service-counts))))
       (when old-status
         (setf (alist-get old-status my-prodigy-service-counts) (max 0 (- old-status-count 1))))
       (setf (alist-get new-status my-prodigy-service-counts) (+ 1 new-status-count))
       (force-mode-line-update t))))

  (defun my-prodigy-working-count ()
    "Number of services with the 'working' status."
    (let ((count (alist-get 'working my-prodigy-service-counts 0)))
      (when (> count 0)
        (format "W:%d" count))))

  (defun my-prodigy-failed-count ()
    "Number of services with the 'failed' status."
    (let ((count (alist-get 'failed my-prodigy-service-counts 0)))
      (if (> count 0)
          (format "F:%d" count)
        "")))

  ;; (prodigy-define-service
  ;;   :name "Python http server"
  ;;   :command "python3"
  ;;   :args '("-m" "http.server" "8000")
  ;;   ;; :cwd "."
  ;;   :tags '(python web)
  ;;   :stop-signal 'sigkill
  ;;   :kill-process-buffer-on-stop t)
  )

;;; project.el ends here
