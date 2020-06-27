
;; functions -----------------------------------------------
;;; Code:

(defun gbind (key function)
  "Map FUNCTION to KEY globally."
  (global-set-key (kbd key) function) )

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

(defun melpa-refresh ()
  "Refresh melpa contents."
  (interactive)
  (package-refresh-contents 'ASYNC) )

(defun reload-emacs-config ()
  "Reload your init.el file without restarting Emacs."
  (interactive)
  (load-file "~/.emacs.d/init.el") )

(defun open-emacs-config ()
  "Open your init.el file."
  (interactive)
  (find-file "~/.emacs.d/init.el") )

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
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
		 ;; el segundo valor es para cuando no esta enfocado
         '(95 . 95) '(100 . 100)))))
