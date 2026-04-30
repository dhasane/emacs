;;; gpt.el --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; GPT client (gptel) configuration

;;; Code:

(use-package gptel
  :commands (gptel)
  :custom
  (gptel-model "mistral-7b-openorca.Q4_0.gguf") ;Pick your default model

  (gptel-backend (gptel-make-gpt4all
                  "GPT4All"                              ;Name of your choosing
                  :protocol "http"
                  :host "localhost:4891"                 ;Where it's running
                  :models '("mistral-7b-openorca.Q4_0.gguf")) ;Available models
                 )
  (gptel-max-tokens 500)
  (gptel-api-key "")
  (gptel--debug nil)
  (gptel-default-session "*GPT*")
  )

(use-package agent-shell
  :commands (agent-shell agent-shell-kiro-start-agent))

(use-package agent-shell-sidebar
  :after agent-shell
  :vc (:url "https://github.com/cmacrae/agent-shell-sidebar")
  :custom
  (agent-shell-sidebar-width "25%")
  (agent-shell-sidebar-minimum-width 80)
  (agent-shell-sidebar-maximum-width "50%")
  (agent-shell-sidebar-position 'right)
  (agent-shell-sidebar-locked t)
  (agent-shell-sidebar-default-config
   (agent-shell-kiro-make-config))
  :bind
  (("C-c a s" . agent-shell-sidebar-toggle)
   ("C-c a f" . agent-shell-sidebar-toggle-focus)))

;;; llm.el ends here
