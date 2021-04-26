;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; funciones para compilar archivos de elisp

;;; code:

;; TODO: arreglar para native-compile
;; https://stackoverflow.com/questions/20952894/what-emacs-lisp-function-is-to-require-as-autoload-is-to-load

(defun dh/load-file (file)
  "Cargar FILE.
Servir como un wrapper alrededor de la funcion de carga.
Para no tener que cambiar en varias partes sino solo aca."
  (load-file file)
  )

(defun dh/compile-file (filename)
  "Compilar FILENAME.
Estaba aburrido y queria poner para que se compile un unico archivo."
  (let ((file (concat filename ".el"))
        (comfile (concat filename ".elc")))
    (if (or (not (file-exists-p comfile))
            (file-newer-than-file-p file comfile)
            )
        (progn
          (message (concat "compilando: " file)) ;; compilar
          (byte-compile-file file)
          )
      ;; (message "all is gud") ;; al is gud
      )
    )
  )

(cl-defun comp-load-folder (config-dir &key compilar ignorar)
  "Carga los archivos en CONFIG-DIR con terminacion el o elc.
En caso de que COMPILE sea t, se compilan todos los archivos en CONFIG-DIR.
Al ser nil, se eliminan todos los archivos .elc que se encuentren,
para evitar que vayan a ser cargados en vez de los .el.
Se ignoran los archivos en la lista IGNORAR y no son cargados.
COMPILAR sirve para que solo archivos especificos sean copilados."
  (let ((files-ignore
         (mapcar (lambda (f)
                   (concat config-dir f ".elc?$"))
                 ignorar)))

    (dolist (comp-file (mapcar (lambda (f)
                            (concat config-dir f))
                          compilar))
      (dh/compile-file comp-file)
      (dh/load-file comp-file)
      )

    (dolist (ign files-ignore)
      (message (concat "ignorando: " ign))
      )

    (dolist (file (directory-files config-dir t ".el$"))
      (unless (member file files-ignore)
        ;; (message file)
        (dh/load-file file)
        )
      )
    )
  )

(cl-defun compile-all-load-folder (config-dir &key compile ignorar)
  "Carga los archivos en CONFIG-DIR con terminacion el o elc.
En caso de que COMPILE sea t, se compilan todos los archivos en CONFIG-DIR.
Al ser nil, se eliminan todos los archivos .elc que se encuentren,
para evitar que vayan a ser cargados en vez de los .el.
Se ignoran los archivos en la lista IGNORAR y no son cargados."
  (if compile
      (byte-recompile-directory config-dir 0)
    (dolist (file (directory-files config-dir t ".+\\.elc$"))
      (message (concat "borrando " file ))
      (delete-file file)
      )
    )
  (let ((files-ignore
         (mapcar (lambda (f)
                   (concat config-dir f (if compile ".elc" ".el")))
                 ignorar)))

    (dolist (ign files-ignore)
      (message (concat "ignorando: " ign))
      )

    (dolist (file (directory-files config-dir t (if compile ".elc$" ".el$")))
      (unless (member file files-ignore)
        ;; (message file)
        (dh/load-file file)
        )
      )
    )
  )

(defun auto-comp-init ()
  "Auto compilar el archivo INIT."
  ;; esta dando errores al comenzar desde el archivo compilado
  (dh/compile-file (concat user-emacs-directory "init"))
  )

;;; Compile ends here
