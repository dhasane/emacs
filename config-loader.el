;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; funciones para cargar archivos de elisp

;;; code:

;; could be nice to save this across sessions
(defcustom config-loader-lazy nil
  ""
  :type 'list
  :group 'config-loader)

(require 'cl-lib)

(defun cl/expand-name (file)
  "Expands FILE in relation to emacs dir."
  (expand-file-name file user-emacs-directory))

(cl-defun cl/dir (dir-name &key ignore lazy)
  "Get all filenames in DIR-NAME. Ignores files listed in ignore."

  (let* ((dir (cl/expand-name (concat dir-name "/")))
         (ignore-exp (mapcar #'(lambda (x) (concat dir x))
                             (flatten-tree (list ignore
                                                 (if lazy (cl/lazy-load dir-name lazy)))))))
                     ;; (cl/comp-dir dir compile)
                     (seq-uniq ;; if a file has been compiled, it will appear 2 times
                      (cl-remove-if (lambda (r) (member r ignore-exp))
                                    (mapcar #'file-name-sans-extension (directory-files dir t "^\\([^.]\\|\\.[^.]\\|\\.\\..\\)")))))
         )

(defun cl/file (filename)
  "Gets FILENAME and inserts it into a list."
  (let ((file (cl/expand-name filename)))
    ;; (cl/comp-file file compile)
    (list file)))

(defun cl/load (&rest filelist)
  "Load FILELIST, it may be a list, or a list of lists.
Elements contained in these lists represent full paths to files to load."
  (let* ((files (flatten-tree filelist))
         (f (car files)) (l (cdr files)))
    (load f)
    (if l (cl/load l))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;        lazy loading of files        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun cl/add-hook-for-extension (ext)
  ""
  (message (concat "added hook for " ext))
  (add-hook 'find-file-hook #'(lambda () (cl/add-check-extension ext))))

(defun cl/remove-hook-for-extension (ext)
  ""
  (message (concat "removed hook for " ext))
  (remove-hook 'find-file-hook #'(lambda () (cl/add-check-extension ext))))

(defun cl/load-extension-files (ext)
  "Load files for extension EXT.  Usefull for force loading EXT."
  (cl/remove-hook-for-extension ext)
  (message "loading config for %s" ext)

  (cl/load
   (flatten-tree
    (mapcar (lambda (elem)
              (mapcar
               #'(lambda (to-load-file)
                   ;; (message "(%s)" to-load-file)
                   (cl/modify-var ext (car elem))
                   (let ((filepath (format "%s/%s" (car elem) to-load-file)))
                     (cl/file filepath)))
               (flatten-tree (cdr elem))))
            (cl/get-in-var ext)))))

(defun cl/force-load-ext ()
  (interactive)
  (let ((force-load-e (completing-read
                       "Select: "
                       config-loader-lazy
                       nil t)))
    (if (not (null force-load-e))
        (cl/load-extension-files force-load-e))))

(defun cl/check-extension (ext)
  (if (and (stringp buffer-file-name)
       (string-match (concat "\\." ext "\\'") buffer-file-name))
      t
    nil))

(defun cl/add-check-extension (ext)
  "Check if current file has extension EXT.  If so, the files for the EXT are loaded."
  (if (cl/check-extension ext)
    (cl/load-extension-files ext)))

(defun cl/add-to-var (ext dir-name to-load)
  ""
  (message "adding %s::%s::%s" ext dir-name to-load)
  ;; (if (null (boundp 'config-loader-lazy))
  ;;     (defvar config-loader-lazy nil))

  (let* ((store-val (list (cons dir-name (list to-load))))
         (complete-val (cons ext store-val))
         (cur-val (assoc ext config-loader-lazy))
         (type-list (cdr cur-val))
         (to-load-list (cdr (car type-list))))

    (if (null cur-val)
        (add-to-list 'config-loader-lazy complete-val)
      (let* ((sub-cons (assoc dir-name type-list)))
        (if (null sub-cons)
            (setf type-list (nconc (cdr cur-val) store-val))
          (setf to-load-list (seq-uniq to-load-list to-load))))))

  config-loader-lazy)

(defun cl/get-in-var (ext &optional dir-name)
  "If found will return the state, otherwise nil."
  (cdr
   (if dir-name
       (assoc dir-name (cdr (assoc ext config-loader-lazy)))
     (assoc ext config-loader-lazy))))

(defun cl/modify-var (ext dir-name)
  "Changes the list of files to load to t, to represent they have been loaded."
  (setcdr (assoc dir-name (cdr (assoc ext config-loader-lazy))) nil)
  )

(defun cl/get-exts-in-var ()
  "Get car from all values in list."
  (mapcar (lambda (x) (car x)) config-loader-lazy))

(defun cl/lazy-load-if-not-in-var (ext dir-name to-load)
  ""
  ;; only add if there are no configurations for it
  (if (null (cl/get-in-var ext dir-name))
      (cl/add-to-var ext dir-name to-load)
      )

  (let ((ext-state (cl/get-in-var ext dir-name)))
    (if (not (null ext-state))
        (progn
          (cl/add-hook-for-extension ext) ;;    agregar hook
          to-load
          )
      nil)))

(defun cl/lazy-load (dir-name lazy)
  ""
  (flatten-tree
   (mapcar (lambda (elem)
            (let ((exts (flatten-tree (car elem)))
                  (to-load (flatten-tree (cdr elem))))
              (mapcar (lambda (ext)
                        (message "%s::%s" ext to-load)
                        (cl/lazy-load-if-not-in-var ext dir-name to-load))
                      exts)))
          lazy))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                        ;        compile / maybe remove       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; TODO: arreglar para native-compile
;; https://stackoverflow.com/questions/20952894/what-emacs-lisp-function-is-to-require-as-autoload-is-to-load

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
