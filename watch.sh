jsx --watch jsx/ build/ &
sass --watch styles.sass:styles.css

trap 'kill $(jobs -p)' EXIT
