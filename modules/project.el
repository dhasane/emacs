
;;; Code:

;; Projectile
(use-package projectile
  :ensure t
  :defer .1
  :bind
  (
   :map
   projectile-mode-map
   ("M-p" . 'projectile-command-map)
   )
  :init
  (setq projectile-require-project-root nil)
  :config
  (projectile-mode +1)
  ;; (setq projectile-project-search-path '("~/projects/" "~/work/"))
  (setq projectile-project-search-path '("~/dev/"))
  (setq projectile-sort-order 'recently-active)
  (setq projectile-completion-system 'ivy)
  )

(use-package midnight
  :config
  (midnight-delay-set 'midnight-delay "5:30am")
  (setq clean-buffer-list-delay-general 3)
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
  )

;; eliminar espacios al final de una linea
;; (add-hook 'before-save-hook 'delete-trailing-whitespace)
(use-package ws-butler
  :ensure t
  :defer .1
  :hook (
         (prog-mode . ws-butler-mode)
         )
  )

;; tramp ---------------------------------------------------

(use-package tramp
  :defer t
  :config
  (setq tramp-default-method "ssh")
  (setq tramp-terminal-type "tramp")
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
