;;;; Rholang Mode
;;;;
;;;; Syntax highlighting (and maybe indentation rules at some point) for
;;;; the Rholang language.
;;;;
;;;; NOTE:  "https://www.emacswiki.org/emacs/ModeTutorial" has proven to be
;;;; valuable in developing this mode!

(defvar rholang-mode-hook nil)

(defvar rholang-mode-map
  (let ((map (make-keymap)))
    (define-key map "\C-j" 'newline-and-indent)
    map)
  "Keymap for Rholang major mode")

(add-to-list 'auto-mode-alist '("\\.rho\\'" . rholang-mode))

(defconst rholang-font-lock-keywords-1
  (list
   `(,(regexp-opt '("contract" "for" "in" "match" "new" "select" "case") 'words) . font-lock-builtin-face)
   '("\\('\\w*\\)" . font-lock-variable-name-face))
  "Minimal highlighting expressions for Rholang mode")

(defconst rholang-font-lock-keywords-2
  (append rholang-font-lock-keywords-1
	  (list '("\\<\\(true\\|false\\|Nil\\)\\>" . font-lock-constant-face)))
  "Additional keywords to highlight in Rholang mode")

;;;; Colorize tokens and brackets

;; Arguably, I should define my own faces for operators and for brackets, but
;; trying to figure out how to best do than became warisome....


(defconst rholang-font-lock-keywords-3
  (append rholang-font-lock-keywords-2
	  (list
	   `(,(regexp-opt '("@" "|" "!" "<-" "<=" "=>" "=" "+" "-" "*" "/") t) . font-lock-keyword-face)
	   `(,(regexp-opt '("{" "[" "(" ")" "]" "}") t) . font-lock-comment-delimiter-face)))
  "Additional keywords to highlight operators and brackets in Rholang mode")


(defvar rholang-font-lock-keywords rholang-font-lock-keywords-3
  "Default highlighting expressions for Rholang mode")


;;;; TODO:  Indentation will need to be tackled at some point!


(defvar rholang-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?_ "w" st)    ; for Emacs to consider underscored_words as a single word

    ;; Enable comments -- going full C++ style is probably going overboard; to the best of
    ;; my knowledge, Rholang only uses // style comments...
    (modify-syntax-entry ?/  ". 124b" st) ; enable C++ style commenst // (1b) and /* (24)
    (modify-syntax-entry ?*  ". 23"   st) ; enable C++ style comments /* (23)
    (modify-syntax-entry ?\n "> b"    st) ; \n ends "b-style" commenst (for //)
    st)
  "Syntax table for Rholang mode")




;;;; Entry function to enable Rholang mode
(defun rholang-mode ()
  "Major mode for editing Rholang files"
  (interactive)
  (kill-all-local-variables)
  (set-syntax-table rholang-mode-syntax-table)
  (use-local-map rholang-mode-map)

  (set (make-local-variable 'font-lock-defaults) '(rholang-font-lock-keywords))

  ; (set (make-local-variable 'indent-line-function) 'rholang-line-function)

  (setq major-mode 'rholang-mode)
  (setq mode-name "Rholang")
  (run-hooks 'rholang-mode-hook))

(provide 'rholang-mode)

