;;; package --- Summary

;;; Commentary:

;;; code:

;; -*- lexical-binding: t; -*-

;; en caso que la version sea mayor a 27, usar los tabs ya que vienen
;; incluidos, de lo contrario, usar eyebrowse (tiene cosas que se
;; parecen mas a tmu, lo cual es genial, pero hay unos detalles que no
;; me gustan tanto, como que este en el modeline)

(defcustom dh/min-tab-size 10
  "Minimum width of a tab in characters."
  :type 'integer
  :group 'tab-line)

(defcustom dh/max-tab-size 30
 "Maximum width of a tab in characters."
  :type 'integer
  :group 'tab-line
  )

(use-package tab-bar
  :after evil
  :general
  (:states '(normal motion)
   "g b" 'tab-bar-switch-to-prev-tab
   )
  :custom-face
  (tab-bar              ((t (:background "#282828" :foreground "#fdf4c2"))))
  (tab-bar-tab          ((t (:background "#282828" :foreground "#fdf4c2"))))
  (tab-bar-tab-inactive ((t (:background "#504945" :foreground "#fdf4c2"))))
  :custom
  (tab-bar-show 1)

  ;;(setq tab-bar-tab ((t (:background "#fdf4c1" :foreground "#504945"))))
  ;;(setq tab-bar-tab-inactive ((t (:background "#fdf4c1" :foreground "#282828"))))
  (tab-bar-show 1)
  (tab-bar-close-button-show nil)
  (tab-bar-tab-hints t)
  (tab-bar-tab-name-truncated-max 1)
  (tab-bar-tab-name-function 'dh/set-tabs-name)
  ;; (tab-bar-tab-name-function 'set-name-if-in-project)
  ;; (tab-bar-tab-name-function 'tab-bar-tab-name-current)
  ;; (tab-bar-tab-name-function)
  :config
  ;; esto tal vez lo podria usar para cambiar tab-bar
  ;; https://stackoverflow.com/questions/7709158/how-do-i-customize-the-emacs-interface-specifically-the-tabs-fonts-in-windows

  (defun dh/set-tabs-name ()
    "Muestra el nombre del tab, en caso de exceder los MAX caracteres,
muestra solo el nombre del proyecto y los caracteres sobrantes del
nombre del tab."
    (let ((nombre (tab-bar-tab-name-current)))
      (let ((final-name (concat
                         (if (< dh/max-tab-size (length nombre))
                             (substring nombre (- dh/max-tab-size))
                           nombre))))
        (format "%s%s"
                (get-project-name-except-if-remote
                 :show-external t
                 :pre "["
                 :pos "] "
                 )
                final-name)
        )))

  (defun close-tab-configuration ()
    (interactive)
    (tab-bar-close-tab)
    )

  (defhydra hydra-tabs ( global-map "C-SPC" :color blue :idle 1.0 )
    "Tab management"
    ("c" tab-bar-new-tab-to "create" )
    ("q" tab-bar-close-tab "quit" )
    ("l" tab-bar-switch-to-next-tab "left"); :color red)
    ("h" tab-bar-switch-to-prev-tab "right"); :color red)
    ("-" split-window-vertically "vertical" )
    ("+" split-window-horizontally "horizontal")
    ("s" tab-switcher "switcher")
    ;;("2" eyebrowse-switch-to-window-config-2 )
    ;;("3" eyebrowse-switch-to-window-config-3 )
    ;;("4" eyebrowse-switch-to-window-config-4 )
    ;;("5" eyebrowse-switch-to-window-config-5 )
    ;;("6" eyebrowse-switch-to-window-config-6 )
    ;;("7" eyebrowse-switch-to-window-config-7 )
    ;;("8" eyebrowse-switch-to-window-config-8 )
    ;;("9" eyebrowse-switch-to-window-config-9 )
    )
  )

(use-package eyebrowse
  :if (version< emacs-version "27.0" )
  :ensure t
  :after evil
  :bind
  (
   :map
   evil-normal-state-map
   ("TAB t" . 'eyebrowse-create-window-config )
   ("g t" . eyebrowse-next-window-config )
   ("g b" . eyebrowse-prev-window-config )
   )
  :config
  (eyebrowse-mode t)
  (defun close-tab-configuration ()
    (interactive)
    (eyebrowse-close-window-config)
    )
  (defhydra hydra-tabs ( global-map "C-SPC" :color blue :idle 1.0 )
    "Tab management"
    ("c" eyebrowse-create-window-config "create" )
    ("$" eyebrowse-rename-window-config "rename" )
    ("q" eyebrowse-close-window-config "quit" )
    ("l" eyebrowse-next-window-config "left"); :color red)
    ("h" eyebrowse-prev-window-config "right"); :color red)
    ("-" split-window-vertically "vertical" )
    ("+" split-window-horizontally "horizontal")
    ("1" eyebrowse-switch-to-window-config-1)
    ("2" eyebrowse-switch-to-window-config-2)
    ("3" eyebrowse-switch-to-window-config-3)
    ("4" eyebrowse-switch-to-window-config-4)
    ("5" eyebrowse-switch-to-window-config-5)
    ("6" eyebrowse-switch-to-window-config-6)
    ("7" eyebrowse-switch-to-window-config-7)
    ("8" eyebrowse-switch-to-window-config-8)
    ("9" eyebrowse-switch-to-window-config-9)
    )
  )
