;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package ruby-mode
  :ensure nil
  :hook ((ruby-mode . robe-mode)
         (ruby-ts-mode . robe-mode))
  :custom
  (ruby-insert-encoding-magic-comment nil)
  ;; :config
  ;; :general
  ;; (
  ;;  :keymaps '(ruby-mode-map)
  ;;           ;; :states '(normal insert)
  ;;  )
  )

(use-package rvm
  :disabled t
  :after '(robe)
  :init
  (advice-add 'inf-ruby-console-auto :before #'rvm-activate-corresponding-ruby)
  )

(use-package rbenv)

(use-package robe
  :after '(ruby-mode)
  ;; :hook ((ruby-mode-hook)
  ;;        (ruby-ts-mode-hook))
  ;; :config
  ;; ;; (push 'company-robe company-backends)
  ;; ;; (add-to-list 'completion-at-point-functions #'company-robe)
  ;; (setq-local completion-at-point-functions
  ;;             (mapcar #'cape-company-to-capf
  ;;                     (list #'company-robe)))
  )

(use-package inf-ruby
  ;; :after ruby-mode
  ;; ;; :hook (ruby-mode . 'inf-ruby-keys)
  ;; ;;:config

  ;; ;(define-key ruby-mode-map [S-f7] 'ruby-compilation-this-buffer)
  ;; ;;(eval-after-load 'ruby-mode
  ;; ;;'(add-hook 'ruby-mode-hook 'inf-ruby-keys))

  ;; ;; (define-key ruby-mode-map (kbd "C-c C-c") 'inf-ruby)
  ;; ;; :hook (ruby-mode . inf-ruby)
  ;; :general
  ;; (
  ;;  :keymaps '(ruby-mode-map enh-ruby-mode-map)
  ;;           ;; :states '(normal insert)
  ;;           "C-M-x" 'ruby-send-block
  ;;           "C-c C-c" 'ruby-send-buffer-or-create-inf-ruby-buffer
  ;;  )
  ;; :config
  ;; (inf-ruby-minor-mode +1)

  ;; (defun ruby-send-buffer-or-create-inf-ruby-buffer ()
  ;;   "Crea un buffer para inf-ruby, en caso de no existir, y manda la definicion actual."
  ;;   (interactive)
  ;;   (if (get-buffer-process (if (eq major-mode 'inf-ruby-mode)
  ;;                               (current-buffer)
  ;;                             (or (inf-ruby-buffer)
  ;;                                 inf-ruby-buffer)))
  ;;                                       ; (ruby-send-buffer-and-go)
  ;;       (ruby-send-definition)
  ;;     (progn
  ;;       (inf-ruby)
  ;;       ;; TODO: buffer is not being sent
  ;;       (ruby-send-buffer))))
  )

(use-package enh-ruby-mode
  :disabled t
  :hook
  ((ruby-mode)
   (enh-ruby-mode . 'yard-mode))

  ;; :ensure-system-package
  ;; ((ruby-lint   . "gem install ruby-lint")
  ;;  ;; (ripper-tags . "gem install ripper-tags")
  ;;  (ripper . "gem install ripper")
  ;;  (pry         . "gem install pry"))
  :mode "\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'"
  ;; :init
  ;; (add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
  ;; (add-to-list 'auto-mode-alist
  ;;              '("\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'" . enh-ruby-mode))
  :config
  (add-hook 'enh-ruby-mode-hook 'robe-mode)
  )

;; (use-package rubocop
;;   :ensure-system-package
;;   ((rubocop     . "sudo gem install rubocop"))
;;   )

(use-package ruby-electric
  :hook ((ruby-mode . ruby-electric-mode)
         (enh-ruby-mode . ruby-electric-mode)))

(use-package rake
  :general
  (
   :keymaps '(ruby-mode-map enh-ruby-mode-map)
            "C-!" 'rake))

(use-package slim-mode)

;;; ruby.el ends here
