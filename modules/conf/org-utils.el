;;; org-utils.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Org mode extras and utilities

;;; code:

;; (use-package flyspell-mode
;;   :hook (org-mode . flyspell-mode)
;;   )

(use-package org-appear
  :hook ((org-mode . (lambda ()
                       (add-hook 'evil-insert-state-entry-hook
                                 (lambda ()
                                   (org-appear-mode 1)
                                   (org-appear-manual-start))
                                 nil
                                 t)
                       (add-hook 'evil-insert-state-exit-hook
                                 (lambda ()
                                   (org-appear-manual-stop)
                                   (org-appear-mode -1))
                                 nil
                                 t))))
  :custom
  (org-appear-autolinks t)
  (org-appear-trigger 'manual)
  )

(use-package poly-org
  :disabled
  :after (polymode org)
  :hook (org-mode . poly-org-mode)
  ;; :config
  ;; (add-to-list 'auto-mode-alist '("\\.org" . poly-org))
  )

(use-package babel
  :after org
  :commands (babel-mode))

(use-package evil-org
  :delight
  :after (org evil)
  :general
  (
   :states 'normal
   :keymaps 'org-mode-map
   "C-k" 'evil-window-up
   "C-j" 'evil-window-down
   )
  :hook (org-mode . evil-org-mode)
  :config
  ;; (setf evil-org-key-theme '(navigation insert textobjects additional))
  ;; (evil-org-agenda-set-keys)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys)

  (evil-org-set-key-theme '(textobjects insert navigation additional shift todo heading))


  (add-hook 'org-mode-hook
            (lambda ()
              (evil-org-mode)

              ;; Custom mappings
              (evil-define-key 'normal evil-org-mode-map
                (kbd "-") 'org-ctrl-c-minus
                (kbd "|") 'org-table-goto-column
                (kbd "M-o") (evil-org-define-eol-command org-insert-heading)
                (kbd "M-t") (evil-org-define-eol-command org-insert-todo))
              )

            )
          )

(use-package org-bullets
  ;; :commands org-bullets-mode
  :hook (org-mode . org-bullets-mode))

(use-package org-download
  :hook
  (org-mode . org-download-enable)
  :custom
  (org-download-image-dir "~/org/imagenes")
  :general
  (dahas-org-map
   "p"  '(:ignore t :which-key "paste")
   "pi" '(org-download-clipboard :wk "paste image")
   "pt" '(org-toggle-inline-images :wk "toggle inline image")
   )
  )

;; Define a transient state for quick navigation
;; (defhydra hydra-org-state ()
;;   ;; basic navigation
;;   ("i" org-cycle)
;;   ("I" org-shifttab)
;;   ("h" org-up-element)
;;   ("l" org-down-element)
;;   ("j" org-forward-element)
;;   ("k" org-backward-element)
;;   ;; navigating links
;;   ("n" org-next-link)
;;   ("p" org-previous-link)
;;   ("o" org-open-at-point)
;;   ;; navigation blocks
;;   ("N" org-next-block)
;;   ("P" org-previous-block)
;;   ;; updates
;;   ("." org-ctrl-c-ctrl-c)
;;   ("*" org-ctrl-c-star)
;;   ("-" org-ctrl-c-minus)
;;   ;; change todo state
;;   ("H" org-shiftleft)
;;   ("L" org-shiftright)
;;   ("J" org-shiftdown)
;;   ("K" org-shiftup)
;;   ("t" org-todo))

(use-package polymode
  :disabled
  :mode ("\\.md\\'" "\\.org\\'" )
  :config
  ;; (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
  ;; (setq polymode-prefix-key (kbd "C-c n"))
  ;; (define-hostmode poly-python-hostmode :mode 'python-mode)
  )

;;; org-utils.el ends here
