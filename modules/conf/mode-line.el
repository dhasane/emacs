;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

;; change mode-line color by evil state
;; (let (default-color (cons (face-background 'mode-line)
                          ;; (face-foreground 'mode-line)))
;; (add-hook 'post-command-hook
;;           (lambda ()
;;             (let ((color (cond ;; ((minibufferp) default-color)
;;                           ((evil-insert-state-p) '("#73b3e7" . "#3e4249"))
;;                           ((evil-normal-state-p) '("#a1bf78" . "#3e4249"))
;;                           ((evil-replace-state-p)'("#d390e7" . "#3e4249"))
;;                           ((evil-visual-state-p) '("#e77171" . "#3e4249"))
;;
;;                           ;; "#209070"
;;                           ((evil-motion-state-p) '("#501099" . "#ffffff"))
;;
;;                           ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
;;                           ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
;;                           ;; (t default-color)
;;                           )))
;;               (set-face-background 'mode-line (car color))
;;               (set-face-foreground 'mode-line (cdr color)))))
;;   ;; )

(setq mode-line-compact 'long)

(use-package nyan-mode
  :disabled
  ;; :demand t
  )

(use-package minions
  :disabled
  :config (minions-mode 1))

(use-package telephone-line
  :demand t
  :config
  (telephone-line-evil-config)
  :custom
  (telephone-line-primary-left-separator 'telephone-line-tan-left)
  ;; (telephone-line-secondary-left-separator 'telephone-line-halfsin-left)

  (telephone-line-primary-right-separator 'telephone-line-tan-right)
  (telephone-line-secondary-right-separator 'telephone-line-tan-right)
  :custom-face
  (telephone-line-evil-insert ((t (:foreground "#3e4249" :background "#73b3e7"))))
  (telephone-line-evil-normal ((t (:foreground "#3e4249" :background "#a1bf78"))))
  (telephone-line-evil-visual ((t (:foreground "#3e4249" :background "#e77171"))))
  (telephone-line-evil-motion ((t (:foreground "#3e4249" :background "#501099"))))

  (telephone-line-evil-operator ((t (:foreground "white" :background "red" :inherit mode-line-inactive))))

  (telephone-line-evil-inactive ((t (:foreground "#3e4249" :background "#006fa0" :inherit mode-line-inactive))))
)

(use-package awesome-tray
  :disabled t
  :elpaca
  (:host github :repo "manateelazycat/awesome-tray" :branch "master" :files ("*.el" "out"))
  :custom
  (awesome-tray-evil-show-mode t)
  :init
  (awesome-tray-mode 1)
  )

;; https://emacs.stackexchange.com/questions/5529/how-to-right-align-some-items-in-the-modeline/37270#37270
(defun simple-mode-line-render (left right)
  "Return a string of `window-width' length.
Containing LEFT, and RIGHT aligned respectively."
  (let ((available-width
         (- (window-total-width)
            (+ (length  left)
               (length right)))))
    (append left
            (list (format (format "%%%ds" available-width) ""))
            right)))

;; status line information
(defun dahas-modeline ()
  (setq-default mode-line-format
                (list
                 mode-line-misc-info ; for eyebrowse
                 ;; '(eyebrowse-mode (:eval (eyebrowse-mode-line-indicator)))
                 '(:eval (when-let (vc vc-mode)
                           (list
                            " "
                            (replace-regexp-in-string "^ Git:" "" vc-mode)
                            " "
                            ) ) )
                 '(:eval (list
                          " "
                                        ; en caso de ser archivo remoto
                          (when (file-remote-p default-directory) ":")
                                        ; nombre del archivo
                          (propertize "%b" 'help-echo (buffer-file-name) )
                                        ; archivo modificado
                          (when (buffer-modified-p) " " );;" "
                                        ; read only
                          (when buffer-read-only " " )
                          " "
                          ) )
                 '(:eval (list (nyan-create)))
                 '(:eval (propertize
                          " " 'display
                          `(
                            (space :align-to
                                   (- (+ right right-fringe right-margin)
                                      ,(+
                                        3
                                        (string-width mode-name)
                                        3
                                        (string-width (get-project-name-except-if-remote))
                                        )
                                      )
                                   ) ) ) )

                 ;; para mostrar el nombre del proyecto en el que se esta trabajando
                 '(:eval (propertize
                          (format "[%s] " (get-project-name-except-if-remote) ) ) )

                 ;; the current major mode
                 (propertize " %m " )
                 )
                )
  )

;; (defun dahas-modeline ()
;;   (setq-default mode-line-format
;;                 (list
;;                  mode-line-misc-info ; for eyebrowse
;;                  ;; '(eyebrowse-mode (:eval (eyebrowse-mode-line-indicator)))
;;                  '(:eval
;;                    (list
;;                     (when-let (vc vc-mode)
;;                       (list
;;                        " "
;;                        (replace-regexp-in-string "^ Git:" "" vc-mode)
;;                        " "
;;                        ) )
;;                    " "
;;                                         ; en caso de ser archivo remoto
;;                    (when (file-remote-p default-directory) ":")
;;                                         ; nombre del archivo
;;                    (propertize "%b" 'help-echo (buffer-file-name) )
;;                                         ; archivo modificado
;;                    (when (buffer-modified-p) " " );;" "
;;                                         ; read only
;;                    (when buffer-read-only " " )
;;                    " "
;;                    (nyan-create)
;;                    ) )
;;                  ;; '(:eval (propertize
;;                  ;;          " " 'display
;;                  ;;          `(
;;                  ;;            (space :align-to
;;                  ;;                   (- (+ right right-fringe right-margin)
;;                  ;;                      ,(+
;;                  ;;                        3
;;                  ;;                        (string-width mode-name)
;;                  ;;                        3
;;                  ;;                        (string-width (get-project-name-except-if-remote))
;;                  ;;                        )
;;                  ;;                      )
;;                  ;;                   ) ) ) )
;;
;;                  '(:eval
;;                    (list
;;                     ;; para mostrar el nombre del proyecto en el que se esta trabajando
;;                     (propertize
;;                      (format "[%s] " (get-project-name-except-if-remote) ) )
;;
;;                     ;; the current major mode
;;                     (propertize " %m " )
;;                     )
;;                    )
;;                  )
;;                 )
;;   )


;; (dahas-modeline)

;; (setq-default
;;  mode-line-format
;;  '((:eval
;;     (simple-mode-line-render
;;      ;; Left.
;;      (list ("%e "
;;              mode-line-buffer-identification
;;              " %l : %c"
;;              evil-mode-line-tag
;;              "[%*]"))
;;      ;; Right.
;;      (list ("%p "
;;              ;; mode-line-frame-identification
;;              ;; mode-line-modes
;;              ;; mode-line-misc-info
;;              get-project-name-except-if-remote
;;             ))))))

(defun jordon-fancy-mode-line-render (left center right &optional lpad rpad)
  "Return a string the width of the current window with
LEFT, CENTER, and RIGHT spaced out accordingly, LPAD and RPAD,
can be used to add a number of spaces to the front and back of the string."
  (condition-case err
      (let* ((left (if lpad (concat (make-string lpad ?\s) left) left))
             (right (if rpad (concat right (make-string rpad ?\s)) right))
             (width (apply '+ (window-width) (let ((m (window-margins))) (list (or (car m) 0) (or (cdr m) 0)))))
             (total-length (+ (length left) (length center) (length right) 2)))
        (when (> total-length width) (setq left "" right ""))
        (let* ((left-space (/ (- width (length center)) 2))
               (right-space (- width left-space (length center)))
               (lspaces (max (- left-space (length left)) 1))
               (rspaces (max (- right-space (length right)) 1 0)))
          (concat left (make-string lspaces  ?\s)
                  center
                  (make-string rspaces ?\s)
                  right)))
    (error (format "[%s]: (%s) (%s) (%s)" err left center right))))

;; (jordon-fancy-mode-line-render )

;;; mode-line.el ends here
