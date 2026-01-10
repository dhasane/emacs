;; -*- lexical-binding: t; -*-

;;; Code:

(use-package emacs :ensure nil
  :demand t
  :custom
  (enable-recursive-minibuffers nil)
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
  :custom
  (breadcrumb-idle-time 100)
  :init
  (breadcrumb-mode)
  )

(use-package sideline
  :hook ((flycheck-mode . sideline-mode)   ; for `sideline-flycheck`
         (flymake-mode  . sideline-mode))  ; for `sideline-flymake`
  :custom
  (sideline-backends-left-skip-current-line t)    ; don't display on current line (left)
  (sideline-backends-right-skip-current-line t)   ; don't display on current line (right)
  (sideline-order-left 'down)                     ; or 'up
  (sideline-order-right 'up)                      ; or 'down
  (sideline-format-left "%s   ")                  ; format for left aligment
  (sideline-format-right "   %s")                 ; format for right aligment
  (sideline-priority 100)                         ; overlays' priority
  (sideline-display-backend-name t)               ; display the backend name

  (sideline-delay 0.2)

  (sideline-backends-left '(sideline-flycheck))
  (sideline-backends-right '((sideline-lsp      . up)
                             (sideline-flycheck . down)
                             (sideline-flymake . down)
                             ))
  :config
  (add-hook 'ts-fold-on-fold-hook #'sideline-render-this)
  )

(use-package sideline-flycheck
  :hook
  (flycheck-mode . sideline-mode)
  (flycheck-mode . sideline-flycheck-setup)
  :custom
  (sideline-flycheck-display-mode 'line)
  (sideline-flycheck-max-lines 1)
  (sideline-backends-right '(sideline-flycheck)))

(use-package sideline-flymake
  :custom
  (sideline-flymake-display-mode 'line))

(use-package eldoc
  :ensure nil
  :custom
  (eldoc-idle-delay 0.2)
  (eldoc-echo-area-use-multiline-p nil)
  :config
  (remove-hook 'eldoc-display-functions 'eldoc-display-in-echo-area)
  )

(use-package eldoc-box
  :after eldoc
  :demand t
  :general
  (
   ;; :keymap '(prog-mode override)
   :keymap 'eglot-mode
   :states 'normal
   "K"   #'eldoc-box-help-at-point ; eldoc-box-eglot-help-at-point
   "M-K" #'eldoc-doc-buffer
   )
  ;; (:keymaps 'eglot-mode-map
	;;     "K" 'rex/eldoc-box-scroll-up
	;;     "J" 'rex/eldoc-box-scroll-down
  ;;     )
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
  )

(use-package origami
  :demand t
  :config
  (global-origami-mode)
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

(use-package nhexl-mode
  :custom
  (nhexl-display-unprintables t)
  (nhexl-line-width t)
  (nhexl-obey-font-lock nil)
  (nhexl-separate-line nil)
  (nhexl-silently-convert-to-unibyte t)
  )

(use-package smart-tabs-mode
  :config
  (progn (smart-tabs-insinuate 'c 'c++)))

(use-package realgud)
(use-package realgud-ipdb)
(use-package realgud-pry)

;;; code-editor.el ends here
