;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; code:

(general-define-key
 :keymaps 'override
 "C-+"   'text-scale-increase
 "C--"   'text-scale-decrease
 "C-S-h" 'help-command
 "C-S-s" 'save-all-buffers
 "C-S-q" 'kill-other-buffers ; tambien esta clean-buffer-list
 "M-/"   'comment-dwim
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
      (call-interactively 'projectile-find-file)
    (call-interactively 'find-file)
    )
  )

(general-define-key
 :keymaps 'override
 :prefix "SPC"
 :non-normal-prefix "M-SPC"
 :states '(emacs normal visual motion insert)

 [tab] '(hydra-tabs/body    :wk "tabs")
 "TAB" '(hydra-tabs/body    :wk "tabs")
 "o"   '(hydra-org/body     :wk "org")
 "s"   '(hydra-search/body  :wk "search")
 "l"   '(hydra-lsp/body     :wk "lsp")

 ;; "k" 'kill-buffer
 ;; "t" 'treemacs ; "tree"
 "t" 'dirvish-side ; "tree"

 ;; general
 "X" 'eval-defun
 "x" 'execute-extended-command
 ;; consult-complex-command
 "b" 'consult-buffer  ;'switch-to-buffer
 "g" 'magit
 "w" '(:keymap evil-window-map :wk "evil window prefix")
 "y" 'yas-insert-snippet

 "j" 'evil-collection-consult-jump-list

 "d" 'dired

 ;; evito poner shift para @
 ;; "q" (lambda () (evil-execute-macro 1 (evil-get-register ?q t))) ; ; ; "execute macro"
 "2" '((lambda () (interactive) (call-interactively 'evil-owl-execute-macro)) :which-key "execute macro")
 ;; "?" #'evil-show-marks ; "marks"

 ;; eshell
 "." '(dh/create-new-eshell-buffer :which-key "new eshell")     ; "terminal"
 "," '(dh/select-eshell :which-key "select eshell")             ; "seleccionar terminal"

 ;; move to files
 "e" 'find-file                         ; buscar solo en el mismo directorio
 "E" 'dh/jet-pack                       ; buscar en todo el proyecto

 ;; TODO: arreglar esto
 ;; "j" 'prev-user-buffer-ring
 ;; "k" 'next-user-buffer-ring

 ;; projectile
 "p" 'projectile-command-map

 ;; emacs
 "'" '(:ignore t :which-key "system")
 "'rs" 'reload-emacs-config             ; "reload init"
 "'e"  'open-emacs-config               ; "edit init"


 "'p" '(:ignore t :which-key "profiler")
 "'ps" 'profiler-start
 "'pS" 'profiler-stop
 "'pr" 'profiler-report
 "'s"  'proced


 "c" '(:ignore t :which-key "config")
 "cg" 'global-display-line-numbers-mode
 "cl" 'display-line-numbers-mode
 )

;;; keybinds.el ends here
