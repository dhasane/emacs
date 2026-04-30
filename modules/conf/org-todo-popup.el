;;; org-todo-popup.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Popup window showing org TODO items

;;; Code:

(defvar dh/org-todo-popup-order '("WORK" "TODO" "WAIT" "BLOCK")
  "Order in which TODO states appear in the popup.")

(defun dh/org-todo-popup ()
  "Show org TODO items in a popup window."
  (interactive)
  (let* ((buf (get-buffer-create "*Org Todo Popup*"))
         (todos (dh/org-todo-popup--collect)))
    (with-current-buffer buf
      (dh/org-todo-popup--render todos))
    (dh/org-todo-popup--display buf)))

(defun dh/org-todo-popup--render (todos)
  "Render TODOS into the current buffer."
  (let ((inhibit-read-only t))
    (erase-buffer)
    (special-mode)
    (insert (propertize "  TODO List" 'face '(:height 1.3 :weight bold))
            (propertize "  [t] cycle  [d] done  [RET] goto  [q] close\n" 'face 'font-lock-comment-face))
    (insert (make-string 40 ?─) "\n\n")
    (if todos
        (dolist (item todos)
          (let ((state (plist-get item :state))
                (title (plist-get item :title))
                (file  (plist-get item :file))
                (marker (plist-get item :marker))
                (beg (point)))
            (insert (propertize (format "  %-6s" state)
                                'face (dh/org-todo-popup--state-face state))
                    (format " %s" title)
                    (propertize (format "  (%s)" (file-name-nondirectory file))
                                'face 'font-lock-comment-face)
                    "\n")
            (put-text-property beg (point) 'dh/org-marker marker)))
      (insert "  No TODO items found.\n"))
    (goto-char (point-min))
    (local-set-key (kbd "t") #'dh/org-todo-popup-cycle)
    (local-set-key (kbd "d") #'dh/org-todo-popup-done)
    (local-set-key (kbd "RET") #'dh/org-todo-popup-goto)
    (when (bound-and-true-p evil-local-mode)
      (setq-local evil-normal-state-local-map
                  (let ((map (make-sparse-keymap)))
                    (define-key map (kbd "t") #'dh/org-todo-popup-cycle)
                    (define-key map (kbd "d") #'dh/org-todo-popup-done)
                    (define-key map (kbd "RET") #'dh/org-todo-popup-goto)
                    (define-key map (kbd "q") #'quit-window)
                    map))
      (evil-normalize-keymaps))))

(defvar dh/org-todo-popup-states '("TODO" "WORK" "WAIT" "BLOCK")
  "States available for selection (excluding DONE).")

(defun dh/org-todo-popup-cycle ()
  "Select a TODO state for the item on the current line."
  (interactive)
  (when-let ((marker (get-text-property (point) 'dh/org-marker)))
    (when (marker-buffer marker)
      (let* ((current (with-current-buffer (marker-buffer marker)
                        (goto-char marker)
                        (org-get-todo-state)))
             (next (completing-read (format "State [%s]: " current)
                                    dh/org-todo-popup-states nil t)))
        (with-current-buffer (marker-buffer marker)
          (goto-char marker)
          (org-todo next))
        (message "State: %s → %s" current next)
        (dh/org-todo-popup--refresh)))))

(defun dh/org-todo-popup-goto ()
  "Jump to the org heading of the item on the current line."
  (interactive)
  (when-let ((marker (get-text-property (point) 'dh/org-marker)))
    (when (marker-buffer marker)
      (quit-window)
      (switch-to-buffer (marker-buffer marker))
      (goto-char marker)
      (org-reveal))))

(defun dh/org-todo-popup-done ()
  "Mark the item on the current line as DONE."
  (interactive)
  (when-let ((marker (get-text-property (point) 'dh/org-marker)))
    (when (marker-buffer marker)
      (with-current-buffer (marker-buffer marker)
        (goto-char marker)
        (org-todo "DONE"))
      (dh/org-todo-popup--refresh))))

(defun dh/org-todo-popup--refresh ()
  "Refresh the popup contents."
  (let ((line (line-number-at-pos)))
    (dh/org-todo-popup--render (dh/org-todo-popup--collect))
    (goto-char (point-min))
    (forward-line (1- line))))

(defun dh/org-todo-popup--collect ()
  "Collect TODO items from `org-agenda-files', sorted by `dh/org-todo-popup-order'."
  (let (items)
    (dolist (file (org-agenda-files))
      (when (file-exists-p file)
        (with-current-buffer (find-file-noselect file)
          (org-map-entries
           (lambda ()
             (let ((state (org-get-todo-state)))
               (when (and state (not (string= state "DONE")))
                 (push (list :state state
                             :title (org-get-heading t t t t)
                             :file file
                             :marker (point-marker))
                       items))))))))
    (sort (nreverse items)
          (lambda (a b)
            (< (or (cl-position (plist-get a :state) dh/org-todo-popup-order :test #'string=) 99)
               (or (cl-position (plist-get b :state) dh/org-todo-popup-order :test #'string=) 99))))))

(defun dh/org-todo-popup--state-face (state)
  "Return face for todo STATE."
  (pcase state
    ("TODO"  '(:foreground "cyan" :weight bold))
    ("WORK"  '(:foreground "orange" :weight bold))
    ("WAIT"  '(:foreground "purple" :weight bold))
    ("BLOCK" '(:foreground "red" :weight bold))
    (_       '(:weight bold))))

(defun dh/org-todo-popup--display (buf)
  "Display BUF as a bottom popup."
  (let* ((height (min 25 (with-current-buffer buf
                           (+ 2 (count-lines (point-min) (point-max))))))
         (win (display-buffer-in-side-window
               buf
               `((side . bottom)
                 (window-height . ,height)
                 (slot . 0)))))
    (select-window win)
    (set-window-dedicated-p win t)))

;;; org-todo-popup.el ends here
