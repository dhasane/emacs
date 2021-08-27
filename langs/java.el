;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package lsp-java
  ;; :disabled
  :hook (
         (java-mode . lsp-deferred)
         )
  :custom
  ;; (setenv "JAVA_HOME"  "/usr/lib/jvm/java-15-openjdk/")
  ;; (lsp-java-java-path "/usr/lib/jvm/java-15-openjdk/bin/java")
  ;; (lsp-java-configuration-runtimes '[(:name "JavaSE-15"
  ;;                                     :path "/usr/lib/jvm/java-15-openjdk"
  ;;                                     :default t)])

  (require 'dap-java)
  :custom
  (lsp-java-completion-overwrite nil)
  ;; current VSCode defaults
  (lsp-java-vmargs
   '(;; "-XX:+UseParallelGC"
     ;; "-XX:GCTimeRatio=4"
     ;; "-XX:AdaptiveSizePolicyWeight=90"
     ;; "-Dsun.zip.disableMemoryMapping=true"
     ;; "-Xmx2G"
     ;; "-Xms100m"

     "-Dosgi.requiredJavaVersion=11"
     "-Dosgi.instance.area.default=@user.home/eclipse-workspace"
     "-Dsun.java.command=Eclipse"
     "-XX:+UseG1GC"
     "-XX:+UseStringDeduplication"
     "--add-modules=ALL-SYSTEM"
     "-XstartOnFirstThread"
     "-Dorg.eclipse.swt.internal.carbon.smallFonts"
     "-Dosgi.requiredJavaVersion=11"
     "-Dosgi.dataAreaRequiresExplicitInit=true"
     "-Dorg.eclipse.swt.graphics.Resource.reportNonDisposed=true"
     "-Xms1g"
     "-Xmx5g"
     "-server"
     "-XX:+DoEscapeAnalysis"
     "-XX:+UseCompressedOops"
     "-XX:-UseSplitVerifier"
     "-Xverify:none"
     "--add-modules=ALL-SYSTEM"
     "-Xdock:icon=../Resources/Eclipse.icns"
     "-XstartOnFirstThread"
     "-Dorg.eclipse.swt.internal.carbon.smallFonts"

     ))
  ;; (lsp-java-vmargs (list
  ;;                   "-noverify"
  ;;                   "--enable-preview"))
  (lsp-java-enable-file-watch nil)
  )

;;; java.el ends here
