rm -Rf ./apache-tomcat*
today=$(date)
git add .
git commit -m "secure tomcat $today"
git push

