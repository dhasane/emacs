;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

;; en caso que la version sea mayor a 27, usar los tabs ya que vienen
;; incluidos, de lo contrario, usar eyebrowse (tiene cosas que se
;; parecen mas a tmu, lo cual es genial, pero hay unos detalles que no
;; me gustan tanto, como que este en el modeline)

(defcustom dh/min-tab-size 15
  "Minimum width of a tab in characters."
  :type 'integer
  :group 'tab-bar)

(defcustom dh/max-tab-size 25
 "Maximum width of a tab in characters."
  :type 'integer
  :group 'tab-bar)

(use-package tab-bar
  :ensure nil
  :demand t
  :general
  (:states '(normal motion)
   "g b" 'tab-bar-switch-to-prev-tab
   )
  :custom-face
  ;; (tab-bar              ((t (:background "#282828" :foreground "#fdf4c2"))))
  ;; (tab-bar-tab          ((t (:background "#282828" :foreground "#fdf4c2"))))
  ;; (tab-bar-tab-inactive ((t (:background "#504945" :foreground "#fdf4c2"))))

  ;; (tab-bar              ((t (:inherit ansi-color-inverse))))
  ;; (tab-bar-tab          ((t (:inherit default :underline t))))
  ;; (tab-bar-tab-inactive ((t (:inherit ansi-color-inverse))))

  ;; The tab bar's appearance
  ;; (tab-bar
  ;;  ((t (:inherit region
  ;;       ;; :background ,(face-attribute 'region :background)
  ;;       ;; :foreground region
  ;;       ))))
  ;; ;; Inactive tabs
  ;; (tab-bar-tab-inactive
  ;;  ((t (:inherit region
  ;;       ;; :background ,(face-attribute 'region :background)
  ;;       ;; :foreground region
  ;;       ;; :box (:line-width 1 :color ,(face-attribute 'region :background) :style nil)
  ;;       ))))
  ;; ;; Active tab
  ;; (tab-bar-tab
  ;;  ((t (:inherit default
  ;;       ;; :underline t
  ;;       :background ,(face-attribute 'region :background)
  ;;       ;;:foreground default
  ;;       ;; :box (:line-width 3 :color (face-attribute 'default :background) :style nil)
  ;;       ; :box (:line-width -1 :color ,(face-attribute 'default :foreground) :style nil)
  ;;       ))))
  :custom
  (tab-bar-close-button-show nil)
  (tab-bar-new-button-show nil)
  (tab-bar-tab-hints nil)
  ;; (tab-bar-separator
  ;;       (concat
  ;;        (propertize " " 'face `(:background ,(face-attribute 'region :background))
  ;;                    'display '(space :width (1)))
  ;;        (propertize " " 'face `(:underline (:position t) :foreground ,(face-attribute 'region :background) :inherit tab-bar))
  ;;        (propertize " " 'face `(:background ,(face-attribute 'region :background))
  ;;                    'display '(space :width (1)))))


  (tab-bar-tab-name-truncated-max 1)
  ;; (tab-bar-tab-name-function 'dh/set-tabs-name)
  ;; (tab-bar-tab-name-function 'set-name-if-in-project)
  ;; (tab-bar-tab-name-function 'tab-bar-tab-name-current)
  ;; (tab-bar-tab-name-function)
  (tab-bar-show 1)
  (tab-bar-format
   '(
     tab-bar-format-tabs
     ;; tab-bar-format-history
     ;; tab-bar-format-tabs-groups
     tab-bar-separator
     tab-bar-format-add-tab
     tab-bar-format-align-right
     ))

  (tab-bar-auto-width-max '(330 30))
  ;; (tab-bar-tab-name-function 'tab-bar-tab-name-current)
  :hook (after-load-theme . dh/set-tab-faces)
  :init
  (defun dh/set-tab-faces ()
    (interactive)
    (let ((active-color (face-attribute 'region :background))
          (background-color (face-attribute 'default :foreground))
          )
      (custom-set-faces
       ;; Tab bar general appearance
       `(tab-bar
         ((t
           (
            :inherit region
            :background ,background-color
            :foreground ,active-color
            ))))

       ;; Inactive tabs
       `(tab-bar-tab-inactive
         ((t
           (
            :inherit region
            ;; :box (:line-width 1 :color ,background-color :style nil)
            :background ,background-color
            :foreground ,active-color
            ))))

       ;; Active tab appearance
       `(tab-bar-tab
         ((t (
              :inherit default
              :background ,active-color
              ))))
       )

      ;; Set the tab bar separator
      (setq-default tab-bar-separator
                    (propertize
                     ;; " "
                     "\u200B"
                     'face `(:background ,active-color)
                     'display '(space :width (2)))
                    )
      )
    )
  (setq-default tab-bar-show 1)
  (defun dh/set-tabs-name ()
    "Muestra el nombre del tab, en caso de exceder los MAX caracteres,
muestra solo el nombre del proyecto y los caracteres sobrantes del
nombre del tab."
    (let* ((nombre (tab-bar-tab-name-current))
           ;; project
           (project-name (get-project-name-except-if-remote
                          :show-external t
                          :pre "["
                          :pos "] "))
           ;; max
           (nombre (concat (if (< dh/max-tab-size (length nombre))
                               (substring nombre (- dh/max-tab-size))
                             nombre
                             )))
           ;; min
           (nombre (concat (if (< (length (concat nombre project-name)) dh/min-tab-size)
                               (concat (make-string (- dh/min-tab-size (length nombre)) ?\s ) nombre)
                             nombre)
                           ))
           )
      (format "%s%s" project-name nombre)))

  (setq tab-bar-tab-name-function 'dh/set-tabs-name)
  :config
  (defun close-tab-configuration ()
    (interactive)
    (tab-bar-close-tab)
    )

  (defhydra+ hydra-tabs ()
    ("c" tab-bar-new-tab-to         "create"        :column "manage")
    ("d" tab-bar-duplicate-tab      "duplicate"     :column "manage")
    ("q" tab-bar-close-tab          "close"         :column "manage")
    ("l" tab-bar-switch-to-next-tab "left"          :column "move")
    ("h" tab-bar-switch-to-prev-tab "right"         :column "move")
    ("s" tab-switch                 "switcher"      :column "move")

    ("L" tab-bar-move-tab           "move left"     :column "organize")
    ("H" tab-bar-move-tab-backward  "move right"    :column "organize")
    ;; ("-" split-window-vertically    "vertical"      :column "split")
    ;; ("+" split-window-horizontally  "horizontal"    :column "split")

    ;; TODO define these dynamically
    ;; ("1" (lambda () (interactive) (tab-bar-select-tab 1)))
    ;; ("2" (lambda () (interactive) (tab-bar-select-tab 2)))
    ;; ("3" (lambda () (interactive) (tab-bar-select-tab 3)))
    ;; ("4" (lambda () (interactive) (tab-bar-select-tab 4)))
    ;; ("5" (lambda () (interactive) (tab-bar-select-tab 5)))
    ;; ("6" (lambda () (interactive) (tab-bar-select-tab 6)))
    ;; ("7" (lambda () (interactive) (tab-bar-select-tab 7)))
    ;; ("8" (lambda () (interactive) (tab-bar-select-tab 8)))
    ;; ("9" (lambda () (interactive) (tab-bar-select-tab 9)))
    )
  )

;; (use-package eyebrowse
;;   :if (version< emacs-version "27.0" )
;;   :after evil
;;   :bind
;;   (
;;    :map
;;    evil-normal-state-map
;;    ("TAB t" . 'eyebrowse-create-window-config )
;;    ("g t" . eyebrowse-next-window-config )
;;    ("g b" . eyebrowse-prev-window-config )
;;    )
;;   :config
;;   (eyebrowse-mode t)
;;   (defun close-tab-configuration ()
;;     (interactive)
;;     (eyebrowse-close-window-config)
;;     )
;;   (defhydra+ hydra-tabs ()
;;     "Tab management"
;;     ("c" eyebrowse-create-window-config "create" )
;;     ("$" eyebrowse-rename-window-config "rename" )
;;     ("q" eyebrowse-close-window-config "quit" )
;;     ("l" eyebrowse-next-window-config "left"); :color red)
;;     ("h" eyebrowse-prev-window-config "right"); :color red)
;;     ("-" split-window-vertically "vertical" )
;;     ("+" split-window-horizontally "horizontal")
;;     ("1" eyebrowse-switch-to-window-config-1)
;;     ("2" eyebrowse-switch-to-window-config-2)
;;     ("3" eyebrowse-switch-to-window-config-3)
;;     ("4" eyebrowse-switch-to-window-config-4)
;;     ("5" eyebrowse-switch-to-window-config-5)
;;     ("6" eyebrowse-switch-to-window-config-6)
;;     ("7" eyebrowse-switch-to-window-config-7)
;;     ("8" eyebrowse-switch-to-window-config-8)
;;     ("9" eyebrowse-switch-to-window-config-9)
;;     )
;;   )
