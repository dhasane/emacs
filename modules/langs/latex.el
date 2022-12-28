;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-save-query nil)
(setq-default TeX-master nil)
;(setq TeX-PDF-mode t)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-buffer)

(add-hook 'LaTeX-mode-hook 'auto-fill-mode)

(use-package company-auctex
  :config
  (company-auctex-init))

(setq org-latex-logfiles-extensions
      '("lof" "lot" "tex=" "aux" "idx" "log" "out" "toc" "nav" "snm" "vrb"
        "dvi" "fdb_latexmk" "blg" "brf" "fls" "entoc" "ps" "spl" "bbl"))

;;; latex.el ends here
