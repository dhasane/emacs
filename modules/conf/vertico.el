;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package vertico
  :init
  (vertico-mode)
  :general
  (:keymaps 'vertico-map
   "<escape>"       #'minibuffer-keyboard-quit ; Close minibuffer
   "<tab>"          #'vertico-insert  ; Insert selected candidate into text area
   "C-<return>"     #'vertico-exit
   "C-K" #'vertico-next-group
   "C-J" #'vertico-previous-group
   )
  (:states '(normal insert motion emacs) :keymaps 'vertico-map
   "C-j"      #'vertico-next
   "C-k"      #'vertico-previous
   "?" #'minibuffer-completion-help
   ;; "M-RET" #'minibuffer-force-complete-and-exit
   ;"TAB" #'minibuffer-complete
   )
  (:states '(normal) :keymaps 'vertico-map
   "j"      #'vertico-next
   "k"      #'vertico-previous
   )
  :custom
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t)

  (completion-styles '(substring orderless basic))
  ;; (completion-styles '(basic substring partial-completion flex))

  ;; modify completion-at-point
  (completion-in-region-function 'consult-completion-in-region)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (vertico-cycle nil)
  )

;; A few more useful configurations...

;; Add prompt indicator to `completing-read-multiple'.
;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
(defun crm-indicator (args)
  (cons (format "[MULTI%s] %s"
                (replace-regexp-in-string
                 "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                 crm-separator)
                (car args))
        (cdr args)))
(advice-add #'completing-read-multiple :filter-args #'crm-indicator)

;; Do not allow the cursor in the minibuffer prompt
(setq minibuffer-prompt-properties
      '(read-only t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

;; Emacs 28: Hide commands in M-x which do not work in the current mode.
;; Vertico commands are hidden in normal buffers.
;; (setq read-extended-command-predicate
;;       #'command-completion-default-include-p)

;; Enable recursive minibuffers
(setq enable-recursive-minibuffers t)

;;; vertico.el ends here
