all: public/elm.js public/bundle.js public/assets

clean:
	rm -r public/assets/; rm public/bundle.js; rm public/elm.js

src/Types/Auto.elm: src/Types.elm
	WATCHING=false elm-auto-encoder-decoder src/Types.elm

public/elm.js: src/*.elm src/Types/Auto.elm
	npx elm make src/Main.elm --output public/elm.js

public/bundle.js: src/main.js node_modules
	npx browserify src/main.js -o public/bundle.js --debug

public/assets: node_modules
	mkdir public/assets
	# these cannot be bundled, so need to be copied explicitly
	cp node_modules/peerjs/dist/peerjs.min.js public/assets
	cp node_modules/peerjs/dist/peerjs.min.js.map public/assets
	cp node_modules/material-components-web-elm/dist/material-components-web-elm.min.js public/assets
	cp node_modules/material-components-web-elm/dist/material-components-web-elm.min.css public/assets

node_modules:
	npm install

elm-live:
	npx elm-live src/Main.elm --open --dir public -- --output public/elm.js --debug

js-live:
	while true; do sleep 5; make public/assets public/bundle.js src/Types/Auto.elm; done

live:
	make elm-live & make js-live --silent