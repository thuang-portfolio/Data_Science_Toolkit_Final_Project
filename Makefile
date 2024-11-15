# Report associated rules
report.html: report.Rmd code/04_render_report.R outputs/table outputs/mosaic_plot
	Rscript code/04_render_report.R

outputs/table: code/02_descriptive_table.R cleaned_data
	Rscript code/02_descriptive_table.R
	
outputs/mosaic_plot: code/03_mosaic_plot.R cleaned_data
	Rscript code/03_mosaic_plot.R
	
cleaned_data: code/01_clean_data.R raw_data/Bullying_2018.csv
	Rscript code/01_clean_data.R
	
.PHONY: clean
clean: 
	rm -f outputs/*.rds && rm -f outputs/*.png && rm -f report.pdf 
	
.PHONY: install
install:
	Rscript -e "renv::restore(prompt = FALSE)"
	
# Docker associated rules
PROJECTFILES = report.Rmd code/01_clean_data.R code/02_descriptive_table.R code/03_mosaic_plot.R code/04_render_report.R
RENVFILES = renv.lock renv/activate.R renv/settings.json .Rprofile

# rule to build image
.PHONY: project_image
project_image: Dockerfile $(PROJECTFILES) $(RENVFILES)
	docker build -t data550fin .
	touch $@
	
.PHONY: pull_image
pull_image:
	docker pull htracy15/data550fin
	
.PHONY: macdocker
macdocker:
	docker run -v "$$(pwd)/report":/project/report htracy15/data550fin

.PHONY: pcdocker
pcdocker: 
	docker run -v "/$$(pwd)/report":/project/report htracy15/data550fin
