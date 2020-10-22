

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

  (with-eval-after-load "evil"
    (add-hook 'eshell-mode-hook
              (lambda ()
                (general-define-key
                 :states 'normal
                 :keymaps 'eshell-mode-map
                 "] ]" 'eshell-next-prompt
                 "[ [" 'eshell-previous-prompt
                 "TAB" 'company-complete-common-or-cycle
                 )
                )
              )
    )

  (defun with-face (str &rest face-plist)
    (propertize str 'face face-plist))

  ;; (propertize "┌─[" 'face `(:foreground "green"))
  ;; (propertize (user-login-name) 'face `(:foreground "red"))
  ;; (propertize "]──[" 'face `(:foreground "green"))
  ;; (propertize "└─" 'face `(:foreground "green"))

  (defun dahas-eshell-prompt ()
    (let (
          (header-bg "#453060")
          (grin "#b8bb26") ;; minibuffer-prompt
          (blu "#83a598") ;; magit-hash
          )
      (concat
       "\n"
       (with-face user-login-name
                  :weight 'bold
                  :foreground grin
                  :background header-bg)
       (with-face "@"
                  :foreground "orange"
                  :background header-bg)
       (with-face (system-name)
                  :weight 'bold
                  :foreground blu
                  :background header-bg)
       (with-face "::"
                  :weight 'bold
                  :foreground "orange"
                  :background header-bg)
       (with-face (concat (eshell/pwd) " ")
                  :foreground grin
                  :background header-bg)
       (with-face (or
                   (ignore-errors
                     (format "(%s)"
                             (vc-responsible-backend
                              default-directory)))
                   "")
                  :background header-bg)
       "\n"
       (if (= (user-uid) 0)
           (with-face " #" :foreground "red")
         " $")
       " "
       )))

  (setq eshell-prompt-function 'dahas-eshell-prompt
        eshell-highlight-prompt t
        comint-prompt-read-only t)


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
      ))
  )

(use-package eshell-z
  :config
  (add-hook 'eshell-mode-hook
            (lambda ()
              (require 'eshell-z)))
  )

(use-package eshell-syntax-highlighting
  :after esh-mode
  :demand t ;; Install if not already installed.
  :config
  ;; Enable in all Eshell buffers.
  (eshell-syntax-highlighting-global-mode +1))

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

;; proced (top)
;; (defun proced-settings ()
;;   (proced-toggle-auto-update))
;;
;; (add-hook 'proced-mode-hook 'proced-settings)

(defun shell-command-on-buffer ()
  "Asks for a command and executes it in inferior shell with current buffer
as input."
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   (read-shell-command "Shell command on buffer: ")))
