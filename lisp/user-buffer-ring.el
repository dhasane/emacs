

;;; Code:
(defcustom user-buffer-ring ()
  "Ultimos buffers visitados."
  :type 'list
  :group 'user-buffer-ring
  )

(defcustom user-buffer-ring-index 0
  "Posicion actual en los buffers."
  :type 'number
  :group 'user-buffer-ring
  )

(defcustom user-buffer-ring-max 20
  "Tam maximo para los ultimos buffers visitados."
  :type 'number
  :group 'user-buffer-ring
  )

(defun show-user-buffer-ring ()
  "Mostrar los ultimos buffers visitados."
  (interactive)
  (message "%s" user-buffer-ring)
  )

(defun get-user-buffer-ring-i ()
  "Saltar al buffer en la posicion de user-buffer-ring-index."
  (interactive)
  (let ((bff (nth user-buffer-ring-index user-buffer-ring)))
    (switch-to-buffer bff)
    )
  )

(defun prev-user-buffer-ring ()
  "User-buffer-ring-index + 1."
  (interactive)
  (when (> (- (length user-buffer-ring) 1) user-buffer-ring-index)
    (setq user-buffer-ring-index (+ user-buffer-ring-index 1))
    (get-user-buffer-ring-i)))

(defun next-user-buffer-ring ()
  "User-buffer-ring-index - 1."
  (interactive)
  (when (< 0 user-buffer-ring-index)
    (setq user-buffer-ring-index (- user-buffer-ring-index 1))
    (get-user-buffer-ring-i)))

(defun save-to-user-buffer-ring ()
  "Agregar un nuevo buffer al user-buffer-ring."
  (when (buffer-file-name)
    (let ((bfn (buffer-name)))
      (setq user-buffer-ring-index 0)
      (message (concat "agregando " bfn))
      (when (member bfn user-buffer-ring)
        (remove-value-from-user-buffer-ring bfn))
      (push bfn user-buffer-ring)))
  (when (> (length user-buffer-ring) user-buffer-ring-max)
    (setq user-buffer-ring (butlast user-buffer-ring))))

(defun remove-value-from-user-buffer-ring (bfn)
  "Eliminar el valor BFN del user-buffer-ring."
  (interactive)
  (setq user-buffer-ring (delete bfn user-buffer-ring)))

(defun remove-from-user-buffer-ring ()
  "Eliminar los buffers del user-buffer-ring."
  (when (buffer-file-name)
    (remove-value-from-user-buffer-ring (buffer-name))))

(add-hook 'find-file-hook 'save-to-user-buffer-ring)
(add-hook 'kill-buffer-hook 'remove-from-user-buffer-ring)


(defun user-buffer-ring-get-index ()
  "Update `user-buffer-ring-index` to match the current buffer's position."
  (interactive)
  (let ((pos (seq-position user-buffer-ring (buffer-name))))
    (when pos
      (setq user-buffer-ring-index pos)
      (message "index: %d" user-buffer-ring-index))))

(provide 'user-buffer-ring)
;;; user-buffer-ring ends here
