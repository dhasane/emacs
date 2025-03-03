;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package web-mode
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
         ;; "\\.tsx\\'"
         "\\.jsx\\'"
         "\\.mjs\\'"
         ;; "\\.js\\'"
         )
  :custom
  (web-mode-code-indent-offset 2)
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)

  :config
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers
                        '(javascript-jshint json-jsonlist)))

  ;; configure jsx-tide checker to run after your default jsx checker
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (flycheck-add-mode 'typescript-tslint 'web-mode)

  ;; adjust indents for web-mode to 2 spaces
  (defun web-mode-init-hook ()
    "Hooks for Web mode.  Adjust indent."
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2))

  (add-hook 'web-mode-hook 'web-mode-init-hook)

  ;; for better jsx syntax-highlighting in web-mode
  ;; - courtesy of Patrick @halbtuerke
  (defadvice web-mode-highlight-part (around tweak-jsx activate)
    (if (equal web-mode-content-type "jsx")
        (let ((web-mode-enable-part-face nil))
          ad-do-it)
      ad-do-it))
)

(use-package restclient)

(use-package sass-mode)

;;; web.el ends here
