;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:
;;; Configuracion para eshel y term

;;; code:

(use-package pcomplete
  :custom
  (pcomplete-ignore-case t)
  )

(defun pcomplete/mk ()
  "Completion rules for the `make' command."
  ;; mk esta definido en eshell/alias
  (pcomplete/make)
  )

;; https://www.emacswiki.org/emacs/EshellCompletion
;;;; sudo completion
(defun pcomplete/sudo ()
  "Completion rules for the `sudo' command."
  (let ((pcomplete-ignore-case t))
    (pcomplete-here (funcall pcomplete-command-completion-function))
    (while (pcomplete-here (pcomplete-entries)))))

;;;; systemctl completion
(defcustom pcomplete-systemctl-commands
  '("disable" "enable" "status" "start" "restart" "stop" "reenable"
    "list-units" "list-unit-files")
  "p-completion candidates for `systemctl' main commands"
  :type '(repeat (string :tag "systemctl command"))
  :group 'pcomplete)

(defvar pcomplete-systemd-units
  (split-string
   (shell-command-to-string
    "(systemctl list-units --all --full --no-legend;systemctl list-unit-files --full --no-legend)|while read -r a b; do echo \" $a\";done;"))
  "p-completion candidates for all `systemd' units")

(defvar pcomplete-systemd-user-units
  (split-string
   (shell-command-to-string
    "(systemctl list-units --user --all --full --no-legend;systemctl list-unit-files --user --full --no-legend)|while read -r a b;do echo \" $a\";done;"))
  "p-completion candidates for all `systemd' user units")

(defun pcomplete/systemctl ()
  "Completion rules for the `systemctl' command."
  (pcomplete-here (append pcomplete-systemctl-commands '("--user")))
  (cond ((pcomplete-test "--user")
         (pcomplete-here pcomplete-systemctl-commands)
         (pcomplete-here pcomplete-systemd-user-units))
        (t (pcomplete-here pcomplete-systemd-units))))

;;;; man completion
(defvar pcomplete-man-user-commands
  (split-string
   (shell-command-to-string
    "apropos -s 1 .|while read -r a b; do echo \" $a\";done;"))
  "p-completion candidates for `man' command")

(defun pcomplete/man ()
  "Completion rules for the `man' command."
  (pcomplete-here pcomplete-man-user-commands))


;;; eshell-completion.el ends here
