;;; runners.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Compilation and task runner tools

;;; code:

(use-package compile
  :ensure nil
  :hook
  (
   ;; Add color formatting to *compilation* buffer
   (compilation . (lambda () (setenv "TERM" "dumb")))
   (compilation-filter . #'ansi-color-compilation-filter)
   (compilation-filter . comint-truncate-buffer)
   )
  :custom
  (compilation-scroll-output t)
  ;; (compilation-scroll-output 'first-error)
  ;; (compilation-ask-about-save nil)
  :general
  ;; ("<f5>" (lambda ()
  ;;           (interactive)
  ;;           ;; (setq-local compilation-read-command nil)
  ;;           (call-interactively 'compile))
  ;;  )
  (dahas-comp-map
   ;; "s" '(deets/side-window-toggle :wk "side window")
   "c" '((lambda ()
            (interactive)
            ;; (setq-local compilation-read-command nil)
            (call-interactively 'compile))
         :wk "compile")
   )
  :config
  (setq switch-to-buffer-obey-display-actions t)
  ;; Introduce a bottom side window that catches
  ;; compilations, deadgreps etc.
  ;; (add-to-list 'display-buffer-alist
  ;;              '("\\*deadgrep.*\\|\\*Compilation\\*"
  ;;                (display-buffer-in-side-window)
  ;;                (side . bottom)
  ;;                (slot . 0)
  ;;                (window-parameters
  ;;                 (no-delete-other-windows . t))))

  (defun deets/side-window-resize (enlarge)
    (let ((bottom-windows (window-at-side-list (window-normalize-frame nil) 'bottom)))
      (dolist (window bottom-windows)
        (when (symbolp (window-parameter window 'window-side))
          (if enlarge
              (window-resize window (window-height window))
            (window-resize window (- (/ (window-height window) 2))))))))

  (defun deets/side-window-toggle (arg)
    (interactive "P")
    (cond ((null arg) (window-toggle-side-windows))
          ((listp arg) (deets/side-window-resize t))
          ((symbolp arg) (deets/side-window-resize nil))))

  ;; Remove our side-windows
  ;; (global-set-key (read-kbd-macro "C-x w") 'deets/side-window-toggle)
  )

(defun byte-compile-this-file+ ()
  (byte-compile-file (buffer-file-name)))

;; TODO: arreglar esto
(defun parse-package_json-scripts ()
  (interactive)
  (let ((pkg (json-parse-string (buffer-substring-no-properties (point-min) (point-max)))))
    (mapcar
     (lambda (key value)
       (message "%s %s" key value)
       ((concat "npm:" key) . value)
       )
     (gethash "scripts" pkg))
    ))

(use-package load-env-vars
  :commands (load-env-vars))

(use-package compile-multi
  :commands (compile-multi)
  :custom
  (compile-multi-default-directory #'projectile-project-root)

  (compile-multi-config
   `(
     (t ; siempre
      ("general:pwd" . "pwd")
      )

     (emacs-lisp-mode
      ("emacs:bytecompile" . ,#'byte-compile-this-file+))

     (rust-ts-mode
      ("rust:debug" . "cargo run")
      ("rust:release" . "cargo run --release")
      ("rust:test" . "cargo test"))

     (python-mode
      ("python:pylint" "python3" "-m" "pylint" (buffer-file-name)))

     ((file-exists-p "package-lock.json")
      ("npm:update" . ,#'(lambda () (call-interactively 'npm-update)))
      ("npm:install" . ,#'(lambda () (call-interactively 'npm-install)))
      ("npm:run" . ,#'(lambda () (call-interactively 'npm-run)))
      ("npm:outdated" . "npm outdated")
      )

     ((file-exists-p "node_modules")
      ("npm:clean" . "rm -rf ./node_modules")
      )

     ((file-exists-p "Gemfile")
      ("Gem:install" . "bundle install")
      ("Gem:test" . "bundle exec rspec")
      )

     ((file-exists-p ".nvmrc")
      ("nvm:nvm use" . ,#'nvm-use-for)
      )

     ((directory-files "." t "^.env")
      ("env:load env" . ,#'(lambda () (call-interactively 'load-env-vars)))
      )

     ((file-exists-p ".snyk")
      ("snyk:test" . "snyk test")
      )
     )))

(use-package consult-compile-multi
  :ensure t
  :after compile-multi
  :demand t
  :config (consult-compile-multi-mode))

(use-package compile-multi-all-the-icons
  :ensure t
  :after all-the-icons-completion
  :after compile-multi
  :demand t)

(use-package prodigy
  :general
  (dahas-manage-map
   "p" '(prodigy :wk "prodigy"))

  :config
  (prodigy-define-status :id 'working :face 'prodigy-yellow-face)
  (defvar my-prodigy-service-counts nil "Map of status ID to number of Prodigy processes with that status")
  (advice-add
   'prodigy-set-status
   :before
   (lambda (service new-status)
     (let* ((old-status (plist-get service :status))
            (old-status-count (or 0 (alist-get old-status my-prodigy-service-counts)))
            (new-status-count (or 0 (alist-get new-status my-prodigy-service-counts))))
       (when old-status
         (setf (alist-get old-status my-prodigy-service-counts) (max 0 (- old-status-count 1))))
       (setf (alist-get new-status my-prodigy-service-counts) (+ 1 new-status-count))
       (force-mode-line-update t))))

  (defun my-prodigy-working-count ()
    "Number of services with the 'working' status."
    (let ((count (alist-get 'working my-prodigy-service-counts 0)))
      (when (> count 0)
        (format "W:%d" count))))

  (defun my-prodigy-failed-count ()
    "Number of services with the 'failed' status."
    (let ((count (alist-get 'failed my-prodigy-service-counts 0)))
      (if (> count 0)
          (format "F:%d" count)
        "")))

  ;; (prodigy-define-service
  ;;   :name "Python http server"
  ;;   :command "python3"
  ;;   :args '("-m" "http.server" "8000")
  ;;   ;; :cwd "."
  ;;   :tags '(python web)
  ;;   :stop-signal 'sigkill
  ;;   :kill-process-buffer-on-stop t)
  )

;;; runners.el ends here
