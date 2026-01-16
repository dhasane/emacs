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

;;; gpt.el ends here
