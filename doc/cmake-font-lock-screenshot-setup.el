;; multicolumn-screenshot-setup.el --- prepare Emacs for screenshot.

(defvar cmake-font-lock-screenshot-setup-file-name
  (or load-file-name
      (buffer-file-name)))

(let ((dir (file-name-directory cmake-font-lock-screenshot-setup-file-name)))
  (load (concat dir "../andersl-cmake-font-lock.el"))
  (andersl-cmake-font-lock-set-signature "my_get_dirs" '(:var))
  ;; Note: Needs cmake-mode.
  (load (concat dir "../../../lisp/cmake-mode.el"))
  (find-file (concat dir "Example.cmake")))

(cmake-mode)
(andersl-cmake-font-lock-activate)

(set-frame-size (selected-frame) 80 30)

(goto-char (point-max))

(message "")

;; cmake-font-lock-screenshot-setup.el ends here
