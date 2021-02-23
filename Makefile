
clean_dst11:=*.log *.ps *.dvi *.aux *.out *.toc
clean_dst21:=$(foreach aa1,$(clean_dst11), tmp/$(aa1))
clean_dst22:=$(foreach aa1,$(clean_dst11), */$(aa1))
clean_dst91:=$(wildcard $(clean_dst21) )
clean_dst92:=$(wildcard $(clean_dst22) )

F1latex:=$(wildcard src*/*.latex)
F2tex:=$(wildcard src*/*.tex)
F7combine:=$(wildcard src*/*.combine)
F8books:=$(wildcard books/*.pdf)
Fs:=$(F1latex) $(F2tex)

PDF1latex:=$(foreach     aa1,$(basename $(notdir $(F1latex))),pdf/$(aa1).pdf)
PDF2tex:=$(foreach       aa1,$(basename $(notdir $(F2tex))),pdf/$(aa1).pdf)
PDF7combine:=$(foreach   aa1,$(basename $(notdir $(F7combine))),pdf/$(aa1).pdf)
PDF8books:=$(foreach     aa1,$(basename $(notdir $(F8books))),pdf/$(aa1).pdf)
PDFs:=$(PDF1latex) $(PDF2tex) $(PDF8books) $(PDF7combine)


all: $(PDFs)
	# F1latex		$(F1latex)
	# F2tex			$(F2tex)
	# PDF1latex		$(PDF1latex)
	# PDF2tex		$(PDF2tex)
	# F8books		$(PDF8books)
	@echo
	@ls -l pdf/*.pdf
	echo "$${index_html}" > pdf/index.html

#pdf/latex_002_article_1998.pdf:Makefile
pre1latex:=$(foreach aa1,$(F1latex),$$(eval $(aa1):pdf/$(aa1)))

# pdftk cv_02231010am_common_2021_dengyanuo_cover_letter.pdf rs_02181536pm_2021_dengyanuo_resume.pdf cat output b.pdf


define FUNCbooks8pdf
$1 : $(wildcard books/$(basename $(notdir $(1))).pdf)
	@echo
	# $1 : $$^
	cp $$^ $1 
	@ls -l $1 || (echo $1 not found. 1738188 ; exit 28)

endef

define FUNCtex2pdf
$1 : $(wildcard src*/$(basename $(notdir $(1))).tex)
	@echo
	# $1 : $$^
	cd tmp/ && tex ../$$^ && dvipdf $$(notdir $$(basename $$^)).dvi ../pdf/$$(notdir $$(basename $$^)).pdf 
	#@ls -l $1 || (echo $1 not found. 1738182 ; exit 22)

endef

define FUNClatex2pdf
$1 : $(wildcard src*/$(basename $(notdir $(1))).latex)
	@echo
	# $1 : $$^
	cd tmp/ && latex ../$$^ && dvipdf $$(notdir $$(basename $$^)).dvi ../pdf/$$(notdir $$(basename $$^)).pdf 
	#@ls -l $1 || (echo $1 not found. 1738181 ; exit 21)

endef

$(foreach aa3,$(PDF1latex),$(eval $(call FUNClatex2pdf, $(aa3))))
$(foreach aa3,$(PDF2tex),$(eval   $(call FUNCtex2pdf,   $(aa3))))
$(foreach aa3,$(PDF8books),$(eval $(call FUNCbooks8pdf, $(aa3))))

c clean:
	$(if $(clean_dst91),rm -f $(clean_dst91))

ca clean_all:
	$(if $(clean_dst92),rm -f $(clean_dst92))

m vim_makefile:
	vim Makefile

gu up push :
	@echo git push -u origin main
	git push 

gd:
	git diff

gs:
	git status

ga:
	git add .

gc:
	git commit -a -m '$(shell date +%Y_%m%d_%H%M%P)'

X : ga gc up


index_html_idx:=1

define index_html
<html>
    <head>

        <meta http-equiv="content-type"    content="text/html; charset=utf-8" />

        <style>

table, th, td {
	margin-left: auto;
	margin-right: auto;
	padding: 10px;
    border: 1px solid black;
}
        </style>


    </head>
    <body onload="TTTmyTimer()">

        <table>
            <tr>
                <th>idx</th>
                <th>Name</th>
                <th>FileSize</th>
            </tr>
$(foreach aa1,$(PDFs), 
<tr>
<td> $(index_html_idx) </td>
<td> 
<a href="$(notdir $(aa1))" target="_blank" src="" referrerpolicy="no-referrer" ref="noreferrer"> $(notdir $(aa1))</a>
</td>
<td> $(shell cat $(aa1)|wc -c) </td>
</tr>
$(eval index_html_idx:=$(shell expr $(index_html_idx) + 1))
)
        </table>

    </body>
</html>


endef
export index_html

