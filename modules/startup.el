;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; Empezar procesos necesarios para el funcionamiento correcto del resto de la configuracion

;;; code:

(setq file-name-handler-alist nil)

(eval-when-compile (require 'use-package))

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
  :disabled t
  :defer nil
  :config (auto-compile-on-load-mode))

(use-package gcmh
  :delight
  :init
  (gcmh-mode 1)
  :custom
  (gcmh-verbose nil)
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

(if (featurep 'elpaca)
    (elpaca-wait))

;; TODO: revisar si se puede definiendo un nuevo keybind map

(defhydra hydra-tabs ( global-map "C-SPC" :color blue :idle 1.0 )
  "Tab management"
  )

(defhydra hydra-search ( :color blue :idle 1.0 )
  "Search functions"
  )

(defhydra hydra-lsp ( :color blue :idle 1.0 )
  "lsp"
  )

(defhydra hydra-org (:color blue)
  "Org"
  )

(defhydra hydra-manage (:color blue)
  "Manage"
  )

;;; startup.el ends here
