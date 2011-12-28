#!/bin/bash

echo ".quit" | sqlite3 -init ./initschema.sql  ../database/qe.db
cd ..
./qe.py --init_db
cd -


