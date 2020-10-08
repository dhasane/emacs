
;; (use-package lsp-java
;;   :ensure t
;;   ;; :mode "\\.java\\'"
;;   ;; :hook (
;;   ;;        (java-mode . 'lsp-deferred)
;;   ;;        (java-mode . 'flycheck-mode)
;;   ;;        (java-mode . 'company-mode)
;;   ;;        )
;;   ;; :after (lsp-mode company)
;;   :config
;;   ;; (require 'lsp-java-boot)
;;
;; ;; to enable the lenses
;;   (add-hook 'lsp-mode-hook #'lsp-lens-mode)
;;   ;; (add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)
;;   (add-hook 'java-mode-hook #'lsp-deferred)
;;   (add-hook 'java-mode-hook 'flycheck-mode)
;;   (add-hook 'java-mode-hook 'company-mode)
;;   )

(use-package helm
  )
(use-package lsp-java
  :demand t
  :hook (java-mode . 'lsp-deferred)
  :config
  ;; (add-hook 'java-mode-hook 'lsp)
  ;; (add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)
  (add-hook 'lsp-mode-hook #'lsp-lens-mode)
  (require 'dap-java)
  ;; (add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)
  )

;; (use-package lsp-java :after lsp
;;   :init
;;   (setq lsp-java-java-path "/usr/lib/jvm/jdk-15/bin/java"
;;         lsp-java-import-gradle-java-home "/usr/lib/jvm/jdk-15/bin/java"
;;         lsp-java-configuration-runtimes '[(:name "JavaSE-15"
;;                                                  :path "/usr/lib/jvm/jdk-15"
;;                                                  :default t)]
;;         lsp-java-vmargs (list
;;                          "-noverify"
;;                          "--enable-preview"))
;;   :config
;;   (add-hook 'java-mode-hook #'lsp)
;;   (require 'dap-java)
;;   )


(use-package dap-java
  :ensure nil
  )
