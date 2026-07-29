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
         ;; "\\.jsx\\'"
         "\\.mjs\\'"
         ;; "\\.js\\'"
         )
  :custom
  (web-mode-code-indent-offset 2)
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)

  :config
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

(define-derived-mode web-vue-mode web-mode "Vue"
  "A major mode derived from web-mode, for editing .vue files with LSP support.")

(add-to-list 'auto-mode-alist '("\\.vue\\'" . web-vue-mode))

;;; web.el ends here
