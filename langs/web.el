;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package web-mode
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

(use-package js
  :custom
  (js-indent-level 2)

  (flycheck-check-syntax-automatically  '(save idle-change mode-enabled))
  (flycheck-auto-change-delay           1.5)

  (whitespace-line-column               120)   ;; max line length
  (whitespace-style                     '(face lines-tail trailing))
  )

(use-package js2-mode
  :disabled
  ;; :mode "\\.js\\'"
  ;; en teoria esto es mejor como minor-mode desde emacs 27, pero como que me funciona mejor como principal
  :hook ((js-mode . js2-minor-mode))
  :custom
  (tern-mode t)
  :config
  ;; (push 'company-tern company-backends)
  )

;; https://github.com/magnars/js2-refactor.el
(use-package js2-refactor
  :disabled
  :hook ((js2-mode . #'js2-refactor-mode))
  :config
  ; (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (setq js2-skip-preprocessor-directives t)
  )

(use-package php-mode
  :mode ("\\.php\\'" . php-mode)
  :general
  (php-mode-map
   :states '(insert override)
   "TAB" 'basic-tab-indent-or-complete
   [tab] 'basic-tab-indent-or-complete
   )
  )

(use-package phpunit
  )

(use-package typescript-mode
  :mode "\\.ts\\'"
  :custom
  (typescript-indent-level       2)
  (typescript-expr-indent-offset 2)
  :config
  ;; (push 'company-tern company-backends)
  )

(use-package tide                              ; https://github.com/ananthakumaran/tide
  :disabled
  :after (typescript-mode company flycheck)
  :hook (
         ;; (typescript-mode . tide-setup)
         (typescript-mode . tide-mode)
         (typescript-mode . tide-hl-identifier-mode)
         (typescript-mode . (lambda ()
                              (tide-setup)
                              (tide-hl-identifier-mode +1)
                              (eldoc-mode +1)
                              (add-to-list 'company-backends 'company-tide)
                              (add-hook before-save-hook tide-format-before-save)
                              ))
         )
  :custom
  (tide-format-options
   '(
     :insertSpaceAfterFunctionKeywordForAnonymousFunctions t
     :placeOpenBraceOnNewLineForFunctions nil
     :tabSize 2
     :indentSize 2
     ))
  :config
  (flycheck-add-mode 'typescript-tide 'ng2-ts-mode)
  )

(use-package ng2-mode
  :config
  (flycheck-add-mode 'typescript-tslint 'ng2-ts-mode)
  (with-eval-after-load 'typescript-mode
    (add-hook 'typescript-mode-hook #'lsp))
 )

(use-package rjsx-mode
  :defer t)

(use-package restclient
  )

;;; web.el ends here
