;; -*- lexical-binding: t; -*-

(use-package ispell
  :init
  (if (file-exists-p "/usr/bin/hunspell")
      (progn
        (setq ispell-program-name "hunspell")
        ))
  )
