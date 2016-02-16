#!/usr/bin/make

Make = $(MAKE) --no-print-directory #

typo:  ready 
	@- git status
	@- git commit -am "saving"
	@- git push origin master

commit:  ready 
	@- git status
	@- git commit -a 
	@- git push origin master

update:; @- git pull origin master
status:; @- git status

ready: gitting  


gitting:
	@git config --global credential.helper cache
	@git config credential.helper 'cache --timeout=3600'

your:
	@git config --global user.name "Your name"
	@git config --global user.email your@email.address

timm:
	@git config --global user.name "Tim Menzies"
	@git config --global user.email tim.menzies@gmail.com

oks:	
	@ $(foreach f,$(shell ls *ok.lua),echo ""; echo "--| $f |---------"; lua $f;)

 
