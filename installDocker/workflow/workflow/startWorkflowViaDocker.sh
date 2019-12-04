#!/bin/sh

export TESSDATA_PREFIX=/data/models/tesseract/GT4HistOCR/

case "${1}" in
        init)
                if test -f /data/workflow/taverna/Execute_OCR-D_workflow.t2flow; then
                  echo Environment already initialized.
                  echo Remove files first or change to another directory.
                else 
                  echo Init workspace
                  cp -r /tmp/docker/dockerfiles/workflow /data
                  cp -r /ocrd/* /data
                fi
                ;;

	dump)
                echo Dump json of module $2
		echo $2 --dump-json
		$2 --dump-json
                ;;

	version)
                echo Version of module $2
		echo $2 --version
		$2 --version
                ;;

	testWorkflow)
                echo Test workflow with all algorithms
                echo This may take a while...
		bash /data/workflow/startWorkflow.sh parameters_all.txt
                ;;

	cmd)
               echo Execute command $2 $3 $4 $5 $6 $7 $8 $9
		$2 $3 $4 $5 $6 $7 $8 $9
                ;;

	*)
                if test -f /data/workflow/taverna/Execute_OCR-D_workflow.t2flow; then
                  echo Start workflow ...
                  bash /data/workflow/startWorkflow.sh $1
                else 
                  echo You should initialize environment first
		  echo "Usage: docker run -v \`pwd\`:/data dockerimage {init|dump|version|testWorkflow}" >&2
                  exit 1
                fi
		;;
esac

exit 0

