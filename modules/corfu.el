;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:


(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t)
  )

(use-package corfu
  :if (not (featurep 'vertico))
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-commit-predicate nil)   ;; Do not commit selected candidates on next input
  (corfu-quit-at-boundary t)     ;; Automatically quit at word boundary
  (corfu-quit-no-match t)        ;; Automatically quit if there is no match
  (corfu-echo-documentation 0) ;; Do not show documentation in the echo area

  ;; Optionally use TAB for cycling, default is `corfu-complete'.
  :general
  (
   :keymap '(prog-mode override)
   :states '(insert)
   "TAB" 'basic-tab-indent-or-complete
   )
  (
   :keymaps 'corfu-map
         "TAB"     'corfu-next
         [tab]     'corfu-next
         "S-TAB"   'corfu-previous
         [backtab] 'corfu-previous

         [escape]  'corfu-quit-no-match
         "C-s"     'corfu-quit
   )
  ;; :bind (:map corfu-map
  ;;        ("TAB" . corfu-next)
  ;;        ([tab] . corfu-next)
  ;;        ("S-TAB" . corfu-previous)
  ;;        ([backtab] . corfu-previous)

  ;;        ([escape] . corfu-quit-no-match)
  ;;        ("C-s" . corfu-quit)
  ;;        )

  ;; You may want to enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.
  ;; This is recommended since dabbrev can be used globally (M-/).
  :config
  (with-eval-after-load "evil"
    (evil-make-intercept-map corfu-map 'insert)
    )

  (defun dh/complete-and-save ()
    "Completar la recomendacion y guardar"
    (interactive)
    (corfu-complete)
    (save-buffer)
    )

  ;; completar siempre que no sea espacio
  (defun basic-check-expansion ()
    "True en caso de no tener whitespace previo la cursor"
    (save-excursion
      (backward-char 1)
      (not (looking-at "[\n \t]"))
      )
    )

  (defun basic-tab-indent-or-complete ()
    "Agrega un tab, en caso de no tener texto previo, en caso de tenerlo, completa."
    (interactive)
    (corfu-next)
    (if (basic-check-expansion)
        (completion-at-point)
      (tab-to-tab-stop) ;; agregar tabs
      )
    )
  :init
  (corfu-global-mode))

;; Optionally use the `orderless' completion style. See `+orderless-dispatch'
;; in the Consult wiki for an advanced Orderless style dispatcher.
;; Enable `partial-completion' for files to allow path expansion.
;; You may prefer to use `initials' instead of `partial-completion'.
;; (use-package orderless
;;   :init
;;   ;; Configure a custom style dispatcher (see the Consult wiki)
;;   ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
;;   ;;       orderless-component-separator #'orderless-escapable-split-on-space)
;;   (setq completion-styles '(orderless)
;;         completion-category-defaults nil
;;         completion-category-overrides '((file (styles . (partial-completion))))))

;; Dabbrev works with Corfu
(use-package dabbrev
  ;; Swap M-/ and C-M-/
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand)))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; TAB cycle if there are only few candidates
  (setq completion-cycle-threshold 3)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete))

;;; corfu.el ends here
