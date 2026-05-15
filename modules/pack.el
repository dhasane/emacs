

(defun dh/define-use-package-elpaca-placeholder()
  (message "added placeholder for elpaca")

  (setq use-package-keywords (append use-package-keywords '(:elpaca :pack)))

  (defalias 'use-package-normalize/:elpaca 'ignore)
  (defalias 'use-package-handler/:elpaca 'ignore)

  (defalias 'use-package-normalize/:pack 'use-package-normalize/:straight)
  (defalias 'use-package-handler/:pack 'use-package-handler/:straight)
  )

(defun dh/define-use-package-straight-placeholder()
  (message "added placeholder for straight")

  (setq use-package-keywords (append use-package-keywords '(:straight :pack)))

  (defalias 'use-package-normalize/:straight 'ignore)
  (defalias 'use-package-handler/:straight 'ignore)

  (defalias 'use-package-normalize/:pack 'use-package-normalize/:elpaca)
  (defalias 'use-package-handler/:pack 'use-package-handler/:elpaca)
  )

(when (featurep 'straight)
  (dh/define-use-package-elpaca-placeholder))

(when (featurep 'elpaca)
  (dh/define-use-package-straight-placeholder))
