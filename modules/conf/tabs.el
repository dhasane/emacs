;;; tabs.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Tab-bar and tab management

;;; code:

;; en caso que la version sea mayor a 27, usar los tabs ya que vienen
;; incluidos, de lo contrario, usar eyebrowse (tiene cosas que se
;; parecen mas a tmu, lo cual es genial, pero hay unos detalles que no
;; me gustan tanto, como que este en el modeline)

(defcustom dh/min-tab-size 15
  "Minimum width of a tab in characters."
  :type 'integer
  :group 'tab-bar)

(defcustom dh/max-tab-size 25
 "Maximum width of a tab in characters."
  :type 'integer
  :group 'tab-bar)

(use-package tab-bar
  :ensure nil
  :demand t
  :general
  (:states '(normal motion)
   "g b" 'tab-bar-switch-to-prev-tab
   )
  :custom-face
  ;; (tab-bar              ((t (:background "#282828" :foreground "#fdf4c2"))))
  ;; (tab-bar-tab          ((t (:background "#282828" :foreground "#fdf4c2"))))
  ;; (tab-bar-tab-inactive ((t (:background "#504945" :foreground "#fdf4c2"))))

  ;; (tab-bar              ((t (:inherit ansi-color-inverse))))
  ;; (tab-bar-tab          ((t (:inherit default :underline t))))
  ;; (tab-bar-tab-inactive ((t (:inherit ansi-color-inverse))))

  ;; The tab bar's appearance
  ;; (tab-bar
  ;;  ((t (:inherit region
  ;;       ;; :background ,(face-attribute 'region :background)
  ;;       ;; :foreground region
  ;;       ))))
  ;; ;; Inactive tabs
  ;; (tab-bar-tab-inactive
  ;;  ((t (:inherit region
  ;;       ;; :background ,(face-attribute 'region :background)
  ;;       ;; :foreground region
  ;;       ;; :box (:line-width 1 :color ,(face-attribute 'region :background) :style nil)
  ;;       ))))
  ;; ;; Active tab
  ;; (tab-bar-tab
  ;;  ((t (:inherit default
  ;;       ;; :underline t
  ;;       :background ,(face-attribute 'region :background)
  ;;       ;;:foreground default
  ;;       ;; :box (:line-width 3 :color (face-attribute 'default :background) :style nil)
  ;;       ; :box (:line-width -1 :color ,(face-attribute 'default :foreground) :style nil)
  ;;       ))))
  :custom
  (tab-bar-close-button-show nil)
  (tab-bar-new-button-show nil)
  (tab-bar-tab-hints nil)
  ;; (tab-bar-separator
  ;;       (concat
  ;;        (propertize " " 'face `(:background ,(face-attribute 'region :background))
  ;;                    'display '(space :width (1)))
  ;;        (propertize " " 'face `(:underline (:position t) :foreground ,(face-attribute 'region :background) :inherit tab-bar))
  ;;        (propertize " " 'face `(:background ,(face-attribute 'region :background))
  ;;                    'display '(space :width (1)))))


  (tab-bar-tab-name-truncated-max 1)
  (tab-bar-show 1)
  ;; (tab-bar-format
  ;;  '(
  ;;    tab-bar-format-tabs
  ;;    ;; tab-bar-format-history
  ;;    ;; tab-bar-format-tabs-groups
  ;;    tab-bar-separator
  ;;    tab-bar-format-add-tab
  ;;    tab-bar-format-align-right
  ;;    ))

  (tab-bar-tab-name-function 'dh/set-tabs-name)

  ;; (tab-bar-tab-name-function 'tab-bar-tab-name-current)
  ;; (tab-bar-tab-name-function 'set-name-if-in-project)


  (tab-bar-auto-width-max '(330 30))
  :hook (after-load-theme . dh/set-tab-faces)
  :init
  (defun dh/set-tab-faces ()
    (interactive)
    (let ((active-color (face-attribute 'region :background))
          (background-color (face-attribute 'default :foreground))
          )
      (custom-set-faces
       ;; Tab bar general appearance
       `(tab-bar
         ((t
           (
            :inherit region
            :background ,background-color
            :foreground ,active-color
            ))))

       ;; Inactive tabs
       `(tab-bar-tab-inactive
         ((t
           (
            :inherit region
            ;; :box (:line-width 1 :color ,background-color :style nil)
            :background ,background-color
            :foreground ,active-color
            :box (:line-width (1 . -1) :color ,active-color)
            ))))

       ;; Active tab appearance
       `(tab-bar-tab
         ((t (
              :inherit default
              :background ,active-color
              ;; :box (:line-width (1 . -1) :color ,background-color)
	      :box (:line-width (1 . -1) :color ,active-color)
              ))))
       )

      ;; Set the tab bar separator
      (setq-default tab-bar-separator
                    (propertize
                     "\u200B"
                     'face `(:background ,active-color))
                    )
      )
    )
  (setq-default tab-bar-show 1)
  (defun dh/set-tabs-name ()
    "Muestra el nombre del tab, en caso de exceder los MAX caracteres,
muestra solo el nombre del proyecto y los caracteres sobrantes del
nombre del tab."
    (let* ((nombre (tab-bar-tab-name-current))
           ;; project
           (project-name (get-project-name-except-if-remote
                          :show-external t
                          :pre "["
                          :pos "] "))
           ;; max
           (nombre (concat (if (< dh/max-tab-size (length nombre))
                               (substring nombre (- dh/max-tab-size))
                             nombre
                             )))
           ;; min
           (nombre (concat (if (< (length (concat nombre project-name)) dh/min-tab-size)
                               (concat (make-string (- dh/min-tab-size (length nombre)) ?\s ) nombre)
                             nombre)
                           ))
           )
      (format "%s%s" project-name nombre)))

  :config
  (defun close-tab-configuration ()
    (interactive)
    (tab-bar-close-tab)
    )

  (defun dh/tab-bar-select-closed ()
    "Select a recently closed tab to reopen from a list."
    (interactive)
    (if (null tab-bar-closed-tabs)
        (message "No closed tabs")
      (let* ((names (mapcar (lambda (entry)
                              (alist-get 'name (alist-get 'tab entry)))
                            tab-bar-closed-tabs))
             (choice (completing-read "Reopen tab: " names nil t))
             (idx (seq-position names choice #'equal)))
        (when idx
          ;; Move chosen entry to front of the list
          (let ((entry (nth idx tab-bar-closed-tabs)))
            (setq tab-bar-closed-tabs
                  (cons entry (delq entry tab-bar-closed-tabs))))
          (tab-bar-undo-close-tab)))))

  (defhydra+ hydra-tabs ()
    ("c" tab-bar-new-tab-to         "create"        :column "manage")
    ("d" tab-bar-duplicate-tab      "duplicate"     :column "manage")
    ("q" tab-bar-close-tab          "close"         :column "manage")

    ("l" tab-bar-switch-to-next-tab "left"          :column "move")
    ("h" tab-bar-switch-to-prev-tab "right"         :column "move")
    ("s" tab-switch                 "switcher"      :column "move")

    ("L" dh/tab-bar-move-tab-right  "move right"    :column "organize")
    ("H" dh/tab-bar-move-tab-left   "move left"     :column "organize")
    ("m" tab-group                  "to group"      :column "manage")
    ("r" dh/tab-bar-select-closed   "closed tabs"   :column "manage")
    ;; ("-" split-window-vertically    "vertical"      :column "split")
    ;; ("+" split-window-horizontally  "horizontal"    :column "split")

    ;; TODO define these dynamically
    ;; ("1" (lambda () (interactive) (tab-bar-select-tab 1)))
    ;; ("2" (lambda () (interactive) (tab-bar-select-tab 2)))
    ;; ("3" (lambda () (interactive) (tab-bar-select-tab 3)))
    ;; ("4" (lambda () (interactive) (tab-bar-select-tab 4)))
    ;; ("5" (lambda () (interactive) (tab-bar-select-tab 5)))
    ;; ("6" (lambda () (interactive) (tab-bar-select-tab 6)))
    ;; ("7" (lambda () (interactive) (tab-bar-select-tab 7)))
    ;; ("8" (lambda () (interactive) (tab-bar-select-tab 8)))
    ;; ("9" (lambda () (interactive) (tab-bar-select-tab 9)))
    )
  )

(use-package tab-bar-groups
  :disabled t
  :demand t
  :hook ((tab-bar-groups-tab-post-change-group-functions . tab-bar-groups-regroup-tabs)
         (tab-bar-tab-post-open-functions . tab-bar-groups-regroup-tabs)
         (tab-bar-tab-post-change-group-functions . tab-bar-groups-regroup-tabs)
         (window-buffer-change-functions . dh/regroup-tabs-on-project-change))
  :config
  (defvar dh/last-tab-group nil "Last known tab group for change detection.")
  (defun dh/regroup-tabs-on-project-change (&rest _)
    "Regroup tabs only when the current tab's group actually changed."
    (let ((group (alist-get 'group (tab-bar--current-tab))))
      (unless (equal group dh/last-tab-group)
        (setq dh/last-tab-group group)
        (tab-bar-groups-regroup-tabs))))
  )


(use-package project-tab-groups
  :disabled t
  :demand t
  :after tab-bar
  :custom
  (tab-bar-tab-name-function 'tab-bar-tab-name-current)

  ;; Switch tab-bar-format-tabs to tab-bar-format-tabs-groups
  (tab-bar-format
   '(
     tab-bar-format-history
     tab-bar-format-tabs-groups
     tab-bar-separator
     tab-bar-format-add-tab
     ))

  :custom-face
  (tab-bar-tab-group-current
   ((t (:inherit tab-bar-tab
                 :underline nil
                 ;; :foreground region
                 :box (:line-width 1 :style nil)
                 ))))
  (tab-bar-tab-group-inactive
   ((t (:inherit tab-bar-tab-inactive
                 :underline nil
                 :background "black"
                 :foreground "#a89984"
                 :box (:line-width 1 :style nil)
                                        ; :strike-through t
                 ;; :inverse-video t
                 ))))
  :config
  (project-tab-groups-mode 1)

  (defun tab-bar-groups-current-tab ()
    "Retrieve original data about the current tab."
    (assq 'current-tab (funcall tab-bar-tabs-function)))

  (defun tab-bar-groups-tab-group-name (&optional tab)
    "The group name of the given TAB (or the current tab)."
    (alist-get 'group (or tab (tab-bar-groups-current-tab))))

  (defun dh/tab-bar--move-tab-within-group (direction &optional count)
    "Move current tab DIRECTION within its current group.
DIRECTION is 1 for right and -1 for left.
COUNT is the number of steps to move."
    (let ((steps (max 1 (abs (or count 1)))))
      (catch 'stop
        (dotimes (_ steps)
          (let* ((tabs (funcall tab-bar-tabs-function))
                 (from-index (or (tab-bar--current-tab-index tabs) 0))
                 (to-index (+ from-index direction)))
            (cond
             ((or (< to-index 0) (>= to-index (length tabs)))
              (message "Tab is already at the edge")
              (throw 'stop nil))
             ((equal (tab-bar-groups-tab-group-name (nth from-index tabs))
                     (tab-bar-groups-tab-group-name (nth to-index tabs)))
              (tab-bar-move-tab-to (1+ to-index) (1+ from-index)))
             (t
              (message "Blocked crossing groups; use tab-group to move between groups")
              (throw 'stop nil))))))))

  (defun dh/tab-bar-move-tab-right (&optional arg)
    "Move current tab right within its group."
    (interactive "p")
    (dh/tab-bar--move-tab-within-group 1 arg))

  (defun dh/tab-bar-move-tab-left (&optional arg)
    "Move current tab left within its group."
    (interactive "p")
    (dh/tab-bar--move-tab-within-group -1 arg))


  ;; (defun tab-bar-groups-parse-groups ()
  ;;   "Build an alist of tabs grouped by their group name.
  ;;
  ;; Successive tabs that don't belong to a group are grouped under
  ;; intermitting nil keys.
  ;;
  ;; For example, consider this list of tabs: groupA:foo, groupB:bar,
  ;; baz, qux, groupC:quux, quuz, groupB:corge, groupA:grault.
  ;;
  ;; Calling this function would yield this result:
  ;;
  ;; '((groupA (foo grault))
  ;;   (groupB (bar corge))
  ;;   (nil (baz qux))
  ;;   (groupC (grault))
  ;;   (nil (quuz)))"
  ;;   (interactive)
  ;;   (let* ((tabs (frame-parameter (selected-frame) 'tabs))
  ;;          (result '()))
  ;;     (dolist (tab tabs)
  ;;       (let* ((group-name (tab-bar-groups-tab-group-name tab))
  ;;              (group (and group-name (intern group-name)))
  ;;              (new-named-group-p (and group (null (assq group result))))
  ;;              (in-nil-group-p (and (consp (car result)) (null (caar result))))
  ;;              (new-nil-group-p (not (or group in-nil-group-p))))
  ;;         (if (or new-named-group-p new-nil-group-p)
  ;;             (push (cons group (list tab)) result)
  ;;           (nconc (alist-get group result) (list tab)))))
  ;;     ;; (reverse result)
  ;;     result
  ;;     ))

;;   (defun tab-bar-groups-parse-groups ()
;;     (interactive)
;;     (let* ((tabs (frame-parameter (selected-frame) 'tabs))
;;            (result '()))
;;       (dolist (tab tabs)
;;         (let* ((group-name (tab-bar-groups-tab-group-name tab))
;;                ;; Non-project tabs get unique groups so they remain separate.
;;                (group (if group-name (intern group-name) (gensym "ungrouped-")))
;;                (existing (assq group result)))
;;           (if existing
;;               (nconc (cdr existing) (list tab))
;;             (push (cons group (list tab)) result))
;;
;;           )
;;         )
;;       ;; (pp result)
;;       result
;;       ))
;;
;;   (defun tab-bar-groups-regroup-tabs (&rest _)
;;     "Re-order tabs so that all tabs of each group are next to each other.
;;
;; Accepts, but ignores any arguments so it can be used as-is in the
;; `tab-bar-groups-tab-post-change-group-functions' abnormal
;; hook in order to keep tabs grouped at all times."
;;     (interactive)
;;     (let* ((tabs (apply #'append (seq-map #'cdr (tab-bar-groups-parse-groups)))))
;;       (dotimes (index (length tabs))
;;         (let ((tab (elt tabs index)))
;;           (tab-bar-move-tab-to (1+ index) (1+ (tab-bar--tab-index tab)))))))

  )

;;; --- Auto-close idle tabs ---

(defcustom dh/tab-idle-timeout (* 30 60)
  "Seconds of inactivity before a tab is automatically closed.
Default is half an hour (1800 seconds)."
  :type 'integer
  :group 'tab-bar)

(defcustom dh/tab-idle-check-interval 300
  "Seconds between idle tab checks. Default is 5 minutes."
  :type 'integer
  :group 'tab-bar)

(defcustom dh/tab-idle-minimum-tabs 5
  "Minimum number of tabs to keep open. Auto-close only triggers above this count."
  :type 'integer
  :group 'tab-bar)

(defun dh/tab-idle--record-usage (&rest _)
  "Stamp current time on the current tab."
  (let ((now (float-time))
        (tab (assq 'current-tab (funcall tab-bar-tabs-function))))
    (when tab
      (let ((entry (assq 'dh/last-used tab)))
        (if entry
            (setcdr entry now)
          (nconc tab (list (cons 'dh/last-used now))))))))

(defun dh/tab-idle--record-pre-select (&rest _)
  "Stamp the tab being left before switching."
  (dh/tab-idle--record-usage))

(defun dh/tab-idle--close-old-tabs ()
  "Close tabs idle longer than `dh/tab-idle-timeout'."
  (let* ((tabs (funcall tab-bar-tabs-function))
         (tab-count (length tabs))
         (max-closeable (max 0 (- tab-count dh/tab-idle-minimum-tabs)))
         (now (float-time))
         (candidates '()))
    (when (> max-closeable 0)
      ;; Collect idle candidates with their idle time
      (dotimes (i tab-count)
        (let* ((tab (nth i tabs))
               (is-current (eq (car tab) 'current-tab))
               (last-used (or (cdr (assq 'dh/last-used tab)) now)))
          (when (and (not is-current)
                     (> (- now last-used) dh/tab-idle-timeout))
            (push (cons (1+ i) (- now last-used)) candidates))))
      ;; Sort by most idle first, then take only what we're allowed to close
      (setq candidates (seq-take (sort candidates (lambda (a b) (> (cdr a) (cdr b))))
                                 max-closeable))
      ;; Close from highest index first to avoid shifting
      (dolist (idx (sort (mapcar #'car candidates) #'>))
        (tab-bar-close-tab idx)))))

(defvar dh/tab-idle-timer nil)

(defun dh/tab-idle-mode-enable ()
  "Enable idle tab auto-closing."
  (let ((now (float-time)))
    (dolist (tab (funcall tab-bar-tabs-function))
      (unless (assq 'dh/last-used tab)
        (nconc tab (list (cons 'dh/last-used now))))))
  (add-hook 'tab-bar-tab-pre-select-functions #'dh/tab-idle--record-pre-select)
  (add-hook 'tab-bar-tab-post-select-functions #'dh/tab-idle--record-usage)
  (add-hook 'window-buffer-change-functions #'dh/tab-idle--record-usage)
  (setq dh/tab-idle-timer
        (run-with-timer dh/tab-idle-check-interval dh/tab-idle-check-interval
                        #'dh/tab-idle--close-old-tabs)))

(defun dh/tab-idle-list ()
  "Display all tabs with time since last use."
  (interactive)
  (let ((now (float-time)))
    (message
     (mapconcat
      (lambda (tab)
        (let* ((name (alist-get 'name tab))
               (current (eq (car tab) 'current-tab))
               (last-used (or (cdr (assq 'dh/last-used tab)) 0))
               (idle-secs (- now last-used))
               (hours (floor (/ idle-secs 3600)))
               (mins (floor (/ (mod idle-secs 3600) 60))))
          (format "%s %s: %dh %dm idle"
                  (if current "*" " ") name hours mins)))
      (funcall tab-bar-tabs-function)
      "\n"))))

(defun dh/tab-idle--restore-project-tab (orig-fun &rest args)
  "If a closed tab matches the project being switched to, restore it instead."
  (let* ((dir (car args))
         (project-name (file-name-nondirectory (directory-file-name dir)))
         (prefix (format "[%s]" project-name))
         ;; Check open tabs first
         (tabs (funcall tab-bar-tabs-function))
         (open-idx (seq-position tabs prefix
                                 (lambda (tab pfx)
                                   (string-prefix-p pfx (or (alist-get 'name tab) ""))))))
    (cond
     ;; Jump to existing open tab
     (open-idx
      (tab-bar-select-tab (1+ open-idx)))
     ;; Restore from closed tabs
     ((seq-find (lambda (entry)
                  (string-prefix-p prefix
                                   (or (alist-get 'name (alist-get 'tab entry)) "")))
                tab-bar-closed-tabs)
      (let ((match (seq-find (lambda (entry)
                               (string-prefix-p prefix
                                                (or (alist-get 'name (alist-get 'tab entry)) "")))
                             tab-bar-closed-tabs)))
        (setq tab-bar-closed-tabs
              (cons match (delq match tab-bar-closed-tabs)))
        (tab-bar-undo-close-tab)
        ;; Replace dead buffers in restored tab windows
        (let ((fallback (or (find-buffer-visiting dir)
                            (dired-noselect dir))))
          (walk-windows
           (lambda (w)
             (unless (buffer-live-p (window-buffer w))
               (let* ((name (buffer-name (window-buffer w)))
                      (file (and name (expand-file-name name dir))))
                 (set-window-buffer
                  w (if (and file (file-exists-p file))
                        (find-file-noselect file)
                      fallback)))))
           nil (selected-frame)))))
     ;; No match, fall through
     (t (apply orig-fun args)))))

(advice-add 'project-switch-project :around #'dh/tab-idle--restore-project-tab)

(dh/tab-idle-mode-enable)

;;; --- Persist closed tabs ---

(defcustom dh/tab-closed-history-file
  (expand-file-name "tab-closed-history.el" user-emacs-directory)
  "File to persist recently closed tabs."
  :type 'file
  :group 'tab-bar)

(defcustom dh/tab-closed-history-max 10
  "Maximum number of closed tabs to persist."
  :type 'integer
  :group 'tab-bar)

(defun dh/tab-closed-history-save ()
  "Save the last N closed tabs to disk.
Strips unreadable objects (frames, markers, buffers, window-configurations)."
  (let* ((to-save (seq-take tab-bar-closed-tabs dh/tab-closed-history-max))
         (clean (mapcar (lambda (entry)
                          (list (cons 'index (alist-get 'index entry))
                                (cons 'tab (alist-get 'tab entry))))
                        to-save)))
    (with-temp-file dh/tab-closed-history-file
      (prin1 clean (current-buffer)))))

(defun dh/tab-closed-history-restore ()
  "Restore closed tabs from disk, re-attaching the current frame."
  (when (file-exists-p dh/tab-closed-history-file)
    (condition-case nil
        (with-temp-buffer
          (insert-file-contents dh/tab-closed-history-file)
          (let ((entries (read (current-buffer))))
            (setq tab-bar-closed-tabs
                  (mapcar (lambda (entry)
                            (cons (cons 'frame (selected-frame)) entry))
                          entries))))
      (error (setq tab-bar-closed-tabs nil)))))

(add-hook 'kill-emacs-hook #'dh/tab-closed-history-save)
(add-hook 'after-init-hook #'dh/tab-closed-history-restore)

;;; tabs.el ends here
