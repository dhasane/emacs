;;; comint.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Comint and REPL integration tweaks

;;; Configuracion para comint

;;; code:

(defun comint-jump-to-input-ring ()
  "Jump to the buffer containing the input history."
  (interactive)
  (progn
    (comint-dynamic-list-input-ring)
    (other-window 1)))

(setq comint-prompt-read-only t)    ; "Make the prompt read only."
(setq comint-buffer-maximum-size 10000)

(general-define-key
 :states 'normal
 :keymaps 'comint-mode-map
 "] ]" 'comint-next-prompt
 "[ [" 'comint-previous-prompt
 )
(general-define-key
 :states 'insert
 :keymaps 'comint-mode-map
 [up] 'comint-previous-input
 [down] 'comint-next-input
 )

(add-hook 'comint-mode-hook
          (lambda ()
            (local-set-key (kbd "C-<f7>") 'comint-jump-to-input-ring)
            ))

;; proced (top)
;; (defun proced-settings ()
;;   (proced-toggle-auto-update))
;;
;; (add-hook 'proced-mode-hook 'proced-settings)

(defun shell-command-on-buffer ()
  "Asks for a command and execute it in inferior shell with current buffer as input."
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   (read-shell-command "Shell command on buffer: ")))

;;; comint.el ends here
