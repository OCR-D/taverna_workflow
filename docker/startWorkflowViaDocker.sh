#!/bin/sh

# Determine directory of script. 
ACTUAL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export TESSDATA_PREFIX=/data/models/tesseract/GT4HistOCR/

case "${1}" in
        init)
                if test -f /data/workflow/taverna/Execute_OCR-D_workflow.t2flow; then
                  echo Environment already initialized.
                  echo Remove files first or change to another directory.
                else 
                  echo Initialize taverna workflow
                  bash "$ACTUAL_DIR"/../installTaverna.sh /data
                  echo Now you can start workflow by executing 'docker run -v \`pwd\`:/data dockerimage process' 
               fi
                ;;

        update)
                if test -f /data/workflow/taverna/Execute_OCR-D_workflow.t2flow; then
                  echo Update taverna or processors
                 bash "$ACTUAL_DIR"/../scripts/updateTaverna.sh /taverna/git
                else 
                  echo You should initialize environment first
		  echo "Usage: docker run -v \`pwd\`:/data dockerimage init" >&2
                  exit 1
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

	process)
                if test -f /data/workflow/taverna/Execute_OCR-D_workflow.t2flow; then
                  echo Start workflow ...
                  bash /data/workflow/startWorkflow.sh $2
                else 
                  echo You should initialize environment first
		  echo "Usage: docker run -v \`pwd\`:/data dockerimage init" >&2
                  exit 1
                fi
		;;

	*)
                echo "Usage: docker run -v \`pwd\`:/data dockerimage {init|update|dump|version|testWorkflow|process}" >&2
                echo "init         - intialize environment for taverna" >&2
                echo "update       - update environment" >&2
                echo "dump         - dump json of given processor" >&2
                echo "version      - print version of given processor" >&2
                echo "testWorkflow - process workflow with all processors" >&2
                echo "process      - process workflow with selected parameter file" >&2
                exit 1
 		;;
esac

exit 0

