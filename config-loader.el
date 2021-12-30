;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; funciones para cargar archivos de elisp

;;; code:

;; TODO: arreglar para native-compile
;; https://stackoverflow.com/questions/20952894/what-emacs-lisp-function-is-to-require-as-autoload-is-to-load

(defun cl/expand-name (file)
  "Expands FILE in relation to emacs dir."
  (expand-file-name file user-emacs-directory))

;; me gustaria usar cl-defun, pero por alguna razon da problemas
(defun cl/dir (dir-name &optional ignore)
  "Get all filenames in DIR-NAME. Ignores files listed in ignore."
  (let ((dir (cl/expand-name (concat dir-name "/")))
        (ignore-exp (mapcar #'(lambda (x) (cl/expand-name (concat dir-name "/" x))) ignore)))
    (delete-dups (append (mapcar #'file-name-sans-extension (directory-files dir t "^\\([^.]\\|\\.[^.]\\|\\.\\..\\)"))
                         ignore-exp))))

(defun cl/file (filename)
  "Gets FILENAME and inserts it into a list."
  (list (cl/expand-name filename)))

(defun cl/load (filelist &rest add-filelist)
  "Load FILELIST, list which contains the full path to the files to load.
The files don't have their extention.
COMP is to compile the files (not working). "
  (let ((files (if add-filelist
                   (flatten-tree (list filelist add-filelist))
                 filelist)))
    (let ((f (car files)) (l (cdr files)))
      ;; (if comp (cl/compile-file f) (cl/clean-compile f)) ;; esto podria ser interesante arreglarlo, pero no afecta mucho
      (load f)
      (if l (cl/load l)))))

(defun cl/clean-compile (filename)
  "Remove compiled version of FILENAME."
  (let ((file (concat filename ".elc")))
    (if (file-exists-p file)
        (delete-file file))))

(defun cl/compile-file (filename)
  "Compilar FILENAME solo si aun no existe."
  (let ((file (concat filename ".el"))
        (comfile (concat filename ".elc")))
    (if (or (not (file-exists-p comfile))
            (file-newer-than-file-p file comfile))
        (progn
          (message (concat "compiling: " file))
          (byte-compile-file file))
      ;; (message "all is gud")
      )))

(provide 'config-loader)
;;; config-loader.el ends here
