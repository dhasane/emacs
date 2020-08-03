
;;(use-package solargraph
	;;:ensure t
	;;:config
	;;(define-key ruby-mode-map (kbd "M-i") 'solargraph:complete)
	;;)

(setq ruby-indent-tabs-mode nil)

(use-package ruby-mode
  :bind
  (:map
   ruby-mode-map
   ("C-M-x" . ruby-send-block)
   ("C-c C-c" . inf-ruby)
   )
  ;; (with-eval-after-load 'evil
  ;;   ;; (evil-define-key 'normal ruby-mode--mode-map (kbd "] ]") 'eshell-next-prompt)
  ;;   ;; (evil-define-key 'normal eshell-mode-map (kbd "[ [") 'eshell-previous-prompt)
  ;;   ;; (evil-define-key 'normal eshell-mode-map (kbd "C-d") 'eshell/exit) ;; ni idea
  ;;   )

  ;; (general-define-key
  ;;  :states 'normal
  ;;  :keymaps 'ruby-mode-map
  ;;  ;; or xref equivalent
  ;;  "g d" 'elisp-slime-nav-describe-elisp-thing-at-point)

  :ensure-system-package
  ((ruby-lint   . "sudo gem install ruby-lint")
   ;; (ripper-tags . "gem install ripper-tags")
   (pry         . "sudo gem install pry")))

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
