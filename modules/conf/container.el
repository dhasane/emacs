;;; container.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Docker and Kubernetes integration

;;; code:

(use-package dockerfile-mode
  :mode (("Dockerfile\\'" . dockerfile-mode)
         ("\\.dockerfile\\'" . dockerfile-mode)))

(use-package docker
  :demand t
  :custom
  ;; (docker-show-messages t)
  (docker-run-async-with-buffer-function 'docker-run-async-with-compile-buffer)
  (docker-container-columns
   '((:name "Names" :width 15 :template "{{ json .Names }}" :sort nil :format nil)
     (:name "Id" :width 16 :template "{{ json .ID }}" :sort nil :format nil)
     (:name "Status" :width 20 :template "{{ json .Status }}" :sort nil :format nil)
     (:name "Image" :width 15 :template "{{ json .Image }}" :sort nil :format nil)
     (:name "Command" :width 30 :template "{{ json .Command }}" :sort nil :format nil)
     (:name "Created" :width 23 :template "{{ json .CreatedAt }}" :sort nil :format
            (lambda
              (x)
              (format-time-string "%F %T"
                                  (date-to-time x))))
     (:name "Ports" :width 10 :template "{{ json .Ports }}" :sort nil :format nil))
   )
  :general
  (dahas-manage-map
   "d" '(docker :wk "docker"))
  :init
  ;; (defhydra+ hydra-manage ()
  ;;   ("d" docker "docker" :column "containers"))
  (defun docker-run-async-with-compile-buffer (program &rest args)
    "Execute \"PROGRAM ARGS\" and display output in a new `shell' buffer."
    (let* ((process-args (-remove 's-blank? (-flatten args)))
           (command (s-join " " (-insert-at 0 program process-args))))
      (when docker-show-messages (message "Running: %s" command))
      (compile command)))

  ;; :custom
  ;; (docker-command "podman")
  ;; (docker-compose-command "docker-compose")
  ;; (docker-container-default-sort-key "Names")
  )

(use-package kubernetes
  :demand t
  :commands (kubernetes-overview)
  :custom
  (kubernetes-poll-frequency 3600)
  (kubernetes-redraw-frequency 3600)
  ;; :config
  ;;(defhydra+ hydra-manage ()
  ;;  ("k" kubernetes-overview "kubernetes" :column "containers"))
  :general
  (dahas-manage-map
   "k" '(kubernetes-overview :wk "kubernetes"))
  )

(use-package kubernetes-evil
  :after kubernetes
  :hook (kubernetes-overview-mode . kubernetes-evil-mode))

;;; container.el ends here
