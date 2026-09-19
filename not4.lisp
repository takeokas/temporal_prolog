;;
;;nobiru , another imprementation by S.Takeoka
;;

#-kcl (tmpro-assert-new
 '(
   ((p) (aaa *x) ~(●q) (print "ppp")(print *x))
   ((q) (ttt) ~(●q))
   ((ttt))
   ((xxx) (●p))

   ((r) (aaa *x) (print "asd") ~(bbb *x) (print "qwe") (ccc *z)(bbb *z)~(fail)(print "zxc"))
   ((aaa *x) (print "aaa")(+ 1 2 *x))
   ((ccc *x) (+ 3 2 *x)(print "ccc"))
   ((bbb *x) (+ 3 2 *x)(print "bbb"))

   ((ap () *x *x))
   ((ap (*a . *x) *y (*a . *z)) (ap *x *y *z))
   ((xap *sw) (ap *x *y (a s d)) (prin1 *x)(print *y) ~ (check *sw) (print " 1 anser only"))
   ((check on))))

(tmpro-assert-at0-new '())



(set-halt-time 8)
