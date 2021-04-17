;;; package --- Summary

;;; Commentary:

;;; code:

;; -*- lexical-binding: t; -*-

(use-package company :demand t :defer .1
  :general
  (
   :keymap '(prog-mode override)
   :states '(insert)
   "TAB" 'basic-tab-indent-or-complete
   )
  (
   :keymaps 'company-active-map
   "TAB" 'company-complete-common-or-cycle
   [tab] 'company-complete-common-or-cycle
   "<tab>" 'company-complete-common-or-cycle

   "S-TAB" 'company-select-previous
   "<backtab>" 'company-select-previous

   "RET" 'company-complete-selection
   "<return>" 'company-complete-selection
   "<ret>" 'company-complete-selection

   [escape] 'company-abort
   )
  :custom
  ;;(company-begin-commands '(self-insert-command))
  ;;(company-show-numbers t)
  (company-tooltip-align-annotations t)
  (company-minimum-prefix-length 1) ; Show suggestions after entering one character.
  (company-selection-wrap-around t)
  (company-idle-delay nil) ; Delay in showing suggestions.
  (global-company-mode t)
  ;;(setq company-tooltip-margin 4)

  (company-tooltip-maximum-width 60) ;; normalizar y evitar saltos
  (company-tooltip-minimum-width 60)
  (company-tng-mode t)
  ;; (company-tng-auto-configure nil)
  (company-require-match nil)
  (company-dabbrev-downcase nil) ;; Do not downcase completions by default.
  (company-dabbrev-ignore-case nil)

   ;; Search other buffers for compleition candidates
  ;; (company-dabbrev-other-buffers t)
  ;; (company-dabbrev-code-other-buffers t)

  (company-tooltip-flip-when-above t)
  :config
  (company-tng-mode)

  (eval-after-load 'evil
    (evil-make-intercept-map company-active-map 'insert)
    )

  ;; completar siempre que no sea espacio
  (defun basic-check-expansion ()
    "True en caso de no tener whitespace previo la cursor"
    (save-excursion
      (backward-char 1)
      (if (looking-at "[\n \t]")
          nil
        t
        )
      )
    )

  (defun basic-tab-indent-or-complete ()
    "Agrega un tab, en caso de no tener texto previo, en caso de tenerlo, llama a company para completarlo."
    (interactive)
    (if (minibufferp)
        (minibuffer-complete)
      (if (basic-check-expansion)
          (company-complete-common)
        (tab-to-tab-stop) ;; agregar tabs
        )
      )
    )
  )

(use-package company
  :disabled
  :hook (prog-mode . company-mode)
  :functions
  (
   check-expansion
   )
  :config

  ;; disable company completion of *all* remote filenames, whether
  ;; connected or not
  (defun company-files--connected-p (file)
    (not (file-remote-p file)))


  ;;(setq company-frontends (delq 'company-pseudo-tooltip-frontend company-frontends))

  ;; set default `company-backends'
  (setq company-backends
        '(
          (
           company-files          ; files & directory
           company-keywords       ; keywords
           company-capf
           ;; company-yasnippet
           company-dabbrev-code
           ;; company-dabbrev
           ;; company-abbrev
           )
          )
        )

  ;; (add-hook 'after-init-hook 'global-company-mode)
  (global-company-mode)

  ;; https://emacs.stackexchange.com/questions/12360/how-to-make-private-python-methods-the-last-company-mode-choices
  (defun company-transform-candidates-_-to-end (candidates)
    "mover los candidatos que inicien por _ al final"
    (let ((deleted))
	  (mapc #'(lambda (c)
				(if (or (string-prefix-p "_" c) (string-prefix-p "._" c))
					(progn
					  (add-to-list 'deleted c)
					  (setq candidates (delete c candidates)))))
			candidates)
	  (append candidates (nreverse deleted))))

  (append company-transformers '(company-transform-candidates-_-to-end))

  ;; (company-tng-configure-default)
  )

;;(use-package readline-complete
;;:ensure t
;;)

(use-package company-quickhelp
  :disabled
  :after (company)
  :init
  (company-quickhelp-mode)
  )

(use-package company-box
  :disabled
  :ensure t
  :after (company)
  :hook (company-mode . company-box-mode)
  :config
  (setq company-box-doc-delay 0
        company-box-doc-enable t
        ;;company-box--max 10
        )

  (setq company-box-backends-colors
        '(
          (company-yasnippet :all "lime green"
                             :selected
                             (
                              :background "lime green"
                              :foreground "black"
                              ))
          (company-elisp . (:icon "yellow"
                                  :selected (
                                             :background "orange"
                                             :foreground "black")))
        (company-dabbrev . "purple")
        ;;(company-)
        )
        )
  )

(use-package company
  :disabled
  :diminish
  :demand t
  :bind ((:map company-mode-map ("M-/" . company-complete))
         (:map company-active-map
               ("M-/" . company-select-next)
               ("C-n" . company-select-next)
               ("C-p" . company-select-previous)))
  :init
  (global-company-mode 1))
