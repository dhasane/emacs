
;;(use-package solargraph
	;;:ensure t
	;;:config
	;;(define-key ruby-mode-map (kbd "M-i") 'solargraph:complete)
	;;)

(setq ruby-indent-tabs-mode nil)

(use-package inf-ruby
  :ensure t
  :bind
  (:map
   ruby-mode-map
   ("C-c C-c" . inf-ruby)
   ("C-M-x" . ruby-send-block)
   )
  :hook
  (ruby-mode . 'inf-ruby-keys)
  ;;:config

  ;(define-key ruby-mode-map [S-f7] 'ruby-compilation-this-buffer)
  ;;(eval-after-load 'ruby-mode
  ;;'(add-hook 'ruby-mode-hook 'inf-ruby-keys))

  ;; (define-key ruby-mode-map (kbd "C-c C-c") 'inf-ruby)
  ;; :hook (ruby-mode . inf-ruby)

  )

(use-package robe
	:ensure t
	:after company
	:hook (ruby-mode . robe-mode)
	:config
    '(push 'company-robe company-backends)
    )
