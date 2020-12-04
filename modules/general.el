

;;; Code:

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(use-package nix-mode
  :ensure t)

(use-package which-key
  :ensure t
  :demand t
  :defer .1
  :config
  (which-key-setup-side-window-right-bottom)
  ;; (setq which-key-max-description-length 27)
  (setq which-key-unicode-correction 3)
  (setq which-key-show-prefix 'left)
  (setq which-key-side-window-max-width 0.33)
  ;; (setq which-key-popup-type 'side-window)
  ;; (setq which-key-popup-type 'frame)
  ;; ;; max width of which-key frame: number of columns (an integer)
  ;; (setq which-key-frame-max-width 60)
  ;;
  ;; ;; max height of which-key frame: number of lines (an integer)
  ;; (setq which-key-frame-max-height 20)
  (which-key-mode)
  )

;; eliminar espacios al final de una linea
;; (add-hook 'before-save-hook 'delete-trailing-whitespace)
(use-package ws-butler
  :demand t
  :ensure t
  :defer .1
  :hook (
         (prog-mode . ws-butler-mode)
         (org-mode . ws-butler-mode)
         )
  )

(use-package midnight
  :demand t
  :config
  (midnight-delay-set 'midnight-delay "5:30am")
  (setq clean-buffer-list-delay-general 3)
  (setq clean-buffer-list-delay-special (* 2 3600)) ;; cada 2 horas
  ;; adicionales para cerrar
  (setq clean-buffer-list-kill-buffer-names
        (nconc clean-buffer-list-kill-buffer-names
               '("*buffer-selection*"
                 "*Finder*"
                 "*Finder Category*"
                 "*Finder-package*"
                 "*RE-Builder*"
                 "*vc-change-log*")))
  ;; no cerrar estos buffers
  (setq clean-buffer-list-kill-never-buffer-names
        (nconc clean-buffer-list-kill-never-buffer-names
               '("*eshell*"
                 "*ielm*"
                 "*mail*"
                 "*w3m*"
                 "*w3m-cache*")))
  (setq clean-buffer-list-kill-regexps
        (nconc clean-buffer-list-kill-regexps
               '(
                 "\\`\\*Customize .*\\*\\'"
                 "\\`\\*\\(Wo\\)?Man .*\\*\\'"
                 )))
  )

(use-package highlight-indentation
  :config
  ;; (set-face-background 'highlight-indentation-face "lightgray")
  ;; (set-face-background 'highlight-indentation-current-column-face "#c334b3")
  )

;; (use-package rainbow-blocks
  ;; )

(use-package proced
  :custom
  (proced-auto-update-flag t)
  )

;; (use-package restart-emacs
;;   )

(use-package origami
  :demand t
  :config
  (global-origami-mode)
  )

(use-package undo-tree
  :demand t
  :config
  ;; (setq ;; undo-tree-show-minibuffer-help t
  ;;       ;; undo-tree-auto-save-history t
  ;;       )
  (global-undo-tree-mode)
  )

;; tramp ---------------------------------------------------

(use-package tramp
  :defer t
  :config
  (setq tramp-default-method "ssh")
  (setq tramp-terminal-type "tramp")
  (setq tramp-verbose 6) ;; ver si tramp se alentiza por algo
  ;;(setq tramp-chunksize 500)
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

(use-package ranger
  :demand t
  :custom
  (ranger-override-dired-mode t)
  (ranger-return-to-ranger t)
  (ranger-show-hidden t)
  :config
  (ranger-show-file-details)
  (ranger-override-dired-mode t)
  )
