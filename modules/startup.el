;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; Empezar procesos necesarios para el funcionamiento correcto del resto de la configuracion

;;; code:

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

  (setq use-package-verbose nil)
  )

(use-package use-package-ensure-system-package :ensure nil)

(use-package general :demand t)

(use-package hydra :demand t)

(use-package benchmark-init
  :disabled
  :init
  (benchmark-init/activate)
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

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

(use-package seq
  :ensure nil
  )

(use-package transient)

(if (featurep 'elpaca)
    (elpaca-wait))

;;; startup.el ends here
