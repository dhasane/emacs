;;; writting.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:

;;; code:

(use-package olivetti
  :hook (org-mode . olivetti-mode)
  :custom
  (olivetti-body-width 0.65)
  (olivetti-minimum-body-width 120)
  (olivetti-style t)
  ;; :custom-face
  ;; (olivetti-fringe ((t (:background "#504945" :foreground "#fdf4c2"))))
  )

(use-package page-break-lines
  :hook (fountain-mode . page-break-lines-mode))

(use-package fountain-mode
  :mode ("\\.fountain\\'" . fountain-mode)
  :hook (fountain-mode . dh/fountain-setup)
  :config
  (defvar dh/fountain-body-width 63
    "Text width for fountain-mode, matching standard screenplay format.")

  (defvar-local dh/fountain-page-overlays nil
    "List of overlays used to display page breaks.")

  (defvar-local dh/fountain-separator-overlays nil
    "List of overlays used for === separators.")

  (defun dh/fountain-clear-page-overlays ()
    "Remove all page break overlays."
    (mapc #'delete-overlay dh/fountain-page-overlays)
    (setq dh/fountain-page-overlays nil))

  (defun dh/fountain-clear-separator-overlays ()
    "Remove all separator overlays."
    (mapc #'delete-overlay dh/fountain-separator-overlays)
    (setq dh/fountain-separator-overlays nil))

  (defun dh/fountain-show-page-breaks ()
    "Display visual lines at fountain-mode page boundaries."
    (dh/fountain-clear-page-overlays)
    (save-excursion
      (save-restriction
        (widen)
        (goto-char (point-min))
        (let* ((line-chars (make-string (+ dh/fountain-body-width 19) ?─)) ;; magico 19
               (line-string (propertize (concat line-chars "\n")
                                       'face '(:foreground "gray40" :height 0.8)
                                       'line-height t))
               (next-pos (next-single-property-change (point) 'fountain-pagination)))
          (while next-pos
            (goto-char next-pos)
            (unless (eobp)
              ;; Check if this line has a === separator
              (let ((has-separator (save-excursion
                                    (beginning-of-line)
                                    (looking-at "^===+$"))))
                (unless has-separator
                  (let ((ov (make-overlay (line-beginning-position)
                                         (line-beginning-position))))
                    (overlay-put ov 'before-string line-string)
                    (push ov dh/fountain-page-overlays)))))
            (setq next-pos (next-single-property-change (point) 'fountain-pagination)))))))

  (defun dh/fountain-show-separators ()
    "Display visual lines for === separators and hide the actual separator text."
    (dh/fountain-clear-separator-overlays)
    (save-excursion
      (save-restriction
        (widen)
        (goto-char (point-min))
        (let* ((line-chars (make-string (+ dh/fountain-body-width 19) ?─))
               (line-display (propertize line-chars
                                        'face '(:foreground "gray40" :height 0.8))))
          (while (re-search-forward "^===+$" nil t)
            (let* ((line-start (line-beginning-position))
                   (line-end (line-end-position))
                   (ov (make-overlay line-start line-end)))
              (overlay-put ov 'display line-display)
              (overlay-put ov 'dh/fountain-separator t)
              (push ov dh/fountain-separator-overlays)))))))

  (defun dh/fountain-update-separator-visibility ()
    "Update separator visibility based on cursor position."
    (let ((current-line (line-number-at-pos))
          (line-chars (make-string (+ dh/fountain-body-width 19) ?─)))
      (dolist (ov dh/fountain-separator-overlays)
        (let ((ov-line (line-number-at-pos (overlay-start ov))))
          (if (= current-line ov-line)
              ;; Cursor on separator line - show separator
              (overlay-put ov 'display nil)
            ;; Cursor not on separator line - show visual line
            (overlay-put ov 'display
                        (propertize line-chars
                                   'face '(:foreground "gray40" :height 0.8))))))))

  (defun dh/fountain-update-page-breaks ()
    "Update pagination and refresh visual page breaks."
    (when (derived-mode-p 'fountain-mode)
      (fountain-pagination-update)
      (dh/fountain-show-page-breaks)))

  (defun dh/fountain-update-separators ()
    "Update separator overlays."
    (when (derived-mode-p 'fountain-mode)
      (dh/fountain-show-separators)
      (dh/fountain-update-separator-visibility)))

  (defun dh/fountain-setup ()
    "Configure olivetti for fountain-mode."
    (olivetti-mode 1)
    (setq-local olivetti-body-width dh/fountain-body-width)
    (setq-local olivetti-minimum-body-width dh/fountain-body-width)
    ;; Set background for outer margins to inherit from hl-line
    (face-remap-add-relative 'fringe :background
                             (face-attribute 'hl-line :background nil t))
    ;; Initialize pagination and show page breaks
    (dh/fountain-update-page-breaks)
    ;; Initialize separator overlays
    (dh/fountain-update-separators)
    ;; Update page breaks after changes
    (add-hook 'after-save-hook #'dh/fountain-update-page-breaks nil t)
    ;; Update separators after changes
    (add-hook 'after-save-hook #'dh/fountain-update-separators nil t)
    (add-hook 'after-change-functions
              (lambda (&rest _) (dh/fountain-update-separators)) nil t)
    ;; Update separator visibility on cursor movement
    (add-hook 'post-command-hook #'dh/fountain-update-separator-visibility nil t))
  )

(use-package darkroom
  :disabled t
  :hook (org-mode . darkroom-tentative-mode)
  :custom
  (darkroom-text-scale-increase 0)
  (darkroom-fringes-outside-margins 2)
  (darkroom-margins 'darkroom-guess-margins)

  :config
  (setq darkroom-disable-mode-line nil)

  (defun darkroom--enter (&optional just-margins)
    "Save current state and enter darkroom for the current buffer.
With optional JUST-MARGINS, just set the margins."
    (unless just-margins
      (setq darkroom--saved-state
            (mapcar #'(lambda (sym)
                        (cons sym (buffer-local-value sym (current-buffer))))
                    darkroom--saved-variables))
      (when darkroom-disable-mode-line
        (setq mode-line-format nil))
      (setq header-line-format nil
            fringes-outside-margins darkroom-fringes-outside-margins)
      (text-scale-increase darkroom-text-scale-increase))
    (mapc #'(lambda (w)
              (with-selected-window w
                (darkroom--set-margins)))
          (get-buffer-window-list (current-buffer))))
  )

;;; writting.el ends here
