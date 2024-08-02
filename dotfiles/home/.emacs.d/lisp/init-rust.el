;;; init-rust.el --- Initialize Rust configurations.	-*- lexical-binding: t -*-


;; Rust
(use-package rust-mode
  :mode ("\\.rs\\'" . rustic-mode)
  :init (setq rust-format-on-save t
              rust-mode-treesitter-derive t)
  :config
  ;; HACK: `global-treesit-auto-mode' will override `rust-mode'.
  (define-derived-mode rustic-mode rust-mode "Rust"
    "Major mode for Rust code.

\\{rust-mode-map}")

  (when (xxx-treesit-available-p)
    (setq auto-mode-alist (delete '("\\.rs\\'" . rust-mode) auto-mode-alist))
    (setq auto-mode-alist (delete '("\\.rs\\'" . rust-ts-mode) auto-mode-alist))))


(use-package ron-mode
  :mode ("\\.ron" . ron-mode))

(provide 'init-rust)

;;; init-rust.el ends here
