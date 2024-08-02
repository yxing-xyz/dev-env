;; init-utils.el --- init-utils.el -*- lexical-binding: t -*-
;;; Code:

;; Display available keybindings in popup

(use-package which-key
  :diminish
  :bind ("C-h M-m" . which-key-show-major-mode)
  :hook (after-init . which-key-mode)
  :init (setq which-key-max-description-length 30
              which-key-lighter nil
              which-key-show-remaining-keys t)
  :config
  (which-key-add-key-based-replacements "C-c !" "flycheck")
  (which-key-add-key-based-replacements "C-c &" "yasnippet")
  (which-key-add-key-based-replacements "C-c @" "hideshow")
  (which-key-add-key-based-replacements "C-c c" "consult")
  (which-key-add-key-based-replacements "C-c d" "dict")
  (which-key-add-key-based-replacements "C-c l" "link-hint")
  (which-key-add-key-based-replacements "C-c n" "org-roam")
  (which-key-add-key-based-replacements "C-c p" "projectile")
  (which-key-add-key-based-replacements "C-c t" "hl-todo")
  (which-key-add-key-based-replacements "C-c C-z" "browse")

  (which-key-add-key-based-replacements "C-x 8" "unicode")
  (which-key-add-key-based-replacements "C-x 8 e" "emoji")
  (which-key-add-key-based-replacements "C-x @" "modifior")
  (which-key-add-key-based-replacements "C-x a" "abbrev")
  (which-key-add-key-based-replacements "C-x c" "colorful")
  (which-key-add-key-based-replacements "C-x n" "narrow")
  (which-key-add-key-based-replacements "C-x p" "")
  (which-key-add-key-based-replacements "C-x r" "rect & bookmark")
  (which-key-add-key-based-replacements "C-x t" "tab & treemacs")
  (which-key-add-key-based-replacements "C-x x" "buffer")
  (which-key-add-key-based-replacements "C-x C-a" "edebug")
  (which-key-add-key-based-replacements "C-x RET" "coding-system")
  (which-key-add-key-based-replacements "C-x X" "edebug")

  (which-key-add-major-mode-key-based-replacements 'org-mode
    "C-c \"" "org-plot")
  (which-key-add-major-mode-key-based-replacements 'org-mode
    "C-c C-v" "org-babel")
  (which-key-add-major-mode-key-based-replacements 'org-mode
    "C-c C-x" "org-misc")

  (which-key-add-major-mode-key-based-replacements 'emacs-lisp-mode
    "C-c ," "overseer")
  (which-key-add-major-mode-key-based-replacements 'python-mode
    "C-c C-t" "python-skeleton")

  (which-key-add-major-mode-key-based-replacements 'markdown-mode
    "C-c C-a" "markdown-link")
  (which-key-add-major-mode-key-based-replacements 'markdown-mode
    "C-c C-c" "markdown-command")
  (which-key-add-major-mode-key-based-replacements 'markdown-mode
    "C-c C-s" "markdown-style")
  (which-key-add-major-mode-key-based-replacements 'markdown-mode
    "C-c C-t" "markdown-header")
  (which-key-add-major-mode-key-based-replacements 'markdown-mode
    "C-c C-x" "markdown-toggle")

  (which-key-add-major-mode-key-based-replacements 'gfm-mode
    "C-c C-a" "markdown-link")
  (which-key-add-major-mode-key-based-replacements 'gfm-mode
    "C-c C-c" "markdown-command")
  (which-key-add-major-mode-key-based-replacements 'gfm-mode
    "C-c C-s" "markdown-style")
  (which-key-add-major-mode-key-based-replacements 'gfm-mode
    "C-c C-t" "markdown-header")
  (which-key-add-major-mode-key-based-replacements 'gfm-mode
    "C-c C-x" "markdown-toggle"))

