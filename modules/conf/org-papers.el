;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; configuracion de org mode

;;; code:

(use-package citar
  :custom
  (citar-bibliography '("~/org/references.bib"))
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar)
  :hook
  (LaTeX-mode . citar-capf-setup)
  (org-mode . citar-capf-setup)
  :init
  (defhydra+ hydra-org ()
    ("ci" citar-insert-citation "insert citation" :column "papers")
    )
  )

(use-package org-ref)

(use-package citar-embark
  :after citar embark
  :no-require
  :config (citar-embark-mode))

(use-package org-download
  :custom
  (org-download-image-dir "~/org/imagenes")
  )

;;; org-papers.el ends here
