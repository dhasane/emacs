
(use-package pdf-tools
  :config
  (pdf-tools-install)
  (pdf-loader-install)
  )

(use-package nov
  ;; :mode ("\\.epub\\'" . nov-mode)
  :mode "\\.epub\\'"
  :config
  (cond
   ((string-equal system-type "windows-nt") ; Windows
    (setq nov-unzip-program "c:/Program Files/7-Zip/7z.exe")
    )
   )
  (defhydra nov-org (:color blue :columns 3)
    ("n" nov-next-document         "next")
    ("p" nov-previous-document     "prev")
    )
  )

