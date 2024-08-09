;;; init-custom.el --- custom -*- lexical-binding: t -*-
;;; Code:
(eval-when-compile
  (require 'package))

(defgroup xxx nil
  "emacs config"
  :group 'convenience
  :link '(url-link :tag "Homepage" "https://github.com/yxing-dev/.emacs.d"))

(defcustom xxx-proxy "127.0.0.1:1087"
  "Set HTTP/HTTPS proxy."
  :group 'xxx
  :type 'string)

(defcustom xxx-socks-proxy "127.0.0.1:1086"
  "Set SOCKS proxy."
  :group 'xxx
  :type 'string)

(defcustom xxx-server t
  "Enable `server-mode' or not."
  :group 'xxx
  :type 'boolean)

(defcustom xxx-package-archives-alist
  (let ((proto (if (gnutls-available-p) "https" "http")))
    `((melpa    . (("gnu"    . ,(format "%s://elpa.gnu.org/packages/" proto))
                   ("nongnu" . ,(format "%s://elpa.nongnu.org/nongnu/" proto))
                   ("melpa"  . ,(format "%s://melpa.org/packages/" proto))))
      (emacs-cn . (("gnu"    . ,(format "%s://1.15.88.122/gnu" proto))
                   ("nongnu" . ,(format "%s://1.15.88.122/nongnu" proto))
                   ("melpa"  . ,(format "%s://1.15.88.122/melpa" proto))))
      (bfsu     . (("gnu"    . ,(format "%s://mirrors.bfsu.edu.cn/elpa/gnu/" proto))
                   ("nongnu" . ,(format "%s://mirrors.bfsu.edu.cn/elpa/nongnu/" proto))
                   ("melpa"  . ,(format "%s://mirrors.bfsu.edu.cn/elpa/melpa/" proto))))
      (netease  . (("gnu"    . ,(format "%s://mirrors.163.com/elpa/gnu/" proto))
                   ("nongnu" . ,(format "%s://mirrors.163.com/elpa/nongnu/" proto))
                   ("melpa"  . ,(format "%s://mirrors.163.com/elpa/melpa/" proto))))
      (sjtu     . (("gnu"    . ,(format "%s://mirrors.sjtug.sjtu.edu.cn/emacs-elpa/gnu/" proto))
                   ("nongnu" . ,(format "%s://mirrors.sjtug.sjtu.edu.cn/emacs-elpa/nongnu/" proto))
                   ("melpa"  . ,(format "%s://mirrors.sjtug.sjtu.edu.cn/emacs-elpa/melpa/" proto))))
      (tuna     . (("gnu"    . ,(format "%s://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/" proto))
                   ("nongnu" . ,(format "%s://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/" proto))
                   ("melpa"  . ,(format "%s://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/" proto))))
      (nju     .  (("gnu"    . ,(format "%s://mirrors.nju.edu.cn/elpa/gnu/" proto))
                   ("nongnu" . ,(format "%s://mirrors.nju.edu.cn/elpa/nongnu/" proto))
                   ("melpa"  . ,(format "%s://mirrors.nju.edu.cn/elpa/melpa/" proto))))
      (ustc     . (("gnu"    . ,(format "%s://mirrors.ustc.edu.cn/elpa/gnu/" proto))
                   ("nongnu" . ,(format "%s://mirrors.ustc.edu.cn/elpa/nongnu/" proto))
                   ("melpa"  . ,(format "%s://mirrors.ustc.edu.cn/elpa/melpa/" proto))))))
  "A list of the package archives."
  :group 'xxx
  :type '(alist :key-type (symbol :tag "Archive group name")
                :value-type (alist :key-type (string :tag "Archive name")
                                   :value-type (string :tag "URL or directory name"))))

(defcustom xxx-package-archives 'melpa
  "Set package archives from which to fetch."
  :group 'xxx
  :set (lambda (symbol value)
         (set symbol value)
         (setq package-archives
               (or (alist-get value xxx-package-archives-alist)
                   (error "Unknown package archives: `%s'" value))))
  :type `(choice ,@(mapcar
                    (lambda (item)
                      (let ((name (car item)))
                        (list 'const
                              :tag (capitalize (symbol-name name))
                              name)))
                    xxx-package-archives-alist)))

(defcustom xxx-doom-theme 'doom-one
  "The color theme."
  :group 'xxx
  :type  'symbol)


(defcustom xxx-prettify-symbols-alist
  '(("lambda" . ?λ)
    ("<-"     . ?←)
    ("->"     . ?→)
    ("->>"    . ?↠)
    ("=>"     . ?⇒)
    ("map"    . ?↦)
    ("/="     . ?≠)
    ("!="     . ?≠)
    ("=="     . ?≡)
    ("<="     . ?≤)
    (">="     . ?≥)
    ("=<<"    . (?= (Br . Bl) ?≪))
    (">>="    . (?≫ (Br . Bl) ?=))
    ("<=<"    . ?↢)
    (">=>"    . ?↣)
    ("&&"     . ?∧)
    ("||"     . ?∨)
    ("not"    . ?¬))
  "A list of symbol prettifications.
Nil to use font supports ligatures."
  :group 'xxx
  :type '(alist :key-type string :value-type (choice character sexp)))


(defcustom xxx-lsp-format-on-save nil
  "Auto format buffers on save."
  :group 'xxx
  :type 'boolean)

(defcustom xxx-lsp-format-on-save-ignore-modes
  '(c-mode c++-mode python-mode markdown-mode)
  "The modes that don't auto format and organize imports while saving the buffers.
`prog-mode' means ignoring all derived modes."
  :group 'xxx
  :type '(repeat (symbol :tag "Major-Mode")))

(defcustom xxx-lsp 'eglot
  "Set language server.

`lsp-mode': See https://github.com/emacs-lsp/lsp-mode.
`eglot': See https://github.com/joaotavora/eglot.
tags: Use tags file instead of language server. See https://github.com/universal-ctags/citre.
nil means disabled."
  :group 'xxx
  :type '(choice (const :tag "LSP Mode" lsp-mode)
                 (const :tag "Eglot" eglot)
                 (const :tag "Disable" nil)))


(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(provide 'init-custom)
