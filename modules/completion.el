;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package flycheck
  :demand t
  ;; :hook (prog-mode . flycheck-mode)
  :init (global-flycheck-mode)

  :custom
  (flycheck-check-syntax-automatically
   '(
	 ;; save
	 idle-change
	 idle-buffer-switch
	 mode-enabled
	 ))
  (flycheck-idle-change-delay 2)
  (flycheck-idle-buffer-switch-delay 2)
  ;; :config
  ;; (add-hook 'after-init-hook #'global-flycheck-mode)
  )

(use-package yasnippet
  :demand t
  :defer .1
  :defines
  (
   yas-reload-all
  )
  :hook ((prog-mode org-mode text-mode) . yas-minor-mode)
  :general
  (yas-minor-mode-map
   "TAB" nil
   "<tab>" nil
   )
  ;; :config
  ;; (yas-global-mode 1)

  )

(use-package yasnippet-snippets
  :demand t
  :after yasnippet
  :defines
  (yas-reload-all)
  :config
  (yas-reload-all)
  )
