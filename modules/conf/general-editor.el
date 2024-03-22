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

(use-package flymake
  :ensure nil
  :init
  (setq-default flymake-no-changes-timeout 1)
  :config
  (setq flymake-mode-line-format
	;; the default mode line lighter takes up an unnecessary amount of
	;; space, so make it shorter
	'(" " flymake-mode-line-exception flymake-mode-line-counters)))

;;; general-editor end here
