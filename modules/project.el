
;;; Code:

;; Projectile
(use-package projectile
  :ensure t
  :defer .1
  :bind
  (
   :map
   projectile-mode-map
   ("M-p" . 'projectile-command-map)
   )
  :init
  (setq projectile-require-project-root nil)
  :config
  (projectile-mode +1)
  ;; (setq projectile-project-search-path '("~/projects/" "~/work/"))
  (setq projectile-project-search-path '("~/dev/"))
  (setq projectile-sort-order 'recently-active)
  (setq projectile-completion-system 'ivy)
  )

(use-package flycheck
	:ensure t
	:config
	(add-hook 'after-init-hook #'global-flycheck-mode)
	)

;; eliminar espacios al final de una linea
;; (add-hook 'before-save-hook 'delete-trailing-whitespace)
(use-package ws-butler
  :ensure t
  :defer .1
  :hook (
         (prog-mode . ws-butler-mode)
         )
  )

;; tramp ---------------------------------------------------

(use-package tramp
  :defer t
  :config
  (setq tramp-default-method "ssh")
  )
