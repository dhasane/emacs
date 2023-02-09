;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package dockerfile-mode
  )

(use-package docker
  :bind ("C-c d" . docker)
  ;; :custom
  ;; (docker-command "podman")
  ;; (docker-compose-command "docker-compose")
  ;; (docker-container-default-sort-key "Names")
  )

;;; docker.el ends here
