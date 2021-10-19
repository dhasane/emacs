;;; package --- Summary  -*- lexical-binding: t; -*-

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

;; tambien funciona con emacs-ng
(unless (fboundp 'ng-bootstrap-straight)
  (defvar bootstrap-version)
  (let ((bootstrap-file
         (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
        (bootstrap-version 5))
    (unless (file-exists-p bootstrap-file)
      (with-current-buffer
          (url-retrieve-synchronously
           "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
           'silent 'inhibit-cookies)
        (goto-char (point-max))
        (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage)))

(straight-use-package 'el-patch)
(straight-use-package 'use-package)

(eval-when-compile (require 'use-package))

(use-package straight
  :custom (straight-use-package-by-default t))

(eval-and-compile
  ;; siempre instalar lo que no se tenga
  (setq use-package-always-ensure nil)
  ;; siempre diferir el inicio de paquetes
  (setq use-package-always-defer t)
  ;; (setq use-package-expand-minimally t)
  ;; t para verificar tiempos de carga
  (setq use-package-compute-statistics t)
  (setq use-package-enable-imenu-support t)

  (setq use-package-verbose nil)
  )

(use-package use-package-ensure-system-package)
(use-package general :demand t)
(use-package hydra :demand t)
(use-package benchmark-init
  :disabled
  :init
  (benchmark-init/activate)
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

(use-package delight)

(setq package-native-compile t)
(load (expand-file-name "compile" user-emacs-directory))

(custom-set-variables '(load-prefer-newer nil))
(use-package auto-compile
  :defer nil
  :config (auto-compile-on-load-mode))

(use-package gcmh
  :init
  (gcmh-mode 1)
  :custom
  (gcmh-verbose t)
  )

;; (load "server")
;; (let ((dh/server-name  "emacs_server"))
  ;; (use-package server
    ;; :custom
    ;; (server-name dh/server-name)
    ;; ;; :init
    ;; ;; (unless
    ;; ;;     (server-running-p dh/server-name)
    ;; ;;   (server-start dh/server-name))
    ;; )
  ;; )

;; (auto-comp-init)

(defconst config-module-dir (expand-file-name "modules/" user-emacs-directory)
  "Directorio de modulos de configuracion.")

(defconst config-lang-dir (expand-file-name "langs/" user-emacs-directory)
  "Directorio de modulos de configuracion para lenguajes.")

(defconst custom-elisp-dir (expand-file-name "lisp/" user-emacs-directory)
  "Directorio de modulos de LISP.")

;; (if (native-comp-available-p)
;;     (progn
;;       (mapc (lambda (dir)
;;               (native-compile-async (expand-file-name dir user-emacs-directory) 'recursively))
;;             '(
;;               "modules/"
;;               "langs/"
;;               "elpa/"
;;               )
;;             )
;;       )
;;   (message "no hay native comp disponible")
;;   )

;; load config
(comp-load-folder config-module-dir
				  :ignorar '("fira-code")
				  ;; :compilar '("basic" "evil" "org-mode" "project" "completion")
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
 "M-/"   'comment-dwim
 )

(general-define-key
 :prefix "C-x"
 "b" 'switch-to-buffer
 )

(general-define-key
 :prefix "C-c"
 "g" 'prelude-google
 "t" 'toggle-transparency
 )

(defun dh/jet-pack ()
  "Saltar a cualquier parte del proyecto."
  (interactive)
  (if (projectile-project-p)
      (call-interactively 'project-find-file)
    (call-interactively 'find-file)
    )
  )

(general-define-key
 :keymaps 'override
 :prefix "<SPC>"
 :non-normal-prefix "<M-SPC>"
 :states 'normal

 [tab] 'hydra-tabs/body
 "TAB" 'hydra-tabs/body

 ;; "k" 'kill-buffer
 "t" 'treemacs ; "tree"

 ;; general
 "b" 'switch-to-buffer
 "o" 'hydra-org/body
 "g" 'magit
 "w" 'evil-window-map
 "y" 'yas-insert-snippet

 ;; buscar
 "ss" 'consult-line
 "sg" 'consult-git-grep
 "si" 'consult-imenu

 ;; evito poner shift para @
 ;; "q" (lambda () (evil-execute-macro 1 (evil-get-register ?q t))) ; ; ; "execute macro"
 ;; "2" '(lambda () (interactive) (call-interactively 'evil-execute-macro))
 "2" '(lambda () (interactive) (call-interactively 'evil-owl-execute-macro))
 ;; "?" #'evil-show-marks ; "marks"

 ;; eshell
 "." 'dh/create-new-eshell-buffer       ; "terminal"
 "," 'dh/select-eshell                  ; "seleccionar terminal"

 ;; move to files
 "e" 'find-file                         ; buscar solo en el mismo directorio
 "E" 'dh/jet-pack                       ; buscar en todo el proyecto

 ;; TODO: arreglar esto
 ;; "j" 'prev-user-buffer-ring
 ;; "k" 'next-user-buffer-ring

 ;; lsp
 "rn" 'lsp-rename                       ; "rename"
 "pd" 'lsp-ui-peek-find-definitions
 "pr" 'lsp-ui-peek-find-references
 "pm" 'lsp-ui-imenu
 "pe" 'consult-flycheck                 ; "errores"

 ;; emacs
 "'rs" 'reload-emacs-config             ; "reload init"
 "'e"  'open-emacs-config               ; "edit init"
 "'ps" 'profiler-start
 "'pS" 'profiler-stop
 "'pr" 'profiler-report
 "'s"  'proced
 )
;; the hydra to rule them all buahaha
;; (defhydra hydra-leader (:color blue :idle 1.0 :hint nil)
;;   "
;; actuar como leader en vim :
;;
;; ^Config^       |    ^Buffers^       |  ^Edit^
;; ^^^^^^^^-------------------------------------------------
;; _rs_: reload   |   _l_: jet-pack    |   _m_: magit
;; _re_: edit     |   _j_: previous    |   _o_: org
;; ^ ^            |   _k_: next        |   _e_: errores
;; ^ ^            |   _._: terminal    |   _SPC_: execute macro
;; ^ ^            |   _?_: marks       |   _rn_: rename
;; ^ ^            |   ^ ^              |   _s_: search text
;;
;; "
;;   ( "rs" reload-emacs-config "reload init" )
;;   ( "re" open-emacs-config "edit init" )
;;   ( "l" #'dh/jet-pack  "jet pack" )
;;   ( "s" swiper "swiper" )
;;   ;;( "." toggle-terminal "terminal" )
;;   ;; ( "." eshell-new "terminal" )
;;   ;; ( "." (dh/open-create-eshell-buffer) "terminal" )
;;   ( "." (dh/create-new-eshell-buffer) "terminal" )
;;   ( "/" (dh/select-eshell) "seleccionar terminal" )
;;   ( "e" counsel-flycheck "errores" )
;;
;;   ;;( "j" previous-buffer "next" )
;;   ;;( "k" next-buffer "next" )
;;   ( "j" (prev-user-buffer-ring) "prev" )
;;   ( "k" (next-user-buffer-ring) "next" )
;;
;;   ( "SPC" (evil-execute-macro 1 (evil-get-register ?q t)) "execute macro" )
;;   ( "m" (magit) "magit" )
;;   ( "o" (hydra-org/body) "org" )
;;   ( "rn" lsp-rename "rename")
;;   ( "?" evil-show-marks "marks")
;;   ( "t" treemacs "tree")
;;   )

;; final ------------------------------------------------------

(put 'narrow-to-region 'disabled nil)

;; Make gc pauses faster by decreasing the threshold.
;; (setq gc-cons-threshold 100000000) ;; 100 mb

(provide 'init)
;;; init.el ends here
