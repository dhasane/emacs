;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; configuracion de org roam

;;; code:


(defhydra hydra-roam (:color blue :columns 3)
  ("cn" org-id-get-create "create node")
  ("s" org-roam-db-sync)
)

(use-package org-roam
  :delight
  :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n g" . org-roam-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))
              (("C-c n I" . org-roam-insert-immediate)))
  :custom
  (org-roam-directory "~/org")
  (org-roam-graph-viewer #'eww-open-file)
  (org-roam-graph-executable ;; requiere graphviz
   ;; "dot" ;; esto es el default
   ;; "neato"
   "fdp" ;; compacto y no sobrelapa
   ;; "twopi"
   ;; "circo"
   )
  (org-roam-node-display-template "${title} ${tags}")
  :init
  (org-roam-db-autosync-mode)
  )

(use-package org-roam-ui
  :straight
    (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
    :after org-roam
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :custom
    (org-roam-ui-follow t)
    (org-roam-ui-update-on-save t)
    (org-roam-ui-open-on-start t)
    (org-roam-ui-sync-theme t)
    )

;; (defhydra hydra-roam
;;   (:color blue)
;;   ("o" org-roam           "roam")
;;   ("f" org-roam-find-file "find")
;;   ("i" org-roam-insert    "insert")
;;   ("m" org-roam-graph     "map")
;;   )

;;; org-roam.el ends here
