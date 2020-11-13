

(use-package web-mode
  :ensure t
  :defer t
  :mode (
         "\\.html?\\'"
         "\\.phtml\\'"
         "\\.php\\'"
         "\\.inc\\'"
         "\\.tpl\\'"
         "\\.jsp\\'"
         "\\.as[cp]x\\'"
         "\\.erb\\'"
         "\\.mustache\\'"
         "\\.djhtml\\'"
         "\\.jsx\\'"
         "\\.tsx\\'"
         )
  :config (setq web-mode-markup-indent-offset 2
                web-mode-code-indent-offset 2)
  ;; configure jsx-tide checker to run after your default jsx checker
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (flycheck-add-mode 'typescript-tslint 'web-mode)
  ;; adjust indents for web-mode to 2 spaces
  (defun my-web-mode-hook ()
    "Hooks for Web mode. Adjust indents"
  ;;; http://web-mode.org/
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2))
  (add-hook 'web-mode-hook  'my-web-mode-hook)
  ;; for better jsx syntax-highlighting in web-mode
  ;; - courtesy of Patrick @halbtuerke
  (defadvice web-mode-highlight-part (around tweak-jsx activate)
    (if (equal web-mode-content-type "jsx")
        (let ((web-mode-enable-part-face nil))
          ad-do-it)
      ad-do-it))
)

(use-package js2-mode
  :mode "\\.js\\'"
  ;; en teoria esto es mejor como minor-mode desde emacs 27, pero como que me funciona mejor como principal
  ;; :hook ((js-mode . js2-minor-mode))
  )

;; https://github.com/magnars/js2-refactor.el
(use-package js2-refactor
  :hook ((js2-mode . #'js2-refactor-mode))
  :config
  ; (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (setq js2-skip-preprocessor-directives t)
  )

(use-package php-mode
  :mode ("\\.php\\’" . php-mode)
  :init
  (add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
  )

(use-package phpunit
  )

(use-package typescript-mode
  :config
  (setq typescript-indent-level              2
        typescript-expr-indent-offset        2
        company-tooltip-align-annotations    t

        flycheck-check-syntax-automatically  '(save idle-change mode-enabled)
        flycheck-auto-change-delay           1.5

        whitespace-line-column               120   ;; max line length
        whitespace-style                     '(face lines-tail trailing)
        )

  ;;(whitespace-mode)
  )

(use-package tide                              ; https://github.com/ananthakumaran/tide
  :after(typescript-mode company flycheck)
  :hook((typescript-mode . tide-setup)
        (typescript-mode . tide-mode)
        (typescript-mode . tide-hl-identifier-mode)
        (before-save . tide-format-before-save))
  :init
  (defun setup-tide-mode()
    (interactive)
    (tide-setup)
    (flycheck-mode +1)
    (eldoc-mode +1)
    (tide-hl-identifier-mode +1)
    (company-mode +1))

  (add-hook 'typescript-mode-hook #'setup-tide-mode)
  (add-hook 'js2-mode-hook #'setup-tide-mode)
  :requires flycheck
  :config
  (setq tide-format-options
        '(
          :insertSpaceAfterFunctionKeywordForAnonymousFunctions t :placeOpenBraceOnNewLineForFunctions nil :tabSize 2 :indentSize 2))
  (add-to-list 'company-backends 'company-tide)

  (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)
  (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)
  )

;;(use-package ng2-mode
;;  :after(tide)
;;  :config
;;  (flycheck-add-mode 'typescript-tslint 'ng2-ts-mode)
;;  (flycheck-add-mode 'typescript-tide 'ng2-ts-mode)
;;  )

(use-package rjsx-mode
  :defer t)

;; (use-package tern
;;   )

(use-package restclient
  )
