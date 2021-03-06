;;; package --- Summary

;;; Commentary:

;;; code:

;; -*- lexical-binding: t; -*-

;; change mode-line color by evil state
;; (let (default-color (cons (face-background 'mode-line)
                          ;; (face-foreground 'mode-line)))
(add-hook 'post-command-hook
          (lambda ()
            (let ((color (cond ;; ((minibufferp) default-color)
                          ((evil-insert-state-p) '("#73b3e7" . "#3e4249"))
                          ((evil-normal-state-p) '("#a1bf78" . "#3e4249"))
                          ((evil-replace-state-p)'("#d390e7" . "#3e4249"))
                          ((evil-visual-state-p) '("#e77171" . "#3e4249"))

                          ;; "#209070"
                          ((evil-motion-state-p) '("#501099" . "#ffffff"))

                          ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                          ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
                          ;; (t default-color)
                          )))
              (set-face-background 'mode-line (car color))
              (set-face-foreground 'mode-line (cdr color)))))
  ;; )


(defun get-project-name-except-if-remote ()
  (interactive)
  (if (file-remote-p default-directory)
      ""
    (projectile-project-name)
    )
  )

(use-package nyan-mode
  :demand t
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
