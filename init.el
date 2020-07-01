;;; package --- summary:

;; EEEEEEEEEEEEEEEEEEEEEE                                                                                ;;
;; E::::::::::::::::::::E                                                                                ;;
;; E::::::::::::::::::::E                                                                                ;;
;; EE::::::EEEEEEEEE::::E                                                                                ;;
;;   E:::::E       EEEEEE   mmmmmmm    mmmmmmm     aaaaaaaaaaaaa      cccccccccccccccc    ssssssssss     ;;
;;   E:::::E              mm:::::::m  m:::::::mm   a::::::::::::a   cc:::::::::::::::c  ss::::::::::s    ;;
;;   E::::::EEEEEEEEEE   m::::::::::mm::::::::::m  aaaaaaaaa:::::a c:::::::::::::::::css:::::::::::::s   ;;
;;   E:::::::::::::::E   m::::::::::::::::::::::m           a::::ac:::::::cccccc:::::cs::::::ssss:::::s  ;;
;;   E:::::::::::::::E   m:::::mmm::::::mmm:::::m    aaaaaaa:::::ac::::::c     ccccccc s:::::s  ssssss   ;;
;;   E::::::EEEEEEEEEE   m::::m   m::::m   m::::m  aa::::::::::::ac:::::c                s::::::s        ;;
;;   E:::::E             m::::m   m::::m   m::::m a::::aaaa::::::ac:::::c                   s::::::s     ;;
;;   E:::::E       EEEEEEm::::m   m::::m   m::::ma::::a    a:::::ac::::::c     cccccccssssss   s:::::s   ;;
;; EE::::::EEEEEEEE:::::Em::::m   m::::m   m::::ma::::a    a:::::ac:::::::cccccc:::::cs:::::ssss::::::s  ;;
;; E::::::::::::::::::::Em::::m   m::::m   m::::ma:::::aaaa::::::a c:::::::::::::::::cs::::::::::::::s   ;;
;; E::::::::::::::::::::Em::::m   m::::m   m::::m a::::::::::aa:::a cc:::::::::::::::c s:::::::::::ss    ;;
;; EEEEEEEEEEEEEEEEEEEEEEmmmmmm   mmmmmm   mmmmmm  aaaaaaaaaa  aaaa   cccccccccccccccc  sssssssssss      ;;

;;; Commentary:

;; configuracion de Emacs asi como bien pro

;;; code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
	 '("e1d09f1b2afc2fed6feb1d672be5ec6ae61f84e058cb757689edb669be926896" "aded61687237d1dff6325edb492bde536f40b048eab7246c61d5c6643c696b7f" "4cf9ed30ea575fb0ca3cff6ef34b1b87192965245776afa9e9e20c17d115f3fb" "939ea070fb0141cd035608b2baabc4bd50d8ecc86af8528df9d41f4d83664c6a" default))
 '(git-gutter:window-width 1)
 '(minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))
 '(package-selected-packages
	 '(robe readline-complete company-quickhelp flycheck-kotlin kotlin-mode eshell-z inf-ruby solargraph rust-mode company-box lsp-dart lsp-python-ms ws-butler which-key dap-java counsel ivy evil-collection pdf-tools evil-org evil-magit eyebrowse git-gutter company-lsp
					(evil use-package hydra bind-key)
					name lsp-java ccls magit gruvbox-theme fzf flycheck evil))
 '(setq 1 t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-goggles-change-face ((t (:inherit diff-removed))))
 '(evil-goggles-delete-face ((t (:inherit diff-removed))))
 '(evil-goggles-paste-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-add-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-change-face ((t (:inherit diff-changed))))
 '(evil-goggles-undo-redo-remove-face ((t (:inherit diff-removed))))
 '(evil-goggles-yank-face ((t (:inherit diff-changed)))))

;; init ----------------------------------------------------

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

;;; Inicio configuracion

(server-start)

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
(setq use-package-compute-statistics t)

(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

(defconst config-module-dir "~/.emacs.d/modules/"
  "Directorio de modulos de configuracion.")

(defun load-config-module (filelist)
  "Cargar un archivo de configuracion a partir del FILELIST."
  (dolist (file filelist)
    (load (expand-file-name
           (concat config-module-dir file)))
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
;;(make-config-file :name "basic" :load 1)

(defun load-config ()
  "Cargar los archivos de configuracion."
  (interactive)
  (load-config-module
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

(gbind "C-M-h" 'help-menu )
(gbind "C-S-h" 'help-command )
(gbind "C-_" 'comment-dwim) ;; TODO: poner esto a funcionar
(gbind "C-S-s" 'save-all-buffers )
(gbind "C-S-q" 'kill-other-buffers ) ; tambien esta clean-buffer-list
(gbind "C-c g" 'prelude-google)
(gbind "C-c t" 'toggle-transparency)

(defhydra hydra-leader (:color blue :idle 1.0 :hint nil)
  "
actuar como leader en vim :

^Config^       |    ^Buffers^       |  ^Edit^
^^^^^^^^-------------------------------------------------
_rs_: reload   |   _l_: jet-pack    |   _m_: magit
_re_: edit     |   _j_: previous    |   _o_: org
^ ^            |   _k_: next        |   _e_: errores
^ ^            |   _._: terminal    |   _SPC_: execute macro
^ ^            |   _b_: all buffers |   _t_: tree
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
  ( "b" ivy-switch-buffer "buffer list" )
  ( "s" swiper "swiper" )
  ( "." toggle-terminal "terminal" )
  ( "e" counsel-flycheck "errores" )

  ;;( "j" previous-buffer "next" )
  ;;( "k" next-buffer "next" )
  ( "j" projectile-next-project-buffer "next" )
  ( "k" projectile-previous-project-buffer "next" )

  ( "SPC" (evil-execute-macro 1 (evil-get-register ?q t) ) "execute macro" )
  ( "m" (magit) "magit" )
  ( "o" (hydra-org/body) "org" )
  ( "t" #'treemacs "tree" )
  ( "rn" lsp-rename "rename")
  ( "?" evil-show-marks "marks")
  )

;; otros/mover ------------------------------------------------

(setq custom-tab-width 2)

(defun disable-tabs ()
  (interactive)
  (setq indent-tabs-mode nil))
(defun enable-tabs  ()
  (interactive)
  (local-set-key (kbd "TAB") 'tab-to-tab-stop)
  (setq indent-tabs-mode t)
  (setq tab-width custom-tab-width))
(enable-tabs)

;;(local-set-key (kbd "TAB") 'tab-to-tab-stop)
;;(setq indent-tabs-mode t)
;;(setq tab-width custom-tab-width))

;; redefinir mappings de evil
;; (with-eval-after-load 'evil-maps
;; )

;; final ------------------------------------------------------

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))

(provide 'init)
;;; init.el ends here
