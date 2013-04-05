;;; andersl-cmake-font-lock-test-facit.el -- Regression test CMake font-lock.

;; Copyright (C) 2012-2013 Anders Lindgren

;; Author: Anders Lindgren
;; Keywords: faces languages

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Regression test of `andersl-cmake-font-lock', a package providing
;; font-lock rules for CMake. This module verifies fontification of a
;; number of CMakeLists.txt files taken from real projects. This is
;; done by keeing a text representation of the fontification using
;; `faceup' markup, in addition to the original CMakeLists.txt file.
;;
;; The actual check is performed using `ert', with font-lock test
;; function provided by `faceup'.

;;; Code:

(defvar andersl-cmake-font-lock-test-facit-file-name load-file-name
  "The file name of this file.")

(defun andersl-cmake-font-lock-test-facit-file-name ()
  "The filename of this source file."
  (or andersl-cmake-font-lock-test-facit-file-name
      (symbol-file 'andersl-cmake-font-lock-test-facit-file-name)))

(defun andersl-cmake-font-lock-test-facit (dir)
  "Test that `dir'/CMakeLists.txt is fontifies as the .faceup file describes.

`dir' is interpreted as relative to this source directory."
  (faceup-test-font-lock-file 'cmake-mode
                              (concat
                               (file-name-directory
                                (andersl-cmake-font-lock-test-facit-file-name))
                               dir
                               "/CMakeLists.txt")))

(faceup-defexplainer andersl-cmake-font-lock-test-facit)


(ert-deftest andersl-cmake-font-lock-file-test ()
  (require 'faceup)
  (should (andersl-cmake-font-lock-test-facit "facit/grantlee"))
  (should (andersl-cmake-font-lock-test-facit "facit/libarchive"))
  (should (andersl-cmake-font-lock-test-facit "facit/opencollada"))
  (should (andersl-cmake-font-lock-test-facit "facit/gamekit"))
  (should (andersl-cmake-font-lock-test-facit "facit/gazebo"))
  (should (andersl-cmake-font-lock-test-facit "facit/scrapbook"))
  (should (andersl-cmake-font-lock-test-facit "facit/openscenegraph")))

;; cmake-font-lock-test-facit.el ends here.
