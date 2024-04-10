;; -*- lexical-binding: t; -*-

;;; Code:

(use-package emacs :ensure nil
  :demand t
  :custom
  (enable-recursive-minibuffers t)
  :mode
  ("\\.env.test$" . conf-mode)
  ("\\.env.local$" . conf-mode)
  ("\\.env.example$" . conf-mode)
  ("\\.env.sample$" . conf-mode)
  ("\\.env$" . conf-mode))

(use-package prog
  :demand t
  :ensure nil
  :straight (:type built-in)
  :init
  (setq-default c-basic-offset 4
                tab-width 4
                indent-tabs-mode nil)
  :config
  (setq-local indent-tabs-mode nil)
  :custom
  (indent-tabs-mode nil)
  )

(use-package breadcrumb
  :init
  (breadcrumb-mode)
  )

(use-package sideline
  :demand t
  :hook ((flycheck-mode . sideline-mode)   ; for `sideline-flycheck`
         (flymake-mode  . sideline-mode)   ; for `sideline-flymake`
         )
  :custom
  (sideline-backends-left-skip-current-line t)    ; don't display on current line (left)
  (sideline-backends-right-skip-current-line t)   ; don't display on current line (right)
  (sideline-order-left 'down)                     ; or 'up
  (sideline-order-right 'up)                      ; or 'down
  (sideline-format-left "%s   ")                  ; format for left aligment
  (sideline-format-right "   %s")                 ; format for right aligment
  (sideline-priority 100)                         ; overlays' priority
  (sideline-display-backend-name t)               ; display the backend name

  ;; (sideline-backends-left '(sideline-flycheck))
  ;; (sideline-backends-right '(sideline-lsp))
  (sideline-delay 0.5) ;;0.7)
  (sideline-display-backend-type 'inner)


  (sideline-backends-right '((sideline-lsp      . up)
                             (sideline-flycheck . down)
                             (sideline-flymake . down)
                             ))
  :config
  (defvar-local sideline-eglot--async-candidates-timer nil)
  (defvar-local sideline-eglot--ht-candidates nil)

  (defun sideline-eglot--async-candidates (callback &rest _)
    (when sideline-eglot--async-candidates-timer
      (cancel-timer sideline-eglot--async-candidates-timer)
      (setq sideline-eglot--async-candidates-timer nil))
    (let ((p (point)))
      (setq sideline-eglot--async-candidates-timer
            (run-with-idle-timer
             0.3 nil
             (lambda ()
               (setq sideline-eglot--ht-candidates (ht-create))
               (dolist (row (eglot-code-actions p))
                 (ht-set! sideline-eglot--ht-candidates (getf row :title) row))
               (funcall callback (ht-keys sideline-eglot--ht-candidates)))))))

  (defun sideline-eglot (command)
    "Eglot backend for sideline."
    (cl-case command
      (`candidates
       (cons :async #'sideline-eglot--async-candidates))
      (`action
       (lambda (candidate &rest _)
         (let ((matching-code-action (ht-get sideline-eglot--ht-candidates candidate)))
           (unless matching-code-action
             (error "Failed to find candidate: %s" candidate))
           (let ((command (getf matching-code-action :command))
                 (server (eglot-current-server)))
             (unless server
               (error "Server disappeared"))
             (eglot-execute-command server
                                    (getf command :command)
                                    (getf command :arguments))))))))
  )

(use-package sideline-flycheck
  :after '(sideline)
  ;; :hook (flycheck-mode . sideline-flycheck-setup)
  )

(use-package sideline-flymake
  :after '(sideline)
  :hook (flymake-mode . sideline-flymake-setup)
  :custom
  (sideline-flymake-display-mode 'point)
  )

(use-package sideline-lsp
  :hook (lsp-mode . sideline-mode)
  :custom
  (sideline-lsp-code-actions-prefix "")
  :custom-face
  (sideline-lsp-code-action
   ((((background light)) :foreground "DarkOrange")
    (t :foreground "red"))
   )
  )

(use-package eldoc
  :ensure nil
  )

(use-package eldoc-box
  :after eldoc
  :demand t
  :general
  (
   :keymap '(prog-mode override)
   :states '(normal)
   "K"   'eldoc-box-help-at-point
   )
  :config
  (defun rex/eldoc-box-scroll-up ()
    "Scroll up in `eldoc-box--frame'"
    (interactive)
    (with-current-buffer eldoc-box--buffer
      (with-selected-frame eldoc-box--frame
	(scroll-down 3))))
  (defun rex/eldoc-box-scroll-down ()
    "Scroll down in `eldoc-box--frame'"
    (interactive)
    (with-current-buffer eldoc-box--buffer
      (with-selected-frame eldoc-box--frame
	(scroll-up 3))))
  ;; this won't work without installing general; I include it as an example
  ;; see: https://github.com/skyler544/rex/blob/main/config/rex-keybindings.el
  :general
  (:keymaps 'eglot-mode-map
	    "S-k" 'rex/eldoc-box-scroll-up
	    "S-j" 'rex/eldoc-box-scroll-down
	    "M-h" 'eldoc-box-help-at-point))

(use-package origami
  :demand t
  :config
  (global-origami-mode)
  )

(use-package treemacs
  :disabled t
  :custom
  (treemacs-width 50)
  (treemacs-no-png-images nil)
  (treemacs-follow-mode t)
  )

(use-package rainbow-delimiters
  :delight
  :hook (prog-mode . rainbow-delimiters-mode)
  :demand t
  )

(use-package hl-line
  :ensure nil
  :defer 1
  :hook ((prog-mode . hl-line-mode)
         (yaml-mode . hl-line-mode))
  ;; :config
  ;; (global-hl-line-mode +1)
)

(use-package highlight-indent-guides
  :defer 1
  :delight
  :hook ((prog-mode . highlight-indent-guides-mode)
         (yaml-mode . highlight-indent-guides-mode))
  :custom
  (highlight-indent-guides-method 'character
                                  ;; 'column
                                  )
  (highlight-indent-guides-character ?║ ;; U+2551
  ;; (highlight-indent-guides-character "|" ;; U+2551
                                     )
  (highlight-indent-guides-responsive ;;'top
                                      'stack
                                      )
  ;; :config
  ;; (set-face-background 'highlight-indent-guides-odd-face "blue")
  ;; (set-face-background 'highlight-indent-guides-even-face "green")
  ;; (set-face-foreground 'highlight-indent-guides-character-face "red")

  )

(use-package indent-guide
  :disabled t
  :unless '(highlight-indent-guides)
  :init
  ;; (add-hook 'yaml-mode-hook 'indent-guide-mode)
  (indent-guide-global-mode)
  :custom
  (indent-guide-char "|")
  )

(use-package nhexl-mode
  :custom
  (nhexl-display-unprintables t)
  (nhexl-line-width t)
  (nhexl-obey-font-lock nil)
  (nhexl-separate-line nil)
  (nhexl-silently-convert-to-unibyte t)
  )

(use-package highlight-indentation
  :disabled t
  :delight
  :config
  ;; (set-face-background 'highlight-indentation-face "lightgray")
  ;; (set-face-background 'highlight-indentation-current-column-face "#c334b3")
  )

(use-package smart-tabs-mode
  :config
  (progn (smart-tabs-insinuate 'c 'c++)))

(use-package realgud)
(use-package realgud-ipdb)
(use-package realgud-pry)

;;; code-editor.el ends here
