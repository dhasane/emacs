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

(use-package which-key
  :delight
  :demand t
  :defer .1
  :custom
  ;; (which-key-max-description-length 27)
  (which-key-unicode-correction 3)
  (which-key-show-prefix 'left)
  (which-key-side-window-max-width 0.33)
  ;; (which-key-popup-type 'side-window)
  ;; (which-key-popup-type 'frame)
  ;; ;; max width of which-key frame: number of columns (an integer)
  ;; (which-key-frame-max-width 60)
  ;;
  ;; ;; max height of which-key frame: number of lines (an integer)
  ;; (which-key-frame-max-height 20)
  :config
  (which-key-setup-side-window-right-bottom)
  (which-key-mode)
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
