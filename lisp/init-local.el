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

(add-to-list 'load-path "/Users/gabriel/.emacs.d/helm")

(add-to-list 'load-path "/Users/gabriel/.emacs.d/async")
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(helm-mode 1)

(require 'breadcrumb)
(define-prefix-command 'my-prefix)
(global-set-key (kbd "M-j") 'my-prefix)
(define-key 'my-prefix (kbd "s b") 'bc-set)
(define-key 'my-prefix (kbd "p b") 'bc-previous)
(define-key 'my-prefix (kbd "n b") 'bc-next)
(define-key 'my-prefix (kbd "g") 'magit-status)
(define-key 'my-prefix (kbd "h") 'helm-spotify)
(define-key 'my-prefix (kbd "r") 'rgrep)
(define-key 'my-prefix (kbd "M-o c") 'org-capture)
(define-key 'my-prefix (kbd "M-o h") 'org-mark-element)
(define-key 'my-prefix (kbd "f n") 'copy-file-name-to-clipboard)
(define-key 'my-prefix (kbd "p h") 'highlight-symbol-prev)
(define-key 'my-prefix (kbd "n h") 'highlight-symbol-next)

(require 'multi)
(require 'helm-spotify)



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

(setq blink-cursor-mode nil)
(provide 'init-local)


;; (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
;; (add-hook 'haskell-mode-hook 'haskell-indentation-mode)
;; (custom-set-variables
;;  '(haskell-process-type 'cabal-repl))
;; (custom-set-variables
;;  '(haskell-process-suggest-remove-import-lines t)
;;  '(haskell-process-auto-import-loaded-modules t)
;;  '(haskell-process-log t))
;; (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
;; (define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
;; (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
;; (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
;; (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
;; (define-key haskell-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
;; (define-key haskell-mode-map (kbd "C-c c") 'haskell-process-cabal)
;; (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)
;; (setq haskell-program-name "/some/where/ghci.exe")

(projectile-global-mode)
(add-hook 'projectile-mode-hook 'projectile-rails-on)


(defun isearch-yank-regexp (regexp)
  "Pull REGEXP into search regexp."
  (let ((isearch-regexp nil)) ;; Dynamic binding of global.
    (isearch-yank-string regexp))
  (isearch-search-and-update))

(defun isearch-yank-symbol (&optional partialp backward)
  "Put symbol at current point into search string.

    If PARTIALP is non-nil, find all partial matches."
  (interactive "P")

  (let (from to bound sym)
    (setq sym
                                        ;this block taken directly from find-tag-default
                                        ; we couldn't use the function because we need the internal from and to values
          (when (or (progn
                      ;; Look at text around `point'.
                      (save-excursion
                        (skip-syntax-backward "w_") (setq from (point)))
                      (save-excursion
                        (skip-syntax-forward "w_") (setq to (point)))
                      (> to from))
                    ;; Look between `line-beginning-position' and `point'.
                    (save-excursion
                      (and (setq bound (line-beginning-position))
                           (skip-syntax-backward "^w_" bound)
                           (> (setq to (point)) bound)
                           (skip-syntax-backward "w_")
                           (setq from (point))))
                    ;; Look between `point' and `line-end-position'.
                    (save-excursion
                      (and (setq bound (line-end-position))
                           (skip-syntax-forward "^w_" bound)
                           (< (setq from (point)) bound)
                           (skip-syntax-forward "w_")
                           (setq to (point)))))
            (buffer-substring-no-properties from to)))
    (cond ((null sym)
           (message "No symbol at point"))
          ((null backward)
           (goto-char (1+ from)))
          (t
           (goto-char (1- to))))
    (isearch-search)
    (if partialp
        (isearch-yank-string sym)
      (isearch-yank-regexp
       (concat "\\_<" (regexp-quote sym) "\\_>")))))

(defun isearch-current-symbol (&optional partialp)
  "Incremental search forward with symbol under point.

    Prefixed with \\[universal-argument] will find all partial
    matches."
  (interactive "P")
  (let ((start (point)))
    (isearch-forward-regexp nil 1)
    (isearch-yank-symbol partialp)))

(defun isearch-backward-current-symbol (&optional partialp)
  "Incremental search backward with symbol under point.

    Prefixed with \\[universal-argument] will find all partial
    matches."
  (interactive "P")
  (let ((start (point)))
    (isearch-backward-regexp nil 1)
    (isearch-yank-symbol partialp)))

(defun isearch-backward-current-symbol-ruby-def (&optional partialp)
  "Incremental search backward for function with name at point.

    Prefixed with \\[universal-argument] will find all partial
    matches."
  (interactive "P")
  (let ((start (point)))
    (isearch-backward-regexp nil 1)
    (isearch-yank-symbol partialp)))
(global-set-key (kbd "M-j C-s") 'isearch-current-symbol)
(global-set-key (kbd "M-j C-r") 'isearch-backward-current-symbol)

(require 'yasnippet)
(yas-global-mode 1)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"))

(global-linum-mode 1)

(require 'ein)
(setq ein:use-auto-complete t)
(defun my-find-file-check-make-large-file-read-only-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (> (buffer-size) (* 1024 1024))
    (linum-mode -1)
    (font-lock-mode -1)
    (buffer-disable-undo)
    (fundamental-mode)))

(add-hook 'find-file-hook 'my-find-file-check-make-large-file-read-only-hook)

;(setq magit-auto-revert-mode nil)
;(setq magit-last-seen-setup-instructions "1.4.0")

(set-default 'tramp-default-proxies-alist (quote (("45.55.130.219" "root" "/ssh:gabe@45.55.130.219:"))))

(defun find-file-as-root ()
  "Find a file as root."
  (interactive)
  (let* ((parsed (when (tramp-tramp-file-p default-directory)
                   (coerce (tramp-dissect-file-name default-directory)
                           'list)))
         (default-directory
           (if parsed
               (apply 'tramp-make-tramp-file-name
                      (append '("sudo" "root") (cddr parsed)))
             (tramp-make-tramp-file-name "sudo" "root" "localhost"
                                         default-directory))))
    (call-interactively 'find-file)))
(add-hook 'markdown-mode-hook 'turn-on-visual-line-mode)
(setq scroll-preserve-screen-position 1)
(global-set-key (kbd "M-n") (kbd "C-u 1 C-v"))
(global-set-key (kbd "M-p") (kbd "C-u 1 M-v"))
