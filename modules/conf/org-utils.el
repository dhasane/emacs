;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;; Paquetes adicionales para org

;;; code:

;; (use-package flyspell-mode
;;   :hook (org-mode . flyspell-mode)
;;   )

(use-package ispell
  :elpaca nil
  :disabled
  :config
  ;; Configure `LANG`, otherwise ispell.el cannot find a 'default
  ;; dictionary' even though multiple dictionaries will be configured
  ;; in next line.
  ;; (setenv "LANG" "en_US.UTF-8")

  ;; ispell-set-spellchecker-params has to be called
  ;; before ispell-hunspell-add-multi-dic will work
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_US,es_ES")

  ;; The personal dictionary file has to exist, otherwise hunspell will
  ;; silently not use it.
  (unless (file-exists-p ispell-personal-dictionary)
    (write-region "" nil ispell-personal-dictionary nil 0))

  :custom
  (ispell-program-name "hunspell")
  ;; Configure German, Swiss German, and two variants of English.
  (ispell-dictionary "de_DE,de_CH,en_GB,en_US")
  ;; For saving words to the personal dictionary, don't infer it from
  ;; the locale, otherwise it would save to ~/.hunspell_de_DE.
  (ispell-personal-dictionary "~/.hunspell_personal")
  )

(use-package poly-org
  :disabled
  :after (polymode org)
  :hook (org-mode . poly-org-mode)
  ;; :config
  ;; (add-to-list 'auto-mode-alist '("\\.org" . poly-org))
  )

(use-package babel
  ;; :hook (org-mode . babel-mode)
  :config
  )

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

;;; org-utils.el ends here
