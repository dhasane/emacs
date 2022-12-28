;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package markdown-mode
  :commands (gfm-mode)
  :mode (("\\.md\\'" . gfm-mode)
	   ("\\.gfm\\'" . gfm-mode))
  :config (setq markdown-command "multimarkdown"
		  markdown-fontify-code-blocks-natively t))

;;; markdown.el ends here
