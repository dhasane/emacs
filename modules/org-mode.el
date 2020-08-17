

;; org mode ------------------------------------------------
;;; code:

(use-package org
  :ensure t
  :defer .1
  :after general
  :general
  (:keymap 'org-mode-map
           "C-c c" (lambda ()
                     (interactive)(org-insert-structure-template "src"))
   )
  :hook(
		(org-mode .

		 (lambda ()
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
        (org-mode-hook . visual-line-mode)

		)
  :config

  ;; (add-to-list 'org-structure-template-alist
             ;; '("s" "#+NAME: ?\n#+BEGIN_SRC \n\n#+END_SRC"))



  (custom-theme-set-faces
   'user
   '(org-block ((t (:inherit fixed-pitch))))
   '(org-code ((t (:inherit (shadow fixed-pitch)))))
   '(org-document-info ((t (:foreground "dark orange"))))
   '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
   '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
   '(org-link ((t (:foreground "royal blue" :underline t))))
   '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-property-value ((t (:inherit fixed-pitch))) t)
   '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
   '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
   '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

  (setq org-startup-indented t
        org-src-tab-acts-natively t
		;; org-bullets-bullet-list '(" ") ;; no bullets, needs org-bullets package
		org-ellipsis "  " ;; folding symbol
		org-pretty-entities t
		org-hide-emphasis-markers t
		;; show actually italicized text instead of /italicized text/
		org-agenda-block-separator ""
		org-fontify-whole-heading-line t
		org-fontify-done-headline t
		org-fontify-quote-and-verse-blocks t
		)


  (setq org-log-done t)

  (setq org-agenda-files '("~/org"))
  ;; (setq org-agenda-files
        ;; '(
          ;; "~/org/work.org"
          ;; "~/org/school.org"
          ;; "~/org/home.org"
          ;; )
        ;; )

  (font-lock-add-keywords
   'org-mode
   '(("^ +\\([-*]\\) "
      (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

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

(use-package evil-org
  :ensure t
  :after (org evil)
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

;; (use-package org-bullets
;;   ;; :after (org-mode)
;;   ;; :hook ((org-mode . (lambda () (org-bullets-mode 1))))
;;   :hook org-mode
;;   :config
;;   (org-bullets-mode)
;;   )
(use-package org-bullets
    :hook (org-mode . org-bullets-mode))

;; (use-package org-bullets
;;   :ensure t
;;   :commands org-bullets-mode
;;   :hook (org-mode . org-bullets-mode))

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

;; TODO: cuadrar esto bien y aprender un poco, que por el momento solo he usado 'a'
(defhydra hydra-org (:color red :columns 3)
  "Org Mode Movements"
  ("a" org-agenda "agenda")
  ("l" org-store-link "store link")
  ("n" outline-next-visible-heading "next heading")
  ("p" outline-previous-visible-heading "prev heading")
  ("N" org-forward-heading-same-level "next heading at same level")
  ("P" org-backward-heading-same-level "prev heading at same level")
  ("u" outline-up-heading "up heading")
  ("g" org-goto "goto" :exit t) ;; y esto como que no sirve :v
  )
