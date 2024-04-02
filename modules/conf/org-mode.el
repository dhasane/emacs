;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; configuracion de org mode

;;; code:

(use-package org
  :demand t
  :straight (:type built-in)
  :ensure nil
  :general
  (org-mode-map
   "C-c c" #'(lambda ()
               (interactive)
               (org-insert-structure-template "src")
               )
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
                              right-margin-width 2)
                        ;; (set-window-buffer nil (current-buffer))
                        )))
        (org-mode . org-indent-mode))
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
  ;; (org-bullets-bullet-list '(" ")) ;; no bullets, needs org-bullets package
  (org-ellipsis (propertize
                 ;; " ↵ "
                 ;; " ⌄ "
                 " ▼ "
                 'font-lock-face '(:foreground "red")))    ; folding symbol
  ;; deja de incluir lineas vacias al final, pero arregla el problema con ellipsis
  (org-cycle-separator-lines -1)

  ;; decoracion
  (org-pretty-entities t)
  (org-pretty-entities-include-sub-superscripts nil)
  (org-hide-emphasis-markers t)
  ;; show actually italicized text instead of /italicized text/
  (org-agenda-block-separator "")
  (org-fontify-whole-heading-line t)
  (org-fontify-done-headline t)
  (org-fontify-quote-and-verse-blocks t)

  (org-startup-truncated nil)
  (org-log-done t)

  (org-special-ctrl-a/e nil)

  (org-cite-csl-styles-dir "~/Zotero/styles")
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

  (with-eval-after-load 'ox-latex
    ;; Set up org-mode export stuff
    (unless (boundp 'org-latex-classes)
      (setq org-latex-classes nil))
    (add-to-list 'org-latex-classes
                 '("apa6"
                   "\\documentclass{apa6}"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
    ;; (add-to-list 'org-latex-classes
    ;;              '("report"
    ;;                "\\documentclass{report}"
    ;;                ("\\chapter{%s}" . "\\chapter*{%s}")
    ;;                ("\\section{%s}" . "\\section*{%s}")
    ;;                ("\\subsection{%s}" . "\\subsection*{%s}")
    ;;                ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

    (add-to-list 'org-latex-classes
                 '("elsevier"
                   "\\documentclass[11pt]{elsarticle}"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
                 )

    (add-to-list 'org-latex-classes
                 '("memoria"
                   "\\documentclass[11pt, titlepage]{report}"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
                 )

    (add-to-list 'org-latex-packages-alist '("" "listings"))
    (setq org-latex-listings-options '(("breaklines" "true")))

    (setq org-latex-listings t)
    (setq org-export-preserve-breaks nil)
    ;; (setq org-latex-listings 'minted)

    (setq org-latex-pdf-process
          '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
            "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
            "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

    (org-babel-do-load-languages
     'org-babel-load-languages
     '((R . t)
       (latex . t)))

    )


  ;; (setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))

  ;; (setq org-latex-pdf-process
  ;;       '("latexmk -pdflatex='pdflatex -interaction nonstopmode' -pdf -bibtex -f %f"))

  ;; (defhydra+ hydra-org ()
  ;;   ("g" org-agenda          "agenda"    :column "planning")
  ;;   ("tl" org-todo-list       "todo list" :column "planning")

  ;;   ("ea" org-export-dispatch "export action"    :column "action")

  ;;   ("ti" org-insert-structure-template "structure template" :column "action")

  ;;   ;; ("l s" org-store-link         "store link")
  ;;   ;; ("l i" org-insert-link        "insert link")
  ;;   ;; ("m"   org-roam-graph         "map")
  ;;   ;; ("k"   kill-org-buffers                   "kill" )
  ;;   )
  :general
  (dahas-org-map
   "g" '(org-agenda :wk "agenda")
   "l" '(org-todo-list :wk "todo list")

   "e" '(:ignore t :which-key "export")
   "ea" '(org-export-dispatch :wk "export action")

   "x" '(:ignore t :which-key "extra")
   "xi" '(org-insert-structure-template :wk "structure template")
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

;;; org-mode.el ends here
