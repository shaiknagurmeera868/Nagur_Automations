sqlplus "userfordatabase/password@databasename" <<EOF >/dev/null 2>&1
spool /pathforoutputfile/07022022-4.txt
"past the name of sql files"
spool off
exit
EOF

