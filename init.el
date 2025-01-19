;; -*- lexical-binding: t; -*-

(require 'org)
(require 'dired)
(require 'grep)
(require 'bookmark)
(require 'dired)

;; ----------------------------------------------------------------------
;; Emacs-Core
;; ----------------------------------------------------------------------
;;
;; -> completion-core
;;
(setq-default abbrev-mode t)

;;
;; -> keys-navigation-core
;;
(defvar my-jump-keymap (make-sparse-keymap))
(global-set-key (kbd "M-l") my-jump-keymap)
(define-key my-jump-keymap (kbd "b") (lambda () (interactive) (find-file "~/bin")))
(define-key my-jump-keymap (kbd "e")
            (lambda ()
              (interactive)
              (find-file (expand-file-name "init.el" user-emacs-directory))))
(define-key my-jump-keymap (kbd "g") (lambda () (interactive) (find-file "~/.config")))
(define-key my-jump-keymap (kbd "h") (lambda () (interactive) (find-file "~")))
(define-key my-jump-keymap (kbd "r") (lambda () (interactive) (switch-to-buffer "*scratch*")))
;;
(global-set-key (kbd "M-;") #'my/quick-window-jump)

;;
;; -> keys-visual-core
;;
(add-hook 'text-mode-hook 'visual-line-mode)

;;
;; -> keys-visual-core
;;
(defvar my-win-keymap (make-sparse-keymap))
(global-set-key (kbd "C-q") my-win-keymap)
(define-key my-win-keymap (kbd "e") #'whitespace-mode)
(define-key my-win-keymap (kbd "f") #'font-lock-mode)
(define-key my-win-keymap (kbd "h") #'global-hl-line-mode)
(define-key my-win-keymap (kbd "n") #'linum-mode)
(define-key my-win-keymap (kbd "p") #'variable-pitch-mode)
(define-key my-win-keymap (kbd "q") #'toggle-menu-bar-mode-from-frame)
(define-key my-win-keymap (kbd "u") #'set-cursor-color)
(define-key my-win-keymap (kbd "v") #'visual-line-mode)

;;
;; -> keys-other-core
;;
(global-set-key (kbd "M-s ,") #'my/mark-line)
(global-set-key (kbd "M-s =") #'ediff-buffers)
(global-set-key (kbd "M-s h") #'my/mark-block)
(global-set-key (kbd "M-s j") #'eval-defun)
(global-set-key (kbd "M-s l") #'eval-expression)
(global-set-key (kbd "M-s x") #'diff-buffer-with-file)

;;
;; -> keybinding-core
;;
(global-set-key (kbd "C--") (lambda ()(interactive)(text-scale-adjust -1)))
(global-set-key (kbd "C-=") (lambda ()(interactive)(text-scale-adjust 1)))
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x [") #'beginning-of-buffer)
(global-set-key (kbd "C-x ]") #'end-of-buffer)
(global-set-key (kbd "C-x l") #'scroll-lock-mode)
(global-set-key (kbd "C-x s") #'save-buffer)
(global-set-key (kbd "C-x x g") #'revert-buffer)
(global-set-key (kbd "C-x x t") #'toggle-truncate-lines)
(global-set-key (kbd "C-;") #'my/comment-or-uncomment)
(global-set-key (kbd "M-a") #'delete-other-windows)
(global-set-key (kbd "M-0") 'delete-window)
(global-set-key (kbd "M-1") #'delete-other-windows)
(global-set-key (kbd "M-2") #'split-window-vertically)
(global-set-key (kbd "M-3") #'split-window-horizontally)
(global-set-key (kbd "M-[") #'yank)
(global-set-key (kbd "M-]") #'yank-pop)
(global-set-key (kbd "M-e") #'dired-jump)
(global-set-key (kbd "M-g i") #'imenu)
(global-set-key (kbd "M-g o") #'org-goto)
(global-set-key (kbd "M-j") #'(lambda ()(interactive)(scroll-up (/ (window-height) 4))))
(global-set-key (kbd "M-k") #'(lambda ()(interactive)(scroll-down (/ (window-height) 4))))
(global-set-key (kbd "M-o") #'bookmark-jump)
(global-set-key (kbd "M-m") #'split-window-vertically)
(global-unset-key (kbd "C-h h"))
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-t"))

;;
;; -> modes-core
;;
(column-number-mode 1)
(desktop-save-mode -1)
(display-time-mode 1)
(global-auto-revert-mode t)
(savehist-mode 1)
(show-paren-mode t)
(global-font-lock-mode t)

;;
;; -> bell-core
;;
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;;
;; -> setqs-core
;;
(setq custom-safe-themes t)
(setq enable-local-variables :all)
(setq frame-title-format "%f")
(setq kill-whole-line t)
(setq-default truncate-lines t)
(setq frame-inhibit-implied-resize t)

;;
;; -> confirm-core
;;
(defalias 'yes-or-no-p 'y-or-n-p)
(setq confirm-kill-emacs 'y-or-n-p)
(setq confirm-kill-processes nil)
(setq confirm-nonexistent-file-or-buffer nil)
(set-buffer-modified-p nil)

;;
;; -> backups-core
;;
(setq make-backup-files 1)
(setq backup-directory-alist '(("." . "~/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 10   ; how many of the newest versions to keep
      kept-old-versions 5)   ; and how many of the old

;;
;; -> defun-core
;;
(defun save-macro (name)
  "Save a macro by NAME."
  (interactive "SName of the macro: ")
  (kmacro-name-last-macro name)
  (find-file user-init-file)
  (goto-char (point-max))
  (newline)
  (insert-kbd-macro name)
  (newline))
;;
(defun my/comment-or-uncomment ()
  "Comments or uncomments the current line or region."
  (interactive)
  (if (region-active-p)
      (comment-or-uncomment-region
       (region-beginning)(region-end))
    (comment-or-uncomment-region
     (line-beginning-position)(line-end-position))))
;;
(defun my/mark-line ()
  "Mark the current line, handling Eshell prompt if in Eshell."
  (interactive)
  (if (derived-mode-p 'eshell-mode)
      (let ((prompt-end (marker-position eshell-last-output-end)))
        (goto-char prompt-end)
        (push-mark (point) nil t)
        (end-of-line))
    (beginning-of-line)
    (push-mark (point) nil t)
    (end-of-line)))
;;
(defun my/mark-block ()
  "Marking a block of text surrounded by a newline."
  (interactive)
  (when (not (region-active-p))
    (backward-char))
  (skip-chars-forward " \n\t")
  (re-search-backward "^[ \t]*\n" nil 1)
  (skip-chars-forward " \n\t")
  (when (not (region-active-p))
    (push-mark))
  (re-search-forward "^[ \t]*\n" nil 1)
  (skip-chars-backward " \n\t")
  (setq mark-active t))
;;
(defun my/dired-du ()
  "Run 'du -hc' and count the total number of files in the directory under
  the cursor in Dired, then display the output in a buffer named *dired-du*."
  (interactive)
  (let ((current-dir (dired-get-file-for-visit)))
    (if (file-directory-p current-dir)
        (let ((output-buffer-name "*dired-du*"))
          (with-current-buffer (get-buffer-create output-buffer-name)
            (erase-buffer)) ; Clear the buffer before running the command
          (shell-command
           (format "du -hc --max-depth=1 %s && echo && echo 'File counts per subdirectory:' && find %s -maxdepth 2 -type d -exec sh -c 'echo -n \"{}: \"; find \"{}\" -type f | wc -l' \\;"
                   (shell-quote-argument current-dir)
                   (shell-quote-argument current-dir))
           output-buffer-name))
      (message "The current point is not a directory."))))
;;
;; -> org-core
;;
(setq org-log-done t)
(setq org-export-with-sub-superscripts nil)
(setq org-deadline-warning-days 365)
(setq org-image-actual-width (list 50))
(setq org-return-follows-link t)
(setq org-use-fast-todo-selection 'expert)
(setq org-reverse-note-order t)
(setq org-src-preserve-indentation t)
(setq org-cycle-separator-lines 0)
(setq org-edit-src-content-indentation 0)
(setq org-tags-sort-function 'org-string-collate-greaterp)
(setq org-startup-indented t)
(setq org-use-speed-commands t)
(setq org-hide-leading-stars t)
(setq org-goto-interface 'outline-path-completionp)
(setq org-outline-path-complete-in-steps nil)
;;
;; -> scroll-core
;;
(setq scroll-margin 10)
(setq scroll-conservatively 10)
(setq scroll-preserve-screen-position t)

;;
;; -> dired-core
;;
(setq dired-dwim-target t)
(setq dired-listing-switches "-alGgh")
(setq dired-auto-revert-buffer t)
(setq dired-confirm-shell-command nil)
(setq dired-no-confirm t)
(setq dired-deletion-confirmer '(lambda (x) t))
(setq dired-recursive-deletes 'always)

;;
;; -> visuals-core
;;
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-startup-screen t)
(setq use-dialog-box nil)
(set-fringe-mode '(20 . 20))
(setq bookmark-set-fringe-mark nil)
(setq bookmark-fringe-mark nil)

;;
;; -> recentf-core
;;
(recentf-mode 1)
(setq recentf-max-menu-items 200)
(setq recentf-max-saved-items 200)

;;
;; -> modeline-core
;;
(setq my/mode-line-format
      (list
       '(:eval (if (and (buffer-file-name) (buffer-modified-p))
                   (propertize " * " 'face
                               '(:background "#ff0000" :foreground "#ffffff" :inherit bold)) ""))
       '(:eval
         (propertize (format "%s" (abbreviate-file-name default-directory)) 'face '(:inherit bold)))
       '(:eval
         (if (not (equal major-mode 'dired-mode))
             (propertize (format "%s " (buffer-name)))
           " "))
       'mode-line-position
       'mode-line-modes
       'mode-line-misc-info
       '(:eval (format " | Point: %d" (point)))))
;;
(setq-default mode-line-format my/mode-line-format)

;;
;; -> gdb-core
;;
(setq gdb-display-io-nopopup 1)
(setq gdb-many-windows t)
(global-set-key (kbd "<f9>") 'gud-break)
(global-set-key (kbd "<f10>") 'gud-next)
(global-set-key (kbd "<f11>") 'gud-step)

;;
;; -> compilation-core
;;
(setq compilation-always-kill t)
(setq compilation-context-lines 3)
(setq compilation-scroll-output t)
;; ignore warnings
(setq compilation-skip-threshold 2)

;;
;; -> diff-core
;;
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-highlight-all-diffs t)
(setq ediff-split-window-function 'split-window-horizontally)
(add-hook 'ediff-prepare-buffer-hook (lambda () (visual-line-mode -1)))

;;
;; -> indentation-core
;;
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; ----------------------------------------------------------------------
;; Emacs-Enhanced
;; ----------------------------------------------------------------------

(defun my-icomplete-exit-minibuffer-with-input ()
  "Exit the minibuffer with the current input, without forcing completion."
  (interactive)
  (exit-minibuffer))

(defun my/quick-window-jump ()
  "Jump to a window by typing its assigned character label.
If there is only a single window, split it horizontally.
If there are only two windows, jump directly to the other window."
  (interactive)
  (let* ((window-list (window-list nil 'no-mini)))
    (cond
     ;; If there is only a single window, split it horizontally.
     ((= (length window-list) 1)
      (split-window-horizontally)
      (other-window 1)) ;; Move focus to the new window immediately after splitting.

     ;; If there are only two windows, switch to the other one directly.
     ((= (length window-list) 2)
      (select-window (other-window-for-scrolling)))

     ;; Otherwise, present the key selection interface.
     (t
      (let* ((my/quick-window-overlays nil)
             (sorted-windows (sort window-list
                                   (lambda (w1 w2)
                                     (let ((edges1 (window-edges w1))
                                           (edges2 (window-edges w2)))
                                       (or (< (car edges1) (car edges2))
                                           (and (= (car edges1) (car edges2))
                                                (< (cadr edges1) (cadr edges2))))))))
             (window-keys (seq-take '("j" "k" "l" ";" "a" "s" "d" "f")
                                    (length sorted-windows)))
             (window-map (cl-pairlis window-keys sorted-windows)))
        (setq my/quick-window-overlays
              (mapcar (lambda (entry)
                        (let* ((key (car entry))
                               (window (cdr entry))
                               (start (window-start window))
                               (overlay (make-overlay start start (window-buffer window))))
                          (overlay-put overlay 'after-string 
                                       (propertize (format "[%s]" key)
                                                   'face '(:foreground "white" :background "blue" :weight bold)))
                          (overlay-put overlay 'window window)
                          overlay))
                      window-map))
        (let ((key (read-key (format "Select window [%s]: " (string-join window-keys ", ")))))
          (mapc #'delete-overlay my/quick-window-overlays)
          (setq my/quick-window-overlays nil)
          (when-let ((selected-window (cdr (assoc (char-to-string key) window-map))))
            (select-window selected-window))))))))

(setq ispell-local-dictionary "en_GB")
(setq ispell-program-name "hunspell")
(setq dictionary-default-dictionary "*")
(defun spelling-menu ()
  "Menu for spelling."
  (interactive)
  (let ((key (read-key
              (propertize
               "------- Spelling [q] Quit: -------
Run        [s] Spelling
Dictionary [l] Check"
               'face 'minibuffer-prompt))))
    (pcase key
      ;; Spelling
      (?s (progn
            (flyspell-buffer)
            (call-interactively 'flyspell-mode)))
      (?l (call-interactively 'ispell-word))
      ;; Quit
      (?q (message "Quit Build menu."))
      (?\C-g (message "Quit Build menu."))
      ;; Default Invalid Key
      (_ (message "Invalid key: %c" key)))))
;;
(global-set-key (kbd "C-c s") #'spelling-menu)
(global-set-key (kbd "C-0") #'ispell-word)
;;
(global-set-key (kbd "M-g o") #'org-goto)
(setq org-goto-interface 'outline-path-completionp)
(setq org-outline-path-complete-in-steps nil)
;;
(global-set-key (kbd "C-c ,") 'find-file-at-point)
(define-key dired-mode-map (kbd "C") 'my/rsync)
;;
;; ----------------------------------------------------------------------
;; Emacs-Init
;; ----------------------------------------------------------------------

;; title bar to print visited filename
(setq frame-title-format "%f")

;; allows shift and cursor keys to move between split windows
(windmove-default-keybindings)

;; follow symbolic links to real name
(setq find-file-visit-truename t)

;; default grep arguments
(setq grep-command "grep -ni")

;; minibuffer completion for file and buffer switching
(setq ido-enable-flex-matching t)
(setq ido-everywhere nil)
(ido-mode 1)
(icomplete-mode t)

(defun my/switch-buffer (buffer)
  "Switch to a buffer."
  (interactive
   (list (ido-read-buffer "Switch: ")))
  (set-window-buffer (selected-window) buffer))

(global-set-key (kbd "C-x b") 'my/switch-buffer)

;; can revert to previous windows with winner-undo
(winner-mode 1)

;; keybindings
(global-set-key (kbd "C-x j") 'winner-undo)
(global-set-key (kbd "C-x k") 'winner-redo)
(global-set-key (kbd "M-l l") 'recentf-open-files)
(global-set-key (kbd "M-u") '(lambda()(interactive)(my/resize-window -4 t)))
(global-set-key (kbd "M-i") '(lambda()(interactive)(my/resize-window 4 t)))

;; ada formatting
(setq-default ada-indent 4)
(setq-default ada-broken-indent 4)
(setq-default ada-indent-record-rel-type 4)
(setq-default ada-indent-renames 4)
(setq-default ada-use-indent 4)
(setq-default ada-when-indent 4)
(setq-default ada-with-indent 4)

;; my/functions
(defun my/resize-window (delta &optional horizontal)
  "Resize a window."
  (interactive)
  (let ((edge (if horizontal
                  (car (window-edges))
                (car (cdr (window-edges))))))
    (if (= edge 0)
        (enlarge-window delta horizontal)
      (shrink-window delta horizontal))))

(global-set-key (kbd "M-l f") 'find-name-dired)

;; faces
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "#121623" :foreground "#aaaaaa" :weight normal :height 120 :family "Monospace"))))
 '(fringe ((((class color) (background dark)) (:background "#121623"))))
 '(mode-line ((((class color) (min-colors 88)) (:background "#cccccc" :foreground "#000000"))))
 '(vertical-border ((nil (:foreground "#444444")))))

(global-set-key (kbd "M-o") #'bookmark-bmenu-list)

(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map (kbd "M-o") 'nil)))

(global-set-key (kbd "M-s g") #'rgrep)
