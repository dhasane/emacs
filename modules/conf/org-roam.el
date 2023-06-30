;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; configuracion de org roam

;;; code:

(use-package org-roam
  ;; :delight
  ;; :bind (:map org-roam-mode-map
  ;;             (("C-c n l" . org-roam)
  ;;              ("C-c n f" . org-roam-find-file)
  ;;              ("C-c n g" . org-roam-graph))
  ;;             :map org-mode-map
  ;;             (("C-c n i" . org-roam-insert))
  ;;             (("C-c n I" . org-roam-insert-immediate)))
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

  (setq zettlekasten-paths-alist `(("Main" . ,org-roam-directory)
                                   ("Work" . "~/docs")
                                   ("Tesis" . "~/tesis")))

  (defun switch-zettelkasten ()
    (interactive)
    (let* ((keys (mapcar #'car zettlekasten-paths-alist))
           (prompt (format "Select Zettlekasten:"))
           (key (completing-read prompt keys))
           (chosen-zettlekasten-path (cdr (assoc key zettlekasten-paths-alist))))
      (setq org-roam-directory chosen-zettlekasten-path)
      (setq org-roam-db-location (concat chosen-zettlekasten-path "org-roam.db"))
      (org-roam-db-sync)))

  (defhydra+ hydra-org (:color blue :columns 3)
    ("f"  org-roam-node-find                "find"                 :column "action")
    ("i"  org-roam-node-insert              "insert"               :column "action")
    ("z"   switch-zettelkasten              "switch zettelkasten"  :column "action")

    ("dd" org-roam-dailies-capture-today    "daily capture"        :column "daily")
    ("dt" org-roam-dailies-goto-today       "show today's capture" :column "daily")
    ;; ("ds" org-roam-dailies-goto-date        "show all captures"    :column "daily")

    ("at" org-roam-tag-add                  "add tag"              :column "tags")
    ("rt" org-roam-tag-remove               "remove tag"           :column "tags")

    ("o"  org-roam-buffer-toggle            "roam buffer"          :column "roam")
    ("cn" org-id-get-create                 "create node"          :column "roam")
    ("s"  org-roam-db-sync                  "sync db"              :column "roam")

    ;; ("m" org-roam-graph     "map" :column "ui")
    )
  )

(use-package org-roam-ui
  :elpaca
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
  :init
  (defhydra+ hydra-org (:color blue :columns 3)
    ("m"   org-roam-ui-mode  "map" :column "ui")
    )
  )


;;; org-roam.el ends here
