
;; functions -----------------------------------------------
;;; Code:

(defun save-all-buffers ()
  "Save all buffers."
  (interactive)
  (mapc 'save-buffer (buffer-list) )
  (message "Se han guardado todos los buffers") )

(defun kill-other-buffers ()
  "Kill all other buffers, except the current buffer and Emacs' 'system' buffers."
  (interactive)
  (save-all-buffers)
  (mapc
   (lambda (x)
     (let ((name (buffer-name x) ) )
       (unless (eq ?\s (aref name 0) )
         (kill-buffer x) ) ) )
   (delq (current-buffer) (buffer-list) ) )
  (message "Se han cerrado los demas buffers")
  )

(defun dahas/refresh-package-database ()
  "Refresh melpa contents."
  (interactive)
  (package-refresh-contents 'ASYNC)
  ;; (auto-package-update-now)
  )

(defun reload-emacs-config ()
  "Reload your init.el file without restarting Emacs."
  (interactive)
  (load-file (concat user-emacs-directory "init.el")))

(defun open-emacs-config ()
  "Open your init.el file."
  (interactive)
  (find-file (concat user-emacs-directory "init.el")))

(defun prelude-google ()
  "Googles a query or region if any."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (if mark-active
        (buffer-substring (region-beginning) (region-end))
      (read-string "Google: ")))))

(defun nmap (key function)
  "Define mapping in evil normal mode.  FUNCTION in KEY."
  (define-key evil-motion-state-map (kbd key) function) )

(defun imap (key function)
  "Define mapping in evil insert mode.  FUNCTION in KEY."
  (define-key evil-insert-state-map (kbd key) function) )

(defun amap (key function)
  "Define mapping in evil normal and insert mode.  FUNCTION in KEY."
  (nmap key function)
  (imap key function) )

(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

(defun toggle-terminal ()
	"Toggle terminal in its own buffer."
	(interactive)
	;; (split-window-horizontally)
	(eshell)
	(message
	 (buffer-file-name (current-buffer) ) )
	)

;; Set transparency of emacs
(defun transparency (value)
  "Set the transparency of the frame window to VALUE.  0=transparent/100=opaque."
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value)
  )

(defun toggle-transparency ()
  "Toggle between frame transparency of 95 and 100."
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond
               ((numberp alpha) alpha)
               ((numberp (cdr alpha)) (cdr alpha))
               ;; Also handle undocumented (<active> <inactive>) form.
               ((numberp (cadr alpha)) (cadr alpha))
               )
              100)
         ;; el segundo valor es para cuando no esta enfocado
         '(95 . 95) '(100 . 100)))))

;; (require 'notifications)
;; (defun send-notification (msg)
;;   "Prueba MSG."
;;   (notifications-notify
;;     :title msg
;;     :body "There's 34 mails unread"
;;     :urgency 'low)
;;   )

(defun print-list (list)
  "Imprimir todos los elementos de la lista LIST."
  (dolist (el list)
    (print el)
    )
  )

(defun kill-org-buffers ()
  "Kill all org buffers."
  (interactive)
  (dolist (x (buffer-list))
    (let ((name (buffer-name x) ) )
      ;; (message name)
      (if (string-match "\\.org\\'" name)
          (progn
            (message (concat ">> " name))
            (save-buffer x)
            (kill-buffer x)
            )
        )
      )
    )
  )

(defun dahas/insert-relative-file-name (filename &optional args)
  "Insert name of file FILENAME into buffer after point.

  Prefixed with \\[universal-argument], expand the file name to
  its fully canocalized path.  See `expand-file-name'.

  Prefixed with \\[negative-argument], use relative path to file
  name from current directory, `default-directory'.  See
  `file-relative-name'.

  The default with no prefix is to insert the file name exactly as
  it appears in the minibuffer prompt."
  ;; Based on insert-file in Emacs -- ashawley 20080926
  (interactive "*fInsert file name: \nP")
  (cond ((eq '- args)
         (insert (file-relative-name filename))
         )
        ((not (null args))
         (insert (expand-file-name filename)))
        (t
         (insert filename))))

(defun my-insert-file-name (filename &optional args)
  "Insert name of file FILENAME into buffer after point.

  Prefixed with \\[universal-argument], expand the file name to
  its fully canocalized path.  See `expand-file-name'.

  Prefixed with \\[negative-argument], use relative path to file
  name from current directory, `default-directory'.  See
  `file-relative-name'.

  The default with no prefix is to insert the file name exactly as
  it appears in the minibuffer prompt."
  ;; Based on insert-file in Emacs -- ashawley 20080926
  (interactive "*fInsert file name: \nP")
  (cond ((eq '- args)
         (insert (file-relative-name filename)))
        ((not (null args))
         (insert (expand-file-name filename)))
        (t
         (insert filename))))

(global-set-key "\C-c\C-i" 'my-insert-file-name)


(defun dh/fill-column ()
  "Para que no se me olvide."
  (interactive)
  (setq fill-column 80)
  (display-fill-column-indicator-mode)
  ;; (global-display-fill-column-indicator-mode)
  ;; (set-face-attribute 'fill-column-indicator nil :foreground "grey90")
  )

(defun dahas/prt-list (list)
  (dolist (val list)
    (message val)
    )
  )

(defun insert-literal-key-pressed (key)
  (interactive "kKey: ")
  (insert (format "(kbd %S)" (key-description key))))

(defun dh/return-first-existing-file (posible-files)
  (let ((first (car posible-files))
        (rest (cdr posible-files)))
    (if (f-exists-p first)
        first
      (if rest (dh/return-first-existing-file rest)))))


(defun dh/set-by-first-existing-file (var posible-files)
  (let ((first (car posible-files))
        (rest (cdr posible-files)))
    (if (f-exists-p first)
        (set var first)
      (if rest (dh/set-by-first-existing-file var rest)))))

(defun dh/set-lang-config-file (var config-filename &optional u-path)
  (let ((saved-path (expand-file-name "lang-config" user-emacs-directory))
        (unsaved-path (if u-path u-path "~"))) ;; TODO: maybe it could be a good idea to move it somewhere else than ~
    (let ((saved (format "%s/%s" saved-path config-filename))
          (unsaved (format "%s/%s" unsaved-path config-filename)))
      ;; (message (format "loading from: saved:%s unsaved:%s" saved unsaved))
      (dh/set-by-first-existing-file var (list unsaved saved)))))