;; Search tools
;; Writable `grep' buffer
(use-package wgrep
  :init
  (setq wgrep-auto-save-buffer t
        wgrep-change-readonly-file t))

;; Fast search tool `ripgrep'
(use-package rg
  :hook (after-init . rg-enable-default-bindings)
  :bind (:map rg-global-map
         ("c" . rg-dwim-current-dir)
         ("f" . rg-dwim-current-file)
         ("m" . rg-menu))
  :init (setq rg-group-result t
              rg-show-columns t)
  :config
  (cl-pushnew '("tmpl" . "*.tmpl") rg-custom-type-aliases))

(use-package pomidor
  :bind ("s-<f12>" . pomidor)
  :init
  (setq alert-default-style 'mode-line)

  (when sys/macp
    (setq pomidor-play-sound-file
          (lambda (file)
            (when (executable-find "afplay")
              (start-process "pomidor-play-sound" nil "afplay" file))))))
;; Nice writing
(use-package olivetti
  :diminish
  :bind ("<f7>" . olivetti-mode)
  :init (setq olivetti-body-width 0.62))


(use-package ztree
  :custom-face
  (ztreep-header-face ((t (:inherit diff-header :foreground unspecified))))
  (ztreep-arrow-face ((t (:inherit font-lock-comment-face :foreground unspecified))))
  (ztreep-leaf-face ((t (:inherit diff-index :foreground unspecified))))
  (ztreep-node-face ((t (:inherit font-lock-variable-name-face :foreground unspecified))))
  (ztreep-expand-sign-face ((t (:inherit font-lock-function-name-face))))
  (ztreep-diff-header-face ((t (:inherit (diff-header bold :foreground unspecified)))))
  (ztreep-diff-header-small-face ((t (:inherit diff-file-header :foreground unspecified))))
  (ztreep-diff-model-normal-face ((t (:inherit font-lock-doc-face :foreground unspecified))))
  (ztreep-diff-model-ignored-face ((t (:inherit font-lock-doc-face :strike-through t :foreground unspecified))))
  (ztreep-diff-model-diff-face ((t (:inherit diff-removed :foreground unspecified))))
  (ztreep-diff-model-add-face ((t (:inherit diff-nonexistent :foreground unspecified))))
  :pretty-hydra
  ((:title (pretty-hydra-title "Ztree" 'octicon "nf-oct-diff" :face 'nerd-icons-green)
    :color pink :quit-key ("q" "C-g"))
   ("Diff"
    (("C" ztree-diff-copy "copy" :exit t)
     ("h" ztree-diff-toggle-show-equal-files "show/hide equals" :exit t)
     ("H" ztree-diff-toggle-show-filtered-files "show/hide ignores" :exit t)
     ("D" ztree-diff-delete-file "delete" :exit t)
     ("v" ztree-diff-view-file "view" :exit t)
     ("d" ztree-diff-simple-diff-files "simple diff" :exit t)
     ("r" ztree-diff-partial-rescan "partial rescan" :exit t)
     ("R" ztree-diff-full-rescan "full rescan" :exit t))
    "View"
    (("RET" ztree-perform-action "expand/collapse or view" :exit t)
     ("SPC" ztree-perform-soft-action "expand/collapse or view in other" :exit t)
     ("TAB" ztree-jump-side "jump side" :exit t)
     ("g" ztree-refresh-buffer "refresh" :exit t)
     ("x" ztree-toggle-expand-subtree "expand/collapse" :exit t)
     ("<backspace>" ztree-move-up-in-tree "go to parent" :exit t))))
  :bind (:map ztreediff-mode-map
         ("C-<f5>" . ztree-hydra/body))
  :init (setq ztree-draw-unicode-lines t
              ztree-show-number-of-children t))
;; misc
(use-package proced
  :ensure nil
  :init
  (setq-default proced-format 'verbose)
  (setq proced-auto-update-flag t
        proced-auto-update-interval 3))

(use-package disk-usage)
(use-package memory-usage)

(use-package list-environment)

(unless sys/win32p
  (use-package daemons)                 ; system services/daemons
  (use-package tldr))

(provide 'init-utils)
