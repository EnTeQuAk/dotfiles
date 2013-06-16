install: install-vcprompt install-git install-hub install-bin install-bash \
	install-pythonrc install-subl


install-vcprompt:
	@rm -rf /tmp/vcprompt
	@mkdir -p /tmp/vcprompt
	@cd /tmp/vcprompt && curl -OL https://bitbucket.org/gward/vcprompt/get/default.tar.gz && \
		tar zxf default.tar.gz && cd gward-* && make && \
		echo "Installing vcprompt to /usr/local/bin/vcprompt" && sudo mv vcprompt /usr/local/bin/vcprompt
	@rm -rf /tmp/vcprompt

install-git:
	rm ~/.gitconfig && ln -n `pwd`/gitconfig ~/.gitconfig
	curl -o ~/.git-completion.bash https://github.com/git/git/raw/master/contrib/completion/git-completion.bash -OL

install-hub:
	curl http://defunkt.io/hub/standalone -sLo ~/bin/hub && chmod +x ~/bin/hub

install-bin:
	mkdir -p ~/bin/
	ln -fs `pwd`/bin/* ~/bin/

install-bash:
	rm ~/.bash_profile && rm ~/.bashrc
	ln -n `pwd`/bashrc ~/.bash_profile
	ln -n ~/.bash_profile ~/.bashrc

install-pythonrc:
	ln -n `pwd`/python/pythonrc.py ~/.pythonrc.py

install-subl:
ifeq ($(shell uname),Darwin)
	sudo ln -n "/Applications/Sublime Text 3.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
endif

