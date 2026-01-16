;;; text.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Text editing utilities and spell checking

(use-package ispell
  :disabled t
  :ensure nil
  :hook ((org-mode . flyspell-mode)
         (git-commit-mode . flyspell-mode))
  :custom
  (ispell-hunspell-dict-paths-alist
   '(("en_US" "~/.emacs.d/spell/en_US.aff" "~/.emacs.d/spell/en_US.dic")
     ("es_CO" "~/.emacs.d/spell/es_CO.aff" "~/.emacs.d/spell/es_CO.dic")
     ))

  :config
  ;; (setq ispell-program-name "hunspell")
  ;; (setq ispell-dictionary "en_US,es_CO")
  ;; ;; ispell-set-spellchecker-params has to be called
  ;; ;; before ispell-hunspell-add-multi-dic will work
  ;; (ispell-set-spellchecker-params)
  ;; (ispell-hunspell-add-multi-dic "en_US,es_CO")
  ;; ;; find aspell and hunspell automatically
  (cond
   ;; try hunspell at first
   ;; if hunspell does NOT exist, use aspell
   ((executable-find "hunspell")
    ;; (setq ispell-local-dictionary-alist
    ;;       '(("en_US" "~/.emacs.d/spell/en_US.aff" "~/.emacs.d/spell/en_US.dic")
    ;;         ("es_CO" "~/.emacs.d/spell/es_CO.aff" "~/.emacs.d/spell/es_CO.dic")
    ;;         ))

    (setq ispell-program-name "hunspell")
    (setq ispell-local-dictionary "en_US,es_CO")
    (setq ispell-dictionary "en_US,es_CO")

    (ispell-set-spellchecker-params)

    (ispell-hunspell-add-multi-dic "en_US,es_CO")
    (setq ispell-local-dictionary-alist
          ;; Please note the list `("-d" "en_US")` contains ACTUAL parameters passed to hunspell
          ;; You could use `("-d" "en_US,en_US-med")` to check with multiple dictionaries
          '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US,es_CO") nil utf-8)))

    ;; new variable `ispell-hunspell-dictionary-alist' is defined in Emacs
    ;; If it's nil, Emacs tries to automatically set up the dictionaries.
    (when (boundp 'ispell-hunspell-dictionary-alist)
      (setq ispell-hunspell-dictionary-alist ispell-local-dictionary-alist)))

   ((executable-find "aspell")
    (setq ispell-program-name "aspell")
    ;; Please note ispell-extra-args contains ACTUAL parameters passed to aspell
    (setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US"))))

  ;; (flyspell-mode 1)
  )

(use-package jinx
  :if (or (executable-find "enchant-2")
          (executable-find "enchant"))
  :hook ((org-mode . jinx-mode)
         (git-commit-mode . jinx-mode))
  :custom
  (jinx-languages "en_US es_CO"))

;;; text.el ends here
