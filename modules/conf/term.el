;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; Configuracion para eshel y term

;;; code:

(use-package keychain-environment
  ;; :hook (tramp-mode . keychain-refresh-environment)
  :config
  (add-hook 'tramp-mode-hook 'keychain-refresh-environment)
  )

(use-package pcomplete
  :demand t
  :custom
  (pcomplete-ignore-case t)
  )

(use-package eshell
  :hook (
        (eshell-mode . visual-line-mode)
        (eshell-output-filter-functions . #'eshell-truncate-buffer)
         )
  :general
  (
   :states '(normal insert)
   "C-d" 'eshell-send-eof-to-process
   )
  :custom
  (eshell-aliases-file (cl/expand-name "eshell/alias")) ;; TODO: tal vez podria ser mejor definir los alias a traves de elisp en vez de usando este archivo
  (eshell-destroy-buffer-when-process-dies t)
  (eshell-banner-message "")
  (eshell-buffer-maximum-lines 1000)
  (setenv "TERM" "dumb")
  :init
  ;; (setq eshell-visual-subcommands
  ;;       '(
  ;;         ("sudo" "pacman")
  ;;         ("sudo" "apt")
  ;;         ))
  (add-hook 'eshell-mode-hook
            (lambda ()
              (mapc (lambda (vc)
                      (push 'eshell-visual-commands vc))
                    '(
                      "ssh"
                      "htop"
                      "tail"
                      "top"
                      "less"
                      "vim"
                      "irb"
                      )
                    )
              )
            )
  ;; (push 'display-buffer-alist
  ;;                '("sudo". ((display-buffer-pop-up-window) .
  ;;                            ((inhibit-same-window . t)))))
  :config

  ;; (advice-add 'eshell-interrupt-process :before #'end-of-buffer)
  ;; (advice-remove 'eshell-interrupt-process #'end-of-buffer)

  ;; (setq ivy-do-completion-in-region t) ; this is the default

  ;; (defun setup-eshell-ivy-completion ()
  ;;   (interactive)
  ;;   ;; (define-key eshell-mode-map [remap eshell-pcomplete] 'completion-at-point)
  ;;   ;; only if you want to use the minibuffer for completions instead of the
  ;;   ;; in-buffer interface
  ;;   (setq-local ivy-display-functions-alist
  ;;               (remq (assoc 'ivy-completion-in-region ivy-display-functions-alist)
  ;;                     ivy-display-functions-alist)))

  ;; (add-hook 'eshell-mode-hook #'setup-eshell-ivy-completion)

  (add-hook 'eshell-directory-change-hook
            (lambda ()
              (rename-buffer (dh/eshell-buffer-name))
              )
            )
  ;; (add-hook 'eshell-after-prompt-hook
  ;;           (lambda ()
  ;;             (rename-buffer (dh/eshell-buffer-name))
  ;;             ))

  (add-hook 'eshell-mode-hook
            (lambda ()
              (general-define-key
                :keymaps 'eshell-mode-map
                :states '(insert)
                "TAB" 'completion-at-point
               )
              )
            )

  (with-eval-after-load "evil"
    (add-hook 'eshell-mode-hook
              (lambda ()
                (general-define-key
                 :states '(insert normal)
                 :keymaps 'eshell-mode-map
                 "C-l" 'evil-window-right
                 "C-h" 'evil-window-left
                 "C-k" 'evil-window-up
                 "C-j" 'evil-window-down
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

  (defun dahas/eshell-prompt ()
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

  (setq eshell-prompt-function 'dahas/eshell-prompt
        eshell-highlight-prompt t)

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

  (defun eshell/upd ()
    "Update system"
    ;;TODO: identificar el sistema para actualizar
    )

  (cl-defun eshell/test (&optional params)
    "test alias"
    ;; TODO: mover los alias de eshell/alias a funciones
    (message (format "%s" params))
    )

  (defun eshell/mk ()
    "Update system"

    )

  (defun pcomplete/mk ()
    "Completion rules for the `make' command."
    ;; alias mk make $*
    ;; mk esta definido en eshell/alias
    (pcomplete/make)
    )

  (defun eshell/v (file)
    (find-file file))

  (defun eshell/e (file)
    (find-file file))

  ;; https://www.emacswiki.org/emacs/EshellCompletion
;;;; sudo completion
  (defun pcomplete/sudo ()
    "Completion rules for the `sudo' command."
    (let ((pcomplete-ignore-case t))
      (pcomplete-here (funcall pcomplete-command-completion-function))
      (while (pcomplete-here (pcomplete-entries)))))

;;;; systemctl completion
  (defcustom pcomplete-systemctl-commands
    '("disable" "enable" "status" "start" "restart" "stop" "reenable"
      "list-units" "list-unit-files")
    "p-completion candidates for `systemctl' main commands"
    :type '(repeat (string :tag "systemctl command"))
    :group 'pcomplete)

  (defvar pcomplete-systemd-units
    (split-string
     (shell-command-to-string
      "(systemctl list-units --all --full --no-legend;systemctl list-unit-files --full --no-legend)|while read -r a b; do echo \" $a\";done;"))
    "p-completion candidates for all `systemd' units")

  (defvar pcomplete-systemd-user-units
    (split-string
     (shell-command-to-string
      "(systemctl list-units --user --all --full --no-legend;systemctl list-unit-files --user --full --no-legend)|while read -r a b;do echo \" $a\";done;"))
    "p-completion candidates for all `systemd' user units")

  (defun pcomplete/systemctl ()
    "Completion rules for the `systemctl' command."
    (pcomplete-here (append pcomplete-systemctl-commands '("--user")))
    (cond ((pcomplete-test "--user")
           (pcomplete-here pcomplete-systemctl-commands)
           (pcomplete-here pcomplete-systemd-user-units))
          (t (pcomplete-here pcomplete-systemd-units))))

;;;; man completion
  (defvar pcomplete-man-user-commands
    (split-string
     (shell-command-to-string
      "apropos -s 1 .|while read -r a b; do echo \" $a\";done;"))
    "p-completion candidates for `man' command")

  (defun pcomplete/man ()
    "Completion rules for the `man' command."
    (pcomplete-here pcomplete-man-user-commands))

  ;; https://www.masteringemacs.org/article/pcomplete-context-sensitive-completion-emacs
  (defconst pcmpl-git-commands
    '("add" "bisect" "branch" "checkout" "clone"
      "commit" "diff" "fetch" "grep"
      "init" "log" "merge" "mv" "pull" "push" "rebase"
      "reset" "rm" "show" "status" "tag" )
    "List of `git' commands.")

  (defvar pcmpl-git-ref-list-cmd "git for-each-ref refs/ --format='%(refname)'"
    "The `git' command to run to get a list of refs.")

  (defun pcmpl-git-get-refs (type)
    "Return a list of `git' refs filtered by TYPE."
    (with-temp-buffer
      (insert (shell-command-to-string pcmpl-git-ref-list-cmd))
      (goto-char (point-min))
      (let ((ref-list))
        (while (re-search-forward (concat "^refs/" type "/\\(.+\\)$") nil t)
          (push 'ref-list (match-string 1)))
        ref-list)))

  (defun pcomplete/git ()
    "Completion for `git'."
    ;; Completion for the command argument.
    (pcomplete-here* pcmpl-git-commands)
    ;; complete files/dirs forever if the command is `add' or `rm'
    (cond
     ((pcomplete-match (regexp-opt '("add" "rm")) 1)
      (while (pcomplete-here (pcomplete-entries))))
     ;; provide branch completion for the command `checkout'.
     ((pcomplete-match "checkout" 1)
      (pcomplete-here* (pcmpl-git-get-refs "heads")))))

  )

(use-package eat
  :demand t
  :straight (eat :type git
                 :host codeberg
                 :repo "akib/emacs-eat"
                 :files ("*.el" ("term" "term/*.el") "*.texi"
                         "*.ti" ("terminfo/e" "terminfo/e/*")
                         ("terminfo/65" "terminfo/65/*")
                         ("integration" "integration/*")
                         (:exclude ".dir-locals.el" "*-tests.el")))
  ;; :custom
  ;; (eat-eshell-mode t)
  ;; :hook (
  ;;        ;; For `eat-eshell-mode'.
  ;;        (eshell-load . eat-eshell-mode)
  ;;        ;; For `eat-eshell-visual-command-mode'.
  ;;        (eshell-load . eat-eshell-visual-command-mode)
  ;;        )
  :init
  ;; For `eat-eshell-mode'.
  (add-hook 'eshell-load-hook #'eat-eshell-mode)

  ;; For `eat-eshell-visual-command-mode'.
  (add-hook 'eshell-load-hook #'eat-eshell-visual-command-mode)
  ;; :hook (
  ;;        ;; For `eat-eshell-mode'.
  ;;        (eshell-load . #'eat-eshell-mode)
  ;;        ;; For `eat-eshell-visual-command-mode'.
  ;;        (eshell-load . #'eat-eshell-visual-command-mode)
  ;;        )
  )

(use-package xterm-color
  :disabled
  :after (eshell)
  :hook
  (eshell-before-prompt-hook . (lambda ()
                                 (setq xterm-color-preserve-properties t)))

  :init
  (push 'eshell-preoutput-filter-functions 'xterm-color-filter)
  ;; :custom
  ;; (eshell-output-filter-functions (remove 'eshell-handle-ansi-color eshell-output-filter-functions))
  :config
  ;; (setenv "TERM" "xterm-256color")
  )

(use-package tramp
  ;; TODO check why tramp is causing an error
  :disabled t
  :custom
  (tramp-verbose 6) ;; aumentarlo para debug
  (tramp-terminal-type "tramp")
  ;; (tramp-default-method "ssh")
  ;;(tramp-chunksize 500)

  ;; The information about remote hosts is kept in the file specified in ‘tramp-persistency-file-name’. Keep this file.
  ;; If you are confident that files on remote hosts are not changed
  ;; out of Emacs’ control, set
  (remote-file-name-inhibit-cache nil) ;; esto puede ser mala idea, pero probemos
  (tramp-completion-reread-directory-timeout nil)
  :config
  ;; (defadvice projectile-on (around exlude-tramp activate)
  ;;   "This should disable projectile when visiting a remote file"
  ;;   (unless  (--any? (and it (file-remote-p it))
  ;;                    (list
  ;;                     (buffer-file-name)
  ;;                     list-buffers-directory
  ;;                     default-directory
  ;;                     ;; dired-directory
  ;;                     ))
  ;;     ad-do-it))
  (defadvice projectile-project-root (around ignore-remote first activate)
    (unless (file-remote-p default-directory) ad-do-it))
  )

(defun eval-connection (usr hst)
  (with-temp-buffer
    (let* ((user usr) (host hst)
           (init 0) (step 50)
           (sent init) (received init))
      (while (= sent received)
        (setq sent (+ sent step))
        (erase-buffer)
        (let ((proc (start-process (buffer-name) (current-buffer)
                                   "ssh" "-l" user host "wc" "-c")))
          (when (process-live-p proc)
            (process-send-string proc (make-string sent ?\ ))
            (process-send-eof proc)
            (process-send-eof proc))
          (while (not (progn (goto-char (point-min))
                             (re-search-forward "\\w+" (point-max) t)))
            (accept-process-output proc 1))
          (when (process-live-p proc)
            (setq received (string-to-number (match-string 0)))
            (delete-process proc)
            (message "Bytes sent: %s\tBytes received: %s" sent received)
            (sit-for 0))))
      (if (> sent (+ init step))
          (message "You should set ‘tramp-chunksize’ to a maximum of %s"
                   (- sent step))
        (message "Test does not work")
        (display-buffer (current-buffer))
        (sit-for 30))))
  )

(use-package esh-autosuggest
  :disabled
  :demand t
  :hook (
         (eshell-mode . esh-autosuggest-mode)
         )
  ;; If you have use-package-hook-name-suffix set to nil, uncomment and use the
  ;; line below instead:
  ;; :hook (eshell-mode-hook . esh-autosuggest-mode)
  :config
  )

(use-package eshell-z
  :hook (
         (eshell-mode .
                   (lambda ()
                     (require 'eshell-z)))
         )
  )

(use-package eshell-syntax-highlighting
  :after esh-mode
  :demand t ;; Install if not already installed.
  :config
  ;; Enable in all Eshell buffers.
  (eshell-syntax-highlighting-global-mode +1))

(use-package bash-completion
  :disabled
  :hook
  (shell-dynamic-complete-functions . bash-completion-dynamic-complete)
  :config
  (defun eshell-bash-completion ()
    (while (pcomplete-here
            (nth 2 (bash-completion-dynamic-complete-nocomint (save-excursion (eshell-bol) (point)) (point))))))

  (setq eshell-default-completion-function 'eshell-bash-completion)
  )

(use-package vterm)

;;; term.el ends here
