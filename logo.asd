(asdf:defsystem #:logo
  :description "Describe logo here"
  :author "Stefano Rodighiero <stefano.rodighiero@gmail.com>"
  :license "Artistic"
  :serial t
  :depends-on (:lispbuilder-sdl)
  :components ((:file "package")
               (:file "logo")))

