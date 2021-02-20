;;; package --- Summary

;;; Commentary:
;;; Configuracion para eshel y term

;;; code:

;; -*- lexical-binding: t; -*-

(use-package keychain-environment
  ;; :hook (tramp-mode . keychain-refresh-environment)
  :config
  (add-hook 'tramp-mode-hook 'keychain-refresh-environment)
  )

(add-hook 'eshell-mode-hook (lambda () (set (make-local-variable 'scroll-margin) 0)))
(add-hook 'shell-mode-hook (lambda () (set (make-local-variable 'scroll-margin) 0)))
(add-hook 'term-mode-hook (lambda () (set (make-local-variable 'scroll-margin) 0)))

(defun eshell-new()
  "Open a new instance of eshell."
  (interactive)
  (eshell 'N))

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
                  (if (projectile-project-p)
                      (projectile-project-name)
                    (concat default-directory)
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

(use-package eshell
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
              (rename-buffer
               (concat "*eshell*<"
                       (if (projectile-project-p)
                           (projectile-project-name)
                         (concat default-directory)
                         )
                       ">")
               )
              )
            )

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
  )

(use-package pcomplete
  :custom
  (pcomplete-ignore-case t)
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
  "Asks for a command and execute it in inferior shell with current buffer as input."
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   (read-shell-command "Shell command on buffer: ")))
