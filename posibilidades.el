
;; Cosas que he ido encontrado que podrian ser utiles


;; todo esto fue copiado
;; http://ergoemacs.org/emacs/emacs_init_index.html
;; for isearch-forward, make these equivalent: space newline tab hyphen underscore
(setq search-whitespace-regexp "[-_ \t\n]+")
(setq backup-by-copying t)
(column-number-mode 1)
(progn
  ;; pointless to warn. There's always undo.
  (put 'narrow-to-region 'disabled nil)
  (put 'narrow-to-page 'disabled nil)
  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  (put 'erase-buffer 'disabled nil)
  (put 'scroll-left 'disabled nil)
  (put 'dired-find-alternate-file 'disabled nil)
  )
(progn
  (require 'dired-x)
  (setq dired-dwim-target t)
  (when (string-equal system-type "gnu/linux")
    (setq dired-listing-switches "-al --time-style long-iso"))
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always))
;;; --------------------
(setq save-interprogram-paste-before-kill t)
;; 2015-07-04 bug of pasting in emacs.
;; http://debbugs.gnu.org/cgi/bugreport.cgi?bug=16737#17
;; http://ergoemacs.org/misc/emacs_bug_cant_paste_2015.html
;; (setq x-selection-timeout 300)
(setq sentence-end-double-space nil )
(setq set-mark-command-repeat-pop t)
(setq mark-ring-max 5)
(setq global-mark-ring-max 5)
;;; --------------------
(setq shift-select-mode nil)
(progn
  ;; org-mode
  ;; make “org-mode” syntax color code sections
  (setq org-src-fontify-natively t)
  (setq org-startup-folded nil)
  (setq org-return-follows-link t)
  (setq org-startup-truncated nil))
(progn
  ;; Make whitespace-mode with very basic background coloring for whitespaces.
  ;; http://ergoemacs.org/emacs/whitespace-mode.html
  (setq whitespace-style (quote (face spaces tabs newline space-mark tab-mark newline-mark )))
  )

