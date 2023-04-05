;;; package --- Summary  -*- lexical-binding: t; -*-

;;; Commentary:

;;; code:

(use-package php-mode
  :mode ("\\.php\\'" . php-mode)
  :general
  (php-mode-map
   :states '(insert override)
   "TAB" 'basic-tab-indent-or-complete
   [tab] 'basic-tab-indent-or-complete
   )
  )

(use-package phpunit)

;;; php.el ends here
