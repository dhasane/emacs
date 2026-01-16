;;; corfu.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Corfu completion UI configuration

;;; code:

(use-package corfu
  :ensure (corfu :files (:defaults "extensions/*")
                 :includes (corfu-info corfu-history))
  ;; :straight (corfu :files (:defaults "extensions/*")
  ;;                  :includes (corfu-info corfu-history))
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-commit-predicate nil)   ;; Do not commit selected candidates on next input
  (corfu-quit-at-boundary t)     ;; Automatically quit at word boundary
  (corfu-quit-no-match t)        ;; Automatically quit if there is no match
  (corfu-echo-documentation 0) ;; Do not show documentation in the echo area
  (corfu-auto nil)

  (corfu-preselect 'prompt)

  ;; (corfu-min-width 80)
  ;; (corfu-max-width corfu-min-width)

  (corfu-popupinfo-delay 0.5)

  ;; (tab-always-indent 'complete)
  ;; (corfu-separator ?\s)            ; Use space
  ;; (corfu-quit-no-match 'separator) ; Don't quit if there is `corfu-separator' inserted

  ;; Optionally use TAB for cycling, default is `corfu-complete'.

  ;; TAB cycle if there are only few candidates
  ;; (setq completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (tab-always-indent 'complete)
  :general
  (
   :keymaps 'prog-mode-map
   :states '(insert)
   "TAB" 'basic-tab-indent-or-complete
   )
  (
   :keymaps 'corfu-map
         "TAB"     'corfu-next
         [tab]     'corfu-next
         "S-TAB"   'corfu-previous
         [backtab] 'corfu-previous

         [escape]  'corfu-quit
         "C-s"     'corfu-quit

         "SPC" #'corfu-insert-separator
   )
  :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode)
         )
  :config
  (with-eval-after-load 'evil
    (evil-make-intercept-map corfu-map 'insert)
    )

  ;; completar siempre que no sea espacio
  (defun basic-check-expansion ()
    "True en caso de no tener whitespace previo la cursor"
    (save-excursion
      (if (bobp)
          nil
        (backward-char 1)
        (not (looking-at "[\n \t]")))))

  (defun basic-tab-indent-or-complete ()
    "Agrega un tab, en caso de no tener texto previo, en caso de tenerlo, completa."
    (interactive)
    (if (and (fboundp 'corfu--popup-visible-p)
             (corfu--popup-visible-p))
        (corfu-next)
      (if (basic-check-expansion)
          (completion-at-point)
        (tab-to-tab-stop))) ;; agregar tabs
    )
  :init
  ;; (global-corfu-mode)
  (corfu-popupinfo-mode))

(use-package corfu-candidate-overlay
  :disabled t
  :after corfu
  :general
  (
   :keymaps 'corfu-map
         "TAB"     'corfu-next
         [tab]     'corfu-next
         "S-TAB"   'corfu-previous
         [backtab] 'corfu-previous

         [escape]  'corfu-quit
         "C-s"     'corfu-quit

         "SPC" #'corfu-insert-separator
   )
  :custom
  (corfu-candidate-overlay-mode +1)
  :config
  ;; bind Ctrl + Shift + Tab to trigger completion of the first candidate
  ;; (keybing <iso-lefttab> may not work for your keyboard model)
  ;; (global-set-key (kbd "C-<iso-lefttab>") 'corfu-candidate-overlay-complete-at-point)
  (custom-set-faces '(corfu-candidate-overlay-face ((t (:inherit 'font-lock-comment-face)))))
  :custom-face
  (corfu-candidate-overlay-face-exact-match ((t (:inherit corfu-candidate-overlay-face :underline t))))
  )

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
  :ensure nil
  ;; Swap M-/ and C-M-/
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand)))

;;; corfu.el ends here
