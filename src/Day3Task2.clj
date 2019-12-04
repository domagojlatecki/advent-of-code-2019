(require '[clojure.string :as str])
(require '[clojure.set :as set])

(defn split-ln [ln] (str/split ln #","))
(defn generate-x-coords [xs xe y](map (fn [value] [value y]) (range xs (+ xe 1))))
(defn generate-y-coords [ys ye x](map (fn [value] [x value]) (range ys (+ ye 1))))
(defn parse-move [move] (Integer/parseInt (subs move 1)))
(defn find-coords [[x y coords] move]
  (def mov-val (parse-move move))
  (cond
    (re-matches #"R.+" move) [(+ x mov-val) y (concat coords (rest (generate-x-coords x (+ x mov-val) y)))]
    (re-matches #"L.+" move) [(- x mov-val) y (concat coords (rest (reverse (generate-x-coords (- x mov-val) x y))))]
    (re-matches #"U.+" move) [x (+ y mov-val) (concat coords (rest (generate-y-coords y (+ y mov-val) x)))]
    (re-matches #"D.+" move) [x (- y mov-val) (concat coords (rest (reverse (generate-y-coords (- y mov-val) y x))))]
  )
)

(def paths (map
    (fn [line] (last
      (reduce find-coords (cons [0 0 []] (split-ln line))))
    ) (line-seq (java.io.BufferedReader. *in*))
  )
)
(def intersections (reduce set/intersection (map set paths)))
(defn intersection-distances [path] (map (fn [point] (+ 1 (.indexOf path point))) intersections))
(def dists (map intersection-distances paths))

(println (apply min (map (fn [[a b]] (+ a b)) (map vector (first dists) (last dists)))))
