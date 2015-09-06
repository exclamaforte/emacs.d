(defvar dbm-mode-hook
  (let ((map (make-key)))
    (define-key map "\C-j" 'newline-and-indent)
    map)
  "Keymap for dbm major mode")

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.debugging\\'" . dbm-mode))
