;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(defhydra hydra-tabs ( global-map "C-SPC" :color blue :idle 1.0 )
  "Tab management"
  )

(defhydra hydra-search ( :color blue :idle 1.0 )
  "Search functions"
  )

(defvar-keymap dahas-lsp-map :full t)
(fset 'dahas-lsp-map dahas-lsp-map)

(general-define-key
 :keymaps 'dahas-lsp-map
 "f"  '(:ignore t :which-key "find")
 "fd" '(xref-find-definitions  :which-key "definitions")
 "fr" '(xref-find-references   :which-key "references")
 )

(defvar dahas-org-map (let ((map (make-sparse-keymap))) map))
(fset 'dahas-org-map dahas-org-map)

(defvar dahas-comp-map (let ((map (make-sparse-keymap))) map))
(fset 'dahas-comp-map dahas-comp-map)

(general-define-key
 :keymaps 'dahas-org-map
 "e" '(:ignore t :which-key "export")
 )


;; (defhydra hydra-org (:color blue)
;;   "Org"
;;   )

(defvar dahas-manage-map (let ((map (make-sparse-keymap))) map))
(fset 'dahas-manage-map dahas-manage-map)

;;; startup-keybinds.el ends here
