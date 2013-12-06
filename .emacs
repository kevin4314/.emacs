;; use package.el to install packages
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(eval-when-compile (require 'cl))

(defvar my-packages
  '(auctex coffee-mode expand-region
	   gist haskell-mode inf-ruby
	   magit magit-push-remote markdown-mode
	   paredit python rainbow-mode
	   volatile-highlights coffee-mode
	   smooth-scrolling scala-mode2
	   dired+)
  "A list of packages to ensure are installed at launch.")

(package-initialize)
;; check if the packages is installed; if not, install it.
(mapc
 (lambda (package)
   (or (package-installed-p package)
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package))))
 my-packages)
;; end package.el



;; Settings
(setq user-full-name "LauZi")
(setq user-mail-address "st61112@gmail.com")

(setq load-path  (cons (expand-file-name "~/.emacs.d/lisp/") load-path))
(setq default-directory "D:\Dropbox")

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(global-set-key "\M-r" 'replace-string)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)
(global-unset-key "\C-z")

;; Disable input methods
(global-unset-key (kbd "C-\\"))

;; key bindings to adjust frame size
(global-set-key (kbd "<C-up>") 'shrink-window)
(global-set-key (kbd "<C-down>") 'enlarge-window)
(global-set-key (kbd "<C-left>") 'shrink-window-horizontally)
(global-set-key (kbd "<C-right>") 'enlarge-window-horizontally)


;;; highlight ()
(show-paren-mode 1)

(scroll-bar-mode -1)
(setq column-number-mode t)
(setq size-indication-mode t)

(set-face-attribute 'default nil :font "Consolas-12")

(load "color-theme-molokai")
(color-theme-molokai)

(tool-bar-mode -1)

;;; line number (http://www.pshared.net/diary/20080519.html)
(require 'linum)
(global-linum-mode t)
;(setq linum-format "%5d | ")


;; auto-refresh files
(global-auto-revert-mode t)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; ansi-term
(global-set-key [f1] 'shell)

;;; don't make #filename (http://d.hatena.ne.jp/TetsuOne/20080625/1214398899)
(setq make-backup-files nil)
;;; end Settings


;; Addons
(defadvice comment-or-uncomment-region (before slickcomment activate compile)
  "When called interactively with no active region, toggle comment on current line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

;;;C mode
(defun my-c-mode-hook ()
               (c-set-style "cc-mode")

               (setq c-indent-level 4)
               (setq c-tab-width 4)
               (setq tab-width 4)
               (setq c-basic-offset tab-width)
               (setq indent-tabs-mode nil) ;; force only spaces for indentation
	       (define-key c-mode-base-map [(return)] 'newline-and-indent)
	       (define-key c-mode-base-map [(f9)] 'compile)
	       (define-key c-mode-base-map [(meta \')] 'c-indent-command)
	       (define-key c-mode-base-map "\M-;" 'comment-or-uncomment-region)
           )
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)

(add-to-list 'default-frame-alist '(height . 24))
(add-to-list 'default-frame-alist '(width . 80))
(setq kill-whole-line t) ; makes kill-line remove whole line


;start smart-beginning-of-line
(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.

Move point to the first non-whitespace character on this line.
If point was already at that position, move point to beginning of line."
  (interactive)
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
         (beginning-of-line))))
(global-set-key [home] 'smart-beginning-of-line)
(global-set-key "\C-a" 'smart-beginning-of-line)
;end smart-beginning-of-line


;start qiang-copy-line
(defun qiang-copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring"
  (interactive "p")
  (kill-ring-save (point)
                  (line-end-position))

  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))
(global-set-key "\M-k" 'qiang-copy-line)
;end qiang-copy-line


; begin auto-insert for .sh
(define-auto-insert 'sh-mode '(nil "#!/bin/bash\n\n"))
(define-auto-insert 'ptyhon-mode '(nil "#!/usr/bin/python\n\n"))
(add-hook 'find-file-hooks 'auto-insert)


;; C - ' is not a valid ascii code
(global-set-key [(control ?\')] 'other-window)
(custom-set-variables
 '(initial-buffer-choice "D:\Dropbox"))
(custom-set-faces)


;; AUCTeX settings
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-PDF-mode t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

(add-hook 'LaTeX-mode-hook (lambda()
			     (setq TeX-save-query  nil
				   TeX-engine 'xetex
				   TeX-show-compilation t)
			     (define-key LaTeX-mode-map (kbd "TAB") 'TeX-complete-symbol)
			     ))


;; lambda mode is for python, changes lambda => ,\ symbol
(require 'lambda-mode)
(add-hook 'python-mode-hook #'lambda-mode 1)
(setq lambda-symbol (string (make-char 'greek-iso8859-7 107)))

;; removes buffer after ansi-term closes
(defadvice term-sentinel (around my-advice-term-sentinel (proc msg))
  (if (memq (process-status proc) '(signal exit))
      (let ((buffer (process-buffer proc)))
        ad-do-it
        (kill-buffer buffer))
    ad-do-it))
(ad-activate 'term-sentinel)

(defvar my-term-shell "/bin/bash")
(defadvice ansi-term (before force-bash)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)

(defun my-term-use-utf8 ()
  (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(add-hook 'term-exec-hook 'my-term-use-utf8)

;; makes URLs clickable
(defun my-term-hook ()
  (goto-address-mode))
(add-hook 'term-mode-hook 'my-term-hook)

;; detect octave files
(setq auto-mode-alist (cons '("\\.m$" . octave-mode) auto-mode-alist))

;; change backup files(*~) and autosave files (#*#) directory
(defvar user-temporary-file-directory
  (concat temporary-file-directory user-login-name "/"))
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (,tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))
