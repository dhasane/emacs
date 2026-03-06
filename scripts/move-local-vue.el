
(defalias 'localvue-clean-import-and-definition
   (kmacro "g g / c r e a t e L o c a l V u e <return> d t } h i <backspace> <escape> n d d"))

(defalias 'localvue-get-plugins
   (kmacro "0 f ( a , SPC <escape> F , \" o P \" o d i ( d d k"))

(defalias 'localvue-cleanup-plugins
   (kmacro "O <escape> \" o P I <kp-delete> <kp-delete> <escape> \" o d d"))

(defalias 'go-to-beginning
   (kmacro "g g 0"))

(defalias 'cleanup-o-register
   (kmacro "O <escape> \" o y l d d"))

(defalias 'set-localvue-as-plugins
   (kmacro "B c e g l o b a l : SPC { <return> p l u g i n s : SPC [ <return> <escape> \" o p k k J J J "))

(defalias 'save-b
   (kmacro "C-s"))

(defun macro-cleanup ()
  (interactive)

  (atomic-change-group
    (go-to-beginning)
    (localvue-clean-import-and-definition)
    (go-to-beginning)
    (cleanup-o-register)

    (save-excursion
      (while (re-search-forward "localVue.use" nil t)
        (localvue-get-plugins)
        (go-to-beginning)
        )

      (localvue-cleanup-plugins)

      (while (re-search-forward "localVue" nil t)
        (set-localvue-as-plugins)
        )
      )

    (save-b)
    )
  )

(defalias 'vueRouter-to-createRouter
   (kmacro "B B c t ( c r e a t e R o u t e r <escape>"))


(defalias 'add-createRouter-import
   (kmacro "g g } O i m p o r t SPC { SPC c r e a t e R o u t e r SPC } SPC f r o m SPC ' v u e - r o u t e r ' SPC <escape>"))


(defun macro-cleanup ()
  (interactive)

  (atomic-change-group
    (go-to-beginning)
    (add-createRouter-import)

    (save-excursion
      (while (re-search-forward "new VueRouter(" nil t)
        (vueRouter-to-createRouter)
        )
      )

    (save-b)
    )
  )
