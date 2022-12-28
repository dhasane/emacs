;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

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

;; (use-package evil-paredit
;;   :hook ((emacs-lisp-mode . evil-paredit-mode))
;;   )

;;; lisp.el ends here
