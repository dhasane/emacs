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

(use-package fountain-mode
  :mode ("\\.fountain\\'" . fountain-mode)
  :hook (fountain-mode . dh/fountain-setup)
  :config
;;; --- Variables ---

  (defvar dh/fountain-body-width 63
    "Text width for fountain-mode, matching standard screenplay format.")

  (defvar-local dh/fountain-page-overlays nil
    "List of overlays used to display page breaks.")

  (defvar-local dh/fountain-separator-overlays nil
    "List of overlays used for === separators.")

  (defvar-local dh/fountain--last-line nil
    "Last cursor line, used to avoid redundant separator visibility updates.")

  (defvar-local dh/fountain--separator-timer nil
    "Idle timer for debounced separator rebuilds.")

  (defvar-local dh/fountain--cached-line-string nil
    "Cached separator line string, rebuilt on window resize.")

;;; --- Helpers ---

  (defun dh/fountain--rebuild-line-string ()
    "Recompute and cache the separator line string to span the text area."
    (let ((width (if-let ((win (get-buffer-window)))
                    (window-body-width win)
                  dh/fountain-body-width)))
      (setq dh/fountain--cached-line-string
            (propertize (make-string width ?─)
                        'face '(:foreground "gray40")))))

  (defun dh/fountain--make-line-string ()
    "Return the cached separator line string."
    (or dh/fountain--cached-line-string
        (dh/fountain--rebuild-line-string)))

  (defun dh/fountain--line-is-separator-p ()
    "Return non-nil if current line is a === separator."
    (save-excursion
      (beginning-of-line)
      (looking-at "^===+$")))

  (defun dh/fountain--clear-overlays (ov-list-sym)
    "Delete all overlays in buffer-local list OV-LIST-SYM and reset it."
    (mapc #'delete-overlay (symbol-value ov-list-sym))
    (set ov-list-sym nil))

;;; --- Page breaks ---

  (defun dh/fountain--place-page-break-overlay (line-string)
    "Place a page-break overlay at point using LINE-STRING, unless on a separator."
    (unless (dh/fountain--line-is-separator-p)
      (let ((lbp (line-beginning-position)))
        (if (= lbp (point-min))
            (let ((ov (make-overlay lbp lbp)))
              (overlay-put ov 'before-string line-string)
              (push ov dh/fountain-page-overlays))
          ;; Attach after previous line's newline to avoid current line's line-prefix
          (let ((ov (make-overlay (1- lbp) (1- lbp))))
            (overlay-put ov 'after-string line-string)
            (push ov dh/fountain-page-overlays))))))

  (defun dh/fountain-show-page-breaks ()
    "Display visual lines at fountain-mode page boundaries."
    (dh/fountain--clear-overlays 'dh/fountain-page-overlays)
    (save-excursion
      (save-restriction
        (widen)
        (goto-char (point-min))
        (let* ((line-string (propertize (concat (dh/fountain--make-line-string) "\n")
                                       'line-height t))
               (next-pos (next-single-property-change (point) 'fountain-pagination)))
          (while next-pos
            (goto-char next-pos)
            (unless (eobp)
              (dh/fountain--place-page-break-overlay line-string))
            (setq next-pos (next-single-property-change (point) 'fountain-pagination)))))))

  (defun dh/fountain-update-page-breaks ()
    "Update pagination and refresh visual page breaks."
    (when (derived-mode-p 'fountain-mode)
      (fountain-pagination-update)
      (dh/fountain-show-page-breaks)))

;;; --- Separators (===) ---

  (defun dh/fountain-show-separators ()
    "Replace === lines with visual horizontal rules."
    (dh/fountain--clear-overlays 'dh/fountain-separator-overlays)
    (save-excursion
      (save-restriction
        (widen)
        (goto-char (point-min))
        (let ((line-display (dh/fountain--make-line-string)))
          (while (re-search-forward "^===+$" nil t)
            (let ((ov (make-overlay (line-beginning-position) (line-end-position))))
              (overlay-put ov 'evaporate t)
              (overlay-put ov 'priority 100)
              (overlay-put ov 'invisible 'dh/fountain-sep)
              (overlay-put ov 'before-string line-display)
              (overlay-put ov 'dh/fountain-separator t)
              (push ov dh/fountain-separator-overlays)))))))

  (defun dh/fountain-update-separator-visibility ()
    "Reveal raw === when cursor is on a separator, hide it otherwise."
    (when (derived-mode-p 'fountain-mode)
      (let ((current-line (line-number-at-pos)))
        (unless (eq current-line dh/fountain--last-line)
          (setq dh/fountain--last-line current-line)
          (let ((line-display (dh/fountain--make-line-string)))
            (dolist (ov dh/fountain-separator-overlays)
              (when (overlay-buffer ov)
                (if (= current-line (line-number-at-pos (overlay-start ov)))
                    (progn
                      (overlay-put ov 'invisible nil)
                      (overlay-put ov 'before-string nil))
                  (overlay-put ov 'invisible 'dh/fountain-sep)
                  (overlay-put ov 'before-string line-display)))))))))

  (defun dh/fountain-update-separators ()
    "Rebuild separator overlays and update visibility."
    (when (derived-mode-p 'fountain-mode)
      (dh/fountain-show-separators)
      (dh/fountain-update-separator-visibility)))

  (defun dh/fountain--on-window-change ()
    "Rebuild cached line string and refresh overlays on window resize."
    (when (derived-mode-p 'fountain-mode)
      (dh/fountain--rebuild-line-string)
      (dh/fountain-update-separators)))

  (defun dh/fountain--schedule-separator-update (&rest _)
    "Debounced separator rebuild triggered by buffer changes."
    (when dh/fountain--separator-timer
      (cancel-timer dh/fountain--separator-timer))
    (setq dh/fountain--separator-timer
          (run-with-idle-timer 0.3 nil
                               (lambda ()
                                 (when (derived-mode-p 'fountain-mode)
                                   (dh/fountain-update-separators))))))

;;; --- Setup ---

  (defun dh/fountain-setup ()
    "Configure fountain-mode with olivetti, page breaks, and visual separators."
    (olivetti-mode 1)
    (setq-local olivetti-body-width dh/fountain-body-width)
    (setq-local olivetti-minimum-body-width dh/fountain-body-width)
    (face-remap-add-relative 'fringe :background
                             (face-attribute 'hl-line :background nil t))
    (add-to-invisibility-spec 'dh/fountain-sep)
    (add-hook 'after-save-hook #'dh/fountain-update-page-breaks nil t)
    (add-hook 'after-save-hook #'dh/fountain-update-separators nil t)
    (add-hook 'after-change-functions #'dh/fountain--schedule-separator-update nil t)
    (add-hook 'post-command-hook #'dh/fountain-update-separator-visibility nil t)
    (add-hook 'window-configuration-change-hook #'dh/fountain--on-window-change nil t)
    ;; Defer initial build so olivetti finishes setting margins first
    (let ((buf (current-buffer)))
      (run-with-idle-timer 0 nil
                           (lambda ()
                             (when (buffer-live-p buf)
                               (with-current-buffer buf
                                 (dh/fountain--rebuild-line-string)
                                 (dh/fountain-update-page-breaks)
                                 (dh/fountain-update-separators)))))))
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
