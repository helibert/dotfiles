;===============================================================================
;; Filename: config.el
;; Description: config file for doom-emacs
;; Author: Helge Liebert
;; Created: Mon Apr 16 23:56:45 2018
;; Last-Updated: So Mär 15 18:07:03 2020
;===============================================================================

;================================ Basic settings ===============================

;; User
(setq user-full-name    "Helge Liebert"
      user-mail-address "helge.liebert@gmail.com")

;; Doom UI settings
(setq doom-font (font-spec :family "MesloLGS NF"))
;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-vibrant)
(setq doom-theme 'doom-snazzy)
;; (setq doom-theme 'doom-dracula)
;; (setq doom-theme 'doom-dark+)
;; (setq doom-theme 'rebecca)

;; Org
(setq org-directory (expand-file-name "~/Dropbox/Org/")
      org-projectile-file (expand-file-name "~/Dropbox/Org/projects.org"))

;; Display absolute line numbers
(setq display-line-numbers-type t)


;================================== Dictionary =================================

;; dictionaries
;; activate multiple dictionaries to avoid switching between German and English
(after! ispell
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "en_US,de_CH")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_US,de_CH"))

;; language tool location
(setq langtool-language-tool-jar
      "/snap/languagetool/13/usr/bin/languagetool-commandline.jar")


;===================================== Evil ====================================

;; Do not replace element in kill ring after pasting over
(setq-default evil-kill-on-visual-paste nil)

;; Delete things by moving them to trash
(setq delete-by-moving-to-trash t)

;; Recenter after search (used to be the default)
(advice-add #'doom-preserve-window-position-a :override
            (lambda (orig-fn &rest args)
              (apply orig-fn args)
              (doom-recenter-a)))

;; Fix search behavior bug
;; (setq evil-search-wrap nil)

;; Fix evil paragraph to behave like vim
;; Works for latex, not for org-mode
(after! evil
(defun forward-evil-paragraph (&optional count)
    "Move forward COUNT paragraphs.
Moves point COUNT paragraphs forward or (- COUNT) paragraphs backward
if COUNT is negative.  A paragraph is defined by
`start-of-paragraph-text' and `forward-paragraph' functions."
    (let ((paragraph-start "\f\\|[ \t]*$"))
    (evil-motion-loop (dir (or count 1))
        (cond
        ((> dir 0) (forward-paragraph))
        ((not (bobp)) (start-of-paragraph-text) (beginning-of-line)))))))


;================================= Key mappings ================================

;; These are old, set before doom moved to general.el.
;; Probably need fixing. Try without them?
(map!
 (:leader
   :desc "Comment"                      :nv ";"   #'evilnc-comment-operator
   (:prefix "f"
     :desc "Copy this file"             :n  "c"   #'doom/copy-this-file
   ;;   :desc "Move this file"             :n  "m"   #'doom/move-this-file
   ;;   :desc "Find file in project"       :n  "p"   #'counsel-projectile
   ;;   :desc "Treemacs"                   :n  "t"   #'+treemacs/toggle
     :desc "Find file jump"             :n  "j"   #'dired-jump
     :desc "Find file fzf"              :n  "z"   #'counsel-fzf
     :desc "Find file rg"               :n  "g"   #'counsel-rg)
   (:prefix "b"
     :desc "Other buffer"               :n  "TAB" #'+helge/alternate-buffer
     :desc "Kill buffer and window"     :n  "q"   #'kill-buffer-and-window)
   (:prefix "w"
     :desc "Maximize window"            :n  "m"   #'doom/window-maximize-buffer
     :desc "Other window"               :n  "w"   #'other-window
     :desc "Alternate window"           :n  "TAB" #'+helge/alternate-window)
   (:prefix "s"
     :desc "Search clear"               :n  "c"   #'evil-ex-nohighlight)
   (:prefix "t"
     ;; :desc "Toggle flyspell dictionary" :n  "d"   #'ispell-change-dictionary
     ;; :desc "Toggle truncate lines"      :n  "l"   #'toggle-truncate-lines
     :desc "Toggle visual lines"        :n  "l"   #'visual-line-mode
     :desc "Toggle line numbers"        :n  "L"   #'doom/toggle-line-numbers)
   (:prefix "i"
     ;; :desc "Org-projectile todo current project" :n  "t"   #'org-projectile-capture-for-current-project
     ;; :desc "Org-projectile todo any project"     :n  "i"   #'org-projectile-project-todo-completing-read
     :desc "Banner-comment"                      :n  "h"   #'banner-comment)
     ))


;================================= Dired/ranger ================================

;; Set ranger not to override dired
;; (after! ranger
;;   (setq ranger-override-dired nil))


;===================================== Ivy =====================================

(after! ivy
;;   ;; do not display ./ and ../ in counsel
;;   (setq ivy-extra-directories nil)
;;   add mapping for ivy-immediate-done (C-M-j)
  (map! (:map ivy-minibuffer-map
          ("<C-return>" #'ivy-immediate-done))))


;=================================== Company ===================================

;; company settings
;; set completion threshold (default 2)
;; (setq company-minimum-prefix-length 3)
;; global backends
(setq company-backends '(company-dabbrev
                         company-files
                         company-keywords
                         company-yasnippet))


;===================================== Org =====================================

;; lang/org
;; (after! org
;;   ;; fix xdg-open for org
;;   (setq org-file-apps
;;         `(("pdf" . default)
;;           ("\\.x?html?\\'" . default)
;;           (auto-mode . emacs)
;;           (directory . emacs)
;;           (t . ,(cond (IS-MAC "open -R \"%s\"")
;;                       (IS-LINUX "setsid -w xdg-open \"%s\""))))))

;; deft
(setq deft-extensions '("txt" "org"))
(setq deft-directory "~/Dropbox/Org/Notes")
(setq deft-recursive t)
;; (setq deft-use-filename-as-title t)


;; org export custom article using koma class scrartcl
;; fix proper
(after! ox-latex
  (setq org-latex-default-class "koma-article")
  (add-to-list 'org-latex-classes
               '("koma-article"
                 "\\documentclass[a4paper,oneside,
                                  headings=standardclasses,
                                  %headings=normal,
                                  %egregdoesnotlikesansseriftitles,
                                  parskip=full
                                  ]{scrartcl}
                    %\\usepackage{mathptmx}
                    %\\usepackage{charter}
                    %\\usepackage[garamond]{mathdesign}
                    \\usepackage[sfdefault,light]{roboto}
                    %\\renewcommand{\\familydefault}{\\sfdefault}
                    \\usepackage[T1]{fontenc}
                    \\usepackage[nswissgerman,english]{babel}"
                 ;; \\usepackage{PTSans}
                 ;; \usepackage[charter]{mathdesign}
                 ;; \\usepackage[garamond]{mathdesign}
                 ;; \\usepackage[full]{textcomp}
                 ;; \\usepackage{garamondx}
                 ;; \\usepackage[varqu,varl,var0,scaled=0.97]{inconsolata}
                 ;; \\usepackage{FiraSans}
                 ;; \\usepackage{newpxtext}
                 ;; \\usepackage{newpxmath}
                 ;; \\usepackage{roboto}
                 ;; \\usepackage{charter}
                 ;; \\renewcommand\sfdefault{\rmdefault}
                 ;; \\usepackage{cmbright}
                 ;; \\usepackage[sfdefault]{roboto}
                 ;; \\usepackage{mathptmx}
                 ;; \\usepackage{lmodern}
                 ;; \\usepackage[defaultsans]{droidsans}
                 ;; \\usepackage{titlesec}
                 ;; \\titleformat*{\section}{\large\bfseries}
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))


;==================================== Latex ====================================

;; pdf viewer (if pdf enabled, pdf-tools is used otherwise)
(setq +latex-viewers '(Evince))

(after! latex
  ;; turn of auto-fill-mode (better way?)
  (add-hook 'latex-mode-hook 'turn-off-auto-fill)
  ;; works better with minted environments
  (setq TeX-parse-self t)
  (add-to-list 'LaTeX-verbatim-environments "minted")
  (add-to-list 'LaTeX-verbatim-environments "Verbatim")
  ;; xetex
  (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' --shell-escape %t" TeX-run-TeX nil t))

  ;; Lifted from spacemacs
  (map!
   (:map (TeX-mode-map LaTeX-mode-map)
     (:localleader
       :desc "TeX-command-master"         :n "," #'TeX-command-master          ;; C-c C-c
       :desc "TeX-command-run-all"        :n "a" #'TeX-command-run-all         ;; C-c C-a
       :desc "TeX-view"                   :n "v" #'TeX-view                    ;; C-c C-v
       :desc "TeX-clean"                  :n "d" #'TeX-clean
       :desc "TeX-kill-job"               :n "k" #'TeX-kill-job                ;; C-c C-k
       :desc "TeX-recenter-output-buffer" :n "l" #'TeX-recenter-output-buffer  ;; C-c C-l
       :desc "TeX-insert-macro"           :n "m" #'TeX-insert-macro            ;; C-c C-m
       :desc "LaTeX-fill-paragraph"       :n "fp" #'LaTeX-fill-paragraph       ;; C-c C-q C-p
       :desc "LaTeX-fill-region"          :n "fr" #'LaTeX-fill-region          ;; C-c C-q C-r
       ;; :desc "TeX-comment-or-uncomment-paragraph"  :n "%" #'TeX-comment-or-uncomment-paragraph   ;; C-c %
       ;; :desc "TeX-comment-or-uncomment-region"     :n ";" #'TeX-comment-or-uncomment-region      ;; C-c ; or C-c :
       ))))

(after! bibtex
  ;; bibliography
  ;; (setq reftex-default-bibliography "~/Zotero/bib.bib")
  ;; Optionally specifying a location for the corresponding PDFs
  ;; (setq bibtex-completion-library-path (list "/your/bib/pdfs"))
  ;; dialect, bibtex vs biblatex
  (setq bibtex-dialect 'BibTeX))

(after! LaTeX-mode
  (set-company-backend!
    'latex-mode
    'company-auctex
    'company-reftex
    'company-capf
    'company-lsp
    'company-files
    'company-dabbrev
    'company-keywords
    'company-yasnippet))


;===================================== ESS =====================================

(after! ess-mode
  ;; Style convention to RStudio
  (ess-set-style 'RStudio)
  ;; Disable asking for saving the history on exit and do not restore it
  (setq inferior-R-args "--no-restore-history --no-save " ))

;; (after! ess-mode
;;   (set-company-backend! 'ess-mode
;;     'company-capf
;;     'company-lsp
;;     'company-files
;;     'company-dabbrev
;;     'company-keywords
;;     'company-yasnippet))

(after! ess-mode
  (setq ess-use-company nil)
  (defun my-ess-config ()
    (make-variable-buffer-local 'company-backends)
    (add-to-list 'company-backends
                 '(company-R-args
                   company-R-objects
                   company-R-library
                   company-lsp
                   company-capf
                   company-dabbrev-code
                   company-files
                   company-dabbrev
                   company-keywords
                   company-yasnippet
                   :separate)))
(add-hook 'ess-mode-hook #'my-ess-config))

;; Upstream this is only ess-eval-line - PR this at some point
(map! :after ess
      :map ess-mode-map
      ;; :map ess-r-mode-map
      :n [C-return] #'ess-eval-region-or-line-visibly-and-step)

;; lintr
(after! flycheck
(customize-set-variable 'flycheck-lintr-linters
                        "with_defaults(commented_code_linter = NULL,
                                       snake_case_linter     = NULL,
                                       object_name_linter    = dotted.case,
                                       line_length_linter    = NULL)"))


;==================================== Stata ====================================

;; Messy, ado-mode on Windows, ado-mode + own functions and shell scripts on Linux
;; Switch to own functions in ESS on Linux?

(after! ado-mode
  (set-company-backend! 'ado-mode
    'company-files
    'company-capf
    'company-dabbrev
    'company-keywords
    'company-yasnippet))

;; ado-mode for Stata
(require 'ado-mode)
(setq ado-submit-default "dofile")
;; send line to stata and move to next
(defun ado-send-line-to-stata (&optional whole-buffer)
  (interactive)
  (ado-command-to-clip ado-submit-default whole-buffer)
  (ado-send-clip-to-stata ado-submit-default ado-comeback-flag)
  (forward-line 1))
;; (define-key ado-mode-map [(control return)] 'ado-send-line-to-stata)
;; (define-key ado-mode-map [(meta control return)] 'ado-send-buffer-to-stata)
;; (define-key ado-mode-map [(control return)] 'stata-rundolines)
;; (define-key ado-mode-map [(meta control return)] 'stata-rundo)
;; (map! (:map ado-mode-map
;;         ("<C-return>"   #'stata-rundolines
;;          "<C-M-return>" #'stata-rundo)))
(map! :after ado-mode
      :map ado-mode-map
      :n [C-return]   #'stata-rundolines
      :n [C-M-return] #'stata-rundo)

;; get rid of this annoying pop up buffer when sending to stata
(add-to-list 'display-buffer-alist
  (cons "\\*Async Shell Command\\*.*" (cons #'display-buffer-no-window nil)))

(defun stata-rundo ()
  "Wrapper of ~/dotfiles/rundo.sh."
  (interactive)
  (save-buffer)
  (start-process-shell-command "rundo" nil (format "~/dotfiles/rundo.sh %s" buffer-file-name)))

(defun stata-rundolines (beg end)
  "Wrapper of ~/dotfiles/rundo.sh."
  (interactive
   ;; 1. If the region is highlighted
   (if (use-region-p)
       ;; the region
       (list (region-beginning) (region-end))
     ;; the line
     (list (line-beginning-position) (line-end-position))))
  ;; 2. move cursor
  (deactivate-mark)
  (goto-char end)
  (backward-char)
  (beginning-of-line)
  (next-logical-line)
  ;; 3. create a temp file
  (let ((tempfile (make-temp-file nil nil ".do")))
    ;; 4. save text to the file
    (write-region beg end tempfile)
    (write-region "\n" nil tempfile t)
    ;; 5. run the command asynchronously
    ;; (remove '&' to run it synchronously, i.e., blocking Emacs)
    ;; (shell-command (format "~/dotfiles/rundo.sh %s &" tempfile))))
    (start-process-shell-command "rundo" nil (format "~/dotfiles/rundo.sh %s" tempfile))))


;================================== Header.el ==================================

;; not working properly, delete?
;; load header.el (alternative: configure simple auto-insert)
;; not on melpa, just use source file
(load! "+header")
(setq header-date-format "%a %b %e %T %Y")
(setq header-file-name 'buffer-file-name)
(setq make-header-hook
      '(header-end-line
        header-file-name
        header-description
        header-author
        header-creation-date
        header-modification-date
        header-end-line))
(autoload 'auto-update-file-header "+header/header2")
(add-hook! 'before-save-hook 'auto-update-file-header)
(add-hook! 'ess-mode-hook 'auto-make-header)


;=================================== Flycheck ==================================

;; ;; region ignore markers
;; ;; https://emacs.stackexchange.com/questions/48587/have-flycheck-skip-certain-regions

;; (defun noflycheck--region-regexp (&optional symbol value)
;;   "Set `noflycheck--region-regexp' from customization of `noflycheck-region-regexps'."
;;   (when (prog1
;;         (or symbol value)
;;       (unless symbol (setq symbol 'noflycheck-region-regexps))
;;       (unless value (setq value (default-value 'noflycheck-region-regexps))))
;;     (set-default symbol value))
;;   (setq noflycheck--region-regexp
;;     (concat "\\(?:\\(" (car value) "\\)\\|" (cadr value) "\\)")
;;     noflycheck--where (cddr value)))

;; (defcustom noflycheck-region-regexps '("\\[BEGIN_FLYCHECK_IGNORE\\]" "\\[END_FLYCHECK_IGNORE\\]" comment)
;;   "Cons of markers to mark the beginning and the end of a noflycheck region.
;; The two regexps may not match the same string."
;;   :type '(cons :tag ""
;;            (regexp :tag "Begin marker")
;;            (cons :tag ""
;;              (regexp :tag "End marker")
;;              (set
;;               (const nostring :tag "Don't match in strings.")
;;               (choice (const comment :tag "Only match in comments.")
;;                   (const code :tag "Only match in code.")))))
;;   :set #'noflycheck--region-regexp
;;   :group 'flycheck)

;; (defvar noflycheck--region-regexp nil
;;   "Regular expression for matching beginning and end of noflycheck regions.
;; The regular expression is generated from `noflycheck-region-regexps'
;; by function `noflycheck--region-regexp'.
;; If the regular expression matches the beginning of a noflycheck region
;; it is captured in group 1.
;; If it matches the end of a noflycheck region group 1 does not match,
;; i.e., (match-beginning 1) gives nil.")

;; (defvar noflycheck--where nil
;;   "Set by function `noflycheck--region-regexp'.
;; Possible members:
;; comment Match beginning and end of noflycheck regions only in comments.
;; code")

;; (noflycheck--region-regexp)

;; (defsubst noflycheck-in-comment-p ()
;;   "Non-nil if point is in comment."
;;   (nth 4 (syntax-ppss)))

;; (defsubst noflycheck-in-string-p ()
;;   "Non-nil if point is in comment."
;;   (nth 3 (syntax-ppss)))

;; (defun noflycheck-re-search-backward (&rest args)
;;   "Do `re-search-forward' but consider `noflycheck--where'."
;;   (let (found)
;;     (while (and
;;         (setq found (apply #'re-search-backward args))
;;         (cond
;;          ((memq 'comment noflycheck--where)
;;           (null (noflycheck-in-comment-p)))
;;          ((memq 'nostring noflycheck--where)
;;           (or (noflycheck-in-string-p) ;; strings only occur in code
;;           (and (memq 'code noflycheck--where)
;;                (noflycheck-in-comment-p))))
;;          (memq 'code noflycheck--where)
;;                (noflycheck-in-comment-p))))
;;     found))

;; (defun noflycheck-region (err)
;;   "Ignore flycheck if ERR is in region marked with regexps from `noflycheck-regions'."
;;   (save-excursion
;;     (goto-char (car (flycheck-error-line-region err)))
;;     (and (noflycheck-re-search-backward noflycheck--region-regexp nil 'noError)
;;      (match-beginning 1))))

;; (defvar noflycheck-process-error-functions nil
;;   "Like `flycheck-process-error-functions'.
;; But should only include the filters and not the actual action.")

;; (defun noflycheck-hook-fun ()
;;   "Add the noflycheck markers to ."
;;   (require 'flycheck)
;;   (add-hook 'noflycheck-process-error-functions #'noflycheck-region)
;;   (add-hook 'flycheck-process-error-functions
;;         (lambda (err)
;;           (run-hook-with-args-until-success 'noflycheck-process-error-functions err))
;;         nil t))

;; (defvar flycheck-error-list-source-buffer)

;; (defun noflycheck-error-list-filter (errors)
;;   "Only let through ERRORS accepted by `error-list-process-error-functions'.
;; Works as :filter-args advice if FILTER-ARGS is non-nil."
;;   (cl-loop for err in errors
;;        unless
;;        (let ((buf (flycheck-error-buffer err)))
;;          (when (buffer-live-p buf)
;;            (with-current-buffer buf
;;          (run-hook-with-args-until-success 'noflycheck-process-error-functions err))))
;;        collect err))

;; (advice-add 'flycheck-filter-errors :filter-return #'noflycheck-error-list-filter)

;; (add-hook 'LaTeX-mode-hook #'noflycheck-hook-fun)
