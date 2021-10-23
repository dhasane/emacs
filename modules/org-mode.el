;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; configuracion de org mode

;;; code:

(use-package org
  :straight (:type built-in)
  :defer .1
  :general
  (org-mode-map
   "C-c c" #'insert-org-mode-src-structure-template
   )
  (org-mode-map
   :states '(normal)
   "RET" 'org-open-at-point
   )
  :hook(
        (org-mode . (lambda ()
                      (progn
                        (make-local-variable 'line-spacing)
                        (make-local-variable 'left-margin-width)
                        (make-local-variable 'right-margin-width)
                        (setq line-spacing 0
                              left-margin-width 2
                              right-margin-width 2

                              )
                        ;; (set-window-buffer nil (current-buffer))
                        )))
        (org-mode . visual-line-mode)
        (org-mode . org-indent-mode)
        )
  :custom-face
  (org-ellipsis ((t (:foreground "red"))))
  (org-block ((t (:inherit fixed-pitch))))
  (org-code ((t (:inherit (shadow fixed-pitch)))))
  (org-document-info ((t (:foreground "dark orange"))))
  (org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
  (org-indent ((t (:inherit (org-hide fixed-pitch)))))
  (org-link ((t (:foreground "royal blue" :underline t))))
  (org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
  ;; (org-property-value ((t (:inherit fixed-pitch))) t)
  (org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
  (org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
  (org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
  (org-verbatim ((t (:inherit (shadow fixed-pitch)))))
  :custom
  ;; ubicacion
  (org-agenda-files '("~/org"))
  (org-default-notes-file (concat org-directory "/capture.org"))

  ;; imagenes
  (org-redisplay-inline-images t)
  (org-startup-with-inline-images "inlineimages")

  ;; code blocks
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-src-preserve-indentation t)
  (org-confirm-babel-evaluate nil)
  (org-edit-src-content-indentation 0)

  ;; organizacion
  (org-startup-indented t)
  ;; org-bullets-bullet-list '(" ") ;; no bullets, needs org-bullets package
  (org-ellipsis (propertize
                 ;; " ↵ "
                 ;; " ⌄ "
                 " ▼ "
                 'font-lock-face '(:foreground "red")))    ; folding symbol
  ;; deja de incluir lineas vacias al final, pero arregla el problema con ellipsis
  (org-cycle-separator-lines -1)

  ;; decoracion
  (org-pretty-entities t)
  (org-hide-emphasis-markers t)
  ;; show actually italicized text instead of /italicized text/
  (org-agenda-block-separator "")
  (org-fontify-whole-heading-line t)
  (org-fontify-done-headline t)
  (org-fontify-quote-and-verse-blocks t)

  (org-startup-truncated nil)
  (org-log-done t)
  :config

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (ruby . t)
     (rust . nil)
     (python . t)
     (sql . t)
     ;; (psql . t)
     ;; (javascript . t)
     ;; (typescript . t)
     (sed . t)
     (awk . t)
     (clojure . t)))

  (defun my/fix-inline-images ()
    (when org-inline-image-overlays
      (org-redisplay-inline-images)))

  (add-hook 'org-babel-after-execute-hook 'my/fix-inline-images)
  (setq-default org-image-actual-width 620)

  (org-display-inline-images t t)
  ;; (setq org-agenda-include-diary t)

  ;; (org-display-inline-images t)

  (defun insert-org-mode-src-structure-template ()
    (interactive)
    (org-insert-structure-template "src")
    )

  ;; (add-to-list 'org-structure-template-alist
             ;; '("s" "#+NAME: ?\n#+BEGIN_SRC \n\n#+END_SRC"))

  ;; (font-lock-add-keywords
  ;;  'org-mode
  ;;  '(("^ +\\([-*]\\) "
  ;;     (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; :custom-face
  ;; (org-level-8 ((t (,@headline ,@variable-tuple))))
  ;; (org-level-7 ((t (,@headline ,@variable-tuple))))
  ;; (org-level-6 ((t (,@headline ,@variable-tuple))))
  ;; (org-level-5 ((t (,@headline ,@variable-tuple))))
  ;; (org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
  ;; (org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
  ;; (org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
  ;; (org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
  ;; (org-document-title ((t (,@headline ,@variable-tuple :height 1.5 :underline nil))))
  )

(defhydra hydra-org (:color blue :columns 3)
  ("a"   org-agenda             "agenda")
  ("l s" org-store-link         "store link")
  ("l i" org-insert-link        "insert link")
  ("o"   org-roam-buffer-toggle "roam")
  ("f"   org-roam-node-find     "find")
  ("i"   org-roam-node-insert   "insert")
  ("m"   org-roam-graph         "map")
  ("k"   kill-org-buffers       "kill")
  )
;; (defhydra hydra-org (:color red :columns 3)
;;   "Org Mode Movements"
;;   ("a" org-agenda "agenda")
;;   ("l" org-store-link "store link")
;;   ("n" outline-next-visible-heading "next heading")
;;   ("p" outline-previous-visible-heading "prev heading")
;;   ("N" org-forward-heading-same-level "next heading at same level")
;;   ("P" org-backward-heading-same-level "prev heading at same level")
;;   ("u" outline-up-heading "up heading")
;;   ("g" org-goto "goto" :exit t) ;; y esto como que no sirve :v
;;   )

(use-package org-roam
  :delight
  :hook
  (after-init . org-roam-mode)
  :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n g" . org-roam-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))
              (("C-c n I" . org-roam-insert-immediate)))
  :custom
  (org-roam-directory "~/org")
  (org-roam-graph-viewer #'eww-open-file)
  (org-roam-graph-executable ;; requiere graphviz
   ;; "dot" ;; esto es el default
   ;; "neato"
   "fdp" ;; compacto y no sobrelapa
   ;; "twopi"
   ;; "circo"
   )
  :init
  (setq org-roam-v2-ack t)
  (org-roam-db-autosync-mode)
  )

;; (defhydra hydra-roam
;;   (:color blue)
;;   ("o" org-roam           "roam")
;;   ("f" org-roam-find-file "find")
;;   ("i" org-roam-insert    "insert")
;;   ("m" org-roam-graph     "map")
;;   )

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

(use-package org-bullets
  ;; :commands org-bullets-mode
  :hook (org-mode . org-bullets-mode))

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
            ;; (evil-leader/set-key-for-mode 'org-mode
            ;;                               "." 'hydra-org-state/body
            ;;                               "t" 'org-todo
            ;;                               "T" 'org-show-todo-tree
            ;;                               "v" 'org-mark-element
            ;;                               "a" 'org-agenda
            ;;                               "c" 'org-archive-subtree
            ;;                               "l" 'evil-org-open-links
            ;;                               "C" 'org-resolve-clocks)

            )
          )

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
  ("t" org-todo))

;;; org-mode ends here
