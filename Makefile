install: install-bin install-vim install-vcprompt install-git install-hub \
	install-bash install-pythonrc install-subl install-inputrc install-wtc


install-vim:
	rm -rf ~/.vim ~/.vimrc
	ln -s `pwd`/vim ~/.vim
	ln -s `pwd`/vimrc ~/.vimrc

install-vcprompt:
	@rm -rf /tmp/vcprompt
	@mkdir -p /tmp/vcprompt
	@cd /tmp/vcprompt && curl -OL https://bitbucket.org/gward/vcprompt/get/default.tar.gz && \
		tar zxf default.tar.gz && cd gward-* && make && \
		echo "Installing vcprompt to /usr/local/bin/vcprompt" && sudo mv vcprompt /usr/local/bin/vcprompt
	@rm -rf /tmp/vcprompt

install-git:
	rm -f ~/.gitconfig
	ln -n `pwd`/gitconfig ~/.gitconfig
	curl -o ~/.git-completion.bash https://github.com/git/git/raw/master/contrib/completion/git-completion.bash -OL
	(cd /tmp && git clone --depth 1 https://github.com/visionmedia/git-extras.git && cd git-extras && sudo make install)

install-hub:
	curl http://hub.github.com/standalone -sLo ~/bin/hub && chmod +x ~/bin/hub

install-bin:
	mkdir -p ~/bin/
	ln -fs `pwd`/bin/* ~/bin/

install-bash:
	rm -f ~/.bashrc
	rm -f ~/.bash_profile
	ln -s `pwd`/bashrc ~/.bash_profile
	ln -s ~/.bash_profile ~/.bashrc

install-inputrc:
	rm -f ~/.inputrc
	ln -s `pwd`/inputrc ~/.inputrc

install-pythonrc:
	rm -f ~/.pythonrc.py
	ln -s `pwd`/python/pythonrc.py ~/.pythonrc.py

install-wtc:
	curl http://github.com/lwe/whatthecommit/raw/master/whatthecommit -sLo ~/bin/wtc && chmod +x ~/bin/wtc

install-subl:
ifeq ($(shell uname),Darwin)
	sudo rm -f /usr/local/bin/subl /usr/local/bin/subl3
	sudo ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
	sudo ln -s /usr/local/bin/subl /usr/local/bin/subl3
endif

