;;; andersl-cmake-font-lock-test-simple.el -- Tests for CMake font-lock rules.

;; Copyright (C) 2013 Anders Lindgren

;; Author: Anders Lindgren
;; Created: 2013-01-31
;; Date: 2013-01-31
;; Keywords: faces languages

;; This file is not part of GNU Emacs.

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

;; Regression tests for the package `andersl-cmake-font-lock'.
;;
;; The following tests use `faceup-test', where the intended
;; fontification is described in the the `faceup' markup language.

;;; Code:
(require 'andersl-cmake-font-lock)
(require 'faceup-test)

(defun andersl-cmake-font-lock-test (faceup)
  (faceup-test-font-lock-string 'cmake-mode faceup))

(defun andersl-cmake-font-lock-test-explain (file)
  (let ((faceup-test-explain t))
    (andersl-cmake-font-lock-test file)))

(put 'andersl-cmake-font-lock-test
     'ert-explainer
     'andersl-cmake-font-lock-test-explain)

(ert-deftest andersl-cmake-font-lock-primitives ()
  ;; --------------------
  ;; andersl-cmake-font-lock-minimun-number-of-arguments
  ;;
  (should (equal (andersl-cmake-font-lock-minimun-number-of-arguments
                  '())
                 0))
  (should (equal (andersl-cmake-font-lock-minimun-number-of-arguments
                  '(nil))
                 1))
  (should (equal (andersl-cmake-font-lock-minimun-number-of-arguments
                  '(nil nil))
                 2))
  (should (equal (andersl-cmake-font-lock-minimun-number-of-arguments
                  '(nil nil nil))
                 3))
  (should (equal (andersl-cmake-font-lock-minimun-number-of-arguments
                  '(:optional nil nil nil))
                 0))
  (should (equal (andersl-cmake-font-lock-minimun-number-of-arguments
                  '(nil :optional nil nil))
                 1))
  (should (equal (andersl-cmake-font-lock-minimun-number-of-arguments
                  '(nil nil :optional nil))
                 2))
  (should (equal (andersl-cmake-font-lock-minimun-number-of-arguments
                  '(:repeat nil))
                 0))
  (should (equal (andersl-cmake-font-lock-minimun-number-of-arguments
                  '(nil :repeat nil))
                 1))
  (should (equal (andersl-cmake-font-lock-minimun-number-of-arguments
                  '(nil :repeat nil nil))
                 2))
  (should (equal (andersl-cmake-font-lock-minimun-number-of-arguments
                  '(nil :repeat (nil nil)))
                 1))
  (should (equal (andersl-cmake-font-lock-minimun-number-of-arguments
                  '(nil :repeat (nil nil) nil))
                 2))
  ;; --------------------
  ;; Add keywords
  ;;
  (let ((andersl-cmake-font-lock-function-keywords-alist '()))
    ;; ----------
    ;; Add a new keyword to a new function.
    (andersl-cmake-font-lock-add-keywords "foo" '("BAR"))
    (should (equal andersl-cmake-font-lock-function-keywords-alist
                   '(("foo" . ("BAR")))))
    ;; ----------
    ;; Add an old keyword to an existing function.
    (andersl-cmake-font-lock-add-keywords "foo" '("BAR"))
    (should (equal andersl-cmake-font-lock-function-keywords-alist
                   '(("foo" . ("BAR")))))
    ;; ----------
    ;; Add an new keyword to an existing function.
    (andersl-cmake-font-lock-add-keywords "foo" '("BAZ"))
    (should (equal andersl-cmake-font-lock-function-keywords-alist
                   '(("foo" . ("BAZ" "BAR")))))
    ;; ----------
    ;; Add an old keyword to a function.
    (andersl-cmake-font-lock-add-keywords "TEST" '("ING"))
    (should (equal andersl-cmake-font-lock-function-keywords-alist
                   '(("test" . ("ING"))
                     ("foo" . ("BAZ" "BAR")))))
    )

  (let ((andersl-cmake-font-lock-function-signatures '()))
    (andersl-cmake-font-lock-set-signature "foo" '(:var))
    (should (equal andersl-cmake-font-lock-function-signatures
                   '(("foo" (:var) ()))))
    (andersl-cmake-font-lock-set-signature "foo" '(:prop))
    (should (equal andersl-cmake-font-lock-function-signatures
                   '(("foo" (:prop) ()))))
    (andersl-cmake-font-lock-set-signature "foo" '(:prop) '(("BAR")))
    (should (equal andersl-cmake-font-lock-function-signatures
                   '(("foo" (:prop) (("BAR" . ()))))))
    (andersl-cmake-font-lock-set-signature "foo" '(:prop) '(("BAR" :var)
                                                            ("BAZ" :prop)))
    (should (equal andersl-cmake-font-lock-function-signatures
                   '(("foo" (:prop) (("BAR" :var)
                                     ("BAZ" :prop))))))
    )
  )

(ert-deftest andersl-cmake-font-lock ()
  (should (andersl-cmake-font-lock-test
           "«f:mark_as_advanced»(«v:allan» «v:sune»)"))
  (should (andersl-cmake-font-lock-test
           "«f:mark_as_advanced»(«t:FORCE» «v:allan» «v:sune»)"))
  (should (andersl-cmake-font-lock-test
           "«f:mark_as_advanced»(«t:CLEAR» «v:allan» «v:sune»)"))
  (should (andersl-cmake-font-lock-test
           "«f:mark_as_advanced»(«v:sune» «t:CLEAR» «v:allan» «v:sune»)"))
  ;; --------------------
  ;; get_directory_property -- keywords in the middle of argument list.
  (should (andersl-cmake-font-lock-test
           "«f:get_directory_property»(«v:var» «c:prop»)"))
  (should (andersl-cmake-font-lock-test
           "«f:get_directory_property»(«v:var» «t:DIRECTORY» dir «c:prop»)"))
  (should (andersl-cmake-font-lock-test
           "«f:get_directory_property»(«v:var» «t:DEFINITION» «v:var»)"))
  (should (andersl-cmake-font-lock-test
           (concat "«f:get_directory_property»("
                   "«v:var» «t:DIRECTORY» dir «t:DEFINITION» «v:var»)")))
  ;; --------------------
  ;; set_directory_properties -- repeat with more than one parameter.
  (should (andersl-cmake-font-lock-test
           (concat "«f:set_directory_properties»("
                   "«t:PROPERTIES» «c:prop» value)")))
  (should (andersl-cmake-font-lock-test
           (concat "«f:set_directory_properties»("
                   "«t:PROPERTIES» «c:prop» value «c:prop» value)")))
  (should (andersl-cmake-font-lock-test
           (concat "«f:set_directory_properties»("
                   "«t:PROPERTIES» «c:prop» value «c:prop» "
                   "value «c:prop» value)")))


  ;; --------------------
  ;; ${...} constructs
  ;;
  (should (andersl-cmake-font-lock-test
           "«f:foo»(«D:${»«v:var»«D:}»)"))
  (should (andersl-cmake-font-lock-test
           "«f:foo»(«D:${${»«v:var»«D:}}»)"))
  (should (andersl-cmake-font-lock-test
           "«f:foo»(«D:${»«v:prefix»«D:${»«v:var»«D:}}»)"))
  (should (andersl-cmake-font-lock-test
           "«f:foo»(«D:${»«v:prefix»«D:${»«v:var»«D:}»«v:suffix»«D:}»)"))

  ;; Verify that arguments with type is fontified even though parts of
  ;; it contain a ${...} construct.
  (should (andersl-cmake-font-lock-test
           "«f:set»(«D:${»«v:var»«D:}»«v:_tail» x)"))
  ;; Identifiers may not contain a "."
  (should (andersl-cmake-font-lock-test
           "«f:set»(«D:${»«v:var»«D:}».tail x)"))
  (should (andersl-cmake-font-lock-test
           "«f:set»(«D:${»«v:prefix»«D:${»«v:var»«D:}»«v:suffix»«D:}»«v:_tail» x)"))

  ;; --------------------
  ;; Malformed identifiers
  ;;

  (should (andersl-cmake-font-lock-test
           "«f:set»(«v:var» 1"))
  (should (andersl-cmake-font-lock-test
           "«f:set»(1 1"))
  (should (andersl-cmake-font-lock-test
           "«f:set»(«D:${»«v:var»«D:}» 1"))
  (should (andersl-cmake-font-lock-test
           "«f:set»(«D:${»«v:var»«D:}»«v:_suffix» 1"))
  (should (andersl-cmake-font-lock-test
           "«f:set»(«D:${»«v:var»«D:}».suffix 1"))

  ;; --------------------
  ;; Repeat
  (should (andersl-cmake-font-lock-test
           "«f:string»(«t:ASCII» 1 2 3 4 5 «v:allan»"))

  (let ((andersl-cmake-font-lock-function-keywords-alist
         (cons '("test" . ("ALPHA"))
               andersl-cmake-font-lock-function-keywords-alist)))
    (should (andersl-cmake-font-lock-test "«f:test»(«t:ALPHA»)"))
    (let ((andersl-cmake-font-lock-function-signatures
           (cons '("test" (:var))
                 andersl-cmake-font-lock-function-signatures)))
      (should (andersl-cmake-font-lock-test "«f:test»(«v:ALPHA»)")))
    (let ((andersl-cmake-font-lock-function-signatures
           (cons '("test" (:var :repeat :prop))
                 andersl-cmake-font-lock-function-signatures)))
      (should (andersl-cmake-font-lock-test "«f:test»(«v:ALPHA»)"))
      (should (andersl-cmake-font-lock-test "«f:test»(«v:ALPHA» «t:ALPHA»)"))
      (should (andersl-cmake-font-lock-test
               "«f:test»(«v:ALPHA» «c:one»)"))
      (should (andersl-cmake-font-lock-test
               "«f:test»(«v:ALPHA» «c:one» «c:two» «c:three»)"))
    (let ((andersl-cmake-font-lock-function-signatures
           (cons '("test" (:var) (("ALPHA" :repeat :prop :var)))
                 andersl-cmake-font-lock-function-signatures)))
      (should (andersl-cmake-font-lock-test
               "«f:test»(«v:ALPHA» «t:ALPHA» «c:one» «c:two» «v:three»)"))))
    (let ((andersl-cmake-font-lock-function-signatures
           (cons '("test" (:var) (("ALPHA" :repeat (:prop nil) :var)))
                 andersl-cmake-font-lock-function-signatures)))
      (should (andersl-cmake-font-lock-test
               "«f:test»(«v:ALPHA» «t:ALPHA» «c:one» two «v:three»)"))
      (should
       (andersl-cmake-font-lock-test
        "«f:test»(«v:ALPHA» «t:ALPHA» «c:one» two «c:three» «v:four»)")))

    ;; --------------------
    ;; Test optional.
    (let ((andersl-cmake-font-lock-function-signatures
           (cons '("test" (:var :optional :var :var)
                   (("ALPHA" :prop)))
                 andersl-cmake-font-lock-function-signatures)))
      (should (andersl-cmake-font-lock-test
               "«f:test»(«v:var»)"))
      (should (andersl-cmake-font-lock-test
               "«f:test»(«v:var» «v:var»)"))
      (should (andersl-cmake-font-lock-test
               "«f:test»(«v:var» «v:var» «v:var»)"))
      (should (andersl-cmake-font-lock-test
               "«f:test»(«v:var» «v:var» «v:var» var)"))
      ;; Keyword in var location.
      (should (andersl-cmake-font-lock-test
               "«f:test»(«v:ALPHA» «v:var» «v:var» var)"))
      ;; Keyword in optional location
      (should (andersl-cmake-font-lock-test
               "«f:test»(«v:var» «t:ALPHA» «c:prop»)"))
      (should (andersl-cmake-font-lock-test
               "«f:test»(«v:var» «v:var» «t:ALPHA» «c:prop»)"))
      (should (andersl-cmake-font-lock-test
               "«f:test»(«v:var» «v:var» «v:var» «t:ALPHA» «c:prop»)"))
      (should (andersl-cmake-font-lock-test
               "«f:test»(«v:var» «v:var» «v:var» other «t:ALPHA» «c:prop»)"))))

  ;; --------------------
  ;; Keyword case
  (should (andersl-cmake-font-lock-test
           "«f:string»(tolower one two)"))
  (should (andersl-cmake-font-lock-test
           "«f:string»(«t:TOLOWER» one «v:two»)"))

  ;; --------------------
  ;; Out of place keywords.
  ;;
  ;; Note: The last parameter should not be there (SUBSTRING takes
  ;; exactly four parameters). However, this package has (currently)
  ;; no way of saying that there should be no more keywords, so it
  ;; fontifies the last argument as a new keyword.
  (should (andersl-cmake-font-lock-test
           "«f:string»(«t:SUBSTRING» MATCH MATCH MATCH «v:MATCH» «t:MATCH»")))

(ert-deftest andersl-cmake-font-lock-bugs ()
  :expected-result :failed
  ;; Need to tell the parser that keywords are only allowed at the start.
  (should (andersl-cmake-font-lock-test
           "«f:message»(«t:STATUS» STATUS STATUS STATUS)"))
  )


;;; andersl-cmake-font-lock-test-simple.el ends here
