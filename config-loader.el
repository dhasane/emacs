;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; funciones para cargar archivos de elisp

;;; code:

;; TODO: arreglar para native-compile
;; https://stackoverflow.com/questions/20952894/what-emacs-lisp-function-is-to-require-as-autoload-is-to-load

(require 'cl-lib)

(defun cl/expand-name (file)
  "Expands FILE in relation to emacs dir."
  (expand-file-name file user-emacs-directory))

(cl-defun cl/dir (dir-name &key ignore)
  "Get all filenames in DIR-NAME. Ignores files listed in ignore."
  (let ((dir (cl/expand-name (concat dir-name "/"))))
    ;; (cl/comp-dir dir compile)
    (let ((ignore-exp (mapcar #'(lambda (x) (concat dir x)) ignore)))
      (seq-uniq ;; if a file has been compiled, it will appear 2 times
       (cl-remove-if (lambda (r) (member r ignore-exp))
                     (mapcar #'file-name-sans-extension (directory-files dir t "^\\([^.]\\|\\.[^.]\\|\\.\\..\\)")))))
    ))

(defun cl/file (filename)
  "Gets FILENAME and inserts it into a list."
  (let ((file (cl/expand-name filename)))
    ;; (cl/comp-file file compile)
    (list file)))

(defun cl/load (filelist &rest add-filelist)
  "Load FILELIST, list which contains the full path to the files to load.
The files don't have their extention.
COMP is to compile the files (not working). "
  (let ((files (if add-filelist
                   (flatten-tree (list filelist add-filelist))
                 filelist)))
    (let ((f (car files)) (l (cdr files)))
      (load f)
      (if l (cl/load l)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;        compile / maybe remove       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun cl/comp-dir (dir-name compile)
  "Compile files in list COMPILE in directory DIR-NAME.
Every compiled file not found in COMPILE is deleted."
  (mapc #'(lambda (x) (cl/clean-compile (file-name-sans-extension x)))
        (cl-remove-if (lambda (r) (member (file-name-base r) compile))
                      (directory-files dir-name t ".elc$")))

  (mapc #'(lambda (x)
            (cl/compile-file
             (concat dir-name x)))
        compile)
  )

(defun cl/comp-file (file compile)
  "Compile FILE if COMPILE is true."
  (if compile
      (cl/compile-file file)
    (cl/clean-compile file))
  )

(defun cl/clean-compile (filename)
  "Remove compiled version of FILENAME."
  (let ((file (concat filename ".elc")))
    (if (file-exists-p file)
        (progn
          (print (format "deleting: %s" file))
          (delete-file file)
          ))))

(defun cl/compile-file (filename)
  "Compilar FILENAME solo si aun no existe."
  (print (format ";;; %s" filename))
  (let ((file (concat filename ".el"))
        (compfile (concat filename ".elc")))
    (if (or (not (file-exists-p compfile))
            (file-newer-than-file-p file compfile))
        (progn
          (message (concat "compiling: " file))
          (byte-compile-file file))
      ;; (message "all is gud")
      )))


(provide 'config-loader)
;;; config-loader.el ends here
