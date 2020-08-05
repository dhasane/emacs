
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

(global-set-key (kbd "<f5>")
                (lambda ()
                  (interactive)
                  (setq-local compilation-read-command nil)
                  (call-interactively 'compile)))

(setq gdb-many-windows t ;; use gdb-many-windows by default
      gdb-show-main t    ;; Non-nil means display source file containing the main routine at startup
 )

(use-package skeletor

  :config
  (setq skeletor-project-directory "~/dev")
  )
