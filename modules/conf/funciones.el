;;; funciones.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; User-defined helper functions

;; functions -----------------------------------------------
;;; Code:

(defun dh/save-all-buffers ()
  "Save all buffers."
  (interactive)
  (mapc 'save-buffer (buffer-list) )
  (message "Se han guardado todos los buffers") )

(defun dh/reload-emacs-config ()
  "Reload your init.el file without restarting Emacs."
  (interactive)
  (load-file (concat user-emacs-directory "init.el")))

(defun dh/open-emacs-config ()
  "Open your init.el file."
  (interactive)
  (find-file (concat user-emacs-directory "init.el")))

(defun dh/google ()
  "Googles a query or region if any."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (if mark-active
        (buffer-substring (region-beginning) (region-end))
      (read-string "Google: ")))))

(defun dh/show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

(defun dh/toggle-terminal ()
	"Toggle terminal in its own buffer."
	(interactive)
	(eshell)
	(message (buffer-file-name (current-buffer))))

;; Set transparency of emacs
(defun dh/transparency (value)
  "Set the transparency of the frame window to VALUE.  0=transparent/100=opaque."
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value)
  )

(defun dh/toggle-transparency ()
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

(defun dh/insert-file-name (filename &optional args)
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

(global-set-key "\C-c\C-i" 'dh/insert-file-name)

(defun dh/fill-column ()
  "Para que no se me olvide."
  (interactive)
  (setq fill-column 120)
  (display-fill-column-indicator-mode))

(defun dh/insert-literal-key-pressed (key)
  (interactive "kKey: ")
  (insert (format "(kbd %S)" (key-description key))))

(defun dh/return-first-existing-file (posible-files)
  (let ((first (car posible-files))
        (rest (cdr posible-files)))
    (if (file-exists-p first)
        first
      (if rest (dh/return-first-existing-file rest)))))


(defun dh/set-by-first-existing-file (var posible-files)
  (let ((first (car posible-files))
        (rest (cdr posible-files)))
    (if (file-exists-p first)
        (set var first)
      (if rest (dh/set-by-first-existing-file var rest)))))

(defun dh/set-lang-config-file (var config-filename &optional u-path)
  (let ((saved-path (expand-file-name "lang-config" user-emacs-directory))
        (unsaved-path (or u-path "~")))
    (let ((saved (format "%s/%s" saved-path config-filename))
          (unsaved (format "%s/%s" unsaved-path config-filename)))
      (dh/set-by-first-existing-file var (list unsaved saved)))))

;;; funciones.el ends here
