
;; ejemplos:
;; (defun test-main ()
;;   (interactive)
;;   (let ((choice (completing-read "Select: " '("item1" "item2" "item3"))))
;;     (message choice)))
;; (let ((algo '(("foobar1" 1) ("barfoo" 2) ("foobaz" 3) ("foobar2" 4))))
;;   (completing-read
;;    "Complete a foo: "
;;    algo
;;    nil t "fo")
;;   )

(defun dh/select-eshell ()
  "Seleccionar entre los buffers de eshell."
  (interactive)
  (let ((buffers
         (mapcar
          (lambda (eshbuf) ;; retorna una lista del nombre con su buffer
            (list (buffer-name eshbuf) eshbuf)
            )
          (seq-filter (lambda (buf) ;; filtra por buffers con eshel
                        (let ((name (buffer-name buf)))
                          (or (string-prefix-p "*eshell" name)
                              (string-suffix-p "eshell*" name))))
                      (buffer-list))
          )
         )
        )
    (if buffers
        (switch-to-buffer
         (completing-read
          "Select: "
          buffers
          nil t
          (get-project-name-except-if-remote)
          )
         )
      (message "No hay buffers de eshell")
      )
    )
  )

;; TODO: crear una terminal del tipo seleccionado
;; (defun dh/create-shell-type ()
;;   "Seleccionar entre los buffers de eshell."
;;   (interactive)
;;   (let ((terminales '("eshell" "vterm")))
;;     (setq sel-term
;;           (completing-read
;;            "Select: "
;;            terminales
;;            nil t))))

(defun dh/eshell-buffer-name ()
  "Conseguir el nombre de una terminal.
Se tiene en cuenta la carpeta actual, el proyecto y la cantidad de
terminales en esta ubicacion."
  (let* ((project-name (get-project-name-except-if-remote
                        :pre "["
                        :pos "]"
                        :else ""))
         (dir-name (if default-directory
                       (file-name-nondirectory
                        (directory-file-name default-directory))
                     "eshell"))
         (base (format "*eshell%s<%s>*" project-name dir-name)))
    (generate-new-buffer-name base)))

(defun dh/create-new-eshell-buffer ()
  (interactive)
  (eshell 99)
  (rename-buffer (dh/eshell-buffer-name) t)
  )

(add-hook 'eshell-mode-hook (lambda () (set (make-local-variable 'scroll-margin) 0)))
(add-hook 'shell-mode-hook (lambda () (set (make-local-variable 'scroll-margin) 0)))
(add-hook 'term-mode-hook (lambda () (set (make-local-variable 'scroll-margin) 0)))

(defun eshell-new()
  "Open a new instance of eshell."
  (interactive)
  (eshell 'N))

(defun display-ansi-colors ()
  (interactive)
  (format-decode-buffer 'ansi-colors))

(defun dh/open-create-eshell-buffer ()
  "Crear un buffer nuevo, o saltar a uno ya existente.
Se crea con el nombre de la carpeta en la que se encuentre.
Adicionalmente, en caso de estar dentro de un proyecto, se utiliza
proyectile para darle nombre al buffer, de forma que se comparta
por todo el proyecto.
"
  (interactive)
  (let* ((nombre
          (concat "*eshell*<"
                  (get-project-name-except-if-remote
                   :else (concat default-directory)
                   )
                  ">")
          )
         (eshell-buffer-exists
          (member nombre
                  (mapcar (lambda (buf)
                            (buffer-name buf))
                          (buffer-list)))))
    (if eshell-buffer-exists
        (switch-to-buffer nombre)
      (progn
        (eshell 99)
        (rename-buffer nombre))))

  )
