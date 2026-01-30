;;; code-editor.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Editing UX, structure, and code display settings

;;; Code:

(use-package emacs :ensure nil
  :demand t
  :ensure nil
  :custom
  (enable-recursive-minibuffers nil)
  :mode
  ("\\.env(.*)?$" . conf-mode)
  :custom
  (indent-tabs-mode nil) ; use spaces only if nil
  (tab-width 4)
  (c-basic-offset 4)
  )

(use-package breadcrumb
  :demand t
  :custom
  (breadcrumb-idle-time 100)
  :init
  (breadcrumb-mode)
  )

(use-package sideline
  :demand t
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
  (sideline-backends-right '(;; (sideline-lsp      . up)
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
  :demand t
  :custom
  (eldoc-idle-delay 0.2)
  (eldoc-echo-area-use-multiline-p nil)
  )

(use-package eldoc-box
  :after eldoc
  :demand t
  :general
  (
   ;; :keymap '(prog-mode override)
   :keymap 'prog-mode-map
   :states 'normal
   "K"   #'eldoc-box-help-at-point ; eldoc-box-eglot-help-at-point
   "M-K" #'eldoc-doc-buffer
   )
  ;; (:keymaps 'eglot-mode-map
	;;     "K" 'rex/eldoc-box-scroll-up
	;;     "J" 'rex/eldoc-box-scroll-down
  ;;     )
  :config
  (when (display-graphic-p)
    (remove-hook 'eldoc-display-functions 'eldoc-display-in-echo-area))

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
  :hook
  (prog-mode . origami-mode)
  )

(use-package nhexl-mode
  :commands (nhexl-mode)
  :custom
  (nhexl-display-unprintables t)
  (nhexl-line-width t)
  (nhexl-obey-font-lock nil)
  (nhexl-separate-line nil)
  (nhexl-silently-convert-to-unibyte t)
  )

(use-package smart-tabs-mode
  :disabled t
  :hook
  (c-mode-common . smart-tabs-mode)
  :config
  (smart-tabs-insinuate 'c 'c++))

;; (use-package realgud)
;; (use-package realgud-ipdb)
;; (use-package realgud-pry)

;;; code-editor.el ends here
