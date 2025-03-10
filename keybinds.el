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

 [tab] '(hydra-tabs/body         :wk "tabs")
 "TAB" '(hydra-tabs/body         :wk "tabs")
 "o"   '(dahas-org-map           :wk "org")
 "a"   '(dahas-agenda-map        :wk "agenda")
 "s"   '(hydra-search/body       :wk "search")
 "l"   '(dahas-lsp-map           :wk "lsp")
 ;; "p"   '(projectile-command-map :wk "projectile")
 "p"   '(project-prefix-map      :wk "project")
 "m"   '(dahas-manage-map        :wk "manage")

 "c"   '(compile-multi           :wk "compilation")
 ; "c"   '(dahas-comp-map          :wk "compilation")
 "w"   '(:keymap evil-window-map :wk "evil window prefix")

 ;; "v" '

 ";" '(:ignore t :which-key "config")
 ";g" 'global-display-line-numbers-mode
 ";l" 'display-line-numbers-mode
 ";v" 'dh/switch-light-dark-mode

 ;; find files
 "e" 'find-file                         ; buscar en el mismo directorio
 "E" 'dh/jet-pack                       ; buscar en todo el proyecto

 "u" 'vundo

 ;; "k" 'kill-buffer
 ;; "t" 'treemacs ; "tree"
 ;; "t" 'dirvish-side ; "tree"
 ;; "t"   '(tab-prefix-map     :wk "tabs")
 "t"   '(project-dired     :wk "files")

 ;; general
 ;; TODO: buscar una mejor forma de organizar esto
 ;; "X" 'eval-defun
 ;; "x" 'execute-extended-command

 ;; consult-complex-command
 "B" 'consult-buffer  ;'switch-to-buffer
 "b" 'consult-project-buffer
 "g" 'magit
 "y" 'yas-insert-snippet

 "j" 'evil-collection-consult-jump-list

 "d" 'dired

 ;; evito poner shift para @
 ;; "q" (lambda () (evil-execute-macro 1 (evil-get-register ?q t))) ; ; ; "execute macro"
 "2" '((lambda () (interactive) (call-interactively 'evil-owl-execute-macro)) :which-key "execute macro")
 ;; "?" #'evil-show-marks ; "marks"

 ;; eshell
 "." '(dh/create-new-eshell-buffer  :which-key "new eshell")
 "," '(dh/select-eshell             :which-key "select eshell")
 "/" '(project-eshell               :which-key "project eshell")
 "-" '(project-eshell               :which-key "project eshell")

 ;; TODO: arreglar esto
 ;; "j" 'prev-user-buffer-ring
 ;; "k" 'next-user-buffer-ring

 ;; emacs
 "'" '(:ignore t :which-key "system")
 "'rs" 'reload-emacs-config             ; "reload init"
 "'e"  'open-emacs-config               ; "edit init"
 "'s"  'proced

 "'p" '(:ignore t :which-key "profiler")
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
