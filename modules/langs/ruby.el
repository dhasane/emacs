
;;(use-package solargraph
	;;:ensure t
	;;:config
	;;(define-key ruby-mode-map (kbd "M-i") 'solargraph:complete)
	;;)

(setq ruby-indent-tabs-mode nil)

(defun ruby-send-buffer-or-create-inf-ruby-buffer ()
  "Crea un buffer para inf-ruby, en caso de no existir, y manda el buffer actual de ruby."
  (interactive)
  (if (get-buffer-process (if (eq major-mode 'inf-ruby-mode)
                              (current-buffer)
                            (or (inf-ruby-buffer)
                                inf-ruby-buffer)))
      (ruby-send-buffer-and-go)
    (inf-ruby)
      ))

(use-package enh-ruby-mode
  :bind
  (:map
   enh-ruby-mode-map
   ("C-M-x" . ruby-send-block)
   ;; ("C-c C-c" . inf-ruby)
   ("C-c C-c" . #'ruby-send-buffer-or-create-inf-ruby-buffer)
   )

  ;; (general-define-key
  ;;  :states 'normal
  ;;  :keymaps 'ruby-mode-map
  ;;  ;; or xref equivalent
  ;;  "g d" ')

  ;; :ensure-system-package
  ;; ((ruby-lint   . "gem install ruby-lint")
  ;;  ;; (ripper-tags . "gem install ripper-tags")
  ;;  (ripper . "gem install ripper")
  ;;  (pry         . "gem install pry"))
  ;; :mode "\\.rb\\"
  :init
  (add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
  (add-to-list 'auto-mode-alist
             '("\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'" . enh-ruby-mode))
  :config
  (add-hook 'enh-ruby-mode-hook 'robe-mode)
  (add-hook 'enh-ruby-mode-hook 'yard-mode)
  )

;; (use-package rubocop
;;   :ensure-system-package
;;   ((rubocop     . "sudo gem install rubocop"))
;;   )

;; (use-package solargraph
;;
;;   :ensure-system-package
;;   (
;;    (solargraph . "gem install solargraph")
;;    ((expand-file-name "elisp/emacs-solargraph" user-emacs-directory)
;;     . "git clone https://github.com/guskovd/emacs-solargraph")
;;    )
;;   )

(use-package inf-ruby
  ;; :after ruby-mode
  ;; :hook (ruby-mode . 'inf-ruby-keys)
  ;;:config

  ;(define-key ruby-mode-map [S-f7] 'ruby-compilation-this-buffer)
  ;;(eval-after-load 'ruby-mode
  ;;'(add-hook 'ruby-mode-hook 'inf-ruby-keys))

  ;; (define-key ruby-mode-map (kbd "C-c C-c") 'inf-ruby)
  ;; :hook (ruby-mode . inf-ruby)

  )

(use-package ruby-electric
  :hook (( ruby-mode . (lambda () (ruby-electric-mode t))))
  )

(use-package robe
  :ensure t
  :after (company ruby-mode)
  :hook (ruby-mode . robe-mode)
  :config
  (push 'company-robe company-backends)
  )
