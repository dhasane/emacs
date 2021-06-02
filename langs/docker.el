;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package dockerfile-mode
  )

(use-package docker
  :ensure t
  :bind ("C-c d" . docker)
  ;; :custom
  ;; (docker-container-default-sort-key "Names")
  )

(use-package docker-tramp
  )

;;; docker.el ends here
