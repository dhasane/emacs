

(add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode))

(use-package slime
  ;; :hook
  ;; (
   ;; ;; (lisp-mode . (lambda () (slime-mode t)))
   ;; (lisp-mode . (slime-mode))
   ;; (inferior-lisp-mode . (inferior-slime-mode t))
   ;; )
  :config
  (setq inferior-lisp-program "sbcl")
  )