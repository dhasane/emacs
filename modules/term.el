;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; Configuracion para eshel y term

;;; code:

(use-package keychain-environment
  ;; :hook (tramp-mode . keychain-refresh-environment)
  :config
  (add-hook 'tramp-mode-hook 'keychain-refresh-environment)
  )

;; ejemplos:
;; (defun test-main ()
;;   (interactive)
;;   (let ((choice (completing-read "Select: " '("item1" "item2" "item3"))))
;;     (message choice)))
;; (let ((algo '(("foobar1" 1) ("barfoo" 2) ("foobaz" 3) ("foobar2" 4))))
;;   (completing-read
;;    "Complete a foo: "
;;    algo
;;    nil t "fo")
;;   )

(defun dh/select-eshell ()
  "Seleccionar entre los buffers de eshell."
  (interactive)
  (let ((buffers
         (mapcar
          (lambda (eshbuf) ;; retorna una lista del nombre con su buffer
            (list (buffer-name eshbuf) eshbuf)
            )
          (seq-filter (lambda (buf) ;; filtra por buffers con eshel
                        (string-match-p "*eshell*" (buffer-name buf)))
                      (buffer-list))
          )
         )
        )
    (if buffers
        (switch-to-buffer
         (completing-read
          "Select: "
          buffers
          nil t
          (get-project-name-except-if-remote)
          )
         )
      (message "No hay buffers de eshell")
      )
    )
  )

;; TODO: crear una terminal del tipo seleccionado
(defun dh/create-shell-type ()
  "Seleccionar entre los buffers de eshell."
  (interactive)
  (let ((terminales '("eshell" "vterm")))
    (setq sel-term
          (completing-read
           "Select: "
           terminales
           nil t
           ))
    )
  )

(defun dh/eshell-buffer-name ()
  "Conseguir el nombre de una terminal.
Se tiene en cuenta la carpeta actual, el proyecto y la cantidad de
terminales en esta ubicacion."
  (let (
        (nombre-base (concat "*eshell*"
                             (get-project-name-except-if-remote
                              :pre "["
                              :pos "]"
                              )
                             "<"
                             (if (get-buffer-process
                                  (current-buffer))
                                 (format "%s" (get-buffer-process
                                               (current-buffer)
                                               ))
                                 default-directory
                                 )
                             ">"
                             )
         )
        (extra "")
        )
    ;; TODO: en caso de que empiece un proceso largo, encontrar como llamar esta funcion

    ;; si ya existe, agregarle un numero al final
    (if (member nombre-base (mapcar (lambda (buf)
                                      (buffer-name buf))
                                    (buffer-list)))
        (let ((buffers-mismo-nombre (seq-filter
                                     (lambda (buf)
                                       (string-prefix-p nombre-base (buffer-name buf)))
                                     (buffer-list))
                                    )
              (i 1)
              )
          ;; (message (format "%s" buffers-mismo-nombre))
          ;; (message (format "%s %s" (concat nombre-base extra) buffers-mismo-nombre))
          ;; (message (format "%s" (member (concat nombre-base extra) buffers-mismo-nombre)))

          ;; puede no ser lo mas eficiente, pero funciona
          (while (member (concat nombre-base extra)
                         (mapcar (lambda (buf)
                                   (buffer-name buf))
                                 buffers-mismo-nombre))
            ;; (message (format "i: %s" i))
            (setq extra (format "%s" i))
            (setq i (+ i 1)))
          )
      )
    (concat nombre-base extra)
    )
  )

(defun dh/create-new-eshell-buffer ()
  (interactive)
  (let* ((nombre (dh/eshell-buffer-name))
         )
    (eshell 99)
    (rename-buffer nombre)
    )
  )

(add-hook 'eshell-mode-hook (lambda () (set (make-local-variable 'scroll-margin) 0)))
(add-hook 'shell-mode-hook (lambda () (set (make-local-variable 'scroll-margin) 0)))
(add-hook 'term-mode-hook (lambda () (set (make-local-variable 'scroll-margin) 0)))

