

;; org mode ------------------------------------------------
;;; code:

(use-package org
  :ensure t
  :defer .1
  :config
  (setq org-log-done t)

  (setq org-agenda-files '("~/org"))
  ;; (setq org-agenda-files
        ;; '(
          ;; "~/org/work.org"
          ;; "~/org/school.org"
          ;; "~/org/home.org"
          ;; )
        ;; )
  )

(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys)

  (evil-org-set-key-theme '(textobjects insert navigation additional shift todo heading))
  )

;; (setf evil-org-key-theme '(navigation insert textobjects additional))
(setf org-special-ctrl-a/e t)
;; (evil-org-agenda-set-keys)

(add-hook 'org-mode-hook
          (lambda ()
            (evil-org-mode)

            ;; Custom mappings
            (evil-define-key 'normal evil-org-mode-map
              (kbd "-") 'org-ctrl-c-minus
              (kbd "|") 'org-table-goto-column
              (kbd "M-o") (evil-org-define-eol-command org-insert-heading)
              (kbd "M-t") (evil-org-define-eol-command org-insert-todo))

            ;; Configure leader key
            (evil-leader/set-key-for-mode 'org-mode
                                          "." 'hydra-org-state/body
                                          "t" 'org-todo
                                          "T" 'org-show-todo-tree
                                          "v" 'org-mark-element
                                          "a" 'org-agenda
                                          "c" 'org-archive-subtree
                                          "l" 'evil-org-open-links
                                          "C" 'org-resolve-clocks)

            ;; Define a transient state for quick navigation
            (defhydra hydra-org-state ()
              ;; basic navigation
              ("i" org-cycle)
              ("I" org-shifttab)
              ("h" org-up-element)
              ("l" org-down-element)
              ("j" org-forward-element)
              ("k" org-backward-element)
              ;; navigating links
              ("n" org-next-link)
              ("p" org-previous-link)
              ("o" org-open-at-point)
              ;; navigation blocks
              ("N" org-next-block)
              ("P" org-previous-block)
              ;; updates
              ("." org-ctrl-c-ctrl-c)
              ("*" org-ctrl-c-star)
              ("-" org-ctrl-c-minus)
              ;; change todo state
              ("H" org-shiftleft)
              ("L" org-shiftright)
              ("J" org-shiftdown)
              ("K" org-shiftup)
              ("t" org-todo)))
          )

