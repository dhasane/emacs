;; -*- lexical-binding: t; -*-

;;; Code:

(use-package whitespace
  :disabled ;; TODO: fix this
  :custom
  (whitespace-line-column 1000)   ;; max line length
  (whitespace-style
   '(
     face
     tabs
     lines-tail
     trailing
     ))
  :hook ((prog-mode . whitespace-mode))
  )

;; eliminar espacios al final de una linea
;; (add-hook 'before-save-hook 'delete-trailing-whitespace)
(use-package ws-butler
  :delight
  :demand t
  :defer .1
  :hook (
         (prog-mode . ws-butler-mode)
         (org-mode . ws-butler-mode)
         )
  )

;;; general-editor end here
