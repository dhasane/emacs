;;; org-utils.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Org mode extras and utilities

;;; code:

;; (use-package flyspell-mode
;;   :hook (org-mode . flyspell-mode)
;;   )

(use-package org-appear
  ;; :hook ((org-mode . org-appear)
  ;;        ;; (org-mode . (lambda ()
  ;;        ;;               (add-hook 'evil-insert-state-entry-hook
  ;;        ;;                         #'org-appear-manual-start
  ;;        ;;                         nil
  ;;        ;;                         t)
  ;;        ;;               (add-hook 'evil-insert-state-exit-hook
  ;;        ;;                         #'org-appear-manual-stop
  ;;        ;;                         nil
  ;;        ;;                         t)))
  ;;        )
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autolinks t)
  (org-appear-trigger 'always)
  ;; (org-appear-trigger 'manual)
  ;; :config
  ;; (add-hook 'org-mode-hook (lambda ()
  ;;                            (add-hook 'evil-insert-state-entry-hook
  ;;                                      #'org-appear-manual-start
  ;;                                      nil
  ;;                                      t)
  ;;                            (add-hook 'evil-insert-state-exit-hook
  ;;                                      #'org-appear-manual-stop
  ;;                                      nil
  ;;                                      t)))
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

(use-package olivetti
  :disabled t
  :hook (org-mode . olivetti-mode)
  :custom
  (olivetti-body-width 0.65)
  (olivetty-minimum-body-width 100)
  (olivetty-body-width 100)
  (olivetty-style t)
  :custom-face
  (olivetti-fringe ((t (:background "#504945" :foreground "#fdf4c2"))))
  )

(use-package darkroom
  :disabled t
  :hook (org-mode . darkroom-tentative-mode)
  :custom
  (darkroom-text-scale-increase 0)
  (darkroom-fringes-outside-margins 2)
  (darkroom-margins 'darkroom-guess-margins)

  :config
  (setq darkroom-disable-mode-line nil)

  (defun darkroom--enter (&optional just-margins)
    "Save current state and enter darkroom for the current buffer.
With optional JUST-MARGINS, just set the margins."
    (unless just-margins
      (setq darkroom--saved-state
            (mapcar #'(lambda (sym)
                        (cons sym (buffer-local-value sym (current-buffer))))
                    darkroom--saved-variables))
      (if darkroom-disable-mode-line
          (setq mode-line-format nil)
          )
      (setq header-line-format nil
            fringes-outside-margins darkroom-fringes-outside-margins)
      (text-scale-increase darkroom-text-scale-increase))
    (mapc #'(lambda (w)
              (with-selected-window w
                (darkroom--set-margins)))
          (get-buffer-window-list (current-buffer))))
  )

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
