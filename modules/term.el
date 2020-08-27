

;;; Code:

(use-package keychain-environment
  ;; :hook (tramp-mode . keychain-refresh-environment)
  :config
  (add-hook 'tramp-mode-hook 'keychain-refresh-environment)

  )


(defun eshell-new()
  "Open a new instance of eshell."
  (interactive)
  (eshell 'N))

(use-package eshell
  :defines
  (
   eshell
   eshell-visual-commands
   eshell-mode-map
   )
  :functions
  (
   eshell-kill-on-exit
   )
  ;; :general
  ;; (:keymaps 'eshell-mode-map
  ;;  :states '(normal)
  ;;          "] ]" 'eshell-next-prompt
  ;;          "[ [" 'eshell-previous-prompt
  ;;          )
  :init
  (add-hook 'eshell-mode-hook
            (lambda ()
              (mapc (lambda (vc)
                      (add-to-list 'eshell-visual-commands vc))
                    '(
                      "ssh"
                      "htop"
                      "tail"
                      "top"
                      "less"
                      "vim"
                      "pacman"
                      "apt"
                      "irb"
                      )
                    )
              )
            )
  :config

  (defun check-gitconfig-create ()
    (interactive)
    (shell-command
     "[ ! -f ~/.gitconfig ] && echo '
[user]
    email = danihas@live.com
    name = dhasane
' > ~/.gitconfig"
     ;;(magit-status)
     )
    )

  (with-eval-after-load "evil"
    (add-hook 'eshell-mode-hook
              (lambda ()
                (general-define-key
                 :states 'normal
                 :keymaps 'eshell-mode-map
                 "] ]" 'eshell-next-prompt
                 "[ [" 'eshell-previous-prompt
                 )
                )
              )
    )


  ;; (setq eshell-prompt-function
  ;;       (lambda ()
  ;;         (concat
  ;;          (propertize "\n")
  ;;          (propertize "┌─[" 'face `(:foreground "green"))
  ;;          (propertize (user-login-name) 'face `(:foreground "red"))
  ;;          (propertize "@" 'face `(:foreground "orange"))
  ;;          (propertize (system-name) 'face `(:foreground "blue"))
  ;;          ;; (propertize "]──[" 'face `(:foreground "green"))
  ;;          ;; (propertize (format-time-string "%H:%M" (current-time)) 'face `(:foreground "yellow"))
  ;;          (propertize "::" 'face `(:foreground "orange"))
  ;;          (propertize (concat (eshell/pwd)) 'face `(:foreground "green"))
  ;;          (propertize "\n")
  ;;          (propertize "└─" 'face `(:foreground "green"))
  ;;          (propertize (if (= (user-uid) 0) "# " "> ") )
  ;;          )))

  ;; (mapcar (lambda (val)
  ;;           (push val 'eshell-cannot-leave-input-list))
  ;;         '(
  ;;           previous-line
  ;;           next-line
  ;;           forward-visible-line
  ;;           forward-comment
  ;;           forward-thing
  ;;           evil-backward-char
  ;;           left-char
  ;;           )
  ;;         )

  (setq eshell-kill-on-exit t)

  (defun eshell/clear ()
	"Clear the eshell buffer."
	(let ((inhibit-read-only t))
	  (erase-buffer)
	  (eshell-send-input)))
  ;;(eshell)
  )

(use-package eshell-z
  :config
  (add-hook 'eshell-mode-hook
            (lambda ()
              (require 'eshell-z)))
  )

;; comint

(defun comint-jump-to-input-ring ()
  "Jump to the buffer containing the input history."
  (interactive)
  (progn
    (comint-dynamic-list-input-ring)
    (other-window 1)))

(setq comint-prompt-read-only t)    ; "Make the prompt read only."

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
