

;;; Code:


;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp"))
;;(use-package aweshell
	;;:load-path "~/.emacs.d/elisp/aweshell"
	;;)

(defun eshell-new()
  "Open a new instance of eshell."
  (interactive)
  (eshell 'N))

(use-package eshell
  :init
  (add-hook 'eshell-mode-hook
            (lambda ()
              (add-to-list 'eshell-visual-commands "ssh")
              (add-to-list 'eshell-visual-commands "tail")
              (add-to-list 'eshell-visual-commands "top")
              (add-to-list 'eshell-visual-commands "less")
              (add-to-list 'eshell-visual-commands "vim")
              (add-to-list 'eshell-visual-commands "pacman")
              (add-to-list 'eshell-visual-commands "apt")
              )
            )
  ;;:bind
  ;;(:map
   ;;eshell-mode-map
   ;;("C-d" . (lambda ()
			  ;;(interactive)
			  ;;(throw 'eshell-terminal t) )
	;;)
   ;;)
  :config

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

(defun term-handle-exit--close-buffer (&rest args)
  (when (null (get-buffer-process (current-buffer)))
    (insert "Press <C-d> to kill the buffer.")
    (use-local-map (let ((map (make-sparse-keymap)))
                     (define-key map (kbd "C-d")
                       (lambda ()
                         (interactive)
                         (kill-buffer (current-buffer))))
                     map))))
(advice-add 'term-handle-exit :after #'term-handle-exit--close-buffer)

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
