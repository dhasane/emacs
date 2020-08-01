
;;; package --- summary:

;; EEEEEEEEEEEEEEEEEEEEEE                                                                               ;;
;; E::::::::::::::::::::E                                                                               ;;
;; E::::::::::::::::::::E                                                                               ;;
;; EE::::::EEEEEEEEE::::E                                                                               ;;
;;   E:::::E       EEEEEE   mmmmmmm    mmmmmmm     aaaaaaaaaaaaa      cccccccccccccccc    ssssssssss    ;;
;;   E:::::E              mm:::::::m  m:::::::mm   a::::::::::::a   cc:::::::::::::::c  ss::::::::::s   ;;
;;   E::::::EEEEEEEEEE   m::::::::::mm::::::::::m  aaaaaaaaa:::::a c:::::::::::::::::css:::::::::::::s  ;;
;;   E:::::::::::::::E   m::::::::::::::::::::::m           a::::ac:::::::cccccc:::::cs::::::ssss:::::s ;;
;;   E:::::::::::::::E   m:::::mmm::::::mmm:::::m    aaaaaaa:::::ac::::::c     ccccccc s:::::s  ssssss  ;;
;;   E::::::EEEEEEEEEE   m::::m   m::::m   m::::m  aa::::::::::::ac:::::c                s::::::s       ;;
;;   E:::::E             m::::m   m::::m   m::::m a::::aaaa::::::ac:::::c                   s::::::s    ;;
;;   E:::::E       EEEEEEm::::m   m::::m   m::::ma::::a    a:::::ac::::::c     cccccccssssss   s:::::s  ;;
;; EE::::::EEEEEEEE:::::Em::::m   m::::m   m::::ma::::a    a:::::ac:::::::cccccc:::::cs:::::ssss::::::s ;;
;; E::::::::::::::::::::Em::::m   m::::m   m::::ma:::::aaaa::::::a c:::::::::::::::::cs::::::::::::::s  ;;
;; E::::::::::::::::::::Em::::m   m::::m   m::::m a::::::::::aa:::a cc:::::::::::::::c s:::::::::::ss   ;;
;; EEEEEEEEEEEEEEEEEEEEEEmmmmmm   mmmmmm   mmmmmm  aaaaaaaaaa  aaaa   cccccccccccccccc  sssssssssss     ;;

;;; Commentary:

;; configuracion de Emacs asi como bien pro

;;; code:

;; medir el tiempo de inico
;; Use a hook so the message doesn't get clobbered by other messages.
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;; Make startup faster by reducing the frequency of garbage
;; collection.  The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;;; init ----------------------------------------------------
;;; Inicio configuracion

(load "server")
(unless (server-running-p) (server-start))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file)

(require 'package)
(setq
 package-archives
 '(
   ("melpa"         . "https://melpa.org/packages/")
   ("melpa-milkbox" . "http://melpa.milkbox.net/packages/")
   ("melpa-stable"  . "http://stable.melpa.org/packages/")
   ("elpa"          . "https://elpa.gnu.org/packages/")
   ("gnu"           . "http://elpa.gnu.org/packages/")
   )
 package-archive-priorities
 '(
   ("melpa"         . 20)
   ("melpa-milkbox" . 15)
   ("melpa-stable"  . 10)
   ("gnu"           . 5)
   ("elpa"          . 0)
   )
 )

(package-initialize)

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))
(package-install-selected-packages)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)
(setq use-package-always-defer t)
(setq use-package-compute-statistics nil) ;; t para verificar tiempos de carga
(use-package use-package-ensure-system-package)

