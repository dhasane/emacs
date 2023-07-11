;; -*- lexical-binding: t; -*-

(use-package ispell
  :elpaca nil
  :init
  (if (file-exists-p "/usr/bin/hunspell")
      (progn
        (setq ispell-program-name "hunspell")
        ))
  )
