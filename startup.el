;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; Empezar procesos necesarios para el funcionamiento correcto del resto de la configuracion

;;; code:

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

;; (load "server")
;; (unless (server-running-p) (server-start))

(setq file-name-handler-alist nil)

;; tambien funciona con emacs-ng
;; (unless (fboundp 'ng-bootstrap-straight)
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
    (load bootstrap-file nil 'nomessage)) ;; )

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

(custom-set-variables '(load-prefer-newer nil))
(use-package auto-compile
  :defer nil
  :config (auto-compile-on-load-mode))

(use-package gcmh
  :delight
  :init
  (gcmh-mode 1)
  :custom
  (gcmh-verbose t)
  )

(use-package delight)

(use-package no-littering
  :demand
  :config
  (require 'recentf)
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)
  :custom
  (auto-save-file-name-transforms
   `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  )

;;; startup.el ends here
