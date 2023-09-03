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
  ;; :init
  ;; (defhydra+ hydra-org ()
  ;;   ("ci" citar-insert-citation "insert citation" :column "papers")
  ;;   ("ep" org-latex-export-to-pdf "export pdf" :column "papers")
  ;;   )
  :general
  (dahas-org-map
   "ci" '(citar-insert-citation :wk "insert citation")
   "ep" '(org-latex-export-to-pdf "export pdf")))

(use-package org-ref)

(use-package citar-embark
  :after citar embark
  :no-require
  :config (citar-embark-mode))

;;; org-papers.el ends here
