Compile Haskell

> ghci hello.hs
GHCi, version 8.10.7: https://www.haskell.org/ghc/  :? for help
[1 of 1] Compiling Main             ( hello.hs, interpreted )
Ok, one module loaded.
> main
Hello, everybody!
Please look at my favorite odd numbers: [11,13,15,17,19]


Leave Haskell(ghci)

:quit or :q



Compile Lisp

sbcl --load hello.lisp


Leave Lisp(sbcl)

(quit) or (exit)

(asdf:initialize-source-registry'(:source-registry(:directory "C:/Users/Anwender/OneDrive/Oth Regensburg_TI/7.Semester/Meta_Programmierung/Projekt_M/"):inherit-configuration))





Install von sbcl

sudo apt install sbcl

Install lispbuilder sdl

sudo apt-get install libsdl1.2-dev

quick lisp installieren

curl -O https://beta.quicklisp.org/quicklisp.lisp
sbcl --load quicklisp.lisp

(ql:quickload "lispbuilder-sdl")

(ql:quickload :lispbuilder-sdl-examples)





cd /mnt/c/Users/Anwender/OneDrive/Oth\ Regensburg_TI/7.Semester/Meta_Programmierung/Projekt_M/lib
cd /mnt/c/Users/Anwender/OneDrive/Oth\ Regensburg_TI/7.Semester/Meta_Programmierung/Projekt_M/src

sbcl --load test-sdl.lisp
sbcl --load hud-openGL.lisp
sbcl --load hud.lisp

(load "hud.lisp")

neue Öffnung

sbcl
(load "C:/Users/Anwender/OneDrive/Oth Regensburg_TI/7.Semester/Meta_Programmierung/Projekt_M/quicklisp/setup.lisp")
(ql:add-to-init-file)
(ql:quickload "lispbuilder-sdl")
(ql:quickload "lispbuilder-sdl-ttf")
(pushnew #p"C:/Users/Anwender/OneDrive/Oth Regensburg_TI/7.Semester/Meta_Programmierung/Projekt_M/lib/usr/"
         cffi:*foreign-library-directories*
         :test #'equal)
(load "/mnt/c/Users/Anwender/OneDrive/Oth Regensburg_TI/7.Semester/Meta_Programmierung/Projekt_M/src/hud.lisp")

(load "/mnt/c/Users/Anwender/OneDrive/Oth Regensburg_TI/7.Semester/Meta_Programmierung/Projekt_M/src/item-container.lisp")

(load "/mnt/c/Users/Anwender/OneDrive/Oth Regensburg_TI/7.Semester/Meta_Programmierung/Projekt_M/src/drag-n-drop.lisp")

(load "/mnt/c/Users/Anwender/OneDrive/Oth Regensburg_TI/7.Semester/Meta_Programmierung/Projekt_M/src/main.lisp")

(load "/mnt/c/Users/Anwender/OneDrive/Oth Regensburg_TI/7.Semester/Meta_Programmierung/Projekt_M/src/test-sdl.lisp")