;; convenient
(defalias 'yes-or-no-p 'y-or-n-p)
(defalias 'rs 'replace-string)
(defalias 'lcd 'list-colors-display)
(defalias 'ds 'desktop-save)
(defalias 'dt 'desktop-save)
(defalias 'dsm 'desktop-save-mode)
(defalias 'elm 'emacs-lisp-mode)
(defalias 'hm 'html-mode)
(defalias 'jsm 'js-mode)
(defalias 'fm 'fundamental-mode)
(defalias 'ssm 'shell-script-mode)
(defalias 'om 'org-mode)
(when (fboundp 'magit-status)
  (defalias 'ms 'magit-status))
;; no want tpu-edt
(defalias 'tpu-edt 'forward-char)
(defalias 'tpu-edt-on 'forward-char)



(progn
  ;; make buffer switch command do suggestions, also for find-file command
  (require 'ido)
  (ido-mode 1)
  ;; show choices vertically
  (if (version< emacs-version "25")
      (progn
        (make-local-variable 'ido-separator)
        (setq ido-separator "\n"))
    (progn
      (make-local-variable 'ido-decorations)
      (setf (nth 2 ido-decorations) "\n")))

  ;; show any name that has the chars you typed
  (setq ido-enable-flex-matching t)
  ;; use current pane for newly opened file
  (setq ido-default-file-method 'selected-window)
  ;; use current pane for newly switched buffer
  (setq ido-default-buffer-method 'selected-window)
  ;; stop ido from suggesting when naming new file
  (when (boundp 'ido-minor-mode-map-entry)
    (define-key (cdr ido-minor-mode-map-entry) [remap write-file] nil)))



(setq hippie-expand-try-functions-list
      '(
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        ;; try-expand-dabbrev-from-kill
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol
        try-complete-file-name-partially
        try-complete-file-name
        ;; try-expand-all-abbrevs
        ;; try-expand-list
        ;; try-expand-line
        ))

;; Helm
(use-package helm
  :ensure t
  :init
  (setq helm-M-x-fuzzy-match t
        helm-mode-fuzzy-match t
        helm-recentf-fuzzy-match t
        helm-locate-fuzzy-match t
        helm-semantic-fuzzy-match t
        helm-imenu-fuzzy-match t
        helm-completion-in-region-fuzzy-match t
        helm-candidate-number-list 150
        helm-split-window-inside-p t
        helm-move-to-line-cycle-in-source t
        helm-echo-input-in-header-line t
        helm-autoresize-max-height 0
        helm-autoresize-min-height 20
        helm-buffers-fuzzy-matching t
        )
  :config
  (helm-mode 1))

;; TODO estas funciones suenan interesantes
;; A function that behaves like Vim's ':tabe' commnad for creating a new tab and
;; buffer (the name "[No Name]" is also taken from Vim).
(defun vimlike-:tabe ()
  "Vimlike ':tabe' behavior for creating a new tab and buffer."
  (interactive)
  (let ((buffer (generate-new-buffer "[No Name]")))
    ;; create new tab
    (elscreen-create)
    ;; set window's buffer to the newly-created buffer
    (set-window-buffer (selected-window) buffer)
    ;; set state to normal state
    (with-current-buffer buffer
      (evil-normal-state))
    )
  )
(defun vimlike-quit ()
  "Vimlike ':q' behavior: close current window if there are split windows;
otherwise, close current tab (elscreen)."
  (interactive)
  (let ((one-elscreen (elscreen-one-screen-p))
        (one-window (one-window-p))
        )
    (cond
                                        ; if current tab has split windows in it, close the current live window
     ((not one-window)
      (delete-window) ; delete the current window
      (balance-windows) ; balance remaining windows
      nil)
                                        ; if there are multiple elscreens (tabs), close the current elscreen
     ((not one-elscreen)
      (elscreen-kill)
      nil)
                                        ; if there is only one elscreen, just try to quit (calling elscreen-kill
                                        ; will not work, because elscreen-kill fails if there is only one
                                        ; elscreen)
     (one-elscreen
      (evil-quit)
      nil)
     )))

(defun complete-or-indent ()
  (interactive)
  (if (company-manual-begin)
      (company-complete-common)
    (indent-according-to-mode)))

;; me gusta mas el funcionamiento de esto que el de company-indent-or-complete-common
(defun indent-or-complete ()
  (interactive)
  (if (or (looking-at "\\_>"))
      (company-complete-common)
    (indent-according-to-mode)))

;; esto es para poner toda la ventana transparente, aunque ya lo tengo incorporado
;; es para referencia de lo de abajo
(set-frame-parameter (selected-frame) 'alpha '(85 85))
(add-to-list 'default-frame-alist '(alpha 85 85))
(set-face-attribute 'default nil :background "black"
  :foreground "white" :font "Courier" :height 180)

;; TODO: me gustaria poder poner solo un corte transparente en vez de toda la ventana
(set-window-parameter (selected-window) 'alpha '(95 95))

;; no se si esto siga siendo necesario :v
(defun my-company-active-return ()
  "Function to autocomplete a company recomendation, or act as enter, depending on mode."
  (interactive)
  (if (company-explicit-action-p)
      (company-complete)
    (call-interactively
     (or (key-binding (this-command-keys))
         (key-binding (kbd "RET")))
     )))

;; para hacer acciones despues de cargar algo
(eval-after-load 'company
  '(progn
     (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
     (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)))
(eval-after-load 'company
  '(progn
     (define-key company-active-map (kbd "S-TAB") 'company-select-previous)
     (define-key company-active-map (kbd "<backtab>") 'company-select-previous)))



(setq custom-tab-width 2)
(defun disable-tabs () (setq indent-tabs-mode nil))
(defun enable-tabs  ()
  (interactive)
  (local-set-key (kbd "TAB") 'tab-to-tab-stop)
  (setq indent-tabs-mode t)
  (setq tab-width custom-tab-width))
(enable-tabs)


;; TODO: meter esto en alguna parte
xref-find-definition-other-window


;; todo esto iba dentro de la configuracion de company, pero me parece que ya no es necesario
  (defun my-company-visible-and-explicit-action-p ()
    (and (company-tooltip-visible-p)
         (company-explicit-action-p)))

  (defun company-ac-setup ()
    "Sets up `company-mode' to behave similarly to `auto-complete-mode'."
    (setq company-require-match nil)
    ;;(setq company-auto-complete #'my-company-visible-and-explicit-action-p)
    (setq company-frontends '(company-echo-metadata-frontend
                              company-pseudo-tooltip-unless-just-one-frontend-with-delay
                              company-preview-frontend))
    (define-key company-active-map [tab]
      'company-select-next-if-tooltip-visible-or-complete-selection)
    (define-key company-active-map (kbd "TAB")
      'company-select-next-if-tooltip-visible-or-complete-selection))

  (company-ac-setup)



;; otros/mover ------------------------------------------------

(setq custom-tab-width 2)

(defun disable-tabs ()
  (interactive)
  (setq indent-tabs-mode nil))
(defun enable-tabs  ()
  (interactive)
  (local-set-key (kbd "TAB") 'tab-to-tab-stop)
  (setq indent-tabs-mode t)
  (setq tab-width custom-tab-width))
(enable-tabs)
                                        ;(local-set-key (kbd "TAB") 'tab-to-tab-stop)
(setq indent-tabs-mode t)
(setq tab-width custom-tab-width))
                                        ; redefinir mappings de evil
(with-eval-after-load 'evil-maps
  )

    ;; (let ((conf-file (expand-file-name
    ;;                  (concat config-directory file)) ))
      ;; (when (equal compile t)
      ;;                        ;; (file-newer-than-file-p config-file (concat conf-file "c"))
      ;;   (message "comp")
      ;;   (byte-compile-file conf-file)
      ;;      )
      ;; (when (equal compile t)
      ;;
      ;; 	(if (not (file-exists-p conf-file))
      ;; 	    (byte-compile-file conf-file)
      ;; 	  (when (file-newer-than-file-p (concat conf-file ".el") (concat conf-file ".elc"))
      ;; 	      (byte-compile-file conf-file)
      ;; 	    )
      ;; 	  )
      ;;   )

    ;; (message "Loaded config file:%s" file)


;; Para cargar archivos externos como parte de la configuracion

;; (defun load-config-module-all (compile config-directory)
;;   "Carga todos los archivos encontrados uno por uno en config-directory."
;;   (if compile (byte-recompile-directory config-directory 0))
;;  ;;  (dolist (file (file-expand-wildcards (concat config-directory "/*.el")))
;;  ;;    (let ((comp-file (concat file "c")))
;;  ;;      (if (file-exists-p comp-file)
;;  ;;          (load comp-file)
;;  ;;        (load file)))
;;   (load-config-module compile
;;                       config-directory
;;                       (directory-files
;;                        config-directory
;;                        nil
;;                        ;; "^\\([^.]\\|\\.[^.]\\|\\.\\..\\)" ;; ignorar '.' y '..'
;;                        "\\.el$"
;;                        )))

(defun load-comp-config-module-folder (config-directory &optional config-comp archivos-ignorar)
  (if config-comp (byte-recompile-directory config-directory 0))
  (let ((libraries-loaded '() )
        (libraries-ignore (mapcar (lambda (f) (concat config-directory f)) archivos-ignorar))
        )
    (dolist (ign libraries-ignore)
      (push ign libraries-loaded)
      (message (concat "ignorado :  " ign )))
    (dolist (file (directory-files config-directory t ".+\\.elc$"))
      (let ((library (file-name-sans-extension file)))
        (unless (member library libraries-loaded)
          ;;(load library)
          (message library)
          (push library libraries-loaded)
          )))))

;; algo que podria servir para ampliar:
;; - https://www.emacswiki.org/emacs/LoadPath
;; - https://www.gnu.org/software/emacs/manual/html_node/elisp/File-Name-Components.html
;; originalmente sacado de https://stackoverflow.com/questions/18706250/emacs-require-all-files-in-a-directory
(defun load-config-module-all (config-directory &optional config-compile)
  "`load' all elisp libraries in directory DIR which are not already loaded."
  (if config-compile (byte-recompile-directory config-directory 0))
  ;; (let ((libraries-loaded (mapcar #'file-name-sans-extension
  ;;                                 (delq nil (mapcar #'car load-history)))))
  (let ((libraries-loaded '() ))
    ;; (dolist (a libraries-loaded)
    ;;     (message (concat "------ " a))
    ;;   )
	(dolist (file (directory-files config-directory t ".+\\.elc?$"))
	  (let ((library (file-name-sans-extension file)))
		(unless (member library libraries-loaded)
		  (load library)
		  ;;(message library)
		  (push library libraries-loaded))))))

;; TODO: podria ser interesante hacer un paquete que cargue los
;; modulos, similar a use-package, pero mas simple
;;(cl-defstruct config-file
  ;;name
  ;;load
  ;;)
;;(load-config-file :name "basic" :load 1)

(defun load-config ()
  "Cargar los archivos de configuracion."
  (interactive)
  (load-config-module
   config-module-dir
   '(
     "basic"
     "general"
     "funciones"
     "decoration"
     "tabs"
     "term"
     "git"
     "evil"
     "project"
     "completion"
     "ivy"
     "mode-line"
     "org-mode"
     "minibuffer"
     "hydras"
     )
   ;; "fira-code"
   )

  ;; cargar la configuracion de todos los lenguajes
  (load-config-module-all config-lang-dir)
  )


(defun load-config-module (config-directory filelist &optional config-compile)
  "Cargar un archivo de configuracion a partir del FILELIST."
  (if config-compile (byte-recompile-directory config-directory 0))
  (dolist (file filelist) (load (concat config-directory file))))