(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

(defconst config-module-dir (expand-file-name "modules/" user-emacs-directory)
  "Directorio de modulos de configuracion.")

(defun load-config-module (config-directory filelist)
  "Cargar un archivo de configuracion a partir del FILELIST."
  (dolist (file filelist)
    (load (expand-file-name
           (concat config-directory file)))
    (message "Loaded config file:%s" file)
    ))

;; TODO: podria ser interesante hacer un paquete que cargue los
;; modulos, similar a use-package, pero mas simple
;; - cargue un archivo
;; - evite que se propaguen errores
;; - tambien algo que podria ser interesante es que mida el tiempo que
;; toma cargar cada uno de los archivos
;; - se podria poner algo para que haga byte-compile a ciertos
;; archivos
;;(cl-defstruct config-file
  ;;name
  ;;load
  ;;)
;;(load-config-file :name "basic" :load 1)

(defun load-config ()
  "Cargar los archivos de configuracion."
  (interactive)
  (load-config-module
   config-module-dir
   '(
     "basic"
     "funciones"
     "decoration"
     "tabs"
     "term"
     "git"
     "evil"
     "project"
     "completion"
     "ivy"
     "mode-line"
     "org-mode"
     "minibuffer"
     "hydras"
     )
   ;; "fira-code"
   )
  )
(load-config)

(use-package which-key
  :ensure t
  :demand t
  :defer .1
  :config
  (which-key-setup-side-window-right-bottom)
  ;; (setq which-key-max-description-length 27)
  (setq which-key-unicode-correction 3)
  (setq which-key-show-prefix 'left)
  (setq which-key-side-window-max-width 0.33)
  ;; (setq which-key-popup-type 'side-window)
  ;; (setq which-key-popup-type 'frame)
  ;; ;; max width of which-key frame: number of columns (an integer)
  ;; (setq which-key-frame-max-width 60)
  ;;
  ;; ;; max height of which-key frame: number of lines (an integer)
  ;; (setq which-key-frame-max-height 20)
  (which-key-mode)
  )

(pdf-tools-install)
(pdf-loader-install)

;; para simplificar
(defun gbind (key function)
  "Map FUNCTION to KEY globally."
  (global-set-key (kbd key) function) )

(gbind "C-M-h" 'help-menu )
(gbind "C-S-h" 'help-command )
(gbind "C-_" 'comment-dwim) ;; TODO: poner esto a funcionar
(gbind "C-S-s" 'save-all-buffers )
(gbind "C-S-q" 'kill-other-buffers ) ; tambien esta clean-buffer-list
(gbind "C-c g" 'prelude-google)
(gbind "C-c t" 'toggle-transparency)
(gbind "C-x b" 'ivy-switch-buffer )


;; the hydra to rule them all buahaha
(defhydra hydra-leader (:color blue :idle 1.0 :hint nil)
  "
actuar como leader en vim :

^Config^       |    ^Buffers^       |  ^Edit^
^^^^^^^^-------------------------------------------------
_rs_: reload   |   _l_: jet-pack    |   _m_: magit
_re_: edit     |   _j_: previous    |   _o_: org
^ ^            |   _k_: next        |   _e_: errores
^ ^            |   _._: terminal    |   _SPC_: execute macro
^ ^            |   _?_: marks       |   _rn_: rename
^ ^            |   ^ ^              |   _s_: search text

"
  ( "rs" reload-emacs-config "reload init" )
  ( "re" open-emacs-config "edit init" )
  ( "l" (lambda ()
          ;; evitar mostrar todos los archivos, en caso de estar fuera
          ;; de un proyecto
          (interactive)
          (if (projectile-project-p)
              (projectile-find-file)
            (ivy-switch-buffer)
            )
          )  "jet pack" )
  ( "s" swiper "swiper" )
  ;;( "." toggle-terminal "terminal" )
  ( "." eshell-new "terminal" )
  ( "e" counsel-flycheck "errores" )

  ;;( "j" previous-buffer "next" )
  ;;( "k" next-buffer "next" )
  ( "j" projectile-next-project-buffer "next" )
  ( "k" projectile-previous-project-buffer "next" )

  ( "SPC" (evil-execute-macro 1 (evil-get-register ?q t) ) "execute macro" )
  ( "m" (magit) "magit" )
  ( "o" (hydra-org/body) "org" )
  ( "rn" lsp-rename "rename")
  ( "?" evil-show-marks "marks")
  )

;; final ------------------------------------------------------

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))

(provide 'init)
;;; init.el ends here
(put 'narrow-to-region 'disabled nil)
