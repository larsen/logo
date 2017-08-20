(in-package #:logo)

(defparameter *window-width* 600)
(defparameter *window-height* 600)
(defparameter *window* nil)

(defparameter *canvas-width* 100)
(defparameter *canvas-height* 100)

(defun x-to-screen-coord (x)
  (* (/ *window-width* *canvas-width*)
     (+ x (/ *canvas-width* 2))))

(defun y-to-screen-coord (y)
  (* (/ *window-height* *canvas-height*)
     (+ y (/ *canvas-height* 2))))
             
(defparameter *position-x* 0)
(defparameter *position-y* 0)
(defparameter *direction*  0)
(defparameter *up/down*    t)

(defun reset-turtle ()
  (progn (setq *position-x* 0)
         (setq *position-y* 0)
         (setq *direction* 0)
         (setq *up/down* t)))

(defun left (angle)
  (setq *direction* (mod (- *direction* angle) 360)))

(defun right (angle)
  (setq *direction* (mod (+ *direction* angle) 360)))

(defun up ()
  (setq *up/down* nil))

(defun down ()
  (setq *up/down* t))

(defun logo-point (x y)
  (draw-pixel (sdl:point :x (x-to-screen-coord x)
                         :y (y-to-screen-coord y))
              :color *white*))

(defun deg->rad (d)
  (* d (/ pi 180)))

(defun move-turtle (l d)
  (let* ((actual-direction (deg->rad (- d 90)))
         (new-pos-x (+ *position-x* (* (cos actual-direction) l)))
         (new-pos-y (+ *position-y* (* (sin actual-direction) l))))
    (progn
      (draw-line (sdl:point :x (x-to-screen-coord *position-x*)
                            :y (y-to-screen-coord *position-y*))
                 (sdl:point :x (x-to-screen-coord new-pos-x)
                            :y (y-to-screen-coord new-pos-y)))
      (setq *position-x* new-pos-x)
      (setq *position-y* new-pos-y))
    (list new-pos-x new-pos-y)))

(defun forward (l)
  (move-turtle l *direction*))

(defun draw-turtle (x y dir)
  (let ((turtle-size 5)
        (pos-x (x-to-screen-coord x))
        (pos-y (y-to-screen-coord y)))
    (draw-trigon (sdl:point :x pos-x
                            :y (- pos-y turtle-size))
                 (sdl:point :x (+ pos-x turtle-size)
                            :y (+ pos-y turtle-size))
                 (sdl:point :x (- pos-x turtle-size)
                            :y (+ pos-y turtle-size)))))

(defun square (l)
  (loop repeat 4
     do (progn (forward l)
               (left 90))))

(defun fancy (l)
  (loop repeat 36
     do (progn (square l)
               (left (* 5 l)))))

(defun main ()
  (with-init ()
    (setf *window*
          (window *window-width* *window-height*))
    (setf (frame-rate) 24)
    (clear-display *black*)
    (with-events ()
      (:quit-event () t)
      (:key-down-event (:key key)
                       (case key
                         (:sdl-key-escape (push-quit-event))))
      (:idle (clear-display *black*)
             (reset-turtle)
             (fancy 20)
             (draw-turtle *position-x* *position-y* *direction*)
             (update-display)))))
