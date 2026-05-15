;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(defhydra hydra-tabs ( global-map "C-SPC" :color blue :idle 1.0 )
  "Tab management"
  )

(defhydra hydra-search ( :color blue :idle 1.0 )
  "Search functions"
  )

(defvar-keymap dh/lsp-map :full t)
(fset 'dh/lsp-map dh/lsp-map)

(general-define-key
 :keymaps 'dh/lsp-map
 "f"  '(:ignore t :which-key "find")
 "fd" '(xref-find-definitions  :which-key "definitions")
 "fr" '(xref-find-references   :which-key "references")
 )

(defvar dh/org-map (let ((map (make-sparse-keymap))) map))
(fset 'dh/org-map dh/org-map)

(defvar dh/agenda-map (let ((map (make-sparse-keymap))) map))
(fset 'dh/agenda-map dh/agenda-map)

(defvar dh/comp-map (let ((map (make-sparse-keymap))) map))
(fset 'dh/comp-map dh/comp-map)

;; (defhydra hydra-org (:color blue)
;;   "Org"
;;   )

(defvar dh/manage-map (let ((map (make-sparse-keymap))) map))
(fset 'dh/manage-map dh/manage-map)

;;; startup-keybinds.el ends here
