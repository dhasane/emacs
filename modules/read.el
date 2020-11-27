
(use-package pdf-tools
  :config
  (pdf-tools-install)
  (pdf-loader-install)
  )

(use-package nov
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (defhydra nov-org (:color blue :columns 3)
    ("n" nov-next-document         "next")
    ("p" nov-previous-document     "prev")
    )
  )
