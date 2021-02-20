;;; package --- Summary

;;; Commentary:

;;; code:

;; -*- lexical-binding: t; -*-

;; esto es algo que me gustaria probar eventualmente


(use-package mu4e
  :disabled
  :load-path "/usr/share/emacs/site-lisp/mu4e"
  :demand t
  :config
  (require 'shr)

  (setq send-mail-function 'smtpmail-send-it
        message-send-mail-function 'smtpmail-send-it
        smtpmail-auth-credentials (expand-file-name "~/.authinfo")
        ;; mu4e-sent-messages-behavior 'delete
        message-kill-buffer-on-exit t
        mu4e-confirm-quit nil
        mu4e-completing-read-function 'ivy-completing-read
        mu4e-compose-format-flowed t
        message-signature-file "~/my-emacs/utils/signature"
        ;; Don't get too clever showing html
        shr-use-colors nil
        shr-use-fonts nil
        shr-width 79
        mu4e-view-prefer-html t
        ;; Define the default folders
        mu4e-sent-folder   "/Fastmail/Sent"
        ;; mu4e-drafts-folder "/Fastmail/Drafts"
        mu4e-trash-folder  "/Fastmail/Trash"
        ;; Define custom shortcuts
        mu4e-maildir-shortcuts '(("/Fastmail/INBOX" . ?i)))

  ;; Override the default bookmark list
  (setq mu4e-bookmarks
    `( ,(make-mu4e-bookmark
         :name  "Unread messages"
         :query "flag:unread AND NOT flag:trashed AND NOT maildir:/Fastmail/Spam"
         :key ?u)
       ,(make-mu4e-bookmark
         :name "Today's messages"
         :query "date:today..now"
         :key ?t)
       ,(make-mu4e-bookmark
         :name "Last 7 days"
         :query "date:7d..now"
         :key ?w)
       ,(make-mu4e-bookmark
         :name "Inbox"
         :query "maildir:/Fastmail/INBOX"
         :key ?i)))

  :bind (("C-c m" . mu4e))
  :hook (mu4e-compose-mode . flyspell-mode))


(use-package mu4e-alert
  :disabled
  :ensure t
  :after mu4e
  :config
  (setq mu4e-alert-modeline-formatter
        'mu4e-alert-custom-mode-line-formatter)
  (mu4e-alert-set-default-style 'libnotify)
  (setq mu4e-alert-interesting-mail-query
        "flag:unread AND NOT flag:trashed AND NOT maildir:/Fastmail/Spam")
  :hook (after-init . mu4e-alert-enable-mode-line-display))

(defun mu4e-alert-custom-mode-line-formatter (mail-count)
  "Custom formatter used to get the string to be displayed in the mode-line.
Uses Font Awesome mail icon to have a more visual icon in the display.
MAIL-COUNT is the count of mails for which the string is to displayed"
  (when (not (zerop mail-count))
    (concat " "
            (propertize
             ""
             ;; 'display (when (display-graphic-p)
             ;;            display-time-mail-icon)
             'face display-time-mail-face
             'help-echo (concat (if (= mail-count 1)
                                    "You have an unread email"
                                  (format "You have %s unread emails" mail-count))
                                "\nClick here to view "
                                (if (= mail-count 1) "it" "them"))
             'mouse-face 'mode-line-highlight
             'keymap '(mode-line keymap
                                 (mouse-1 . mu4e-alert-view-unread-mails)
                                 (mouse-2 . mu4e-alert-view-unread-mails)
                                 (mouse-3 . mu4e-alert-view-unread-mails)))
            (if (zerop mail-count)
                " "
              (format " [%d] " mail-count)))))
