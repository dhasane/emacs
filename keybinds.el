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
      (call-interactively 'project-find-file)
    (call-interactively 'find-file)
    )
  )

(general-define-key
 :keymaps 'override
 :prefix "<SPC>"
 :non-normal-prefix "<M-SPC>"
 :states '(normal motion)

 [tab] 'hydra-tabs/body
 "TAB" 'hydra-tabs/body

 ;; "k" 'kill-buffer
 "t" 'treemacs ; "tree"

 ;; general
 "x" 'execute-extended-command
 ;; consult-complex-command
 "b" 'consult-buffer  ;'switch-to-buffer
 "o" 'hydra-org/body
 "g" 'magit
 "w" 'evil-window-map
 "y" 'yas-insert-snippet

 "d" 'dired

 ;; buscar
 "ss" 'consult-line
 "sg" 'consult-git-grep
 "si" 'consult-imenu

 ;; evito poner shift para @
 ;; "q" (lambda () (evil-execute-macro 1 (evil-get-register ?q t))) ; ; ; "execute macro"
 ;; "2" '(lambda () (interactive) (call-interactively 'evil-execute-macro))
 "2" '(lambda () (interactive) (call-interactively 'evil-owl-execute-macro))
 ;; "?" #'evil-show-marks ; "marks"

 ;; eshell
 "." 'dh/create-new-eshell-buffer       ; "terminal"
 "," 'dh/select-eshell                  ; "seleccionar terminal"

 ;; move to files
 "e" 'find-file                         ; buscar solo en el mismo directorio
 "E" 'dh/jet-pack                       ; buscar en todo el proyecto

 ;; TODO: arreglar esto
 ;; "j" 'prev-user-buffer-ring
 ;; "k" 'next-user-buffer-ring

 ;; lsp
 "rn" 'lsp-rename                       ; "rename"
 "pd" 'lsp-ui-peek-find-definitions
 "pr" 'lsp-ui-peek-find-references
 "pm" 'lsp-ui-imenu
 "pe" 'consult-flycheck                 ; "errores"

 ;; emacs
 "'rs" 'reload-emacs-config             ; "reload init"
 "'e"  'open-emacs-config               ; "edit init"
 "'ps" 'profiler-start
 "'pS" 'profiler-stop
 "'pr" 'profiler-report
 "'s"  'proced
 )

(define-key minibuffer-local-map (kbd "<C-up>" )
  'previous-history-element)
(define-key minibuffer-local-map (kbd "<C-down>" )
  'next-history-element)

;; the hydra to rule them all buahaha
;; (defhydra hydra-leader (:color blue :idle 1.0 :hint nil)
;;   "
;; actuar como leader en vim :
;;
;; ^Config^       |    ^Buffers^       |  ^Edit^
;; ^^^^^^^^-------------------------------------------------
;; _rs_: reload   |   _l_: jet-pack    |   _m_: magit
;; _re_: edit     |   _j_: previous    |   _o_: org
;; ^ ^            |   _k_: next        |   _e_: errores
;; ^ ^            |   _._: terminal    |   _SPC_: execute macro
;; ^ ^            |   _?_: marks       |   _rn_: rename
;; ^ ^            |   ^ ^              |   _s_: search text
;;
;; "
;;   ( "rs" reload-emacs-config "reload init" )
;;   ( "re" open-emacs-config "edit init" )
;;   ( "l" #'dh/jet-pack  "jet pack" )
;;   ( "s" swiper "swiper" )
;;   ;;( "." toggle-terminal "terminal" )
;;   ;; ( "." eshell-new "terminal" )
;;   ;; ( "." (dh/open-create-eshell-buffer) "terminal" )
;;   ( "." (dh/create-new-eshell-buffer) "terminal" )
;;   ( "/" (dh/select-eshell) "seleccionar terminal" )
;;   ( "e" counsel-flycheck "errores" )
;;
;;   ;;( "j" previous-buffer "next" )
;;   ;;( "k" next-buffer "next" )
;;   ( "j" (prev-user-buffer-ring) "prev" )
;;   ( "k" (next-user-buffer-ring) "next" )
;;
;;   ( "SPC" (evil-execute-macro 1 (evil-get-register ?q t)) "execute macro" )
;;   ( "m" (magit) "magit" )
;;   ( "o" (hydra-org/body) "org" )
;;   ( "rn" lsp-rename "rename")
;;   ( "?" evil-show-marks "marks")
;;   ( "t" treemacs "tree")
;;   )

;;; keybinds.el ends here
