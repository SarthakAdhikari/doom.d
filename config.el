;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Sarthak Adhikari"
      user-mail-address "adhikari.sarthak@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 18 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 18))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Window move
(map!
 "C-s-h" #'evil-window-left
 "C-s-j" #'evil-window-down
 "C-s-k" #'evil-window-up
 "C-s-l" #'evil-window-right
 )

;; whichkey delay
(setq which-key-idle-delay 0.25)

;; full screen on startup
(toggle-frame-fullscreen)
(parrot-mode)
(parrot-set-parrot-type 'thumbsup)
(setq parrot-num-rotations nil)
(setq parrot-animation-frame-interval 0.0325)

(defun copy-current-line-position-to-clipboard ()
    "Copy current line in file to clipboard as '</path/to/file>:<line-number>'."
    (interactive)
    (let ((path-with-line-number
           (concat (dired-replace-in-string (getenv "HOME") "~" (buffer-file-name)) ":" (number-to-string (line-number-at-pos)))))
      (kill-new path-with-line-number)
      (message (concat path-with-line-number " copied to clipboard"))))


(defun find-file-at-point-goto-line (ret)
  "Ignore RET and jump to line number given in `ffap-string-at-point'."
  (when (and
     (stringp ffap-string-at-point)
     (string-match ":\\([0-9]+\\)\\'" ffap-string-at-point))
    (goto-char (point-min))
    (forward-line (string-to-number (match-string 1 ffap-string-at-point))))
  ret)

(advice-add 'find-file-at-point :filter-return #'find-file-at-point-goto-line)

(map! (:leader
       (:desc "afnai" :prefix "a"
        :desc "find-file-at-point" :nv "a" #'find-file-at-point
        )))

(modify-syntax-entry ?_ "w")


;; (after! python
;;    (set-formatter! 'autopep8 "autopep8 --aggressive --aggressive -" :modes '(python-mode)))
;; (setq-hook! 'python-mode-hook +format-with-lsp nil)
;; (add-hook 'python-mode-hook 'format-all-mode)
(setq pdf-view-restore-filename "~/.emacs.d/.pdf-view-restore")
(use-package pdf-view-restore
  :after pdf-tools
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode))

(setq doom-line-numbers-style 'relative)
(global-eldoc-mode 0)

(use-package edit-server
  :commands edit-server-start
  :init (if after-init-time
              (edit-server-start)
            (add-hook 'after-init-hook
                      #'(lambda() (edit-server-start))))
  :config (setq edit-server-new-frame-alist
                '((name . "Edit with Emacs FRAME")
                  (top . 200)
                  (left . 200)
                  (width . 80)
                  (height . 25)
                  (minibuffer . t)
                  (menu-bar-lines . t)
                  (window-system . x))))


(setq lsp-clients-python-settings '(:configurationSources ["flake8"]))
(setq lsp-pyls-plugins-pylint-enabled nil)

(defun execute-c-program ()
  (interactive)
  (defvar foo)
  (setq foo (concat "gcc " (buffer-name) " && ./a.out" ))
  (shell-command foo))

(global-set-key [C-f1] 'execute-c-program)
