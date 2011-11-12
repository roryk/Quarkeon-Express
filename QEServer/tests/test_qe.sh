#!/bin/bash 



function checkjson {

    # $1 - command name
    # $2 - the output of a curl command
    # $3 - the key to search for 
    # $4 - the value to search for 
    # $5 - a headers txt file
    # $6 - a place to store a value used later (eg, pass this ${user_id})
    # prints pass or fail

    CMD_NAME=$1
    CMD_OUTPUT=$2
    SOUGHT_KEY=$3
    EXPECTED_VAL=$4
    HEADERS_FILE=$5
    VALUE_STORAGE=$6
    echo "---------------------------" >> ${output}
    date >> ${output}
    echo "${CMD_NAME}" >> ${output}
    cat ${HEADERS_FILE} >> ${output}
    echo "${CMD_OUTPUT}" >> ${output}
    echo "" >> ${output}

    # these two lines need to be grouped

    echo "${CMD_OUTPUT}" | grep -q "\"${SOUGHT_KEY}\": ${EXPECTED_VAL}"
    rcode=${?}
    # end need to be grouped

    if [ ${rcode} -eq 0 ]; then
	echo "expected ${SOUGHT_KEY}:${EXPECTED_VAL}, got it" >> ${output}
        echo "${CMD_NAME} passed"
        eval ${VALUE_STORAGE}=${EXPECTED_VAL}
    else
        # these two lines need to be grouped
        echo "${CMD_OUTPUT}" | grep -q "\"${SOUGHT_KEY}\": \"${EXPECTED_VAL}\""
        rcode=${?}
        # end need to be grouped

        if [ ${rcode} -eq 0 ]; then
	    echo "expected ${SOUGHT_KEY}:${EXPECTED_VAL}, got it" >> ${output}
            echo "${CMD_NAME} passed"
            eval ${VALUE_STORAGE}=${EXPECTED_VAL}
        else
	    echo "expected ${SOUGHT_KEY}:${EXPECTED_VAL}, didn't find it" >> ${output}
            echo "${CMD_NAME} FAILED"
        fi
    fi


}

function cleanup {
    # clean up
    kill ${qepid}
    rm ${testdb}
    rm -f ${testdb}-journal
    rm ${output}
    rm ${headers}
    rm ${cookiejar}
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

# the cookiejar for authentication
cookiejar=cookies-${$}.txt

# the options we'll use for all curl commands
curlopts="-s -c ${cookiejar} -b ${cookiejar} -D ${headers} "


# this will probably be okay :)
port=`perl -e 'print int(rand(30000)) + 1024'`
#let port=8000+${$}

command="../qe.py -sqlite_db=${testdb} --port=${port}"


echo ".quit" | sqlite3 -init ../sql/initschema.sql ${testdb}

python ${command} &
qepid=${!}
# give it a second to start up
sleep 3


echo "PID ${qepid} is: python ${command}"
LOGIN_STATUS=`curl ${curlopts} -d email_address=adamf@csh.rit.edu -d password=foo  http://localhost:${port}/api/login`
XSRF=`grep xsrf ${cookiejar} | awk '{print $7}'`
checkjson "login" "${LOGIN_STATUS}" "id" 1 "${headers}" "LOGIN_STATUS"
USER0_ID=1

DATA=`curl ${curlopts} -d _xsrf=${XSRF} -d email_address=adamfblahblah@gmail.com -d password=foobar -d name=adam2 http://localhost:${port}/api/signupnewplayer | tr -d '[]'`
checkjson "addfirstplayer" "${DATA}" "id" 4 "${headers}" "USER1_ID"

DATA=`curl ${curlopts} -d _xsrf=${XSRF} -d email_address=roryasdfasdf@gmail.com -d password=foobar -d name=rory2 http://localhost:${port}/api/signupnewplayer | tr -d '[]'`
checkjson "addsecondplayer" "${DATA}" "id" 5 "${headers}" "USER2_ID"


USER1_ID=2
USER2_ID=3


LOGIN_STATUS=`curl ${curlopts} -d email_address=adamfblahblah@gmail.com -d password=foobar http://localhost:${port}/api/login`
XSRF=`grep xsrf ${cookiejar} | awk '{print $7}'`
checkjson "login" "${LOGIN_STATUS}" "id" 4 "${headers}" "LOGIN_STATUS"

LOGIN_STATUS=`curl ${curlopts} -d email_address=roryasdfasdf@gmail.com -d password=foobar http://localhost:${port}/api/login`
XSRF=`grep xsrf ${cookiejar} | awk '{print $7}'`
checkjson "login" "${LOGIN_STATUS}" "id" 5 "${headers}" "LOGIN_STATUS"

if [ "${KEEP_DB}" == "" ]; then
    cleanup
else
    kill ${qepid}
    rm -f ${testdb}-journal
    echo "db is ${testdb}"
    echo "Output is ${output}"
    echo "cookie jar is  ${cookiejar}"
fi