(defun eshell-new()
  "Open a new instance of eshell."
  (interactive)
  (eshell 'N))

(defun display-ansi-colors ()
  (interactive)
  (format-decode-buffer 'ansi-colors))

(defun dh/open-create-eshell-buffer ()
  "Crear un buffer nuevo, o saltar a uno ya existente.
Se crea con el nombre de la carpeta en la que se encuentre.
Adicionalmente, en caso de estar dentro de un proyecto, se utiliza
proyectile para darle nombre al buffer, de forma que se comparta
por todo el proyecto.
"
  (interactive)
  (let* ((nombre
          (concat "*eshell*<"
                  (get-project-name-except-if-remote
                   :else (concat default-directory)
                   )
                  ">")
          )
         (eshell-buffer-exists
          (member nombre
                  (mapcar (lambda (buf)
                            (buffer-name buf))
                          (buffer-list)))))
    (if eshell-buffer-exists
        (switch-to-buffer nombre)
      (progn
        (eshell 99)
        (rename-buffer nombre))))

  )

(use-package pcomplete
  :demand t
  :custom
  (pcomplete-ignore-case t)
  )

(use-package eshell
  :hook (
        (eshell-mode . visual-line-mode)
         )
  :defines
  (
   eshell
   eshell-visual-commands
   eshell-visual-subcommands
   eshell-mode-map
   eshell-prompt-function
   eshell-highlight-prompt
   eshell-kill-on-exit
   )
  :functions
  (
   eshell-kill-on-exit
   )
  :custom
  (eshell-destroy-buffer-when-process-dies t)
  (eshell-banner-message "")
  (setenv "TERM" "dumb")
  :init
  (setq eshell-visual-subcommands
        '(
          ("sudo" "pacman")
          ("sudo" "apt")
          ))
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
                      "irb"
                      )
                    )
              )
            )
  (add-to-list 'display-buffer-alist
                 '("sudo". ((display-buffer-pop-up-window) .
                             ((inhibit-same-window . t)))))
  :config

  (setq ivy-do-completion-in-region t) ; this is the default

  (defun setup-eshell-ivy-completion ()
    (interactive)
    ;; (define-key eshell-mode-map [remap eshell-pcomplete] 'completion-at-point)
    ;; only if you want to use the minibuffer for completions instead of the
    ;; in-buffer interface
    (setq-local ivy-display-functions-alist
                (remq (assoc 'ivy-completion-in-region ivy-display-functions-alist)
                      ivy-display-functions-alist)))

  (add-hook 'eshell-mode-hook #'setup-eshell-ivy-completion)

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
        eshell-highlight-prompt t
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
      ))

  (defun eshell/upd ()
    "Update system"
    ;;TODO: identificar el sistema para actualizar
    )

  (defun pcomplete/mk ()
    "Completion rules for the `make' command."
    ;; mk esta definido en eshell/alias
    (pcomplete/make)
    )

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
          (add-to-list 'ref-list (match-string 1)))
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

(use-package xterm-color
  :disabled
  :after (eshell)
  :hook
  (eshell-before-prompt-hook . (lambda ()
                                 (setq xterm-color-preserve-properties t)))

  :init
  (add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)
  ;; :custom
  ;; (eshell-output-filter-functions (remove 'eshell-handle-ansi-color eshell-output-filter-functions))
  :config
  ;; (setenv "TERM" "xterm-256color")
  )

(use-package tramp
  :custom
  (tramp-verbose 1) ;; aumentarlo para debug
  (tramp-terminal-type "tramp")
  ;; (tramp-default-method "ssh")
  ;;(tramp-chunksize 500)

  ;; The information about remote hosts is kept in the file specified in ‘tramp-persistency-file-name’. Keep this file.
  ;; If you are confident that files on remote hosts are not changed
  ;; out of Emacs’ control, set
  (remote-file-name-inhibit-cache nil) ;; esto puede ser mala idea, pero probemos
  (tramp-completion-reread-directory-timeout nil)
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
  :ensure t
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
  :hook
  (shell-dynamic-complete-functions . bash-completion-dynamic-complete)
  :config
  (defun eshell-bash-completion ()
    (while (pcomplete-here
            (nth 2 (bash-completion-dynamic-complete-nocomint (save-excursion (eshell-bol) (point)) (point))))))

  (setq eshell-default-completion-function 'eshell-bash-completion)
  )

(use-package vterm
  )

;; comint

(defun comint-jump-to-input-ring ()
  "Jump to the buffer containing the input history."
  (interactive)
  (progn
    (comint-dynamic-list-input-ring)
    (other-window 1)))

(setq comint-prompt-read-only t)    ; "Make the prompt read only."
;; (setq comint-buffer-maximum-size 2000)

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

;;; term.el ends here
