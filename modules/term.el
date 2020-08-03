

;;; Code:

(use-package keychain-environment
  :hook (tramp-mode . keychain-refresh-environment)
  )

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

(defun eshell-new()
  "Open a new instance of eshell."
  (interactive)
  (eshell 'N))

(use-package eshell
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

  (with-eval-after-load 'evil
    (evil-define-key 'normal eshell-mode-map (kbd "] ]") 'eshell-next-prompt)
    (evil-define-key 'normal eshell-mode-map (kbd "[ [") 'eshell-previous-prompt)
    ;; (evil-define-key 'normal eshell-mode-map (kbd "C-d") 'eshell/exit) ;; ni idea
    )

  '(eshell-cannot-leave-input-list
	'(beginning-of-line-text
	  beginning-of-line
	  move-to-column
	  move-to-left-margin
	  move-to-tab-stop
	  forward-char
	  backward-char
	  delete-char
	  delete-backward-char
	  backward-delete-char
	  backward-delete-char-untabify
	  kill-paragraph
	  backward-kill-paragraph
	  kill-sentence
	  backward-kill-sentence
	  kill-sexp
	  backward-kill-sexp
	  kill-word
	  backward-kill-word
	  kill-region
	  forward-list
	  backward-list
	  forward-page
	  backward-page
	  forward-point
	  forward-paragraph
	  backward-paragraph
	  backward-prefix-chars
	  forward-sentence
	  backward-sentence
	  forward-sexp
	  backward-sexp
	  forward-to-indentation
	  backward-to-indentation
	  backward-up-list
	  forward-word
	  backward-word
	  forward-line
	  previous-line
	  next-line
	  forward-visible-line
	  forward-comment
	  forward-thing
	  evil-backward-char
	  left-char
	  ))

  (setq eshell-kill-on-exit t)
  ;;(setq eshell-buffer-name (concat "*eshell*") (default-directory) )
  ;;(use-package eshell-git-prompt
  ;;:ensure t
  ;;:config
  ;;(eshell-git-prompt-use-theme 'git-radar))
  ;;(setq eshell-prompt-function
  ;;(lambda()
  ;;(concat (getenv "USER") "@" (getenv "HOST") ":"
  ;;((lambda (p-lst)
  ;;(if (> (length p-lst) 3)
  ;;(concat
  ;;(mapconcat (lambda (elm) (substring elm 0 1))
  ;;(butlast p-lst (- (length p-lst) 3))
  ;;"/")
  ;;"/"
  ;;(mapconcat (lambda (elm) elm)
  ;;(last p-lst (- (length p-lst) 3))
  ;;"/"))
  ;;(mapconcat (lambda (elm) elm)
  ;;p-lst
  ;;"/")))
  ;;(split-string (eshell/pwd) "/"))
  ;;(if (= (user-uid) 0) " # " " $ "))))

  (defun eshell/clear ()
	"Clear the eshell buffer."
	(let ((inhibit-read-only t))
	  (erase-buffer)
	  (eshell-send-input)))
  ;;(eshell)
  )

;; (defun term-handle-exit--close-buffer (&rest args)
  ;; (when (null (get-buffer-process (current-buffer)))
	;; (insert "Press <C-d> to kill the buffer.")
	;; (use-local-map (let ((map (make-sparse-keymap)))
					 ;; (define-key map (kbd "C-d")
					   ;; (lambda ()
						 ;; (interactive)
						 ;; (kill-buffer (current-buffer))))
					 ;; map))))
;; (advice-add 'term-handle-exit :after #'term-handle-exit--close-buffer)

(use-package eshell-z
  :config
  (add-hook 'eshell-mode-hook
            (lambda ()
              (require 'eshell-z)))
  )

;; https://www.eigenbahn.com/2020/05/13/emacs-comint-buffer-auto-close
;;(require 'dash)
;;
;;(defun add-my-kill-on-exit-sentinel ()
  ;;"Replace current process sentinel with a new sentinel composed
;;of the current one and `my-kill-buffer-sentinel'."
;;
  ;;(let* ((process (get-buffer-process (current-buffer)))
         ;;(og-sentinel (process-sentinel process))
         ;;(sentinel-list (-remove #'null
                                 ;;(list og-sentinel #'my-kill-buffer-sentinel)))
         ;;(combined-sentinel
          ;;(lambda (process line)
            ;;(--each sentinel-list
              ;;(funcall it process line)))))
    ;;(setf (process-sentinel process) combined-sentinel)))
;;
;;(defvar my-kill-on-exit-comint-hook-has-run nil
  ;;"Whether or not `kill-on-exit-comint-hook' has run or not.
;;We need this buffer-local var to prevent the hook from running
   ;;several times, as can happen for example when calling `shell'.")
;;
;;(defun my-async-funcall (function &optional buffer args delay)
  ;;"Run FUNCTION with ARGS in the buffer after a short DELAY."
  ;;(run-at-time (or delay 0.2) nil
               ;;`(lambda ()
                  ;;(with-current-buffer ,buffer ,(cons function args)))))
;;
;;(defun kill-on-exit-comint-hook ()
  ;;(unless my-kill-on-exit-comint-hook-has-run
    ;;(setq-local my-kill-on-exit-comint-hook-has-run t)
    ;;(my-async-funcall #'add-my-kill-on-exit-sentinel (current-buffer))))
;;
;;(add-hook 'comint-mode-hook #'kill-on-exit-comint-hook)
