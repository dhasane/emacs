

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

  (with-eval-after-load 'evil
    (evil-define-key 'normal eshell-mode-map (kbd "] ]") 'eshell-next-prompt)
    (evil-define-key 'normal eshell-mode-map (kbd "[ [") 'eshell-previous-prompt)
    ;; (evil-define-key 'normal eshell-mode-map (kbd "C-d") 'eshell/exit) ;; ni idea
    )

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

(add-hook 'comint-mode-hook
          (lambda ()
            (with-eval-after-load "evil"
              (evil-define-key 'normal comint-mode-map (kbd "] ]") 'comint-next-prompt)
              (evil-define-key 'normal comint-mode-map (kbd "[ [") 'comint-previous-prompt)
              (evil-define-key 'insert comint-mode-map [up] 'comint-previous-input)
              (evil-define-key 'insert comint-mode-map [down] 'comint-next-input)
              (local-set-key (kbd "C-<f7>") 'comint-jump-to-input-ring)
              )
            ))
