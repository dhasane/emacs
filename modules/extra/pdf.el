
(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-tools)
  :config
  (pdf-tools-install)
  (pdf-loader-install)
  :general
  ;; https://github.com/cjl8zf/evil-pdf-tools/blob/master/evil-pdf-tools.el
  (
   :states '(insert normal motion override)
   :keymaps 'pdf-view-mode-map
   ;; "k" 'pdf-view-previous-line-or-previous-page
   ;; "j" 'pdf-view-next-line-or-next-page
   "k" 'pdf-view-scroll-up-or-next-page
   "j" 'pdf-view-scroll-down-or-previous-page
   "l" 'image-forward-hscroll
   "h" 'image-backward-hscroll
   (kbd "C-f") 'pdf-view-scroll-up-or-next-page
   (kbd "C-b") 'pdf-view-scroll-down-or-previous-page
   "gg" 'pdf-view-first-page
   "G" 'pdf-view-last-page
   "r" 'revert-buffer
   ":" 'evil-ex
   "/" 'isearch-forward
   )
  :config

  (define-minor-mode evil-pdf-tools-mode
    "A minor mode to add evil key bindings to pdf-tools."
    :lighter " evil-pdf-tools"
    :keymap (let ((map (make-sparse-keymap)))
              (define-key map "k" 'pdf-view-previous-line-or-previous-page)
              (define-key map "j" 'pdf-view-next-line-or-next-page)
              (define-key map "l" 'image-forward-hscroll)
              (define-key map "h" 'image-backward-hscroll)
              (define-key map (kbd "C-f") 'pdf-view-scroll-up-or-next-page)
              (define-key map (kbd "C-b") 'pdf-view-scroll-down-or-previous-page)
              (define-key map "gg" 'pdf-view-first-page)
              (define-key map "G" 'pdf-view-last-page)
              (define-key map "r" 'revert-buffer)
              (define-key map ":" 'evil-ex)
              (define-key map "/" 'isearch-forward) map)
    (evil-pdf-tools-setup))

  (defun evil-pdf-tools-setup ()
    "Modify isearch to behave like evil search."
    (progn
      (add-function :before (symbol-function 'isearch-forward) #'evil-like-search-setup)
      (add-function :after (symbol-function 'isearch-forward) #'evil-like-search-setup)))

  (defun evil-like-search-setup (&optional ARG PRED)
    "After enter is pressed in isearch the letters n and N are used to navigate the results."
    (progn
      (define-key isearch-mode-map (kbd "<return>")
                  '(lambda () (interactive)
                     (progn
                       (define-key isearch-mode-map "n" 'isearch-repeat-forward)
                       (define-key isearch-mode-map "N" 'isearch-repeat-backward))))
      (define-key isearch-mode-map "n" 'isearch-printing-char)
      (define-key isearch-mode-map "N" 'isearch-printing-char)))

;;;###autoload
  (add-hook 'pdf-view-mode-hook 'evil-pdf-tools-mode)

  )

(use-package org-noter
  :after org
  :custom
  (org-noter-notes-search-path '("~/org/noter"))
  )
