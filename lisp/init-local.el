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
(global-set-key (kbd "M-j C-s") 'isearch-current-symbol)
(global-set-key (kbd "M-j C-r") 'isearch-backward-current-symbol)
(global-set-key (kbd "M-j M-f") 'find-name-dired)

(defun move-window-down ()
  (interactive)
  (next-line)
  (recenter))
(defun move-window-up ()
  (interactive)
  (previous-line)
  (recenter))

                                        ;(setq local-function-key-map (delq '(kp-tab . [9]) local-function-key-map))
(global-set-key (kbd "C-p") 'move-window-up)
;(global-set-key (kbd "<up>") 'move-window-up)
;(global-set-key (kbd "<down>") 'move-window-down)
(global-set-key (kbd "C-n") 'move-window-down)
                                        ;(definez-key 'my-prefix (kbd "p h") 'highlight-symbol-prev)
                                        ;(define-key 'my-prefix (kbd "n h") 'highlight-symbol-next)


(require 'multi)
(global-linum-mode 1)
;(require 'helm-spotify)

                                        ;Change auto save behavior
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq temporary-file-directory "~/.emacs.backups")
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


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

(defvar blog-prefix "/Users/gabriel/Projects/blog/resources/templates/md/")
(defun create-blog-post (post-name date)
  "Create a blog post"
  (interactive "bPost Name: \nbPost date (YYYY-MM-DD): ")
  (find-file (string-join '(blog-prefix
                            "preliminary/"
                            date
                            "-"
                            (string-join (split-string post-name) "-")
                            ".md"))))
(defun finish-blog-post (post-name)
  "Move a blog post to the correct directory"
  (interactive "bPost Name: ")
  (rename-file ('(blog-prefix
                  "preliminary/"
                  date
                  "-"
                  (string-join (split-string post-name) "-")
                  ".md"))
               (string-join '("/Users/gabriel/Projects/blog/resources/templates/md/posts/"
                              date
                              "-"
                              (string-join (split-string post-name) "-")
                              ".md"))))

(global-linum-mode 1)

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
  (run-scheme
   "/usr/local/scmutils/mit-scheme/bin/scheme --library /usr/local/scmutils/mit-scheme/lib"))


(set-face-attribute 'default nil :height 117)

                                        ;(add-hook 'after-init-hook #'global-flycheck-mode)

;(eval-after-load 'flycheck  '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))
(add-hook 'markdown-mode-hook 'turn-on-visual-line-mode)
(setq scroll-preserve-screen-position 1)
                                        ;(global-set-key (kbd "M-n") (kbd "C-u 1 C-v"))
                                        ;(global-set-key (kbd "M-p") (kbd "C-u 1 M-v"))
                                        ;(global-set-key (kbd "C-i") 'move-window-down)

(add-hook 'text-mode-hook (lambda () (turn-on-visual-line-mode)))
(global-set-key (kbd "C-1") 'sanityinc/toggle-delete-other-windows)
(global-set-key (kbd "C-2") 'split-window-below)
(global-set-key (kbd "C-3") 'split-window-right)
(global-set-key (kbd "C-0") 'delete-window)

(provide 'init-local)
;;; init-local.el ends here
