# Copyright 2018 The box.la Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

APPNAME = "voucher"
DATEVERSION=$(shell date -u +%Y%m%d)
COMMIT_SHA=$(shell git rev-parse --short HEAD)
PWD := $(shell pwd)
CERTSPATH := $(PWD)/build/certs

.PHONY:all
all:build

.PHONY:build
build:generate
	-rm -rf build
	-mkdir -p build/{bin,certs,db,scripts,log}
	go generate .
	go build -o build/bin/${APPNAME} -ldflags "-X main.version=${DATEVERSION} -X main.gitCommit=${COMMIT}"
	cp ./config.toml build/bin/config.toml
	cp ./log.xml build/bin/log.xml
	cp ./scripts/*.sh build/scripts/

.PHONY:generate
generate:
	go generate .

.PHONY:rebuild
rebuild:
	-rm -rf build/bin
	-mkdir -p build/bin
	go build -o build/bin/${APPNAME} -ldflags "-X main.version=${DATEVERSION} -X main.gitCommit=${COMMIT}"
	cp ./config.toml build/bin/config.toml
	cp ./log.xml build/bin/log.xml

.PHONY:install
install:build
	mv ${APPNAME} ${GOPATH}/bin/

.PHONY:clean
clean:
	-rm -rf build