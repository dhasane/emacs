
(defcustom mot-message-position 0
  "Posicion."
  :type 'number)
(defcustom list-mot
  '(
    "todo va a estar bien"
    "se va a pasar esto "
    "hay que relajar los hombros y respirar"
    "esto no va a durar mucho tiempo "
    "tu tienes el control"
    "revisa tu postura"
    "eres una persona saludable"
    "respira profundo"
    "todo estara bien"
    "relaja el cuello"
    "vas a estar bien"
    "todo esta en la cabeza, sigues vivo"
    )
  "Lista mot."
  :type 'list)

(defun send-message (msg)
  "Enviar MSG."
  (notifications-notify
    :title msg
    :urgency 'low)
  )

(defun mot-message-send ()
  "Enviar un mensaje y mover +1 la posicion."
  (interactive)
  (let ((msg (nth mot-message-position list-mot)))
    (send-message msg)
    )
  (setq mot-message-position (+ mot-message-position 1))
  (if (< (- (length list-mot) 1) mot-message-position)
      (setq mot-message-position 0)
      )
  )

(defun disable-motivational-messages ()
  "Desactivar mensajes."
  (interactive)
  (remove-hook 'buffer-list-update-hook
            'mot-message-send)
  )

(defun enable-motivational-messages ()
  "Activar mensajes."
  (interactive)
  (add-hook 'buffer-list-update-hook
            'mot-message-send)
  )

(defun set-motivational-messages-timer ()
  "Poner mensajes cada 15 minutos."
  (interactive)
  (let ((mins 15))
    (disable-motivational-messages)
    (run-with-timer 0 (* mins 60) 'mot-message-send)
    )
  (add-hook 'auto-save-hook 'mot-message-send)
  )
