
(use-package markdown-mode
  :ensure t
  :commands (gfm-mode)
  :mode (("\\.md\\'" . gfm-mode)
	   ("\\.gfm\\'" . gfm-mode))
  :config (setq markdown-command "multimarkdown"
		  markdown-fontify-code-blocks-natively t))
