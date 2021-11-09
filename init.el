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

(defun reql (file)
  "Load FILE relative to 'user-emacs-directory'."
  (load (expand-file-name file user-emacs-directory)))

(reql "startup")

(setq package-native-compile t)
(reql "compile")

(defconst config-module-dir (expand-file-name "modules/" user-emacs-directory)
  "Directorio de modulos de configuracion.")

(defconst config-lang-dir (expand-file-name "langs/" user-emacs-directory)
  "Directorio de modulos de configuracion para lenguajes.")

(defconst custom-elisp-dir (expand-file-name "lisp/" user-emacs-directory)
  "Directorio de modulos de LISP.")

;; load config
(comp-load-folder config-module-dir
				  :ignorar '("fira-code")
				  ;; :compilar '("basic" "evil" "org-mode" "project" "completion")
				  )

(comp-load-folder config-lang-dir)

;; (comp-load-folder custom-elisp-dir
;;                          ;; :compile t
;;                          )

(reql "keybinds")

;; final ------------------------------------------------------

(put 'narrow-to-region 'disabled nil)

;; Make gc pauses faster by decreasing the threshold.
;; (setq gc-cons-threshold 100000000) ;; 100 mb

(provide 'init)
;;; init.el ends here
