
;;(use-package solargraph
	;;:ensure t
	;;:config
	;;(define-key ruby-mode-map (kbd "M-i") 'solargraph:complete)
	;;)

(setq ruby-indent-tabs-mode nil)

;; When folding, take these delimiters into consideration
;; (add-to-list 'hs-special-modes-alist
;;              '(ruby-mode
;;                "\\(class\\|def\\|do\\|if\\)" "\\(end\\)" "#"
;;                (lambda (arg) (ruby-end-of-block)) nil))

(use-package ruby-mode
  )

(use-package inf-ruby
  ;; :disabled
  :ensure t
  :after ruby-mode
  :bind
  (:map
   ruby-mode-map
   ("C-M-x" . ruby-send-block)
   )
  :hook (ruby-mode . 'inf-ruby-keys)
  ;;:config

  ;(define-key ruby-mode-map [S-f7] 'ruby-compilation-this-buffer)
  ;;(eval-after-load 'ruby-mode
  ;;'(add-hook 'ruby-mode-hook 'inf-ruby-keys))

  ;; (define-key ruby-mode-map (kbd "C-c C-c") 'inf-ruby)
  ;; :hook (ruby-mode . inf-ruby)

  )

(use-package ruby-electric
  :hook (
         ( ruby-mode . (lambda () (ruby-electric-mode t)))
         )
  )

(use-package robe
	:ensure t
	:after (company ruby-mode)
	:hook (ruby-mode . robe-mode)
	:config
    (push 'company-robe company-backends)
    )
