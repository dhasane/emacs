;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; configuracion de org roam

;;; code:

(use-package org-roam
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
      (setq org-roam-db-location (concat chosen-zettlekasten-path "org-roam.db"))
      (setq org-download-image-dir (expand-file-name (concat chosen-zettlekasten-path "/imagenes/")))
      (org-roam-db-sync)))

  ;; (defhydra+ hydra-org (:color blue :columns 3)
  ;;   ("f"  org-roam-node-find                "find"                 :column "action")
  ;;   ("i"  org-roam-node-insert              "insert"               :column "action")
  ;;   ("z"   switch-zettelkasten              "switch zettelkasten"  :column "action")

  ;;   ("dd" org-roam-dailies-capture-today    "daily capture"        :column "daily")
  ;;   ("dt" org-roam-dailies-goto-today       "show today's capture" :column "daily")
  ;;   ;; ("ds" org-roam-dailies-goto-date        "show all captures"    :column "daily")

  ;;   ("at" org-roam-tag-add                  "add tag"              :column "tags")
  ;;   ("rt" org-roam-tag-remove               "remove tag"           :column "tags")

  ;;   ("o"  org-roam-buffer-toggle            "roam buffer"          :column "roam")
  ;;   ("cn" org-id-get-create                 "create node"          :column "roam")
  ;;   ("s"  org-roam-db-sync                  "sync db"              :column "roam")

  ;;   ;; ("m" org-roam-graph     "map" :column "ui")
  ;;   )
  :general
  (dahas-org-map
   "f"   '(org-roam-node-find :wk "find")
   "i"   '(org-roam-node-insert :wk "insert")
   "z"   '(switch-zettelkasten :wk "switch zettelkasten")
   ;; "a"   '(org-roam-capture :wk "capture")

   "d" '(:ignore t :which-key "daily")
   "dd" '(org-roam-dailies-capture-today :wk "daily capture")
   "dt" '(org-roam-dailies-goto-today :wk "show today's capture")
   ;; ("ds" org-roam-dailies-goto-date      ;;   "show all captures"    :column "daily")

   "t" '(:ignore t :which-key "tag")
   "ta" '(org-roam-tag-add :wk "add tag")
   "tr" '(org-roam-tag-remove :wk "remove tag")

   "o"  '(org-roam-buffer-toggle :wk "roam buffer")
   "n" '(org-id-get-create :wk "create node")
   "s"  '(org-roam-db-sync :wk "sync db")
   )
  )

(use-package org-roam-ui
  :ensure
  (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
  ;; :straight
  ;; (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
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
  ;; :init
  ;; (defhydra+ hydra-org (:color blue :columns 3)
  ;;   ("m"   org-roam-ui-mode  "map" :column "ui")
  ;;   )
  :general
  (dahas-org-map
   "m" '(org-roam-ui-mode :wk "map")
   )
  )


;;; org-roam.el ends here
