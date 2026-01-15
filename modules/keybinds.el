;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; code:

(if (featurep 'elpaca)
    (elpaca-wait))

(defun comment-or-uncomment-line-or-region ()
  "Comments or uncomments the current line or region."
  (interactive)
  (if (region-active-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))))

(general-define-key
 :keymaps 'override
 "C-+"   'text-scale-increase
 "C--"   'text-scale-decrease
 ;; "C-S-h" 'help-command
 "C-S-s" 'save-all-buffers
 "C-/"   'comment-or-uncomment-line-or-region
 )

(general-define-key
 :prefix "C-x"
 "b" 'consult-buffer  ;'switch-to-buffer
 )

(general-define-key
 :prefix "C-c"
 "g" 'prelude-google
 "t" 'toggle-transparency
 )

(defun dh/jet-pack ()
  "Saltar a cualquier parte del proyecto."
  (interactive)
  (if (projectile-project-p)
      (call-interactively 'project-find-file)
    (call-interactively 'find-file)
    )
  )

(general-define-key
 ;; :keymaps 'override
 :states '(normal)
 "s" 'avy-goto-char-2
 ;; "S" 'avy-goto-char-2
 )

(fset 'project-prefix-map project-prefix-map)
(fset 'tab-prefix-map tab-prefix-map)

(general-define-key
 :keymaps 'override
 :prefix "SPC"
 :non-normal-prefix "M-SPC"
 :states '(emacs normal visual motion)

 [tab] '(hydra-tabs/body         :wk "Tabs")
 ;; "TAB" '(hydra-tabs/body         :wk "Tabs")
 "o"   '(dahas-org-map           :wk "Org")
 "a"   '(dahas-agenda-map        :wk "Agenda")
 "s"   '(hydra-search/body       :wk "Search")
 "l"   '(dahas-lsp-map           :wk "LSP")
 ;; "p"   '(projectile-command-map :wk "projectile")
 "p"   '(project-prefix-map      :wk "Project")
 "m"   '(dahas-manage-map        :wk "Manage")

 "c"   '(compile-multi           :wk "Compilation")
 ; "c"   '(dahas-comp-map          :wk "compilation")
 "w"   '(:keymap evil-window-map :wk "Evil Window")

 "r"   '(dh/elfeed-update-and-open :wk "Read feed")

 ;; "v" '

 ";" '(:ignore t :which-key "Config")
 ";g" 'global-display-line-numbers-mode
 ";l" 'display-line-numbers-mode
 ";v" 'dh/switch-light-dark-mode

 ;; find files
 "e" '(find-file   :wk "File in Directory")                      ; buscar en el mismo directorio
 "E" '(dh/jet-pack :wk "File in Proyect")                       ; buscar en todo el proyecto

 "u" 'vundo

 ;; "k" 'kill-buffer
 ;; "t" 'treemacs ; "tree"
 ;; "t" 'dirvish-side ; "tree"
 ;; "t"   '(tab-prefix-map     :wk "tabs")
 "t" '(project-dired     :wk "File Tree")

 ;; general
 ;; TODO: buscar una mejor forma de organizar esto
 ;; "X" 'eval-defun
 ;; "x" 'execute-extended-command

 ;; consult-complex-command
 "B" '(consult-buffer             :wk "All Buffers")  ;'switch-to-buffer
 "b" '(consult-project-buffer     :wk "Project Buffers")
 "g" 'magit
 "y" '(yas-insert-snippet         :wk "Snippets")

 "j" '(evil-collection-consult-jump-list :wk "Jump List")

 "d" 'dired

 ;; evito poner shift para @
 ;; "q" (lambda () (evil-execute-macro 1 (evil-get-register ?q t))) ; ; ; "execute macro"
 "2" '((lambda () (interactive) (call-interactively 'evil-owl-execute-macro)) :wk "Execute Macro")
 ;; "?" #'evil-show-marks ; "marks"

 ;; eshell
 "." '(dh/create-new-eshell-buffer  :which-key "New Eshell")
 "," '(dh/select-eshell             :which-key "Select Eshell")
 "/" '(project-eshell               :which-key "Project Eshell")
 "-" '(project-eshell               :which-key "Project Eshell")

 ;; TODO: arreglar esto
 ;; "j" 'prev-user-buffer-ring
 ;; "k" 'next-user-buffer-ring

 ;; emacs
 "'" '(:ignore t :which-key "System")
 "'r" 'reload-emacs-config             ; "reload init"
 "'e" 'open-emacs-config               ; "edit init"
 "'s" 'proced

 "'p" '(:ignore t :which-key "Profiler")
 "'ps" 'profiler-start
 "'pS" 'profiler-stop
 "'pr" 'profiler-report
 )

(general-define-key
 :keymaps 'override
 :states '(visual)
 "Q" 'apply-macro-to-region-lines
 )

;;; keybinds.el ends here
