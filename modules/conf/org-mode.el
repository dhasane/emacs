;;; org-mode.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Org mode core configuration

;;; configuracion de org mode

;;; code:

(use-package org
  :demand t
  :ensure nil
  :general
  (org-mode-map
   "C-c c" #'(lambda ()
               (interactive)
               (org-insert-structure-template "src")))
  (org-mode-map
   :states '(normal)
   "RET" 'org-open-at-point)
  (dh/org-map
   "e"  '(:ignore t :which-key "export")
   "ea" '(org-export-dispatch :wk "export action")

   "x"  '(:ignore t :which-key "extra")
   "xi" '(org-insert-structure-template :wk "structure template")

   "l"  '(:ignore t :which-key "links")
   "li" '(org-insert-link :wk "insert link")
   "ls" '(org-store-link :wk "store link"))
  (dh/agenda-map
   "c" '(org-capture             :which-key "capture")
   "a" '(org-agenda              :which-key "agenda")
   "g" '(org-capture-goto-target :which-key "go to")
   "t" '(org-todo-list           :which-key "todo list")
   "p" '(dh/org-todo-popup      :which-key "todo popup"))
  :preface
  (defun dh/org-mode-local-settings ()
    (setq-local line-spacing 0)
    (setq-local left-margin-width 2)
    (setq-local right-margin-width 2))
  (defvar org-meeting-notes-file nil
    "Path to the org meeting notes file.")
  :hook
  ((org-mode . dh/org-mode-local-settings)
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
  (org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
  (org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
  (org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
  (org-verbatim ((t (:inherit (shadow fixed-pitch)))))
  :custom
  ;; ubicacion
  (org-directory "~/org")
  (org-default-notes-file (concat org-directory "/capture.org"))
  (org-meeting-notes-file (concat org-directory "/meetings.org"))
  (org-agenda-files (list org-default-notes-file org-meeting-notes-file))

  ;; organizacion
  (org-startup-indented t)
  ;; (org-bullets-bullet-list '(" ")) ;; no bullets, needs org-bullets package
  ;; (org-ellipsis (propertize
  ;;                ;; " ↵ "
  ;;                ;; " ⌄ "
  ;;                " ▼ "
  ;;                'font-lock-face '(:foreground "red")))    ; folding symbol
  ;; deja de incluir lineas vacias al final, pero arregla el problema con ellipsis
  ;; (org-cycle-separator-lines -1)

  ;; decoracion
  (org-pretty-entities t)
  (org-pretty-entities-include-sub-superscripts nil)
  (org-hide-emphasis-markers t)
  ;; show actually italicized text instead of /italicized text/
  (org-agenda-block-separator "")
  (org-fontify-whole-heading-line t)
  (org-fontify-done-headline t)
  (org-fontify-quote-and-verse-blocks t)

  ;; imagenes
  (org-redisplay-inline-images t)
  (org-startup-with-inline-images t)

  ;; code blocks
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-src-preserve-indentation t)
  (org-confirm-babel-evaluate nil)
  (org-edit-src-content-indentation 0)

  ;; misc
  (org-startup-truncated nil)
  (org-log-done t)

  (org-special-ctrl-a/e nil)

  ;; agenda/todo/capture
  (org-cite-csl-styles-dir "~/Zotero/styles")
  (org-todo-keywords '((sequence "TODO(t)" "WORK(w)" "WAIT(a)" "BLOCK(b)" "DONE(d)")))
  (org-agenda-custom-commands
        '(("n" "My Weekly Agenda"
           ((agenda "" nil)
            (todo "TODO" nil)
            (todo "WORK" nil)
            (todo "WAIT" nil)
            (todo "BLOCK" nil)
            (todo "DONE" nil))
           nil)))
  (org-todo-keyword-faces
   '(
     ("WORK" . (:foreground "orange" :weight bold))
     ("BLOCK" . (:foreground "red" :weight bold))
     ("WAIT" . (:foreground "purple" :weight bold))
     )
   )
  (org-capture-templates
   `(("t" "Todo" entry (file org-default-notes-file)
      "* TODO %? \t:TODO:\n%u\n"
      :clock-in nil
      :clock-keep nil
      :clock-resume nil)
     ("m" "Meeting" entry (file org-meeting-notes-file)
      "* MEETING: %^{Meeting name} :MEETING:\n%t\n%?"
      :clock-in t
      :clock-resume t)
     ("d" "Diary" entry (file+datetree "~/org/diary.org")
      "* %<%l %p>\n%?"
      :clock-in nil
      :clock-resume nil)
     ("i" "Idea" entry (file org-default-notes-file)
      "* %? \t :IDEA: \n%t")
     ("r" "Improv Reflection" entry (file "~/org/improv.org")
      ,(concat
        "* %^{Class/Show/Session name} — %t :IMPROV:\n"
        "** Brain Dump\n"
        "/Immediate thoughts, feelings, or concerns — no filters./\n" "%?\n"
        "** Strengths\n"
        "/What went right: successes, connections, ease, fun./\n" "\n"
        "*** Moment you had fun or enjoyed (internally)\n" "\n"
        "*** Gift from a scene partner that made improv easier\n" "\n"
        "*** Choices you were proud of (and why!)\n" "\n"
        "** Reframing challenges\n"
        "/What was challenging? What should you work on next?/\n" "\n"
        "** The Improv Plan\n"
        "*** What did you learn? (about improv, or yourself)\n" "\n"
        "*** Goal for the next session\n" "\n"
        "/Be specific — e.g. cadence of voice, strong physical choice, big swing./\n"))))
  :config
  (let ((capture-file (expand-file-name org-default-notes-file)))
    (unless (file-exists-p capture-file)
      (make-directory (file-name-directory capture-file) t)
      (write-region "" nil capture-file)))

  (add-hook 'org-capture-mode-hook 'delete-other-windows)

  (defun dh/fix-inline-images ()
    (when org-inline-image-overlays
      (org-redisplay-inline-images)))

  (add-hook 'org-babel-after-execute-hook 'dh/fix-inline-images)
  (setq-default org-image-actual-width 620)

  (org-display-inline-images t t))

;;; org-mode.el ends here
