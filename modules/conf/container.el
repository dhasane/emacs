;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package dockerfile-mode
  )

(use-package docker
  ;; :bind ("C-c d" . docker)
  :init
  (defhydra+ hydra-manage ()
    ("d" docker "docker" :column "containers"))
  ;; :custom
  ;; (docker-command "podman")
  ;; (docker-compose-command "docker-compose")
  ;; (docker-container-default-sort-key "Names")
  )

(use-package kubernetes
  :ensure t
  :commands (kubernetes-overview)
  :config
  (setq kubernetes-poll-frequency 3600
        kubernetes-redraw-frequency 3600)
  :init
  (defhydra+ hydra-manage ()
    ("k" kubernetes-overview "kubernetes" :column "containers"))
  )

(use-package kubernetes-evil
  :after kubernetes)

;;; container.el ends here
