;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

;; (use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))

(use-package lsp-java
  :config
  ;; (setenv "JAVA_HOME"  "/usr/lib/jvm/java-15-openjdk/")
  ;; (setenv "JAVA_HOME" "/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home")

  (require 'dap-java)

  :custom
  (lsp-java-completion-overwrite nil)
  (lsp-java-enable-file-watch nil)

  ;; (lsp-java-java-path (concat (getenv "JAVA_HOME") "/bin/java"))
  ;; (lsp-java-java-path "/usr/lib/jvm/java-15-openjdk/bin/java")
  ;; (lsp-java-configuration-runtimes '[(:name "JavaSE-15"
  ;;                                     :path "/usr/lib/jvm/java-15-openjdk"
  ;;                                     :default t)])
  ;; (lsp-java-import-gradle-home "/Users/dhamiltonsmith/work/learn/")

  ;; current VSCode defaults
  (lsp-java-vmargs
   '(;; "-XX:+UseParallelGC"
     ;; "-XX:GCTimeRatio=4"
     ;; "-XX:AdaptiveSizePolicyWeight=90"
     ;; "-Dsun.zip.disableMemoryMapping=true"
     ;; "-noverify"
     ;; "--enable-preview"

     "--add-modules=ALL-SYSTEM"
     "-Dorg.eclipse.swt.graphics.Resource.reportNonDisposed=true"
     "-Dosgi.dataAreaRequiresExplicitInit=true"
     "-Dosgi.instance.area.default=@user.home/eclipse-workspace"
     "-Dosgi.requiredJavaVersion=11"
     "-XX:+DoEscapeAnalysis"
     "-XX:+UseCompressedOops"
     "-XX:+UseG1GC"
     "-XX:+UseStringDeduplication"
     "-Xms1g"
     ;; "-Xms100m"
     "-Xmx5g"
     ;; "-Xmx2G"
     "-server"
     ))
  )

(use-package gradle-mode)

;;; java.el ends here
