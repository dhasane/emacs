;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package dockerfile-mode
  )

(use-package docker
  :demand t
  ;; :bind ("C-c d" . docker)
  :custom
  ;; (docker-show-messages t)
  (docker-run-async-with-buffer-function 'docker-run-async-with-compile-buffer)
  :config
  (defhydra+ hydra-manage ()
    ("d" docker "docker" :column "containers"))
  :init
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
  :config
  (defhydra+ hydra-manage ()
    ("k" kubernetes-overview "kubernetes" :column "containers"))
  )

(use-package kubernetes-evil
  :after kubernetes)

;;; container.el ends here
