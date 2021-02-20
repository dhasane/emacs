;;; package --- Summary
;; -*- lexical-binding: t -*-

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
;; (setq gc-cons-threshold (* 50 1000 1000))
(setq gc-cons-threshold most-positive-fixnum)

;;; init ----------------------------------------------------
;;; Inicio configuracion

;; (load "server")
;; (unless (server-running-p) (server-start))

(setq file-name-handler-alist nil)

;; carpeta especifica para cada una de las versiones
;; en caso de haber diferencias mayores
;; (format "~/.emacs.d/elpa-%d" emacs-major-version)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file)

(require 'package)
(setq
 package-archives
 '(
   ("melpa"         . "https://melpa.org/packages/")
   ("melpa-stable"  . "http://stable.melpa.org/packages/")
   ("elpa"          . "https://elpa.gnu.org/packages/")
   ("gnu"           . "http://elpa.gnu.org/packages/")
   )
 package-archive-priorities
 '(
   ("melpa"         . 15)
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

(eval-and-compile
  ;; siempre instalar lo que no se tenga
  (setq use-package-always-ensure t)
  ;; siempre diferir el inicio de paquetes
  (setq use-package-always-defer t)
  ;; (setq use-package-expand-minimally t)
  ;; t para verificar tiempos de carga
  (setq use-package-compute-statistics t)
  (setq use-package-enable-imenu-support t)
  )

(use-package use-package-ensure-system-package)
(use-package general :demand t)
(use-package hydra :ensure t :demand t)
(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

(use-package auto-package-update
  :if (not (daemonp))
  :custom
  (auto-package-update-interval 7) ;; in days
  (auto-package-update-prompt-before-update t)
  (auto-package-update-delete-old-versions t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe))

(load (expand-file-name "compile" user-emacs-directory))

;; (auto-comp-init)

(defconst config-module-dir (expand-file-name "modules/" user-emacs-directory)
  "Directorio de modulos de configuracion.")

(defconst config-lang-dir (expand-file-name "langs/" user-emacs-directory)
  "Directorio de modulos de configuracion para lenguajes.")

(defconst custom-elisp-dir (expand-file-name "lisp/" user-emacs-directory)
  "Directorio de modulos de LISP.")

;; load config
(comp-load-folder config-module-dir
                  :ignorar '("fira-code")
                  :compilar '("basic" "evil" "org-mode" "project" "ivy" "completion")
                  )

(comp-load-folder config-lang-dir)

;; (comp-load-folder custom-elisp-dir
;;                          ;; :compile t
;;                          )

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(general-define-key
 :keymaps 'override
 "C-+"   'text-scale-increase
 "C--"   'text-scale-decrease
 "C-S-h" 'help-command
 "C-S-s" 'save-all-buffers
 "C-S-q" 'kill-other-buffers ; tambien esta clean-buffer-list
 )

(general-define-key
 :prefix "C-x"
 "b" 'ivy-switch-buffer
 )

(general-define-key
 :prefix "C-c"
 "g" 'prelude-google
 "t" 'toggle-transparency
 )

(general-define-key
 :keymaps 'override
 :prefix "<SPC>"
 :non-normal-prefix "<M-SPC>"
 :states 'normal
 "e" 'counsel-find-file
 ;; "b" 'switch-to-buffer
 "b" 'bufler-switch-buffer
 "k" 'kill-buffer
 "w" 'evil-window-map
 "t" 'hydra-tabs/body
 "s" 'swiper
 "j" 'prev-user-buffer-ring
 "k" 'next-user-buffer-ring
 "y" 'ivy-yasnippet
 "l" #'(lambda ()
         (interactive)
         (if (projectile-project-p)
             (counsel-projectile-find-file)
           (call-interactively 'counsel-find-file)
           )
         )  ;; "jet pack"
 "o" 'hydra-org/body
 )

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
          (interactive)
          (if (projectile-project-p)
              (counsel-projectile-find-file)
            (call-interactively 'counsel-find-file)
            )
          )  "jet pack" )
  ( "s" swiper "swiper" )
  ;;( "." toggle-terminal "terminal" )
  ;; ( "." eshell-new "terminal" )
  ( "." (dh/open-create-eshell-buffer) "terminal" )
  ( "e" counsel-flycheck "errores" )

  ;;( "j" previous-buffer "next" )
  ;;( "k" next-buffer "next" )
  ( "j" (prev-user-buffer-ring) "prev" )
  ( "k" (next-user-buffer-ring) "next" )

  ( "SPC" (evil-execute-macro 1 (evil-get-register ?q t)) "execute macro" )
  ( "m" (magit) "magit" )
  ( "o" (hydra-org/body) "org" )
  ( "rn" lsp-rename "rename")
  ( "?" evil-show-marks "marks")
  ( "t" treemacs "tree")
  )

;; final ------------------------------------------------------

(put 'narrow-to-region 'disabled nil)

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold 100000000) ;; 100 mb

(provide 'init)
;;; init.el ends here
