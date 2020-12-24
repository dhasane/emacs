
;;; Code:
(use-package ivy
  :ensure t
  ;; :diminish (ivy-mode . "")
  :demand t
  :bind
  (:map ivy-mode-map
        ("C-'" . ivy-avy)
        ("<C-up>" . 'previous-history-element)
        ("<C-down>" . 'next-history-element)
        )
  :config
  (ivy-mode 1)
  ;; add ‘recentf-mode’ and bookmarks to ‘ivy-switch-buffer’.
  (setq ivy-use-virtual-buffers t)
  ;; number of result lines to display
  (setq ivy-height 10)
  ;; does not count candidates
  (setq ivy-count-format "")
  ;; no regexp by default
  (setq ivy-initial-inputs-alist nil)
  ;; configure regexp engine.
  (setq ivy-re-builders-alist
	;; allow input not in order
        '((t   . ivy--regex-ignore-order))))

(use-package ivy-rich
  :demand t
  :after ivy
  ;; :preface
  ;; ;; use all-the-icons for `ivy-switch-buffer'
  ;; (defun ivy-rich-switch-buffer-icon (candidate)
  ;;   (with-current-buffer
  ;;     (get-buffer candidate)
  ;;     (let ((icon (all-the-icons-icon-for-mode major-mode)))
  ;;       (if (symbolp icon)
  ;;         (all-the-icons-icon-for-mode 'fundamental-mode)
  ;;         icon))))
  :init
  ;; To abbreviate paths using abbreviate-file-name (e.g. replace “/home/username” with “~”)
  (setq ivy-rich-path-style 'abbrev)

  (setq ivy-rich-display-transformers-list
        '(
          ivy-switch-buffer
          (:columns
           (
            ;; (ivy-rich-switch-buffer-icon (:width 2))
            (ivy-rich-candidate (:width 30))
            (ivy-rich-switch-buffer-size (:width 7))
            (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
            (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))
            (ivy-rich-switch-buffer-project (:width 15 :face success))
            (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))
           :predicate
           (lambda (cand) (get-buffer cand)))
          counsel-find-file
          (:columns
           (
            (ivy-read-file-transformer)
            ;; (ivy-rich-switch-buffer-path
            ;;  (:width
            ;;   (lambda (x)
            ;;     (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3)))))
            (ivy-rich-counsel-find-file-truename (:face "#900000" ;;font-lock-doc-face
                                                        ))
            ))
          counsel-M-x
          (:columns
           ((counsel-M-x-transformer (:width 35))
            (ivy-rich-counsel-function-docstring (
                                                  ;; :width 34
                                                  :face font-lock-doc-face))))
          counsel-describe-function
          (:columns
           ((counsel-describe-function-transformer (:width 35))
            (ivy-rich-counsel-function-docstring (:width 34 :face font-lock-doc-face))))
          counsel-describe-variable
          (:columns
           ((counsel-describe-variable-transformer (:width 35))
            (ivy-rich-counsel-variable-docstring (:width 34 :face font-lock-doc-face))))
          package-install
          (:columns
           ((ivy-rich-candidate (:width 25))
            (ivy-rich-package-version (:width 12 :face font-lock-comment-face))
            (ivy-rich-package-archive-summary (:width 7 :face font-lock-builtin-face))
            (ivy-rich-package-install-summary (:width 23 :face font-lock-doc-face))))
          counsel-projectile-find-file
          (:columns
           (
            ;; (ivy-rich-switch-buffer-icon (:width 2))
            (ivy-rich-candidate (:width 30))
            (ivy-rich-switch-buffer-size (:width 7))
            (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
            (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))
            (ivy-rich-switch-buffer-project (:width 15 :face success))
            (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))
           :predicate
           (lambda (cand) (get-buffer cand)))
          )
        )
  ;; ivy-rich-mode needs to be called after `ivy-rich--display-transformers-list' is changed
  :config
  (ivy-rich-mode 1)
  (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)
  )

(use-package counsel
  :ensure t
  :after (ivy)
  :bind (
         ("M-x" . 'counsel-M-x)
         ("M-m" . 'counsel-find-file)
         )
  )

(use-package counsel-projectile
  :after (counsel)
  )

;;(use-package lsp-ivy
  ;;:ensure t
  ;;:defer t
  ;;:commands lsp-ivy-workspace-symbol
  ;;)
