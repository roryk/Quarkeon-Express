#!/bin/bash 

function cleanup {
    # clean up
    kill ${qepid}
    rm ${testdb}
    rm -f ${testdb}-journal
    rm ${output}
    exit
    #
}



trap cleanup SIGHUP SIGINT SIGTERM

args=`getopt k $*`

if [ $? != 0 ]
then
    echo 'Usage: ...'
    exit 2
fi

set -- $args

KEEP_DB=""

for i
do
    case "$i"
        in
        -k)
            KEEP_DB="$2";
            shift;;
        --)
            shift; break;;
    esac
done

#echo single-char flags: "'"$sflags"'"
#echo oarg is "'"$oarg"'"

if [ "${KEEP_DB}" == "" ]; then
    echo "won't keep the db, raw log and cookie jar"
else
    echo "will leave the db, raw log and cookie jar on exit"
fi

# the response content
output=output-${$}.txt

# the headers
headers=headers-${$}.txt

# the database we'll test with
testdb=db-${$}.db

# this will probably be okay :)
port=`perl -e 'print int(rand(30000)) + 1024'`
#let port=8000+${$}


echo ".quit" | sqlite3 -init ../sql/initschema.sql ${testdb}

command="../qe.py -sqlite_db=${testdb} --init_db"
python ${command}

command="../qe.py -sqlite_db=${testdb} --port=${port}"

python ${command} &
qepid=${!}
# give it a second to start up
sleep 3

echo "PID ${qepid} is: python ${command}"
python test_qe.py --host="localhost" --port=${port} >> ${output}



if [ "${KEEP_DB}" == "" ]; then
    cleanup
else
    kill ${qepid}
    rm -f ${testdb}-journal
    echo "db is ${testdb}"
    echo "Output is ${output}"
fi
