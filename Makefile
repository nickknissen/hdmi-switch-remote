.PHONY: types hdmi-switch-remote-darwin-amd64

.SUFFIXES:

GULP = $(shell npm bin)/gulp

NAME = hdmi-switch-remote

build: $(NAME)

all: node_modules bower_components public/hello.js public/index.html public/vendor.js public/hello.css public/angular-material.min.css public/font-awesome.min.css public/fonts
	go get -d -v ./...
	go get -v github.com/GeertJohan/go.rice/rice

run\:dev: $(NAME)-bare all
	./$(NAME)-bare

$(NAME)-bare: $(shell find . -name "*.go") all
	rm -rf public.rice-box.go
	go build -o $(NAME)-bare

$(NAME): all
	rm -rf $(NAME)
	rm -rf public.rice-box.go
	go build -o $(NAME)
	rice append --exec $(NAME)

node_modules:
	npm -q update

bower_components:
	bower -q update

public/hello.js: app/hello.ls
	$(GULP)

public/index.html: app/index.jade
	$(GULP)

public/vendor.js: bower.json
	$(GULP)

public/hello.css: app/hello.styl
	$(GULP)

public/angular-material.min.css:
	$(GULP)

public/font-awesome.min.css:
	$(GULP)

public/fonts:
	$(GULP)

types:
	java -jar bower_components/closure-compiler/compiler.jar \
		--warning_level=VERBOSE \
		--externs support/externs/angular-1.2.js \
		--externs support/externs/externs.js \
		--angular_pass \
		tmp/hello.js

public.rice-box.go: all
	rice embed-go

hello_embedded: public.rice-box.go
	go build

setup:
	# For rice
	sudo apt-get install zip
	npm install -q -g bower gulp

$(NAME)-darwin-amd64: all
	rm -rf $(NAME)-darwin-amd64
	rice embed-go
	GOOS=darwin GOARCH=amd64 go build -o $(NAME)-darwin-amd64
