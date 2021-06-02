;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package lsp-java
  ;; :config (add-hook 'java-mode-hook 'lsp)
  ;; :disabled
  :hook (
         (java-mode . 'lsp)
         )
  :custom
  (lsp-java-java-path "/usr/lib/jvm/java-15-openjdk/bin/java")
  (lsp-java-configuration-runtimes '[(:name "JavaSE-15"
                                      :path "/usr/lib/jvm/java-15-openjdk"
                                      :default t)])
  (lsp-java-vmargs (list
                    "-noverify"
                    "--enable-preview"))

  :config
  (setenv "JAVA_HOME"  "/usr/lib/jvm/java-15-openjdk/")
  ;; (require 'dap-java)
  )

;; (use-package dap-java :after (dap-mode lsp-java))

;; (use-package lsp-java
;;   :disabled
;;   :demand t
;;   :after (lsp-mode company)
;;   :diminish
;;   :hook (
;;          ;; (java-mode . lsp-deferred)
;;          (java-mode . lsp-deferred)
;;          (java-mode . lsp-java-boot-lens-mode)
;;          (java-mode . flycheck-mode)
;;          (java-mode . company-mode)
;;          (java-mode . (lambda ()
;;                         (set
;;                          (make-local-variable 'company-idle-delay) 0.5)
;;                         ))
;;          )
;;   ; :after (lsp-mode company)
;;   :custom
;;
;;   (lsp-java-java-path "/usr/lib/jvm/java-15-openjdk/bin/java") ;  "path_to_java_folder/Contents/Home/bin/java"
;;   :config
;;   (setenv "JAVA_HOME"  "/usr/lib/jvm/java-15-openjdk/") ;  "path_to_java_folder/Contents/Home/"
;;   ;; (add-hook 'java-mode-hook 'lsp)
;;   ;; (add-hook 'java-mode-hook #'lsp-java-boot-lens-mode)
;;   ;; (require 'dap-java)
;;   ;; (make-local-variable company-idle-delay)
;;   ;; (setq company-idle-delay 1) ; Delay in showing suggestions.
;;   )
;; ;; (use-package dap-java :after (lsp-java))
;; ;; (use-package dap-java :after (lsp-java))
;;
;; ;; (use-package eclim
;; ;;   :hook (java-mode)
;; ;;   )

;;; java.el ends here
