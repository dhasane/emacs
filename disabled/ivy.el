;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package ivy
  :delight
  :diminish
  :defer 0
  ;; :diminish (ivy-mode . "")
  :demand t
  :bind
  (:map ivy-mode-map
        ("C-'" . ivy-avy)
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

(use-package counsel
  :demand t
  :defer 0
  :bind (("M-x" . 'counsel-M-x))
  )

(use-package counsel-projectile
  :demand t
  :defer 0
  )

(use-package all-the-icons-ivy-rich
  :demand t
  :defer 0
  :custom
  (inhibit-compacting-font-caches t)
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :disabled
  :demand t
  :defer 0
  ;; :after all-the-icons-ivy-rich
  :custom
  ;; To abbreviate paths using abbreviate-file-name (e.g. replace “/home/username” with “~”)
  (ivy-rich-path-style 'abbrev)

  (ivy-rich-display-transformers-list
   '(
     ivy-switch-buffer
     (:columns
      (
       ;; (ivy-rich-switch-buffer-icon (:width 2))
       (ivy-rich-candidate (:width 20))
       (ivy-rich-switch-buffer-size (:width 7))
       (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
       (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))
       (ivy-rich-switch-buffer-project (:width 15 :face success))
       (ivy-rich-switch-buffer-path (:width
                                     (lambda (x)
                                       (ivy-rich-switch-buffer-shorten-path
                                        x (ivy-rich-minibuffer-width 0.3))))))
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
       (ivy-rich-counsel-find-file-truename
        (:face "#900000" ;;font-lock-doc-face
               ))
       ))
     counsel-M-x
     (:columns
      ((counsel-M-x-transformer (:width 35))
       (ivy-rich-counsel-function-docstring
        (
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
  :init
  (ivy-rich-mode 1)
  ;; :config
  ;; (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)
  )

;; revisar esto


;; Better experience with icons
;; Enable it before`ivy-rich-mode' for better performance
(use-package all-the-icons-ivy-rich
  :hook (ivy-mode . all-the-icons-ivy-rich-mode)
  :config
  (plist-put all-the-icons-ivy-rich-display-transformers-list
             'centaur-load-theme
             '(:columns
               ((all-the-icons-ivy-rich-theme-icon)
                (ivy-rich-candidate))
               :delimiter "\t"))
  (all-the-icons-ivy-rich-reload))

;; More friendly display transformer for Ivy
(use-package ivy-rich
  :after counsel-projectile
  :hook ((counsel-projectile-mode . ivy-rich-mode) ; MUST after `counsel-projectile'
         (ivy-rich-mode . (lambda ()
                            "Use abbreviate in `ivy-rich-mode'."
                            (setq ivy-virtual-abbreviate
                                  (or (and ivy-rich-mode 'abbreviate) 'name)))))
  :init
  ;; For better performance
  (setq ivy-rich-parse-remote-buffer nil))

;;(use-package lsp-ivy
;;:defer t
;;:commands lsp-ivy-workspace-symbol
;;)


(use-package ivy-yasnippet
  )
