;;; local --- Summary
;;; Commentary:
;;;tern
;(add-to-list 'load-path "/home/gabe/.emacs.d/tern/emacs")
;(autoload 'tern-mode "tern.el" nil t)
;(add-hook 'js2-mode-hook (lambda () (tern-mode t)))
;(setenv "PATH" (concat "/usr/bin:" (getenv "PATH")))
;
;(eval-after-load 'tern  '(progn     (require 'tern-auto-complete)     (tern-ac-setup)))
;(setenv "NODE_PATH" (concat         "/home/gabe/.emacs.d/tern/lib" ":"         "/home/gabe/.emacs.d" ":"         (getenv "NODE_PATH")         )        )
;;; Code:
(require 'breadcrumb)
(define-prefix-command 'my-prefix)
(global-set-key (kbd "M-j") 'my-prefix)
(define-key 'my-prefix (kbd "s") 'bc-set)
(define-key 'my-prefix (kbd "p") 'bc-previous)
(define-key 'my-prefix (kbd "n") 'bc-next)
(define-key 'my-prefix (kbd "g") 'magit-status)
(define-key 'my-prefix (kbd "m") 'helm-spotify)
(define-key 'my-prefix (kbd "r") 'rgrep)
(require 'multi)
(require 'helm-spotify)
(require 'pinboard)
(global-linum-mode 1)

;Change auto save behavior
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq temporary-file-directory "~/.emacs.backups")
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; [Facultative] Only if you have installed async.
(add-to-list 'load-path "/Users/gabriel/.emacs.d/helm")

(add-to-list 'load-path "/Users/gabriel/.emacs.d/async")
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(helm-mode 1)
(helm-autoresize-mode 0)
;;;if package is not working
;;; M-x package-refresh-contents
(blink-cursor-mode 0)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode -1)

(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))


(global-set-key (kbd "M-[") 'paredit-wrap-square)
(require 'virtualenvwrapper)
(venv-initialize-interactive-shells)
(venv-initialize-eshell)
(setq venv-location "~/env")
(defun open-ssec (name)
  (interactive "Domain name: ")
  (let ((string-name (if (stringp name) name (symbol-name name))))
    (let ((base-path (concat "/ssh:gferns@ash.ssec.wisc.edu|ssh:gferns@" string-name ".ssec.wisc.edu:")))
      (find-file base-path)
      (shell)
      (insert "activate env"))))

(setq blink-cursor-mode nil)
(provide 'init-local)

(defun mechanics ()
  (interactive)
  (run-scheme
   "/usr/local/scmutils/mit-scheme/bin/scheme --library /usr/local/scmutils/mit-scheme/lib"))

(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(add-hook 'haskell-mode-hook 'haskell-indentation-mode)
(custom-set-variables
 '(haskell-process-type 'cabal-repl))
(custom-set-variables
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t))
(define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
(define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
(define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
(define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
(define-key haskell-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
(define-key haskell-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
(define-key haskell-mode-map (kbd "C-c c") 'haskell-process-cabal)
(define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)
;;; init-local.el ends here
