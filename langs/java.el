;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package lsp-java
  ;; :hook ((java-mode . lsp-java-boot-lens-mode))
  :hook
  (java-mode .
            (lambda ()
              ; (setq-local c-basic-offset 2)
              ; (setq-local tab-width 2)
              ; (setq-local indent-tabs-mode nil)
              (setq-local indent-tabs-mode t)
              ))
  :config

  ;; para configurar el formatter
  ;; (setq lsp-java-format-settings-url "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml")
  ;; (setq lsp-java-format-settings-profile "GoogleStyle")


  ;; (setenv "JAVA_HOME" "/usr/lib/jvm/java-15-openjdk/")
  ;; (setenv "JAVA_HOME" "/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home")

  (require 'dap-java)

  (dh/set-lang-config-file 'lsp-java-format-settings-url
                           "java-style.xml")

  :custom
  (lsp-java-completion-overwrite nil)
  (lsp-java-enable-file-watch nil)
  (lsp-enable-indentation nil)

  ;; (lsp-java-java-path (concat (getenv "JAVA_HOME") "/bin/java"))
  ;; (lsp-java-java-path "/usr/lib/jvm/java-15-openjdk/bin/java")
  ;; (lsp-java-configuration-runtimes '[(:name "JavaSE-15"
  ;;                                     :path "/usr/lib/jvm/java-15-openjdk"
  ;;                                     :default t)])

  ;; (lsp-java-java-path "/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home/bin/java")
  ;; (lsp-java-configuration-runtimes
  ;;  '[(:name "java-corretto-11"
  ;;     :path  "/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home/"
  ;;     :default t)])
  ;; (lsp-java-import-gradle-home "/Users/dhamiltonsmith/work/learn/")


  ;; current VSCode defaults
  (lsp-java-vmargs
   '(;; "-XX:+UseParallelGC"
     ;; "-XX:GCTimeRatio=4"
     ;; "-XX:AdaptiveSizePolicyWeight=90"
     ;; "-Dsun.zip.disableMemoryMapping=true"
     "-noverify"
     ;; "--enable-preview"

     ;; "--add-modules=ALL-SYSTEM"
     ;; "-Dorg.eclipse.swt.graphics.Resource.reportNonDisposed=true"
     ;; "-Dosgi.dataAreaRequiresExplicitInit=true"
     ;; "-Dosgi.instance.area.default=@user.home/eclipse-workspace"
     ;; "-Dosgi.requiredJavaVersion=11"

     ;; "-XX:+DoEscapeAnalysis"
     ;; "-XX:+UseCompressedOops"
     ;; "-XX:+UseG1GC"
     ;; "-XX:+UseStringDeduplication"
     ;; "-server"

     ;; ;; "-java.import.gradle.wrapper.enabled=false"

     ;; ;; memory
     "-Xms1g"                           ; min ;; "-Xms100m"
     "-Xmx5g"                           ; max ;; "-Xmx2G"

     ;; "-Xmx1G"
     ;; "-XX:+UseG1GC"
     ;; "-XX:+UseStringDeduplication"

     ;; para lombok
     ;; "-javaagent:/home/daniel/.m2/repository/org/projectlombok/lombok/1.18.12/lombok-1.18.12.jar"
     ;; "-Xbootclasspath/a:/home/daniel/.m2/repository/org/projectlombok/lombok/1.18.12/lombok-1.18.12.jar"
     ;; (concat "-javaagent:" dahas/lombok-jar)
     ;; (concat "-Xbootclasspath/a:" dahas/lombok-jar)


     ;; "-Xms1g"
     ;; "-Xmx5g"
     ;; "-server"
     ;; "-XX:+DoEscapeAnalysis"
     ;; "-XX:+UseCompressedOops"
     ;; "-XX:-UseSplitVerifier"
     ;; "-Xverify:none"
     ))

  (setq lsp-file-watch-ignored
        (list lsp-file-watch-ignored
              '(".idea" ".ensime_cache" ".eunit" "node_modules"
                ".git" ".hg" ".fslckout" "_FOSSIL_"
                ".bzr" "_darcs" ".tox" ".svn" ".stack-work"
                "build")

              ))
  ;; (lsp-file-watch-ignored
  ;;  ')
  )

(use-package gradle-mode)

;;; java.el ends here
