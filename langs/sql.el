;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package sqlup-mode
  :hook
  (
   (sql-mode . sqlup-mode)
   (sql-interactive-mode . sqlup-mode)
   )

  )

;; sql
;; (setq sql-postgres-login-params
;;       '((user :default "postgres")
;;         (database :default "postgres")
;;         (server :default "0.0.0.0")
;;         (port :default 5432)))

;; (add-hook 'sql-interactive-mode-hook
;;           (lambda ()
;;             (toggle-truncate-lines t)))

;;; sql.el ends here
